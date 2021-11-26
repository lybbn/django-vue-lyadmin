# -*- coding: utf-8 -*-

#微信第三方app支付v3(需要APIV3 的apikey)（直连方式-普通商户）

from config import WXPAY_CLIENT_CERT_PATH,WXPAY_CLIENT_KEY_PATH,WXPAY_APPID,WXPAY_MCHID,WXPAY_APIKEY,WXPAY_SERIAL_NO,WXPAY_CERT_DIR,WXPAY_CERT_DIR_RESPONSE
import requests
import json
import time
import os
import uuid
import random
import string
from datetime import datetime
from base64 import b64decode, b64encode
from Cryptodome.PublicKey import RSA
from Cryptodome.Signature import pkcs1_15
from Cryptodome.Hash import SHA256
from cryptography.hazmat.primitives.hashes import SHA256 as SHA256_1
from cryptography.hazmat.primitives.asymmetric.padding import PKCS1v15
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.x509 import load_pem_x509_certificate
from cryptography.hazmat.backends import default_backend
from cryptography.exceptions import InvalidSignature, InvalidTag
import logging
logger = logging.getLogger(__name__)

from enum import Enum


class RequestType(Enum):
    GET = 0
    POST = 1


class WeChatPayType(Enum):
    JSAPI = 0
    APP = 1
    H5 = 2
    NATIVE = 3
    MINIPROG = 4

# 获取加密
def get_sign(sign_str):
    rsa_key = RSA.importKey(open(WXPAY_CLIENT_KEY_PATH).read())
    signer = pkcs1_15.new(rsa_key)
    digest = SHA256.new(sign_str.encode('utf8'))
    sign = b64encode(signer.sign(digest)).decode('utf-8')
    return sign


class WxAppPay:
    """
    微信第三方app支付v3（直连方式-普通商户）
    """

    def __init__(self):
        self.appid = WXPAY_APPID
        self.mchid = WXPAY_MCHID
        self.apikey = WXPAY_APIKEY
        self.url = 'https://api.mch.weixin.qq.com/v3/pay/transactions/app'
        self.gate_way = 'https://api.mch.weixin.qq.com'
        self.notify_url = "https://weixin.qq.com/"#需要回调的默认url，实际上要填写自己的回调地址：要求https，且不能携带参数如：https://www.weixin.qq.com/wxpay/pay.php
        self.serial_no = WXPAY_SERIAL_NO  # 商户号证书序列号
        self.certificates = []#动态请求商户平台证书(验证回调应答签名要使用，目前只能通过api访问)
        self.cert_dir = WXPAY_CERT_DIR_RESPONSE + '/' if WXPAY_CERT_DIR_RESPONSE else None## 微信支付平台证书缓存目录，减少证书下载调用次数。 初始调试时可不设置，调试通过后再设置，示例值：'./cert'
        self.load_local_certificates()



    # 统一下单
    def payorder(self, order_no, total, description,notify_url=None):
        data = {
            "mchid": self.mchid,
            "out_trade_no": order_no,
            "appid": self.appid,
            "description": description,
            "notify_url": notify_url,#必填项
            "amount": {
                "total": int(total),#订单总金额，单位为分
                "currency": "CNY"
                },
            }
        data = json.dumps(data)  # 只能序列化一次
        #构造微信支付签名验证
        random_str = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(32))
        time_stamps = str(int(time.time()))
        """
            HTTP请求方法\n
            URL\n
            请求时间戳\n
            请求随机串\n
            请求报文主体\n
        """
        sign_str = f"POST\n{'/v3/pay/transactions/app'}\n{time_stamps}\n{random_str}\n{data}\n"
        sign = get_sign(sign_str)
        authorization = 'WECHATPAY2-SHA256-RSA2048 ' + f'mchid="{self.mchid}",nonce_str="{random_str}",signature="{sign}",timestamp="{time_stamps}",serial_no="{self.serial_no}"'
        headers = {'Content-Type': 'application/json', 'Accept': 'application/json','Authorization':authorization}
        response = requests.post(self.url, data=data, headers=headers)
        logger.info("微信app支付下单返回消息,订单号：%s,金额：%s,微信返回信息：%s" % (order_no,total/100,response.text))
        """
        正常返回
        {
            "prepay_id": "wx261153585405162d4d02642eabe7000000"
        }
        预支付交易会话标识。用于后续接口调用中使用，该值有效期为2小时(直接返回给app端，支付时需要)
        """
        res = json.loads(response.content)
        random_str_app = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(32))
        time_stamps_app = str(int(time.time()))
        sign_str_app = f"{WXPAY_APPID}\n{time_stamps_app}\n{random_str_app}\n{res['prepay_id']}\n"
        sign_str_app_sign = get_sign(sign_str_app)
        res['sign'] = sign_str_app_sign
        res['nonceStr'] = random_str_app
        res['partnerid'] = WXPAY_MCHID
        res['timestamp'] = time_stamps_app
        return res

    def load_local_certificates(self):
        if self.cert_dir and os.path.exists(self.cert_dir):
            for file in os.listdir(self.cert_dir):
                if file.lower().endswith('.pem'):
                    f = open(self.cert_dir + file, encoding="utf-8")
                    certificate = self.load_certificate(f.read())
                    f.close()
                    now = datetime.utcnow()
                    if certificate:
                        if now >= certificate.not_valid_before and now <= certificate.not_valid_after:
                            self.certificates.append(certificate)
                    f.close()
    #本地加载证书
    def load_certificate(self,certificate_str):
        try:
            return load_pem_x509_certificate(data=certificate_str.encode('UTF-8'), backend=default_backend())
        except:
            return None

    def build_authorization(self,path,method,mchid,serial_no,datas=None,nonce_str=None):
        timeStamp = str(int(time.time()))
        nonce_str = nonce_str or ''.join(str(uuid.uuid4()).split('-')).upper()
        body = json.dumps(datas) if datas else ''
        sign_str = '%s\n%s\n%s\n%s\n%s\n' % (method, path, timeStamp, nonce_str, body)
        signature = get_sign(sign_str=sign_str)
        authorization = 'WECHATPAY2-SHA256-RSA2048 mchid="%s",nonce_str="%s",signature="%s",timestamp="%s",serial_no="%s"' % (
        mchid, nonce_str, signature, timeStamp, serial_no)
        return authorization

    #定义请求
    def request(self, path, method=RequestType.GET, datas=None, skip_verify=False):
        headers = {}
        headers.update({'Content-Type': 'application/json'})
        headers.update({'Accept': 'application/json'})
        headers.update({'User-Agent': 'django-vue-lyadmin wechatpay v3 python sdk'})
        authorization = self.build_authorization(
            path,
            'GET' if method == RequestType.GET else 'POST',
            self.mchid,
            self.serial_no,
            datas=datas,
            nonce_str=None)
        headers.update({'Authorization': authorization})
        if method == RequestType.GET:
            response = requests.get(url=self.gate_way + path, headers=headers)
        else:
            response = requests.post(url=self.gate_way + path, json=data, headers=headers)
        if response.status_code in range(200, 300) and not skip_verify:
            if not self.verify_signature(response.headers, response.text):
                raise Exception('failed to verify signature')
        return response.status_code, response.text

    #更新商户证书
    def update_certificates(self):
        path = '/v3/certificates'
        code, message = self.request(path, skip_verify=False if self.certificates else True)
        if code == 200:
            self.certificates.clear()
            data = json.loads(message).get('data')
            for v in data:
                serial_no = v.get('serial_no')
                effective_time = v.get('effective_time')
                expire_time = v.get('expire_time')
                encrypt_certificate = v.get('encrypt_certificate')
                algorithm = nonce = associated_data = ciphertext = None
                if encrypt_certificate:
                    algorithm = encrypt_certificate.get('algorithm')
                    nonce = encrypt_certificate.get('nonce')
                    associated_data = encrypt_certificate.get('associated_data')
                    ciphertext = encrypt_certificate.get('ciphertext')
                if not (serial_no and effective_time and expire_time and algorithm and nonce and associated_data and ciphertext):
                    continue
                cert_str = self.aes_decrypt(
                    nonce=nonce,
                    ciphertext=ciphertext,
                    associated_data=associated_data,
                    apiv3_key=self.apikey)
                certificate = self.load_certificate(cert_str)
                now = datetime.utcnow()
                if certificate:
                    if now >= certificate.not_valid_before and now <= certificate.not_valid_after:
                        self.certificates.append(certificate)
                        if self.cert_dir:
                            if not os.path.exists(self.cert_dir):
                                os.makedirs(self.cert_dir)
                            if not os.path.exists(self.cert_dir + serial_no + '.pem'):
                                f = open(self.cert_dir + serial_no + '.pem', 'w')
                                f.write(cert_str)
                                f.close()

    #验证签名是否属于微信回调
    def verify_signature(self, headers, body):
        signature = headers.get('Wechatpay-Signature')
        timestamp = headers.get('Wechatpay-Timestamp')
        nonce = headers.get('Wechatpay-Nonce')
        serial_no = headers.get('Wechatpay-Serial')
        cert_found = False
        for cert in self.certificates:
            if int('0x' + serial_no, 16) == cert.serial_number:
                cert_found = True
                certificate = cert
                logger.info('wechatpay debug info verify_signature_1: %s' % cert)
                break
        if not cert_found:
            self.update_certificates()
            for cert in self.certificates:
                if int('0x' + serial_no, 16) == cert.serial_number:
                    cert_found = True
                    certificate = cert
                    logger.info('wechatpay debug info verify_signature_2: %s' % cert)
                    break
            if not cert_found:
                return False
        if not self.rsa_verify(timestamp, nonce, body, signature, certificate):
            logger.info('wechatpay debug info verify_signature_3: %s' % cert)
            return False
        return True

    #解密微信回调（支付成功）请求
    def decrypt_callback(self, request):
        headers = {}
        headers.update({'Wechatpay-Signature': request.META.get('HTTP_WECHATPAY_SIGNATURE')})
        headers.update({'Wechatpay-Timestamp': request.META.get('HTTP_WECHATPAY_TIMESTAMP')})
        headers.update({'Wechatpay-Nonce': request.META.get('HTTP_WECHATPAY_NONCE')})
        headers.update({'Wechatpay-Serial': request.META.get('HTTP_WECHATPAY_SERIAL')})
        body = request.body

        if isinstance(body, bytes):
            body = body.decode('UTF-8')
        logger.debug('Callback Header: %s' % headers)
        logger.debug('Callback Body: %s' % body)
        if not self.verify_signature(headers, body):
            return None
        data = json.loads(body)
        resource_type = data.get('resource_type')
        if resource_type != 'encrypt-resource':
            return None
        resource = data.get('resource')
        if not resource:
            return None
        algorithm = resource.get('algorithm')
        if algorithm != 'AEAD_AES_256_GCM':
            raise Exception('sdk does not support this algorithm')
        nonce = resource.get('nonce')
        ciphertext = resource.get('ciphertext')
        associated_data = resource.get('associated_data')
        if not (nonce and ciphertext):
            return None
        if not associated_data:
            associated_data = ''
        result = self.aes_decrypt(
            nonce=nonce,
            ciphertext=ciphertext,
            associated_data=associated_data,
            apiv3_key=self.apikey)
        logger.debug('Callback resource: %s' % result)
        return result

    #aes解密
    def aes_decrypt(self,nonce, ciphertext, associated_data, apiv3_key):
        key_bytes = apiv3_key.encode('UTF-8')
        nonce_bytes = nonce.encode('UTF-8')
        associated_data_bytes = associated_data.encode('UTF-8')
        data = b64decode(ciphertext)
        aesgcm = AESGCM(key=key_bytes)
        try:
            result = aesgcm.decrypt(nonce=nonce_bytes, data=data, associated_data=associated_data_bytes).decode('UTF-8')
        except:
            result = None
        return result

    #rsa验证
    def rsa_verify(self,timestamp, nonce, body, signature, certificate):
        sign_str = f'{timestamp}\n{nonce}\n{body}\n'
        message = sign_str.encode('UTF-8')
        public_key = certificate.public_key()
        signature = b64decode(signature)
        try:
            public_key.verify(signature, message, PKCS1v15(), SHA256_1())
        except InvalidSignature:
            return False
        return True

#微信支付回调实例

# class wechatpay_notify(APIView):
#     """
#     支付成功后，微信服务器异步通知回调（用于修改订单状态）
#     """
#     def post(self,request):
#         wxpay = WxAppPay()
#         logger.info("收到微信支付回调通知:%s" % (request.body))
#         result = wxpay.decrypt_callback(request=request)
#         logger.info("收到微信支付回调通知解密数据:%s" % (result))
#         if result:
#             resp = json.loads(result)
#             appid = resp.get('appid')
#             mchid = resp.get('mchid')
#             out_trade_no = resp.get('out_trade_no')
#             transaction_id = resp.get('transaction_id')
#             trade_type = resp.get('trade_type')
#             trade_state = resp.get('trade_state')
#             trade_state_desc = resp.get('trade_state_desc')
#             bank_type = resp.get('bank_type')
#             attach = resp.get('attach')
#             success_time = resp.get('success_time')
#             payer = resp.get('payer')
#             amount = resp.get('amount').get('total')
#             # TODO: 根据返回参数进行必要的业务处理，处理完后返回200或204
#             # 查询数据库中存在的订单
#             order = BuyVipRecord.objects.filter(orderno=out_trade_no, status=False).first()
#             if not order:
#                 return HttpResponse('fail')
#             order.tradeno = transaction_id
#             order.status = True
#             order.save()
#             orderpaysuccess(order.id)
#             return HttpResponse('success')
#         else:
#             return HttpResponse('fail')



# #调用代码
# if __name__=="__main__":
#    wx=WxAppPay()
#    print(wx.payorder("80480600",100,"订单支付").text)
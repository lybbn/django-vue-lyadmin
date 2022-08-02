#!/bin/python
#coding: utf-8
# +-------------------------------------------------------------------
# | system: django-vue-lyadmin
# +-------------------------------------------------------------------
# | Author: lybbn
# +-------------------------------------------------------------------
# | QQ: 1042594286
# +-------------------------------------------------------------------

# ------------------------------
# 微信支付v3(需要APIV3 的apikey)（直连方式-普通商户）
# ------------------------------
# 支付官网文档地址：https://pay.weixin.qq.com/wiki/doc/apiv3/index.shtml
# ------------------------------

from config import WXPAY_CLIENT_CERT_PATH,WXPAY_CLIENT_KEY_PATH,WXPAY_APPID,WXPAY_MCHID,WXPAY_APIKEY,WXPAY_SERIAL_NO,WXPAY_CERT_DIR,WXPAY_CERT_DIR_RESPONSE,WXPAY_APPID_APP
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
import hashlib
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

#uniapp调起微信支付只支持MD5加密
def get_sign_md5(sign_str):
    # 定义MD5
    hmd5 = hashlib.md5()
    # 生成MD5加密字符串
    hmd5.update(sign_str)
    # 获取MD5字符串
    sig = hmd5.hexdigest()
    # 将小写字母切换成大写
    return sig.upper()



class WxAppPay:
    """
    微信第三方app支付v3（直连方式-普通商户）
    """

    def __init__(self):
        self.appid = WXPAY_APPID
        self.appid_app = WXPAY_APPID_APP
        self.mchid = WXPAY_MCHID
        self.apikey = WXPAY_APIKEY
        self.url = 'https://api.mch.weixin.qq.com/v3/pay/transactions/app'#微信app支付
        self.url2 = 'https://api.mch.weixin.qq.com/v3/pay/transactions/jsapi'  # 微信小程序支付
        self.url3 = 'https://api.mch.weixin.qq.com/v3/refund/domestic/refunds'  # 微信申请退款、查询单笔退款
        self.url4 = 'https://api.mch.weixin.qq.com/v3/transfer/batches'  # 商家转账到零钱（提现--原来得【企业付款到零钱】的升级款）
        self.gate_way = 'https://api.mch.weixin.qq.com'
        self.notify_url = "https://weixin.qq.com/"#需要回调的默认url，实际上要填写自己的回调地址：要求https，且不能携带参数如：https://www.weixin.qq.com/wxpay/pay.php
        self.serial_no = WXPAY_SERIAL_NO  # 商户号证书序列号
        self.certificates = []#动态请求微信支付平台证书列表(验证回调应答签名要使用，目前只能通过api访问)
        self.cert_dir = WXPAY_CERT_DIR_RESPONSE + '/' if WXPAY_CERT_DIR_RESPONSE else None## 微信支付平台证书缓存目录，减少证书下载调用次数。 初始调试时可不设置，调试通过后再设置，示例值：'./cert'
        self.load_local_certificates()



    # 统一下单(微信app支付)
    def payorder(self, order_no, total, description,attach,notify_url=None):
        data = {
            "mchid": self.mchid,
            "out_trade_no": order_no,
            "appid": self.appid_app,
            "description": description,
            "attach":attach,#标注，微信支付后会原样返回
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
        sign_str_app = f"{WXPAY_APPID_APP}\n{time_stamps_app}\n{random_str_app}\n{res['prepay_id']}\n"
        sign_str_app_sign = get_sign(sign_str_app)
        res['paySign'] = sign_str_app_sign
        res['signType'] = 'RSA'
        res['nonceStr'] = random_str_app
        res['partnerid'] = WXPAY_MCHID
        res['timestamp'] = time_stamps_app
        res['oderno'] = order_no
        return res

    # 统一下单(微信小程序支付、微信公众号网页支付（JSAPI）)
    def payorder_jsapi(self, order_no, total, description,attach, openid,notify_url=None):
        data = {
            "mchid": self.mchid,
            "out_trade_no": order_no,
            "appid": self.appid,
            "description": description,
            "attach": attach,  # 标注，微信支付后会原样返回
            "payer":{
                "openid":openid
            },#（支付者openid）用户在直连商户appid下的唯一标识。 下单前需获取到用户的Openid
            "notify_url": notify_url,  # 必填项
            "amount": {
                "total": int(total),  # 订单总金额，单位为分(整数)
                "currency": "CNY"
            },
        }
        data = json.dumps(data)  # 只能序列化一次
        # 构造微信支付签名验证
        random_str = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(32))
        time_stamps = str(int(time.time()))
        """
            HTTP请求方法\n
            URL\n
            请求时间戳\n
            请求随机串\n
            请求报文主体\n
        """
        sign_str = f"POST\n{'/v3/pay/transactions/jsapi'}\n{time_stamps}\n{random_str}\n{data}\n"
        sign = get_sign(sign_str)
        authorization = 'WECHATPAY2-SHA256-RSA2048 ' + f'mchid="{self.mchid}",nonce_str="{random_str}",signature="{sign}",timestamp="{time_stamps}",serial_no="{self.serial_no}"'
        headers = {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': authorization}
        response = requests.post(self.url2, data=data, headers=headers)
        logger.info("微信app支付下单返回消息,订单号：%s,金额：%s,微信返回信息：%s" % (order_no, total / 100, response.text))
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
        package = "prepay_id="+res['prepay_id']
        sign_str_app = f"{WXPAY_APPID}\n{time_stamps_app}\n{random_str_app}\n{package}\n"
        sign_str_app_sign_v3_rsa = get_sign(sign_str_app)
        res['sign'] = sign_str_app_sign_v3_rsa
        res['signType'] = 'RSA'
        res['package'] = package
        res['nonceStr'] = random_str_app
        res['partnerid'] = WXPAY_MCHID
        res['timestamp'] = time_stamps_app
        res['oderno'] = order_no
        return res

    # 微信【商家转账到零钱】(提现)采用apiv3接口（原来的微信企业付款（提现）企业付款到零钱新用户已无法申请）
    # 开通要求：商户号已入驻90日且截止今日回推30天商户号保持连续不间的交易。
    # 开通方法：商户进入微信支付【商户平台—>产品中心—>商家转账到零钱】，点击开通进入开通流程
    # 开通产品后，商户进入微信支付【商户平台—>产品中心—>商家转账到零钱—>产品设置】，配置发起方式，开启验密批量API。并配置API 调用的IP 地址。
    # 该接口原官网是支持最多3000比的同时转账，这里只支持同时一个用户转账，如需支持多用户的形式的，需要自行扩展
    def cashout(self,order_no,amount,openid):
        batch_name = "转账"
        batch_remark = "转账"
        data = {
            "appid": self.appid,
            "out_batch_no": order_no,
            "batch_name": batch_name,#批次名字：示例值：2019年1月深圳分部报销单
            "batch_remark": batch_remark,  # 转账说明，UTF8编码，最多允许32个字符,示例值：2019年1月深圳分部报销单
            "total_amount": int(amount), # int类型，转账总金额， 转账金额单位为“分”。转账总金额必须与批次内所有明细转账金额之和保持一致，否则无法发起转账操作
            "total_num":1, # int类型 转账笔数 ，一个转账批次单最多发起三千笔转账。转账总笔数必须与批次内所有明细之和保持一致，否则无法发起转账操作
            "transfer_detail_list":[#转账明细，最多三千笔
                {
                    "out_detail_no": order_no,
                    "transfer_amount": int(amount),
                    "transfer_remark": batch_remark,
                    "openid": openid,
                },
            ],
        }
        data = json.dumps(data)  # 只能序列化一次
        # 构造微信签名验证
        random_str = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(32))
        time_stamps = str(int(time.time()))
        """
            HTTP请求方法\n
            URL\n
            请求时间戳\n
            请求随机串\n
            请求报文主体\n
        """
        sign_str = f"POST\n{'/v3/transfer/batches'}\n{time_stamps}\n{random_str}\n{data}\n"
        sign = get_sign(sign_str)
        authorization = 'WECHATPAY2-SHA256-RSA2048 ' + f'mchid="{self.mchid}",nonce_str="{random_str}",signature="{sign}",timestamp="{time_stamps}",serial_no="{self.serial_no}"'
        headers = {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': authorization}
        response = requests.post(self.url4, data=data, headers=headers)
        logger.info("微信提现【商家转账到零钱】返回消息,订单号：%s,金额：%s,微信返回信息：状态码：%s：%s" % (order_no, amount / 100, response.status_code,response.text))
        """
        正常返回：状态码200
        {
          "out_batch_no": "plfk2020042013",#自己的系统内部单号
          "batch_id": "1030000071100999991182020050700019480001",#微信的交易标识单号
          "create_time": "2015-05-20T13:29:35.120+08:00"
        }
        错误返回：非200状态码
        {"code":"NO_AUTH","message":"商户号无权限"}
        """
        return response

    # 微信app退款申请
    def refundsorder(self, out_refund_no,transaction_id,reason,refund,total,notify_url=None):
        """
        当交易发生之后一年内,卖家可以通过退款接口将支付金额退还给买家，微信支付将在收到退款请求并且验证成功之后，将支付款按原路退还至买家账号上。
        退款有一定延时，建议在提交退款申请后1分钟发起查询退款状态，一般来说零钱支付的退款5分钟内到账，银行卡支付的退款1-3个工作日到账。
        参考官方API：https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_2_9.shtml
        """
        data = {
            "out_refund_no": out_refund_no,#新退款单号
            "transaction_id": transaction_id,#原支付交易对应的微信订单号
            "reason": reason,#退款原因
            "notify_url": notify_url,#必填项，退款回调通知地址
            "amount": {
                "refund": int(refund),#退款金额，单位为分，只能为整数，不能超过原订单支付金额
                "total": int(total),#原订单金额，单位为分
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
        sign_str = f"POST\n{'v3/refund/domestic/refunds'}\n{time_stamps}\n{random_str}\n{data}\n"
        sign = get_sign(sign_str)
        authorization = 'WECHATPAY2-SHA256-RSA2048 ' + f'mchid="{self.mchid}",nonce_str="{random_str}",signature="{sign}",timestamp="{time_stamps}",serial_no="{self.serial_no}"'
        headers = {'Content-Type': 'application/json', 'Accept': 'application/json','Authorization':authorization}
        response = requests.post(self.url, data=data, headers=headers)
        logger.info("微信支付订单退款申请返回消息,退款单号：%s,金额：%s,微信返回信息：%s" % (out_refund_no,total/100,response.text))
        """
        正常返回
        {
          "refund_id": "50000000382019052709732678859",
          "out_refund_no": "1217752501201407033233368018",
          "transaction_id": "1217752501201407033233368018",
          "out_trade_no": "1217752501201407033233368018",
          "channel": "ORIGINAL",
          "user_received_account": "招商银行信用卡0403",
          "success_time": "2020-12-01T16:18:12+08:00",
          "create_time": "2020-12-01T16:18:12+08:00",
          "status": "SUCCESS",
          "funds_account": "UNSETTLED",
          "amount": {
            "total": 100,
            "refund": 100,
            "from": [
              {
                "account": "AVAILABLE",
                "amount": 444
              }
            ],
            "payer_total": 90,
            "payer_refund": 90,
            "settlement_refund": 100,
            "settlement_total": 100,
            "discount_refund": 10,
            "currency": "CNY"
          },
          "promotion_detail": [
            {
              "promotion_id": "109519",
              "scope": "SINGLE",
              "type": "DISCOUNT",
              "amount": 5,
              "refund_amount": 100,
              "goods_detail": {
                "merchant_goods_id": "1217752501201407033233368018",
                "wechatpay_goods_id": "1001",
                "goods_name": "iPhone6s 16G",
                "unit_price": 528800,
                "refund_amount": 528800,
                "refund_quantity": 1
              }
            }
          ]
        }
        """
        res = json.loads(response.content)
        return res

    #查询单笔退款
    def query_refundsorder(self,out_refund_no):
        """
        :param out_refund_no:商户系统内部的退款单号，示例值:'1217752501201407033233368018'
        微信官方API：https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_2_10.shtml
        """
        newurl = self.url3+"/"+out_refund_no
        path = newurl.split(self.gate_way)[1]
        return self.request(path)


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
            response = requests.post(url=self.gate_way + path, json=datas, headers=headers)
        if response.status_code in range(200, 300) and not skip_verify:
            if not self.verify_signature(response.headers, response.text):
                raise Exception('failed to verify signature')
        return response.status_code, response.text

    #更新-获取微信支付平台证书列表
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

if __name__=="__main__":
   wx=WxAppPay()
   print(wx.payorder("80480600",100,"订单支付").text)
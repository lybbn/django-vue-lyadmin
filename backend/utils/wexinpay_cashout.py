# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import config
from random import Random
import hashlib
import requests
import re

# 微信企业付款（提现）

def get_client_ip(request):
    """
    获取请求IP
    :param request:
    :return:
    """
    ip = ''
    try:
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0]
        else:
            ip = request.META.get('REMOTE_ADDR')
    except:
        pass
    return ip


def format_url(params, api_key=None):
    """
    字典序排序
    :param params:
    :param api_key:
    :return:
    """
    url = "&".join(['%s=%s' % (key, params[key]) for key in sorted(params)])
    if api_key:
        url = '%s&key=%s' % (url, api_key)
    return url


def calculate_sign(params, api_key):
    """
    计算签名
    :param params:
    :param api_key:
    :return:
    """
    # 签名步骤一：按字典序排序参数, 在string后加入KEY
    url = format_url(params, api_key)
    # 签名步骤二：MD5加密, 所有字符转为大写
    return hashlib.md5(url.encode('utf-8')).hexdigest().upper()


def random_str():
    """
    生成32位随机字符串
    :return:
    """
    chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
    random = Random()
    return "".join([chars[random.randint(0, len(chars) - 1)] for i in range(32)])


def dict_to_xml(params):
    xml = ["<xml>", ]
    for k, v in params.items():
        xml.append('<%s>%s</%s>' % (k, v, k))
    xml.append('</xml>')
    return ''.join(xml)


def dict_to_xml2(params):
    xml = ["<xml>", ]
    for k, v in params.items():
        xml.append('<%s><![CDATA[%s]]></%s>' % (k, v, k))
    xml.append('</xml>')
    return ''.join(xml)


def xml_to_dict(xml):
    xml = xml.strip()
    if xml[:5].upper() != "<XML>" and xml[-6:].upper() != "</XML>":
        return None, None

    result = {}
    sign = None
    content = ''.join(xml[5:-6].strip().split('\n'))

    pattern = re.compile(r"<(?P<key>.+)>(?P<value>.+)</(?P=key)>")
    m = pattern.match(content)
    while m:
        key = m.group("key").strip()
        value = m.group("value").strip()
        if value != "<![CDATA[]]>":
            pattern_inner = re.compile(r"<!\[CDATA\[(?P<inner_val>.+)\]\]>")
            inner_m = pattern_inner.match(value)
            if inner_m:
                value = inner_m.group("inner_val").strip()
            if key == "sign":
                sign = value
            else:
                result[key] = value

        next_index = m.end("value") + len(key) + 3
        if next_index >= len(content):
            break
        content = content[next_index:]
        m = pattern.match(content)

    return sign, result


class WeiXinPay(object):
    def __init__(self, mch_appid, mchid, api_key):
        self.api_key = api_key
        self.url = "https://api.mch.weixin.qq.com/mmpaymkttransfers/promotion/transfers"
        self.params = {
            "mch_appid": mch_appid,
            "mchid": mchid
        }

    def update_params(self, kwargs):
        self.params["desc"] = "付款描述信息"
        self.params["check_name"] = "NO_CHECK"
        self.params.update(kwargs)

    def post_xml(self):
        sign = calculate_sign(self.params, self.api_key)
        self.params["sign"] = sign
        xml = dict_to_xml(self.params)
        # 要特别注意的是需要带证书（微信支付签发的）
        response = requests.post(self.url, data=xml.encode('utf-8'), cert=(config.WXPAY_CLIENT_CERT_PATH, config.WXPAY_CLIENT_KEY_PATH))
        return xml_to_dict(response.text)

    def post_xml2(self):
        sign = calculate_sign(self.params, self.api_key)
        self.params["sign"] = sign
        xml = dict_to_xml2(self.params)
        # 要特别注意的是需要带证书（微信支付签发的）
        response = requests.post(self.url, data=xml.encode('utf-8'), cert=(config.WXPAY_CLIENT_CERT_PATH, config.WXPAY_CLIENT_KEY_PATH))
        return xml_to_dict(response.text)


class Pay(WeiXinPay):
    def __init__(self, mch_appid, mchid, api_key):
        super(Pay, self).__init__(mch_appid, mchid, api_key)

    def post(self, openid, trade_no, amount, ip, name, nonce_str):
        kwargs = {
            "openid": openid,
            "partner_trade_no": trade_no,
            "amount": amount,
            "spbill_create_ip": ip,
            "re_user_name": name,
            "nonce_str": nonce_str
        }
        self.update_params(kwargs)
        return self.post_xml()[1]


class PayQuery(WeiXinPay):
    """
    查询企业付款
    """
    def __init__(self, mch_appid, mchid, api_key):
        super(PayQuery, self).__init__(mch_appid, mchid, api_key)
        self.url = "https://api.mch.weixin.qq.com/mmpaymkttransfers/gettransferinfo"

    def post(self, trade_no, nonce_str):
        kwargs = {
            "partner_trade_no": trade_no,
            "nonce_str": nonce_str
        }
        self.update_params(kwargs)
        return self.post_xml2()[1]

"""
使用方法

openid = '用户openid'
trade_no = '随机生成的商户订单号'
amount = '企业付款金额，单位为分'
ip = 'Ip地址'
name = '收款用户姓名'
nonce_str = '随机字符串'
pay = Pay(settings.WXPAY_APPID, settings.WXPAY_MCHID, settings.WXPAY_APIKEY)
response = pay.post(openid, trade_no, amount * 100, ip, name, nonce_str)

if response and response["return_code"] == "SUCCESS":
    if response["result_code"] == "SUCCESS":
        print '付款成功' 
"""
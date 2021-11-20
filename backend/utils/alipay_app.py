#!/usr/bin/env python
#coding=utf-8

# 支付宝app支付
from alipay import AliPay
from config import ALIPAY_APPID,ALIPAY_PRIVATE_KEY_PATH,ALIPAY_PUBLIC_KEY_PATH

ALIPAY_URL = 'https://openapi.alipaydev.com/gateway.do?'

# 获取公私钥字符串
app_private_key_string = open(ALIPAY_PRIVATE_KEY_PATH).read()
alipay_public_key_string = open(ALIPAY_PUBLIC_KEY_PATH).read()
# 生成支付宝对象
def initalipay():

    alipay = AliPay(
        appid=ALIPAY_APPID,
        app_notify_url=None,# 默认回调url
        app_private_key_string=app_private_key_string,  # 私钥路径
        alipay_public_key_string=alipay_public_key_string,  # 公钥路径(支付宝的公钥，验证支付宝回传消息使用，不是你自己的公钥)
        sign_type="RSA2",
        debug=False,# 上线则改为False , 沙箱True
    )
    return alipay

def alipay_trade_app(out_trade_no,total_amount,notify_url):
    """
    功能：app支付场景
    out_trade_no:本地订单号
    total_amount:需要支付金额
    return 返回支付地址
    """
    alipay = initalipay()
    order_string=alipay.api_alipay_trade_app_pay(
        subject=out_trade_no,
        out_trade_no=out_trade_no,
        total_amount=str(total_amount),
        notify_url=notify_url# 可选, 不填则使用默认notify url
    )

    # 拼接应答地址(支付宝app支付不需要拼接ALIPAY_URL)
    pay_url = order_string
    return pay_url

## 测试代码
# if __name__ == '__main__':
#     alipay_trade_app('123123',50,None)
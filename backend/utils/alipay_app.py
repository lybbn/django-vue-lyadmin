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


#支付宝回调实例

# class alipay_notify(APIView):
#     """
#     支付成功后，支付宝服务器异步通知回调（用于修改订单状态）
#     返回fail之后，支付宝会再回调一次，也就是失败的回调一共回调2次
#     """
#     def post(self,request):
#         # 1. 先将sign剔除掉
#         processed_dict = {}
#         for key, value in request.POST.items():
#             processed_dict[key] = value
#         # 异步通知data参数转换字典后示例如下：
#         """
#         {'gmt_create': '2021-11-22 08:53:05', 'charset': 'utf-8', 'seller_email': 'xxx@126.com', 'subject': '20211122085257269506402001', 'sign': 'dAUOnG1u8/Fap+aDCSa+P2AXFv4vqr3BK4vKTxevai4F3sdN4X6an8GulmKjk3cx1Z9OMp05JAcBCPi+1CXJoy6opybYqr+M/uDUiAYH+MA4ilazSskS/WC22iZhS4oAVjwouGp+Wbu6pmNMM/gFNCxnlf3K+bCa/gzDDPTCTEoZT3IoeQdZ4ERmuNi7WdCCIm8jNaS8nRXS8bEkk7r7PvYs1kO3H9uZhViSKmlx+Qfklm+mRa1xheNd2UJ1pYcVGK4snlUJL4tKO/VEzPb2trFxYfI3y4q2EPBPCHcI24L1IZeZXrugx6mFJm02SntCrTA+/ysb7e59zoNrBmu+gQ==', 'buyer_id': '2088312606228550', 'invoice_amount': '0.01', 'notify_id': '2021112200222085305028551438751992', 'fund_bill_list': '[{"amount":"0.01","fundChannel":"PCREDIT"}]', 'notify_type': 'trade_status_sync', 'trade_status': 'TRADE_SUCCESS', 'receipt_amount': '0.01', 'app_id': '2021002194665673', 'buyer_pay_amount': '0.01', 'sign_type': 'RSA2', 'seller_id': '2088341077382474', 'gmt_payment': '2021-11-22 08:53:05', 'notify_time': '2021-11-22 08:56:13', 'version': '1.0', 'out_trade_no': '20211122085257269506402001', 'total_amount': '0.01', 'trade_no': '2021112222001428551424684280', 'auth_app_id': '2021002194665673', 'buyer_logon_id': '159****7057', 'point_amount': '0.00'}
#         """
#         logger.error("收到支付宝回调通知:%s" % (processed_dict))
#         sign = processed_dict.pop("sign", None)
#         # 2. 生成一个Alipay对象
#         alipay = initalipay()
#         # 3. 进行验签，确保这是支付宝给我们的
#         verify_re = alipay.verify(processed_dict, sign)
#         # 如果验签成功
#         if verify_re is True:
#             order_sn = processed_dict.get('out_trade_no', None)#自己平台的订单号
#             trade_no = processed_dict.get('trade_no', None)#支付宝的订单号
#             trade_status = processed_dict.get('trade_status', None)
#             if trade_status == "TRADE_SUCCESS":#支付成功
#                 # 查询数据库中存在的订单
#                 order = BuyVipRecord.objects.filter(orderno=order_sn,status=False).first()
#                 if not order:
#                     return HttpResponse('fail')
#                 order.tradeno = trade_no
#                 order.status = True
#                 order.save()
#                 #其他逻辑处理
#                 orderpaysuccess(order.id)
#                 return HttpResponse('success')
#             else:
#                 return HttpResponse('fail')
#         else:
#             return HttpResponse('fail')


## 测试代码
# if __name__ == '__main__':
#     alipay_trade_app('123123',50,None)
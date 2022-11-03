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
# 云片网发短信api
# ------------------------------
# 官网文档地址：https://www.yunpian.com/dev-doc
# ------------------------------

import requests
import json


class YunPian(object):

    def __init__(self, api_key):
        self.api_key = api_key
        self.single_send_url = "https://sms.yunpian.com/v2/sms/single_send.json"

    def send_sms(self, code, mobile):
        # 需要传递的参数
        parmas = {
            "apikey": self.api_key,
            "mobile": mobile,
            "text": "【老眼帮】您的验证码是{code}。如非本人操作，请忽略本短信".format(code=code)#该模板需要与申请的一致
        }

        response = requests.post(self.single_send_url, data=parmas)
        re_dict = json.loads(response.text)
        return re_dict


if __name__ == "__main__":
    # 例如：8111127a9701975c734b8aee81ee3521
    yun_pian = YunPian("3e87d1xxxxxx7d4bxxxx1608f7c6da23exxxxx1")
    yun_pian.send_sms("2021", "手机号码")
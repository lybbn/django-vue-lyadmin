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
# 公用方法
# ------------------------------

import os,re
import random
import time
from rest_framework.request import Request
from django.http import QueryDict
from  urllib.parse import urlparse
import datetime
import ast
import base64
import hashlib
import json


#手机号验证正则
REGEX_MOBILE = r"^1[356789]\d{9}$|^147\d{8}$|^176\d{8}$"

#身份证正则
IDCARD_MOBILE = r"^[1-9]\d{5}(18|19|20|(3\d))\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$"

#微信GMT+8 转换成标准时间字符串
def format_wechat_gmt_8_to_normal(wgmt8):
    """
    wgmt8:2022-01-12T16:35:42+08:00
    return:2022-01-12 16:35:42
    """
    try:
        a1 = wgmt8.split('T')
        a2 = a1[1].split('+')
        a3 = a1[0]+' '+a2[0]
        return a3
    except Exception as e:
        return wgmt8

#随机生成6位大写的邀请码:8614LY
def getinvitecode6():
    random_str = getRandomSet(6)
    return random_str.upper()

#生成随机得指定位数字母+数字字符串
def getRandomSet(bits):
    """
    bits:数字是几就生成几位
    """
    num_set = [chr(i) for i in range(48,58)]
    char_set = [chr(i) for i in range(97,123)]
    total_set = num_set + char_set
    value_set = "".join(random.sample(total_set, bits))
    return value_set

def hide4mobile(mobile):
    """
    隐藏手机号中间四位
    """
    if re.match(r"^\d{11}$", mobile):
        list = mobile[3:7]
        new_phone = mobile.replace(list, '****',1)
        return new_phone
    else:
        return ""

def float2dot(str):
    """
    把数字或字符串10.00 转换成保留后两位（字符串）输出
    """
    try:
        return '%.2f' % round(float(str),2)
    except:
        return str

"""
格式化日期时间为指定格式
"""
def formatdatetime(datatimes):
    """
    格式化日期时间为指定格式
    :param datatimes: 数据库中存储的datetime日期时间,也可以是字符串形式(2021-09-23 11:22:03.1232000)
    :return: 格式化后的日期时间如：2021-09-23 11:22:03
    """
    if datatimes:
        try:
            if isinstance(datatimes, str):
                if "." in datatimes:
                    arrays = datatimes.split(".",maxsplit=1)
                    if arrays:
                        return arrays[0]
            return datatimes.strftime('%Y-%m-%d %H:%M:%S')
        except Exception as e:
            return datatimes
    return datatimes

def formatdatetime_convert(datatimes):
    """
    格式化字符串日期时间为 python的日期时间
    :param datatimes: 字符串形式(2021-09-23 11:22:03 或 2021-09-23)
    :return: 反格式化后的日期时间如：datetime.datetime(2021, 9, 23, 11, 22, 3)
    """
    if datatimes:
        try:
            if isinstance(datatimes, str):
                if ':' in datatimes:
                    return datetime.datetime.strptime('datatimes', '%Y-%m-%d %H:%M:%S')
                else:
                    return datetime.datetime.strptime('datatimes', '%Y-%m-%d')
        except Exception as e:
            return datatimes
    return datatimes

#上传图片名自定义
"""
参数为图片文件名
"""
def renameuploadimg(srcimg):
    # 文件扩展名
    ext = os.path.splitext(srcimg)[1]
    # File names longer than 255 characters can cause problems on older OSes.
    if len(srcimg) > 255:
        ext = ext[:255]
    # 定义文件名，年月日时分秒随机数
    fn = time.strftime('%Y%m%d%H%M%S')
    fn = fn + '_%d' % random.randint(100, 999)
    # 重写合成文件名
    name =  fn + ext
    return name

#获取请求的域名包括http或https前缀如：https://www.xxx.cn
"""
参数requests为请求request
"""
def getfulldomian(requests):
    host = '{scheme}://{host}'.format(scheme=requests.scheme,host=requests.get_host())
    return host

"""
获取url地址中的path部分
"""
def geturlpath(url):
    # ParseResult(scheme='https', netloc='blog.xxx.net', path='/yilovexing/article/details/96432467', params='', query='', fragment='')
    all = urlparse(url)
    path = all.path
    return path

"""
重写数据库中的图片url前缀路径，返回相对路径的url路径，保证服务器更换环境导致图片访问失败情况
适用于图片存储在服务器本地
"""
def rewrite_image_url(request,url):
    """
    :param request: 用户请求request
    :param url: 图片url原路径
    :return: 图片url新路径
    """
    if '://' in url and 'http' in url and '127.0.0.1':

        fulldomain = getfulldomian(request)
        urlpath =geturlpath(url)
        # return fulldomain+urlpath
        return urlpath
    else:
        return url

def get_full_image_url(request,url):
    """
    :param request: 用户请求request
    :param url: 图片url原路径
    :return: 图片url新路径
    """
    if not url:
        return url
    elif  'http://' not in url and 'https://' not in url:

        fulldomain = getfulldomian(request)
        return fulldomain+url
    else:
        return url

#验证是否为有效手机号
def checkphonenum(phonenum):
    mobile_pat = re.compile(r'^1([38]\d|5[0-35-9]|7[3678])\d{8}$')
    res = re.search(mobile_pat, phonenum)
    if res:
        return True
    else:
        return False

#获取get 或 post的参数
#使用方法：get_parameter_dic(request)['name'] ,name为获取的参数名 ,此种方式获取name不存在则会报错返回name表示name不存在，需要此参数
#get_parameter_dic(request).get('name') ,name为获取的参数名 ,此种方式获取name不存在不会报错，不存在会返回None
def get_parameter_dic(request, *args, **kwargs):
    if isinstance(request, Request) == False:
        return {}

    query_params = request.query_params
    if isinstance(query_params, QueryDict):
        query_params = query_params.dict()
    result_data = request.data
    if isinstance(result_data, QueryDict):
        result_data = result_data.dict()

    if query_params != {}:
        return query_params
    else:
        return result_data

"""
把字符串列表转换成列表类型
"""
def srttolist(str):
    #['http://6fb77aa4dd1d.ngrok.io/media/tasks/2021-08-16/20210816103922_38.png']
    if str:
        str1 =str.replace('[','').replace(']','').replace("\"",'').replace("\'",'')
        str2 = str1.split(',')
        return str2
    else:
        return []

#获取请求用户的真实ip地址
def getrealip(request):
    try:
        real_ip = request.META['HTTP_X_FORWARDED_FOR']
        regip = real_ip.split(",")[0]
    except:
        try:
            regip = request.META['REMOTE_ADDR']
        except:
            regip = ""
    return regip

#生成订单号(短订单号)
def getminrandomodernum():
    basecode = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
    basecode = basecode[2:]
    chagecode1 = random.randint(10,99)
    chagecode3 = random.randint(10,99)
    return str(basecode)+str(chagecode1)+str(chagecode3)

#生成订单号（长订单号）
def getrandomodernum():
    basecode = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
    chagecode1 = random.randint(100,999)
    chagecode2 = random.randint(10, 99)
    chagecode3 = str(time.time()).replace('.','')[-7:]
    return str(basecode)+str(chagecode1)+str(chagecode2)+chagecode3

#判断是否为金额(不包含0)，（正整数金额，不包含小数点）
def ismoney(num):
    try:
        pattern = re.compile(r'^[0-9]\d*$')
        if not num:
            return False
        val = int(num)
        if val <= 0:
            return False
        result = pattern.match(num)
        if result:
            return True
        else:
            return False
    except Exception as e:
        return False

#判断是否为正确的价格（正整数、小数（小数点后两位）、非0）
def isRealPrice(num):
    try:
        if num == "" or num == None or num == 0 or num == '0':
            return False
        value = str(num)
        pattern = re.compile(r"(^[0-9]\d*$)|(^(([1-9]{1}\d*)|(0{1}))(\.\d{0,2})?$)")#正整数判断和小数判断
        result = pattern.match(value)
        if result:
            return True
        else:
            return False
    except Exception as e:
        return False

#把字符串转换成数组对象等
def ast_convert(str):
    if str:
        try:
            myobject = ast.literal_eval(str)
            return myobject
        except Exception as e:
            return str

    return None

#把数组对象转换成字符串转
def ast_convert_str(arr):
    if arr:
        try:
            if isinstance(arr, str):
                return arr
            if isinstance(arr, dict):
                return json.dumps(arr)
            if isinstance(arr, list):
                return json.dumps(arr)
        except Exception as e:
            return arr

    return None

def bas64_encode_text(text):
    """
    base64加密字符串
    :param text:
    :return:
    """
    if isinstance(text, str):
        return str(base64.b64encode(text.encode('utf-8')), 'utf-8')
    return text


def bas64_decode_text(text):
    """
    base64解密字符串
    :param text:
    :return:
    """
    if isinstance(text, str):
        return str(base64.decodebytes(bytes(text, encoding="utf8")), 'utf-8')
    return text

def ly_md5(str):
    m = hashlib.md5()
    m.update(str.encode(encoding='utf-8'))
    return m.hexdigest()
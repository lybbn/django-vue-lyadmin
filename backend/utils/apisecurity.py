# -*- coding: utf-8 -*-

"""
@Remark: 接口安全（接口数据校验）
"""

import time
from utils.jsonResponse import SuccessResponse,ErrorResponse
from utils.common import ly_md5
from django_redis import get_redis_connection

key = 'lybbn_sxfwanwlaqwanctcswan999666'

visited_keys = {
    #"332d3ddklllskkdwwwiissswewsw":时间
}

"""
使用方法，一般使用@ly_api_security，如果是drf中需要
from utils.apisecurity import ly_api_security
from django.utils.decorators import method_decorator
然后再具体的请求方法前面如get、post前面添加：@method_decorator(ly_api_security)
客户端需要在http头部添加auth-api头部字段
"""
#接口安全装饰器
def ly_api_security(func):
    def inner(request,*args,**kwargs):
        server_float_time = time.time()
        try:
            auth_header = request.META.get('HTTP_AUTH_API')
            # 332d3ddklllskkdwwwiissswewsw|1632392265.7424471|13234
            if not auth_header:
                return ErrorResponse(msg='缺少认证头部信息')
            client_md5,client_time,random_str = auth_header.split('|',maxsplit=2)
        except Exception as e:
            return ErrorResponse(msg="接口安全校验值错误")
        client_float_time = float(client_time)

        if len(random_str) !=5:
            return ErrorResponse(msg="第五个字段只能为5位")

        #第一重验证（时间校验）
        if(client_float_time +200) < server_float_time:
            return ErrorResponse(msg='接口校验时间过期')

        #第二重验证（md5校验）
        server_md5 = ly_md5("%s|%s|%s"%(key,client_time,random_str))
        if server_md5 != client_md5:
            return ErrorResponse(msg='接口加密校验失败')

        # #第三重验证（第几次访问校验）采用本地字典验证
        # if visited_keys.get(client_md5):
        #     return ErrorResponse(msg='该校验头部您已经使用过，请使用新的校验信息')
        # visited_keys['client_md5'] = client_float_time
        #第三重验证（第几次访问校验）采用redis验证(增加md5+ip方式存储解决不同ip下的并发访问问题)
        client = get_redis_connection('authapi')
        if client.get(client_md5):
            return ErrorResponse(msg='该校验头部您已经使用过，请使用新的校验信息')
        client.set(client_md5,client_float_time,ex=86400)#1天有效期

        return func(request,*args,**kwargs)

    return inner
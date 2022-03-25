"""
关闭前端api访问
"""

from django.http import HttpResponseForbidden
from utils.request_util import get_request_path
from config import ALLOW_FRONTEND
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.views import APIView
from utils.jsonResponse import SuccessResponse,ErrorResponse
from utils.common import get_parameter_dic

IS_ALLOW_FRONTEND = ALLOW_FRONTEND

class RedirectResponseMiddleWare:
    def __init__(self,get_response):
        self.get_response = get_response

    def __call__(self, request):
        request_path = get_request_path(request)
        if not IS_ALLOW_FRONTEND:
            if '/api/app/' in  request_path or '/api/xcx/' in request_path:
                return HttpResponseForbidden('<h1>Access Forbidden 301</h1>')
        response = self.get_response(request)
        return response


class OperateAllowFrontendView(APIView):
    """
    超级管理员动态启用/禁用/获取 禁止前端接口访问
    get:
    获取当前是否禁止前端访问的值
    【参数】无
    post:
    设置当前是否禁止前端访问
    【参数】is_allow = 1 允许访问  0 禁止访问
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self, request):
        """
        获取当前是否禁止前端访问的值
        """
        data = {
            'is_allow':IS_ALLOW_FRONTEND
        }
        return SuccessResponse(data=data,msg='success')

    def post(self,request):
        """
        设置当前是否禁止前端访问
        """
        user = request.user
        if user.is_superuser:
            global IS_ALLOW_FRONTEND
            is_allow = int(get_parameter_dic(request)['is_allow'])

            if is_allow:
                IS_ALLOW_FRONTEND = True
            else:
                IS_ALLOW_FRONTEND = False
            data = {
                'is_allow': IS_ALLOW_FRONTEND
            }
            return SuccessResponse(data=data,msg='设置成功')
        else:
            return ErrorResponse(msg="您没有权限操作")
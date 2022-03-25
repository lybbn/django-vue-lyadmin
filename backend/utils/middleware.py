"""
日志 django中间件
"""
import json

from django.conf import settings
from django.contrib.auth.models import AnonymousUser
from django.utils.deprecation import MiddlewareMixin

from mysystem.models import OperationLog
from utils.request_util import get_request_user, get_request_ip, get_request_data, get_request_path, get_os, get_browser, get_verbose_name

from django.http import HttpResponseForbidden
from config import ALLOW_FRONTEND,FRONTEND_API_LIST
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.views import APIView
from utils.jsonResponse import SuccessResponse,ErrorResponse
from utils.common import get_parameter_dic

IS_ALLOW_FRONTEND = ALLOW_FRONTEND

class ApiLoggingMiddleware(MiddlewareMixin):
    """
    用于记录API访问日志中间件
    """

    def __init__(self, get_response=None):
        super().__init__(get_response)
        self.enable = getattr(settings, 'API_LOG_ENABLE', None) or False
        self.methods = getattr(settings, 'API_LOG_METHODS', None) or set()
        self.request_modular = ""

    @classmethod
    def __handle_request(cls, request):
        request.request_ip = get_request_ip(request)
        request.request_data = get_request_data(request)
        request.request_path = get_request_path(request)

    def __handle_response(self, request, response):
        # request_data,request_ip由PermissionInterfaceMiddleware中间件中添加的属性
        body = getattr(request, 'request_data', {})
        # 请求含有password则用*替换掉(暂时先用于所有接口的password请求参数)
        if isinstance(body, dict) and body.get('password', ''):
            body['password'] = '*' * len(body['password'])
        if not hasattr(response, 'data') or not isinstance(response.data, dict):
            response.data = {}
        try:
            if not response.data and response.content:
                content = json.loads(response.content.decode())
                response.data = content if isinstance(content, dict) else {}
        except Exception:
            return
        user = get_request_user(request)
        info = {
            'request_ip': getattr(request, 'request_ip', 'unknown'),
            'creator': user if not isinstance(user, AnonymousUser) else None,
            'dept_belong_id': getattr(request.user, 'dept_id', None),
            'request_method': request.method,
            'request_path': request.request_path,
            'request_body': body,
            'response_code': response.data.get('code'),
            'request_os': get_os(request),
            'request_browser': get_browser(request),
            'request_msg': request.session.get('request_msg'),
            'status': True if response.data.get('code') in [2000, ] else False,
            'json_result': {"code": response.data.get('code'), "msg": response.data.get('msg')},
        }

        temp_request_modular = ""
        if not self.request_modular and settings.API_MODEL_MAP.get(request.request_path, None):
            temp_request_modular = settings.API_MODEL_MAP[request.request_path]
        else:
            temp_request_modular = self.request_modular

        operation_log = OperationLog.objects.create(request_modular=temp_request_modular, request_ip=info['request_ip'],
                                                    creator=info['creator'], dept_belong_id=info['dept_belong_id'],
                                                    request_method=info['request_method'],
                                                    request_path=info['request_path'],
                                                    request_body=info['request_body'],
                                                    response_code=info['response_code'], request_os=info['request_os'],
                                                    request_browser=info['request_browser'],
                                                    request_msg=info['request_msg'], status=info['status'],
                                                    json_result=info['json_result'])

        self.request_modular = ""

    def process_view(self, request, view_func, view_args, view_kwargs):
        if hasattr(view_func, 'cls') and hasattr(view_func.cls, 'queryset'):
            if self.enable:
                if self.methods == 'ALL' or request.method in self.methods:
                    self.request_modular = get_verbose_name(view_func.cls.queryset)

        return None

    def process_request(self, request):
        self.__handle_request(request)

    def process_response(self, request, response):
        """
        主要请求处理完之后记录
        :param request:
        :param response:
        :return:
        """
        if self.enable:
            if self.methods == 'ALL' or request.method in self.methods:
                self.__handle_response(request, response)

        # 过滤前端接口关闭情况
        if not IS_ALLOW_FRONTEND:
            if FRONTEND_API_LIST:
                for i in FRONTEND_API_LIST:
                    if i in request.request_path:
                        return HttpResponseForbidden('<h1>Access Forbidden 301</h1>')

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
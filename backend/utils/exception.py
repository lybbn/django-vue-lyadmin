# -*- coding: utf-8 -*-

"""
@Remark: 自定义异常处理
"""
import logging
import traceback

from django.db.models import ProtectedError
from django.db.utils import DatabaseError
from rest_framework import exceptions
from rest_framework.exceptions import APIException as DRFAPIException, AuthenticationFailed,NotAuthenticated,ValidationError
from rest_framework.views import set_rollback

from utils.jsonResponse import ErrorResponse

logger = logging.getLogger(__name__)


def CustomExceptionHandler(ex, context):
    """
    统一异常拦截处理
    目的:(1)取消所有的500异常响应,统一响应为标准错误返回
        (2)准确显示错误信息
    :param ex:
    :param context:
    :return:
    """
    msg = ''
    code = 4000

    if isinstance(ex, AuthenticationFailed):
        code = 4001
        msg = ex.detail
    elif isinstance(ex, NotAuthenticated):
        code = 4001
        msg = ex.detail
    elif isinstance(ex, exceptions.ValidationError):
        msg = ex.detail
        errorMsg = msg
        for key in errorMsg:
            msg = errorMsg[key][0]
    elif isinstance(ex, DRFAPIException):
        set_rollback()
        msg = str(ex.detail)
    elif isinstance(ex, exceptions.APIException):
        set_rollback()
        msg = ex.detail
    elif isinstance(ex, ProtectedError):
        set_rollback()
        msg = "删除失败:该条数据与其他数据有相关绑定"
    # elif isinstance(ex, DatabaseError):
    #     set_rollback()
    #     msg = "接口服务器异常,请联系管理员"
    elif isinstance(ex, Exception):
        logger.error(traceback.format_exc())
        msg = str(ex)#原样输出错误

    # errorMsg = msg
    # for key in errorMsg:
    #     msg = errorMsg[key][0]
    # print(traceback.format_exc())
    return ErrorResponse(msg=msg, code=code)


class APIException(Exception):
    """
    通用异常:(1)用于接口请求是抛出移除, 此时code会被当做标准返回的code, message会被当做标准返回的msg
    """

    def __init__(self, code=201, message='API异常', args=('API异常',)):
        self.args = args
        self.code = code
        self.message = message

    def __str__(self):
        return self.message
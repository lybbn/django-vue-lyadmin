# -*- coding: utf-8 -*-

"""
@Remark: swagger配置
"""
from drf_yasg.generators import OpenAPISchemaGenerator
from drf_yasg.inspectors import SwaggerAutoSchema

from application.settings import SWAGGER_SETTINGS


def get_summary(string):
    if string is not None:
        result = string.strip().replace(" ","").split("\n")
        if len(result)>=2:
            if 'get:' in result[0] or 'get：' in result[0] or 'post:' in result[0] or 'post：' in result[0] or 'list:' in result[0] or 'list：' in result[0]:
                return result[1]
        return result[0]

class CustomSwaggerAutoSchema(SwaggerAutoSchema):
    def get_tags(self, operation_keys=None):
        tags = super().get_tags(operation_keys)
        if "api" in tags and operation_keys:
            #  `operation_keys` 内容像这样 ['v1', 'prize_join_log', 'create']
            tags[0] = operation_keys[SWAGGER_SETTINGS.get('AUTO_SCHEMA_TYPE', 2)]
        return tags

    def get_summary_and_description(self):#自定义获取描述和概述
        summary_and_description = super().get_summary_and_description()
        summary = get_summary(self.__dict__.get('view').__doc__)#读取view中的注释
        if summary is None:
            summary = summary_and_description[0]
        description = summary_and_description[1]
        return summary,description


class CustomOpenAPISchemaGenerator(OpenAPISchemaGenerator):
    def determine_path_prefix(self, paths):
        """重写获取path地址前缀，默认前缀会截取公用前缀如：/api"""
        return "/"

    def get_schema(self, request=None, public=False):
        """重写 OpenAPISchemaGenerator 实现每个tag的说明文本"""

        swagger = super().get_schema(request, public)
        swagger.tags = [
            {
                "name": "token",
                "description": "认证相关"
            },
            {
                "name": "captcha",
                "description": "图形验证码"
            },
        ]
        return swagger

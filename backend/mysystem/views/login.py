# -*- coding: utf-8 -*-

"""
@Remark:管理后台登录视图
"""
import base64
from datetime import datetime, timedelta
from captcha.views import CaptchaStore, captcha_image
from django.utils.translation import gettext_lazy as _
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import serializers
from rest_framework.views import APIView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView

from mysystem.models import Users
from utils.jsonResponse import SuccessResponse
from utils.validator import CustomValidationError

class CaptchaView(APIView):
    """
    获取图片验证码
    """
    authentication_classes = []

    @swagger_auto_schema(
        responses={
            '200': openapi.Response('获取成功')
        },
        security=[],
        operation_id='captcha-get',
        operation_description='验证码获取',
    )
    def get(self, request):
        hashkey = CaptchaStore.generate_key()
        id = CaptchaStore.objects.filter(hashkey=hashkey).first().id
        imgage = captcha_image(request, hashkey)
        # 将图片转换为base64
        image_base = base64.b64encode(imgage.content)
        json_data = {"key": id, "image_base": "data:image/png;base64," + image_base.decode('utf-8')}
        return SuccessResponse(data=json_data)

class LoginSerializer(TokenObtainPairSerializer):
    """
    登录的序列化器:
    重写djangorestframework-simplejwt的序列化器
    """
    # captcha = serializers.CharField(max_length=6)
    #
    # class Meta:
    #     model = Users
    #     fields = "__all__"
    #     read_only_fields = ["id"]

    default_error_messages = {
        'no_active_account': _('该账号已被禁用,请联系管理员')
    }

    ##开启验证码验证
    # def validate_captcha(self, captcha):
    #     self.image_code = CaptchaStore.objects.filter(
    #         id=self.initial_data['captchaKey']).first()
    #     five_minute_ago = datetime.now() - timedelta(hours=0, minutes=5, seconds=0)
    #     if self.image_code and five_minute_ago > self.image_code.expiration:
    #         self.image_code and self.image_code.delete()
    #         raise CustomValidationError('验证码过期')
    #     else:
    #         if self.image_code and (self.image_code.response == captcha or self.image_code.challenge == captcha):
    #             self.image_code and self.image_code.delete()
    #         else:
    #             self.image_code and self.image_code.delete()
    #             raise CustomValidationError("图片验证码错误")

    def validate(self, attrs):
        username = attrs['username']
        password = attrs['password']
        user = Users.objects.filter(username=username).first()

        if user and not user.is_staff:#判断是否允许登录后台
            result = {
                "code": 4000,
                "msg": "您没有权限登录后台",
                "data": None
            }

            return result

        if user and user.check_password(password):  # check_password() 对明文进行加密,并验证
            data = super().validate(attrs)
            refresh = self.get_token(self.user)

            data['name'] = self.user.name
            data['userId'] = self.user.id
            data['refresh'] = str(refresh)
            data['access'] = str(refresh.access_token)
            result = {
                "code": 2000,
                "msg": "请求成功",
                "data": data
            }
        else:
            result = {
                "code": 4000,
                "msg": "账号/密码不正确",
                "data": None
            }
        return result


class LoginView(TokenObtainPairView):
    """
    登录接口
    """
    serializer_class = LoginSerializer
    permission_classes = []
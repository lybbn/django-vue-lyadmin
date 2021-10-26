from django.shortcuts import render
from rest_framework.views import APIView
from mysystem.models import Users,Role,Dept
from apps.oauth.models import OAuthWXUser
from utils.jsonResponse import SuccessResponse,ErrorResponse
from rest_framework import serializers
from utils.common import REGEX_MOBILE,get_parameter_dic,renameuploadimg,getfulldomian,geturlpath,ismoney,ast_convert,rewrite_image_url
import re
from django.db.models import Q,F,Sum
from rest_framework.serializers import ModelSerializer
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework.permissions import IsAuthenticated
from django.db import transaction
import datetime
import os
from django.conf import settings
import ast
from django.contrib.auth.hashers import make_password
from decimal import Decimal
from utils.locationanalysis import distance_haversine,get_locations_nearby_queryset
from utils.export_excel import export_excel
from utils.pagination import CustomPagination
from utils.wexinpay_cashout import Pay,get_client_ip,random_str
import config
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from utils.imageupload import ImageUpload
# Create your views here.

# ================================================= #
# ************** 前端用户中心 view  ************** #
# ================================================= #

class SetUserNicknameView(APIView):
    """
    修改昵称
    post:
    修改昵称
    【参数】nickname:需要修改的用户新昵称
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    #api文档参数

    @swagger_auto_schema(operation_summary='app回收员修改昵称',
    # manual_parameters=[#GET请求需要
    #     # openapi.Parameter("nickname", openapi.IN_QUERY, description="要修改昵称", type=openapi.TYPE_STRING)
    # ],
    request_body=openapi.Schema(#POST请求需要
        type=openapi.TYPE_OBJECT,
        required=['nickname'],
        properties={
                'nickname':openapi.Schema(type=openapi.TYPE_STRING,description="要修改昵称"),
             },
        ),
    responses={200:'success'},
    )

    def post(self, request):
        nickname = get_parameter_dic(request)['nickname']
        if nickname is None:
            return ErrorResponse(msg="昵称不能为空")
        if not isinstance(nickname,str):
            return ErrorResponse(msg='类型错误')
        user = request.user
        user.nickname  = nickname
        user.save()
        return SuccessResponse(msg="success")

#前端app头像修改
class ChangeAvatarView(APIView):
    '''
    前端app头像修改
    post:
    【功能描述】前端app头像修改</br>
    【参数说明】无，需要登录携带token后才能调用</br>
    '''
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        result = ImageUpload(request,"avatar")
        if result['code'] == 200 :
            user = request.user
            user.avatar = result['img'][0]
            user.save()
            return SuccessResponse(data=result['img'],msg=result['msg'])
        else:
            return ErrorResponse(msg=result['msg'])

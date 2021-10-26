from rest_framework.views import APIView
from utils.jsonResponse import SuccessResponse,ErrorResponse
from rest_framework import serializers
from utils.common import REGEX_MOBILE,get_parameter_dic,getfulldomian,renameuploadimg,geturlpath
import re
from django.db.models import Q,F
from rest_framework.serializers import ModelSerializer
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework.permissions import IsAuthenticated
import os
import datetime
from django.conf import settings
from apps.platformsettings.models import OtherManage
from utils.imageupload import ImageUpload
# Create your views here.
# ================================================= #
# ************** 后台前端平台设置 view  ************** #
# ================================================= #

class OtherManageSerializer(CustomModelSerializer):
    """
    其他设置 简单序列化器
    """

    class Meta:
        model = OtherManage
        # fields = "__all__"
        exclude=['dept_belong_id','modifier','creator','description']
        read_only_fields = ["id"]

class OtherManageViewSet(CustomModelViewSet):
    """
    平台其他设置后台接口:
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = OtherManage.objects.all().order_by('sort')
    serializer_class = OtherManageSerializer

#后端平台设置图片上传
class PlatformImagesUploadView(APIView):
    '''
    post:
    【功能描述】图片上传功能API</br>
    【参数说明】无，需要登录携带token后才能调用</br>
    '''
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        result = ImageUpload(request, "platform")
        if result['code'] == 200:
            return SuccessResponse(data=result['img'], msg=result['msg'])
        else:
            return ErrorResponse(msg=result['msg'])
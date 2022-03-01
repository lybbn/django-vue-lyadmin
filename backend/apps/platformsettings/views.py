from rest_framework.views import APIView
from utils.jsonResponse import SuccessResponse,ErrorResponse
from rest_framework.serializers import ModelSerializer
from rest_framework import serializers
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework.permissions import IsAuthenticated
import os
import datetime
from django.conf import settings
from apps.platformsettings.models import OtherManage,LunbotuManage
from utils.imageupload import ImageUpload
from utils.common import get_parameter_dic,get_full_image_url
# Create your views here.
# ================================================= #
# ************** 后台前端平台设置 view  ************** #
# ================================================= #

class LunbotuManageSerializer(CustomModelSerializer):
    """
    平台轮播图 简单序列化器
    """

    class Meta:
        model = LunbotuManage
        # fields = "__all__"
        exclude = ['dept_belong_id', 'modifier', 'creator', 'description']
        read_only_fields = ["id"]

class LunbotuManageViewSet(CustomModelViewSet):
    """
    平台轮播图设置后台接口
    list:查询(根据type值获取不同类型的轮播图片)
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = LunbotuManage.objects.all().order_by('sort')
    serializer_class = LunbotuManageSerializer
    filter_fields = ('type',)

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
    平台其他设置后台接口
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

# ================================================= #
# ************** 前端用户获取平台配置信息 view  ************** #
# ================================================= #
class GetOtherManageDetailView(APIView):
    """
    前端用户获取平台其他设置接口
    get:
    前端用户获取平台其他设置接口
    【参数】type标签类型: 为获取对应平台设置的key的键值
    """
    # permission_classes = [IsAuthenticated]
    # authentication_classes = [JWTAuthentication]
    serializer_class = OtherManageSerializer

    def get(self, request):
        key = get_parameter_dic(request)['key']
        if key is None:
            return ErrorResponse(msg='type参数不能为空')
        queryset = OtherManage.objects.filter(key=key,status=True).first()
        serializer = self.serializer_class(queryset,many=False)
        return SuccessResponse(data=serializer.data, msg="success")

class GetLunboManageListView(APIView):
    """
    前端用户获取平台轮播图设置接口
    get:
    前端用户获取平台轮播图设置接口
    【参数】type轮播图类型: 1为首页轮播图，2为分类页轮播图
    """
    # permission_classes = [IsAuthenticated]
    # authentication_classes = [JWTAuthentication]
    serializer_class = LunbotuManageSerializer

    def get(self, request):
        type = int(get_parameter_dic(request)['type'])
        if type in [1,2]:
            queryset = LunbotuManage.objects.filter(type=type,status=True).order_by('sort')
            serializer = self.serializer_class(queryset,many=True)
            return SuccessResponse(data=serializer.data, msg="success")
        else:
            return ErrorResponse(msg="type类型错误")

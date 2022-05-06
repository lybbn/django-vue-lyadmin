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
from apps.platformsettings.models import OtherManage,LunbotuManage,UserLeavingMessage
from utils.imageupload import ImageUpload
from utils.common import get_parameter_dic,get_full_image_url,ast_convert
from utils.filters import UserLeavingMessageTimeFilter
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
        fields = "__all__"
        # exclude=['dept_belong_id','modifier','creator','description']
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

class UserLeavingMessageSerializer(CustomModelSerializer):
    """
    后台意见反馈 简单序列化器:
    """
    nickname = serializers.SerializerMethodField()
    avatar = serializers.SerializerMethodField()
    mobile = serializers.SerializerMethodField()
    def get_nickname(self,obj):
        return  obj.user.nickname
    def get_avatar(self,obj):
        return  obj.user.avatar
    def get_mobile(self,obj):
        return  obj.user.mobile

    def to_representation(self, instance):  # 序列化
        """Convert `username` to lowercase."""
        ret = super().to_representation(instance)
        # print(ret,'11111')
        ret['images'] = ast_convert(ret['images'])  # 可以保存的修改字段值的方法
        return ret

    def to_internal_value(self, data):
        # 进提取所需要的数据，对其进行反序列化，data代表未验证的数据
        data['images'] = str(data['images'])
        return super().to_internal_value(data)

    class Meta:
        model = UserLeavingMessage
        read_only_fields = ["id"]
        fields = '__all__'

class UserLeavingMessageViewSet(CustomModelViewSet):
    """
    后台意见反馈 接口:
    """
    queryset = UserLeavingMessage.objects.all().order_by('-create_datetime')
    serializer_class = UserLeavingMessageSerializer
    # filter_fields = ('name',)
    # search_fields = ['user__nickname','message']
    filter_class = UserLeavingMessageTimeFilter

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

class APPUserLeavingMessageView(APIView):
    """
    post:
    前端用户 意见反馈
    【参数】message 需要反馈的内容
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def post(self,request):
        message = get_parameter_dic(request)['message']
        images = get_parameter_dic(request).get('images')
        if message is None:
            return ErrorResponse(msg="message不能为空")
        if images:
            images = ast_convert(images)
            if len(images)>6:
                return ErrorResponse(msg='只能上传最多6张图片')
        UserLeavingMessage.objects.create(user=request.user,message=message,subject=message,images=images,message_type=1)
        return SuccessResponse(msg="success")
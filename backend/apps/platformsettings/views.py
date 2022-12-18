from rest_framework.views import APIView
from utils.jsonResponse import SuccessResponse,ErrorResponse,DetailResponse
from rest_framework.serializers import ModelSerializer
from rest_framework import serializers
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework.permissions import IsAuthenticated
import os
import datetime
from django.conf import settings
from django.db.models import Q
from apps.platformsettings.models import OtherManage,LunbotuManage,UserLeavingMessage,SystemConfig
from utils.imageupload import ImageUpload
from utils.common import get_parameter_dic,get_full_image_url,ast_convert
from utils.filters import UserLeavingMessageTimeFilter,SystemConfigFilter

# Create your views here.
# ================================================= #
# ************** 后台前端平台设置 view  ************** #
# ================================================= #

class SystemConfigSerializer(CustomModelSerializer):
    """
    系统配置-序列化器
    """
    form_item_type_label = serializers.CharField(source='get_form_item_type_display', read_only=True)

    class Meta:
        model = SystemConfig
        fields = "__all__"
        read_only_fields = ["id"]

class SystemConfigCreateSerializer(CustomModelSerializer):
    """
    系统配置-新增时使用-序列化器
    """
    form_item_type_label = serializers.CharField(source='get_form_item_type_display', read_only=True)

    class Meta:
        model = SystemConfig
        fields = "__all__"
        read_only_fields = ["id"]

    def validate_key(self, value):
        """
        验证key是否允许重复
        parent为空时不允许重复,反之允许
        """
        instance = SystemConfig.objects.filter(key=value, parent__isnull=True).exists()
        if instance:
            raise ValueError('已存在相同变量名')
        return value

class SystemConfigChinldernSerializer(CustomModelSerializer):
    """
    系统配置子级-序列化器
    """
    chinldern = serializers.SerializerMethodField()
    form_item_type_label = serializers.CharField(source='get_form_item_type_display', read_only=True)

    def get_chinldern(self, instance):
        queryset = SystemConfig.objects.filter(parent=instance)
        serializer = SystemConfigSerializer(queryset, many=True)
        return serializer.data

    class Meta:
        model = SystemConfig
        fields = "__all__"
        read_only_fields = ["id"]


class SystemConfigViewSet(CustomModelViewSet):
    """
    系统配置接口
    """
    queryset = SystemConfig.objects.order_by('sort', 'create_datetime')
    serializer_class = SystemConfigChinldernSerializer
    create_serializer_class = SystemConfigCreateSerializer
    filter_class = SystemConfigFilter

    def save_content(self, request):
        body = request.data
        data_mapping = {item['id']: item for item in body}
        for obj_id, data in data_mapping.items():
            instance_obj = SystemConfig.objects.filter(id=obj_id).first()
            if instance_obj is None:
                serializer = SystemConfigCreateSerializer(data=data)
            else:
                serializer = SystemConfigCreateSerializer(instance_obj, data=data)
            if serializer.is_valid(raise_exception=True):
                serializer.save()
        return DetailResponse(msg="保存成功")

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
    filterset_fields = ('type',)

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
    # filterset_fields = ('name',)
    # search_fields = ['user__nickname','message']
    filterset_class = UserLeavingMessageTimeFilter

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

class GetSystemConfigSettingsView(APIView):
    """
    get:
    获取系统配置
    参数：group 分组名称（key）
    """
    authentication_classes = []
    permission_classes = []

    def get(self, request):
        group = get_parameter_dic(request)['group']
        if not all([group]):
            return ErrorResponse(msg="params error")
        # 不返回后端专用配置
        queryset = SystemConfig.objects.filter(parent_id__isnull=False,).values('value','key','title')
        data = {}
        if queryset:
            for m in queryset:
                data[m['key']] = m['value']
        return DetailResponse(data=data)

class GetOtherManageDetailView(APIView):
    """
    前端用户获取平台其他设置接口
    get:
    前端用户获取平台其他设置接口
    【参数】type标签类型: 为获取对应平台设置的key的键值
    """
    permission_classes = []
    authentication_classes = []
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
    permission_classes = []
    authentication_classes = []
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
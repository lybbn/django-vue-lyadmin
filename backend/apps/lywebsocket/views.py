from rest_framework.views import APIView
from utils.jsonResponse import SuccessResponse,ErrorResponse,DetailResponse
from rest_framework.serializers import ModelSerializer
from rest_framework import serializers
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework.permissions import IsAuthenticated
from apps.lywebsocket.models import TerminalServer

# Create your views here.

# ================================================= #
# ************** 后台终端服务 view  ************** #
# ================================================= #

class TerminalServerSerializer(CustomModelSerializer):
    """
    终端服务器列表后台 简单序列化器
    """
    typename = serializers.SerializerMethodField()
    def get_typename(self,obj):
        return obj.get_type_display()

    class Meta:
        model = TerminalServer
        # fields = "__all__"
        exclude = ['dept_belong_id', 'modifier', 'creator', 'description','password','pkey','pkey_passwd']
        read_only_fields = ["id"]

class TerminalCreateServerSerializer(CustomModelSerializer):
    """
    终端服务器列表后台 简单序列化器
    """

    class Meta:
        model = TerminalServer
        fields = "__all__"
        read_only_fields = ["id"]

class TerminalUpdateServerSerializer(CustomModelSerializer):
    """
    终端服务器列表后台 简单序列化器
    """


    class Meta:
        model = TerminalServer
        fields = "__all__"
        read_only_fields = ["id"]

class TerminalServerViewSet(CustomModelViewSet):
    """
    终端服务器列表后台接口
    list:查询(根据type值获取不同类型的轮播图片)
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = TerminalServer.objects.all().order_by('-create_datetime')
    serializer_class = TerminalServerSerializer
    create_serializer_class = TerminalCreateServerSerializer
    update_serializer_class = TerminalUpdateServerSerializer
    search_fields = ('host',)
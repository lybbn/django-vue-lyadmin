from rest_framework.views import APIView
from utils.jsonResponse import SuccessResponse,ErrorResponse,DetailResponse
from rest_framework.serializers import ModelSerializer
from rest_framework import serializers
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from utils.server.system import system
from apps.lymonitor.models import MonitorManage
# Create your views here.

class MonitorManageSerializer(CustomModelSerializer):
    """
    服务器监控 简单序列化器
    """

    class Meta:
        model = MonitorManage
        # fields = "__all__"
        exclude = ['dept_belong_id', 'modifier', 'creator', 'description']
        read_only_fields = ["id"]

class MonitorManageViewSet(CustomModelViewSet):
    """
    前端用户服务器监控
    get:
    前端用户服务器监控
    """

    queryset = MonitorManage.objects.all().order_by("create_datetime")
    serializer_class = MonitorManageSerializer

    def getsysteminfo(self, request):
        data = system().GetSystemAllInfo()
        return DetailResponse(data=data)

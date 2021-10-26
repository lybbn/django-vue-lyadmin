# -*- coding: utf-8 -*-

"""
@Remark: 操作日志管理
"""

from mysystem.models import OperationLog
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from utils.jsonResponse import SuccessResponse, ErrorResponse


class OperationLogSerializer(CustomModelSerializer):
    """
    操作日志-序列化器
    """

    class Meta:
        model = OperationLog
        fields = "__all__"
        read_only_fields = ["id"]


class OperationLogCreateUpdateSerializer(CustomModelSerializer):
    """
    操作日志  创建/更新时的列化器
    """

    class Meta:
        model = OperationLog
        fields = '__all__'


class OperationLogViewSet(CustomModelViewSet):
    """
    操作日志接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = OperationLog.objects.all().order_by('-create_datetime')
    serializer_class = OperationLogSerializer
    filter_fields = '__all__'
    search_fields = ('request_modular','request_path','request_ip','request_os','request_body')

    def deletealllogs(self,request):
        user = request.user
        if user.is_superuser:
            OperationLog.objects.all().delete()
            return SuccessResponse(msg="清空成功")
        return ErrorResponse(msg="您没有权限执行此操作，需要超级管理员权限")

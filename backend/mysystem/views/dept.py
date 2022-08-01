# -*- coding: utf-8 -*-

"""
@Remark: 角色管理
"""
from rest_framework import serializers

from mysystem.models import Dept
from utils.jsonResponse import SuccessResponse
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet

class DeptSerializer(CustomModelSerializer):
    """
    部门-序列化器
    """

    class Meta:
        model = Dept
        fields = "__all__"
        read_only_fields = ["id"]


class DeptCreateUpdateSerializer(CustomModelSerializer):
    """
    部门管理 创建/更新时的列化器
    """

    class Meta:
        model = Dept
        fields = '__all__'


class DeptTreeSerializer(CustomModelSerializer):
    """
    部门表的树形序列化器
    """
    children = serializers.SerializerMethodField(read_only=True)

    def get_children(self, instance):
        queryset = Dept.objects.filter(parent=instance.id).filter(status=1)
        if queryset:
            serializer = DeptTreeSerializer(queryset, many=True)
            return serializer.data
        else:
            return None

    class Meta:
        model = Dept
        fields = "__all__"
        read_only_fields = ["id"]


class DeptViewSet(CustomModelViewSet):
    """
    部门管理接口:
    """
    queryset = Dept.objects.all()
    serializer_class = DeptSerializer
    filterset_fields = ['status']
    search_fields = ['name', 'owner','phone','email']

    def dept_tree(self, request):
        queryset = Dept.objects.exclude(status=0).filter(parent=None)
        serializer = DeptTreeSerializer(queryset, many=True)
        return SuccessResponse(data=serializer.data, msg="获取成功")

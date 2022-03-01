# -*- coding: utf-8 -*-

"""
@Remark: 按钮权限管理
"""
from mysystem.models import Button
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet


class ButtonSerializer(CustomModelSerializer):
    """
    按钮权限-序列化器
    """

    class Meta:
        model = Button
        fields = "__all__"
        read_only_fields = ["id"]


class ButtonViewSet(CustomModelViewSet):
    """
    按钮权限接口:
    """
    queryset = Button.objects.all()
    serializer_class = ButtonSerializer

# -*- coding: utf-8 -*-

"""
@Remark: 菜单按钮管理
"""
from mysystem.models import MenuButton
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet


class MenuButtonSerializer(CustomModelSerializer):
    """
    菜单按钮-序列化器
    """

    class Meta:
        model = MenuButton
        fields = "__all__"
        read_only_fields = ["id"]


class MenuButtonViewSet(CustomModelViewSet):
    """
    菜单按钮接口:
    """
    queryset = MenuButton.objects.all()
    serializer_class = MenuButtonSerializer
    filterset_fields = ['menu']

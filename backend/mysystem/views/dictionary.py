# -*- coding: utf-8 -*-

"""
@Remark: 字典管理
"""
from rest_framework import serializers

from mysystem.models import Dictionary
from utils.jsonResponse import SuccessResponse
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet


class DictionarySerializer(CustomModelSerializer):
    """
    字典-序列化器
    """

    class Meta:
        model = Dictionary
        fields = "__all__"
        read_only_fields = ["id"]


class DictionaryCreateUpdateSerializer(CustomModelSerializer):
    """
    字典管理 创建/更新时的列化器
    """

    class Meta:
        model = Dictionary
        fields = '__all__'


class DictionaryTreeSerializer(CustomModelSerializer):
    """
    字典表的树形序列化器
    """
    children = serializers.SerializerMethodField(read_only=True)

    def get_children(self, instance):
        queryset = Dictionary.objects.filter(parent=instance.id).filter(status=1)
        if queryset:
            serializer = DictionaryTreeSerializer(queryset, many=True)
            return serializer.data
        else:
            return None

    class Meta:
        model = Dictionary
        fields = "__all__"
        read_only_fields = ["id"]


class DictionaryViewSet(CustomModelViewSet):
    """
    字典管理接口:
    """
    queryset = Dictionary.objects.all()
    serializer_class = DictionarySerializer
    filterset_fields = ['status']
    search_fields = ['label']

    def dictionary_tree(self, request):
        queryset = Dictionary.objects.exclude(status=0).filter(parent=None)
        serializer = DictionaryTreeSerializer(queryset, many=True)
        return SuccessResponse(data=serializer.data, msg="获取成功")

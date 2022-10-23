#!/bin/python
#coding: utf-8
# +-------------------------------------------------------------------
# | system: django-vue-lyadmin
# +-------------------------------------------------------------------
# | Author: lybbn
# +-------------------------------------------------------------------
# | QQ: 1042594286
# +-------------------------------------------------------------------

# ------------------------------
# django_celery_results TaskResult view
# ------------------------------

from django_celery_results.models import TaskResult

from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet

from apps.lycrontab.filters import CeleryTaskResultFilterSet



class CeleryTaskResultSerializer(CustomModelSerializer):
    """
    定时任务结果 序列化器
    """
    class Meta:
        model = TaskResult
        fields = '__all__'


class CeleryTaskResultViewSet(CustomModelViewSet):
    """
    定时任务 接口
    """
    queryset = TaskResult.objects.all()
    serializer_class = CeleryTaskResultSerializer
    filter_class = CeleryTaskResultFilterSet
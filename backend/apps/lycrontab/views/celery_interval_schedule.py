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
# django_celery_beat IntervalSchedule view
# ------------------------------

from django_celery_beat.models import IntervalSchedule

from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet


class IntervalScheduleSerializer(CustomModelSerializer):
    class Meta:
        model = IntervalSchedule
        fields = '__all__'


class IntervalScheduleModelViewSet(CustomModelViewSet):
    """
    调度间隔模型
    """
    queryset = IntervalSchedule.objects.all()
    serializer_class = IntervalScheduleSerializer


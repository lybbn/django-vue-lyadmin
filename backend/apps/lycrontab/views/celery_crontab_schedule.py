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
# django_celery_beat CrontabSchedule view
# ------------------------------

from django_celery_beat.models import CrontabSchedule

from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet

class CrontabScheduleSerializer(CustomModelSerializer):
    class Meta:
        model = CrontabSchedule
        exclude = ('timezone',)
        # fields = '__all__'


class CrontabScheduleModelViewSet(CustomModelViewSet):
    """
    计划任务
    """
    queryset = CrontabSchedule.objects.all()
    serializer_class = CrontabScheduleSerializer
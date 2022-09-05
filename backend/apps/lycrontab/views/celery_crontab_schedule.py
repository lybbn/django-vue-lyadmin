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
        read_only_fields = ["id"]
        exclude = ('timezone',)
        # fields = '__all__'


class CrontabScheduleModelViewSet(CustomModelViewSet):
    """
    crontab 的周期性任务（同linux的crontab）

    minute="0" 分钟
    hour="*"   小时
    day_of_week="*" 每周的星期几
    day_of_month="10-15" 每月的某一天或间隔
    month_of_year="*"  每年的某一个月
    """
    queryset = CrontabSchedule.objects.all()
    serializer_class = CrontabScheduleSerializer
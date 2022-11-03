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
        read_only_fields = ["id"]
        fields = '__all__'


class IntervalScheduleModelViewSet(CustomModelViewSet):
    """
    以特定（固定间隔）时间间隔（例如每 5 秒）运行的计划(每 /月/日/时/分/秒/微秒)
    DAYS = 'days'
    HOURS = 'hours'
    MINUTES = 'minutes'
    SECONDS = 'seconds'
    MICROSECONDS = 'microseconds'
    """
    queryset = IntervalSchedule.objects.all()
    serializer_class = IntervalScheduleSerializer


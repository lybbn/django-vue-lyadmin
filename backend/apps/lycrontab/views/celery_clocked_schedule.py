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
# django_celery_beat ClockedSchedule view
# ------------------------------

from django_celery_beat.models import ClockedSchedule

from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet

class ClockedScheduleSerializer(CustomModelSerializer):

    class Meta:
        model = ClockedSchedule
        read_only_fields = ["id"]
        fields = '__all__'


class ClockedScheduleModelViewSet(CustomModelViewSet):
    """
    时钟时间（DateTimeField）运行一次性任务
    """
    queryset = ClockedSchedule.objects.all()
    serializer_class = ClockedScheduleSerializer
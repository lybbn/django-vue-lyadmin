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
# 自定义计划任务 view
# ------------------------------
from apps.lycrontab.models import CrontabManage
from apps.lycrontab.views.celery_periodic_task import PeriodicTaskSerializer
from rest_framework import serializers

from utils.jsonResponse import SuccessResponse, ErrorResponse,DetailResponse
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet

class CrontabManageSerializer(CustomModelSerializer):
    periodic_task = PeriodicTaskSerializer()

    class Meta:
        model = CrontabManage
        read_only_fields = ["id"]
        fields = '__all__'
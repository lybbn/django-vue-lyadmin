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
# django_celery_beat PeriodicTask view
# ------------------------------

from django_celery_beat.models import PeriodicTask
from rest_framework import serializers

from utils.jsonResponse import SuccessResponse, ErrorResponse,DetailResponse
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from apps.lycrontab.views.celery_crontab_schedule import CrontabScheduleSerializer
from apps.lycrontab.views.celery_interval_schedule import IntervalScheduleSerializer


class PeriodicTaskSerializer(CustomModelSerializer):
    interval_list = serializers.SerializerMethodField(read_only=True)
    crontab_list = serializers.SerializerMethodField(read_only=True)

    def get_interval_list(self, obj):
        return IntervalScheduleSerializer(obj.interval).data if obj.interval else {}

    def get_crontab_list(self, obj):
        return CrontabScheduleSerializer(obj.crontab).data if obj.crontab else {}

    class Meta:
        model = PeriodicTask
        fields = '__all__'


class PeriodicTaskModelViewSet(CustomModelViewSet):
    """
    任务数据模型
    """
    queryset = PeriodicTask.objects.exclude(name="celery.backend_cleanup")
    serializer_class = PeriodicTaskSerializer

    def gettasks(self, request, *args, **kwargs):
        """
        获取所有 tasks 名称
        """
        lis = []

        def get_data(datas):
            for item in datas:
                if isinstance(item, (str, int)) and item:
                    lis.append(item)
                else:
                    get_data(item)

        from celery import current_app
        tasks = list(sorted(name for name in current_app.tasks if not name.startswith('celery.')))
        get_data((('', ''),) + tuple(zip(tasks, tasks)))
        return SuccessResponse(list(set(lis)))

    def operatecelery(self, request, *args, **kwargs):
        task_name = request.data.get('celery_name', '')
        data = {
            'task': None
        }
        test = f"""
                from {'.'.join(task_name.split('.')[:-1])} import {task_name.split('.')[-1]}
                task = {task_name.split('.')[-1]}.delay()
        """
        exec(test, data)
        if not data["task"]:
            ErrorResponse(msg="执行失败")
        return SuccessResponse({'task_id': data.get('task', ).id})
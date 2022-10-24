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

from django_celery_beat.models import PeriodicTask,CrontabSchedule, cronexp,PeriodicTasks
from rest_framework import serializers

from utils.jsonResponse import SuccessResponse, ErrorResponse,DetailResponse
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from apps.lycrontab.views.celery_interval_schedule import IntervalScheduleSerializer
from utils.common import get_parameter_dic
from rest_framework.exceptions import APIException
from apps.lycrontab.filters import CeleryPeriodicTaskFilterSet
from application import settings
from django.db import transaction

CrontabSchedule.__str__ = lambda self : '{0} {1} {2} {3} {4}'.format(
            cronexp(self.minute), cronexp(self.hour),
            cronexp(self.day_of_month), cronexp(self.month_of_year),
            cronexp(self.day_of_week)
        )

def get_task_list():
    """
    获取本地所有app目录中所有的tasks任务文件中“lytask_”开头的任务方法
    :return:
    """
    task_list = []
    task_dict_list = []
    for app in settings.INSTALLED_APPS:
        try:
            exec(f"""
from {app} import tasks
for t in [i for i in dir(tasks) if i.startswith('lytask_')]:
    task_dict = dict()
    task_dict['label'] = '{app}.tasks.' + t
    task_dict['value'] = '{app}.tasks.' + t
    task_list.append('{app}.tasks.' + t)
    task_dict_list.append(task_dict)
                """)
        except ImportError :
            pass
    return {'task_list': task_list, 'task_dict_list': task_dict_list}



def cronConvert(cron):
    """
    解析cron表达式为字典形式
    :param cron: * * * * * 分、时、天、月、周
    :return:
    """
    cron = cron.split(" ")
    result = {
        "minute":cron[0],
        "hour":cron[1],
        "day":cron[2],
        "month":cron[3],
        "week":cron[4]
    }
    return result

class CrontabScheduleSerializer(CustomModelSerializer):

    class Meta:
        model = CrontabSchedule
        read_only_fields = ["id"]
        exclude = ('timezone',)
        # fields = '__all__'

class PeriodicTaskSerializer(CustomModelSerializer):

    crontab = serializers.StringRelatedField(read_only=True)
    crontab_id = serializers.SerializerMethodField(read_only=True)
    def get_crontab_id(self,obj):
        return obj.crontab_id

    class Meta:
        model = PeriodicTask
        read_only_fields = ["id"]
        fields = '__all__'

class PeriodicTaskCreateUpdateSerializer(CustomModelSerializer):

    class Meta:
        model = PeriodicTask
        read_only_fields = ["id"]
        fields = '__all__'


class PeriodicTaskModelViewSet(CustomModelViewSet):
    """
    任务数据模型
    """
    queryset = PeriodicTask.objects.exclude(name="celery.backend_cleanup")
    serializer_class = PeriodicTaskSerializer
    create_serializer_class = PeriodicTaskCreateUpdateSerializer
    update_serializer_class = PeriodicTaskCreateUpdateSerializer
    filterset_class = CeleryPeriodicTaskFilterSet

    @transaction.atomic
    def create(self, request, *args, **kwargs):
        body_data = request.data.copy()
        cron = body_data.get('crontab')
        cron_dict = cronConvert(cron)
        minute = cron_dict["minute"]
        hour = cron_dict["hour"]
        day = cron_dict["day"]
        month = cron_dict["month"]
        week = cron_dict["week"]
        cron_data = {
            'minute': minute,
            'hour': hour,
            'day_of_week': week,
            'day_of_month': day,
            'month_of_year': month
        }
        task = body_data.get('task')
        result = None
        task_list = get_task_list()
        task_list = task_list.get('task_list')
        if task in task_list:
            # 添加crontab
            serializer = CrontabScheduleSerializer(data=cron_data, request=request)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)

            # 添加任务
            body_data['crontab'] = serializer.data.get('id')
            body_data['enabled'] = False
            serializer = self.get_serializer(data=body_data, request=request)
            res = serializer.is_valid()
            if not res:
                raise APIException({"msg": f"添加失败，已经有一个名为 {body_data['name']} 的任务了"}, code=4000)
            self.perform_create(serializer)
            result = serializer.data
            return DetailResponse(msg="添加成功", data=result)
        else:
            return ErrorResponse(msg="没有该任务方法，请先添加", data=None)

    @transaction.atomic
    def update(self, request, *args, **kwargs):
        body_data = request.data.copy()
        cron = body_data.get('crontab')
        cron_id = body_data.get('crontab_id')
        cron_dict = cronConvert(cron)
        minute = cron_dict["minute"]
        hour = cron_dict["hour"]
        day = cron_dict["day"]
        month = cron_dict["month"]
        week = cron_dict["week"]
        cron_data = {
            'minute': minute,
            'hour': hour,
            'day_of_week': week,
            'day_of_month': day,
            'month_of_year': month
        }
        task = body_data.get('task')
        result = None
        task_list = get_task_list()
        task_list = task_list.get('task_list')
        if task in task_list:
            # 编辑crontab
            cond_instance = CrontabSchedule.objects.filter(id=cron_id).first()
            oldcron = '{0} {1} {2} {3} {4}'.format(
                cronexp(cond_instance.minute), cronexp(cond_instance.hour),
                cronexp(cond_instance.day_of_month), cronexp(cond_instance.month_of_year),
                cronexp(cond_instance.day_of_week)
            )
            if cron.strip() == oldcron:
                body_data['crontab'] = cron_id
            else:
                # cond_instance.minute = minute
                # cond_instance.hour = hour
                # cond_instance.day_of_month = day
                # cond_instance.month_of_year = month
                # cond_instance.day_of_week = week
                # body_data['crontab'] = cond_instance.id
                cron_data['id'] = cron_id
                serializer = CrontabScheduleSerializer(cond_instance, data=cron_data, request=request)
                serializer.is_valid(raise_exception=True)
                self.perform_update(serializer)
                body_data['crontab'] = cond_instance.id
            partial = kwargs.pop('partial', False)
            instance = self.get_object()
            serializer1 = self.get_serializer(instance, data=body_data, request=request, partial=partial)
            serializer1.is_valid(raise_exception=True)
            self.perform_update(serializer1)

            if getattr(instance, '_prefetched_objects_cache', None):
                # If 'prefetch_related' has been applied to a queryset, we need to
                # forcibly invalidate the prefetch cache on the instance.
                instance._prefetched_objects_cache = {}
            # PeriodicTasks.changed()
            return DetailResponse(data=serializer1.data, msg="更新成功")
        else:
            return ErrorResponse(msg="没有该任务方法，请先添加", data=None)



    def tasklist(self, request, *args, **kwargs):
        """获取本地tasks任务所有方法"""
        result = get_task_list()
        task_list = result.get('task_dict_list')
        return SuccessResponse(msg='获取成功', data=task_list, total=len(task_list))

    def taskenabled(self, request, *args, **kwargs):
        """开始、暂停任务"""
        instance = self.get_object()
        instance.enabled = get_parameter_dic(request).get('enabled',False)
        instance.save()
        return DetailResponse(msg="修改成功")
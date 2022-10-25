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
# django-filter 过滤
# ------------------------------
import django_filters
from django_celery_results.models import TaskResult
from django_celery_beat.models import PeriodicTask

class CeleryPeriodicTaskFilterSet(django_filters.FilterSet):
    """
    PeriodicTask 过滤
    """

    name = django_filters.CharFilter(field_name='name', lookup_expr='icontains')
    enabled = django_filters.BooleanFilter(field_name='enabled')
    task = django_filters.CharFilter(field_name='task', lookup_expr='icontains')

    class Meta:
        model = PeriodicTask
        fields = ['name', 'enabled','task']

class CeleryTaskResultFilterSet(django_filters.FilterSet):
    """
    TaskResult过滤
    """

    date_created = django_filters.BaseRangeFilter(field_name="date_created")

    class Meta:
        model = TaskResult
        fields = ['id','task_id', 'status', 'date_done', 'date_created', 'result', 'task_name','periodic_task_name']


# -*- coding: utf-8 -*-
"""
@Remark: 计划任务的路由文件
"""
from django.urls import path, re_path
from rest_framework import routers

from apps.lycrontab.views.celery_crontab_schedule import CrontabScheduleModelViewSet
from apps.lycrontab.views.celery_interval_schedule import IntervalScheduleModelViewSet
from apps.lycrontab.views.celery_periodic_task import PeriodicTaskModelViewSet

system_url = routers.SimpleRouter()

system_url.register(r'intervalschedule', IntervalScheduleModelViewSet)
system_url.register(r'crontabschedule', CrontabScheduleModelViewSet)
system_url.register(r'periodictask', PeriodicTaskModelViewSet)

urlpatterns = [
    re_path(r'^gettasks/', PeriodicTaskModelViewSet.as_view({'get': 'gettasks'})),
    re_path(r'^operatecelery/', PeriodicTaskModelViewSet.as_view({'post': 'operatecelery'})),
]

urlpatterns += system_url.urls
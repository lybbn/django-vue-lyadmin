# -*- coding: utf-8 -*-
"""
@Remark: 计划任务的路由文件
"""
from django.urls import path, re_path
from rest_framework import routers

from apps.lycrontab.views.celery_crontab_schedule import CrontabScheduleModelViewSet
from apps.lycrontab.views.celery_interval_schedule import IntervalScheduleModelViewSet
from apps.lycrontab.views.celery_periodic_task import PeriodicTaskModelViewSet
from apps.lycrontab.views.celery_task_result import CeleryTaskResultViewSet

system_url = routers.SimpleRouter()

system_url.register(r'intervalschedule', IntervalScheduleModelViewSet)
system_url.register(r'crontabschedule', CrontabScheduleModelViewSet)
system_url.register(r'periodictask', PeriodicTaskModelViewSet)
system_url.register(r'taskresult', CeleryTaskResultViewSet)

urlpatterns = [
    re_path('periodictask/enabled/(?P<pk>.*?)/',PeriodicTaskModelViewSet.as_view({'put':'taskenabled'}), name='开始/暂停任务'),
    path('periodictask/tasklist/',PeriodicTaskModelViewSet.as_view({'get':'tasklist'}), name='获取本地所有tasks文件中的task任务方法'),


]

urlpatterns += system_url.urls
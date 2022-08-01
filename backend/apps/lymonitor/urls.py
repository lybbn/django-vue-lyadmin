# -*- coding: utf-8 -*-

"""
@Remark: 服务器监控的路由文件
"""

from django.urls import path, re_path
from rest_framework import routers

from apps.lymonitor.views import MonitorManageViewSet

system_url = routers.SimpleRouter()
system_url.register(r'monitor', MonitorManageViewSet)


urlpatterns = [
    path('getsysteminfo/',MonitorManageViewSet.as_view({'get':'getsysteminfo'}), name='实时获取本机监控信息'),

]
urlpatterns += system_url.urls
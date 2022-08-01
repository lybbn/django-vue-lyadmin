# -*- coding: utf-8 -*-

"""
@Remark: 终端服务的路由文件
"""

from django.urls import path, re_path
from rest_framework import routers

from apps.lywebsocket.views import TerminalServerViewSet

system_url = routers.SimpleRouter()
system_url.register(r'terminal', TerminalServerViewSet)

urlpatterns = [
]
urlpatterns += system_url.urls
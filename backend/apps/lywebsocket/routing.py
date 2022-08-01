# -*- coding: utf-8 -*-

"""
@Remark: websocket的路由文件
"""
from django.urls import re_path,path

from . import consumers

websocket_urlpatterns = [
    re_path(r'^ws/webssh/$', consumers.TerminalConsumer.as_asgi()),
]
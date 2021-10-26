# -*- coding: utf-8 -*-

"""
@Remark: 消息的路由文件
"""

from django.urls import path, re_path
from rest_framework import routers

from apps.lymessages.views import MyMessageTemplateViewSet,MyMessageViewSet

system_url = routers.SimpleRouter()
system_url.register(r'messagetemplate', MyMessageTemplateViewSet)
system_url.register(r'messagenotice', MyMessageViewSet)



urlpatterns = [

]
urlpatterns += system_url.urls
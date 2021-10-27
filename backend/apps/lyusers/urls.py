# -*- coding: utf-8 -*-

"""
@Remark: 用户模块的路由文件
"""

from django.urls import path, re_path
from rest_framework import routers

from apps.lyusers.views import UserManageViewSet

system_url = routers.SimpleRouter()
system_url.register(r'users', UserManageViewSet)



urlpatterns = [
    re_path('users/disableuser/(?P<pk>.*?)/',UserManageViewSet.as_view({'put':'disableuser'}), name='后台禁用用户'),
]
urlpatterns += system_url.urls
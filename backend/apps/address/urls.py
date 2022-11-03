# -*- coding: utf-8 -*-

"""
@Remark: 地区地址相关的路由文件
"""
from django.urls import path, re_path
from rest_framework import routers

from apps.address.views import AreaViewSet

system_url = routers.SimpleRouter()
system_url.register(r'area', AreaViewSet)

urlpatterns = [
    re_path('area_root/', AreaViewSet.as_view({'get': 'area_root'})),
]
urlpatterns += system_url.urls

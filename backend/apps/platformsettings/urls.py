# -*- coding: utf-8 -*-

"""
@Remark: 平台设置的路由文件
"""

from django.urls import path, re_path
from rest_framework import routers

from apps.platformsettings.views import LunbotuManageViewSet,OtherManageViewSet,PlatformImagesUploadView,UserLeavingMessageViewSet

system_url = routers.SimpleRouter()
system_url.register(r'other', OtherManageViewSet)
system_url.register(r'lunboimg', LunbotuManageViewSet)
system_url.register(r'userfeeckback', UserLeavingMessageViewSet)


urlpatterns = [
    path('uploadplatformimg/', PlatformImagesUploadView.as_view(), name='后台上传平台设置图片'),

]
urlpatterns += system_url.urls
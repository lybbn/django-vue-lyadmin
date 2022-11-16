# -*- coding: utf-8 -*-

"""
@Remark: 平台设置的路由文件
"""

from django.urls import path, re_path
from rest_framework import routers

from apps.platformsettings.views import LunbotuManageViewSet,OtherManageViewSet,PlatformImagesUploadView,UserLeavingMessageViewSet,SystemConfigViewSet

system_url = routers.SimpleRouter()
system_url.register(r'other', OtherManageViewSet)
system_url.register(r'lunboimg', LunbotuManageViewSet)
system_url.register(r'userfeeckback', UserLeavingMessageViewSet)
system_url.register(r'sysconfig', SystemConfigViewSet)

urlpatterns = [
    path('uploadplatformimg/', PlatformImagesUploadView.as_view(), name='后台上传平台设置图片'),
    path('sysconfig/save_content/', SystemConfigViewSet.as_view({'put': 'save_content'}), name='保存配置'),

]
urlpatterns += system_url.urls
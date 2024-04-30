# -*- coding: utf-8 -*-

"""
@Remark: 系统管理的路由文件
"""
from django.urls import path, re_path
from rest_framework import routers

from mysystem.views.button import ButtonViewSet
from mysystem.views.dept import DeptViewSet
from mysystem.views.menu import MenuViewSet
from mysystem.views.menu_button import MenuButtonViewSet
from mysystem.views.operation_log import OperationLogViewSet
from mysystem.views.role import RoleViewSet,PermissionViewSet
from mysystem.views.user import UserViewSet

system_url = routers.SimpleRouter()
system_url.register(r'menu', MenuViewSet)
system_url.register(r'button', ButtonViewSet)
system_url.register(r'menu_button', MenuButtonViewSet)
system_url.register(r'role', RoleViewSet)
system_url.register(r'permission', PermissionViewSet,basename='permission')
system_url.register(r'dept', DeptViewSet)
system_url.register(r'user', UserViewSet)
system_url.register(r'operation_log', OperationLogViewSet)

urlpatterns = [
    re_path('menu_tree/', MenuViewSet.as_view({'get': 'menu_tree'})),
    re_path('dept_tree/', DeptViewSet.as_view({'get': 'dept_tree'})),
    re_path('role_id_to_menu/(?P<pk>.*?)/', RoleViewSet.as_view({'get': 'roleId_to_menu'})),
    re_path('role_data/(?P<pk>.*?)/', RoleViewSet.as_view({'get': 'role_data'})),
    # path('menu/web_router/', MenuViewSet.as_view({'get': 'web_router'})),#已在视图的action装饰器中自动生成
    path('user/user_info/',UserViewSet.as_view({'get':'user_info','put':'update_user_info'})),
    re_path('user/change_password/(?P<pk>.*?)/',UserViewSet.as_view({'put':'change_password'})),
    re_path('operation_log/deletealllogs/',OperationLogViewSet.as_view({'delete':'deletealllogs'})),

]
urlpatterns += system_url.urls

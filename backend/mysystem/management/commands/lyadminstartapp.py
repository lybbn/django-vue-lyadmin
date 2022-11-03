import os
import logging

from django.core.management.base import BaseCommand
from application.settings import BASE_DIR

logger = logging.getLogger(__name__)

class Command(BaseCommand):
    """
    向apps目录中创建App命令:
    python manage.py lyadminstartapp app名
    python manage.py lyadminstartapp app名1 app名2
    """

    def add_arguments(self, parser):
        parser.add_argument('appname', nargs='*', type=str, )

    def handle(self, *args, **options):
        appname_list = options.get('appname')
        if appname_list:
            for name in appname_list:
                app_path = os.path.join(BASE_DIR, "apps",name)
                # 判断app是否存在
                if os.path.exists(app_path):
                    print(f"要创建的App名称：{name} 已存在，请更换其他名称！")
                else:
                    #创建app文件夹
                    if not os.path.exists(app_path):
                        # 如果目标路径不存在就创建
                        os.makedirs(app_path)
                    #创建__init__.py文件
                    with open(os.path.join(app_path, "__init__.py"), 'a', encoding='UTF-8') as f:
                        pass
                    migrations_path = os.path.join(app_path, "migrations")
                    #创建migrations目录和__init__.py文件
                    if not os.path.exists(migrations_path):
                        # 如果目标路径不存在就创建
                        os.makedirs(migrations_path)
                    with open(os.path.join(migrations_path, "__init__.py"), 'a', encoding='UTF-8') as f:
                        pass
                    #创建apps.py文件
                    app_init_content = f"""from django.apps import AppConfig

class {name.capitalize()}Config(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = 'apps.{name}'
"""
                    with open(os.path.join(app_path, "apps.py"), 'w', encoding='UTF-8') as f:
                        f.write(app_init_content)
                    #创建models.py文件
                    model_init_content = f"""from django.db import models
from utils.models import CoreModel,BaseModel
"""
                    with open(os.path.join(app_path, "models.py"), 'a', encoding='UTF-8') as f:
                        f.write(model_init_content)
                    #创建views.py文件
                    view_init_content = f"""from rest_framework.views import APIView
from apps.lymessages.models import MyMessageTemplate,MyMessage,MyMessageUser
from utils.jsonResponse import SuccessResponse,ErrorResponse,DetailResponse
from utils.common import get_parameter_dic,formatdatetime
from django.db.models import Q,F,Sum,Count
from django.db import transaction
from rest_framework import serializers
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework.permissions import IsAuthenticated
from utils.pagination import CustomPagination
import logging
logger = logging.getLogger(__name__)
"""
                    with open(os.path.join(app_path, "views.py"), 'a', encoding='UTF-8') as f:
                        f.write(view_init_content)
                    # 创建urls.py文件
                    urls_init_content = f"""# -*- coding: utf-8 -*-

#路由文件

from django.urls import path, re_path
from rest_framework import routers

#from apps.lymonitor.views import MonitorManageViewSet

system_url = routers.SimpleRouter()
#system_url.register(r'monitor', MonitorManageViewSet)

urlpatterns = [
#    path('getsysteminfo/',MonitorManageViewSet.as_view({{'get':'getsysteminfo'}}), name='lyadminstartapp创建app路由文件名'),
]
urlpatterns += system_url.urls
"""
                    with open(os.path.join(app_path, "urls.py"), 'a', encoding='UTF-8') as f:
                        f.write(urls_init_content)

                    print(f"App名称：{name} 创建成功！")

        else:
            print(f"提示：该命令会把app创建到apps目录中")
            print(f"请输入要创建的app名称如：python manage.py lyadminstartapp app名")

from django.apps import AppConfig
from django.utils.module_loading import autodiscover_modules
import os
import psutil

class MallConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.mall'

    # 启动django时自动执行该脚本
    def ready(self):
        if ismainrun():
            print("商城订单超时自动取消功能正在启动........")
            excutemallordercancle()
            print("商城订单超时自动取消功能已启动")


def excutemallordercancle():
    autodiscover_modules('redis_ex_mallorder_callback')


def ismainrun():
    """
    判断是否是django的主程序执行的
    """
    p = psutil.Process(os.getpid())
    return (os.environ.get('RUN_MAIN')=='true') or ('--noreload' in p.cmdline()) or ('application.wsgi:application' in p.cmdline())
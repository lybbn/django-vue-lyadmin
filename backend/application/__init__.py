#Django连接MySQL时默认使用MySQLdb驱动，但MySQLdb不支持Python3，因此这里将MySQL驱动设置为pymysql
import pymysql

pymysql.install_as_MySQLdb()

from .celery import app as celery_app

__all__ = ('celery_app',)
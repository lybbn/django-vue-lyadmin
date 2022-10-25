#!/bin/python
#coding: utf-8
# +-------------------------------------------------------------------
# | system: django-vue-lyadmin
# +-------------------------------------------------------------------
# | Author: lybbn
# +-------------------------------------------------------------------
# | QQ: 1042594286
# +-------------------------------------------------------------------

# ------------------------------
# celery 任务文件
# ------------------------------

from application.celery import app

@app.task(bind=True)
def lytask_test(self):
    print(self.request)
    return "django-vue-lyadmin lycrontab running"
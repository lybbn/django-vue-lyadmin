#Author:ly
#Date:2022-04-30

import os
from django.conf import settings
from celery import platforms
from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'application.settings')
app = Celery(f"application")

app.config_from_object('django.conf:settings')
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)
platforms.C_FORCE_ROOT = True
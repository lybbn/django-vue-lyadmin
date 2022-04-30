#Author:ly
#Date:2022-04-30

import os
from django.conf import settings
from celery import platforms
from celery import Celery

# Set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'application.settings')
app = Celery(f"application")

# Using a string here means the worker doesn't have to serialize
# the configuration object to child processes.
# - namespace='CELERY' means all celery-related configuration keys
#  should have a `CELERY_` prefix.
app.config_from_object('django.conf:settings',namespace='CELERY')

app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)

platforms.C_FORCE_ROOT = True
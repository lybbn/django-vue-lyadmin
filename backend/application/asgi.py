"""
ASGI config for application project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/howto/deployment/asgi/
"""

import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'application.settings')
django.setup()

from django.core.asgi import get_asgi_application

from utils.middleware import JwtAuthMiddleware
from channels.routing import ProtocolTypeRouter, URLRouter
from apps.lywebsocket.routing import websocket_urlpatterns


# application = get_asgi_application()

application = ProtocolTypeRouter({
  "http": get_asgi_application(),# 也可以不需要此项，普通的HTTP请求不需要我们手动在这里添加，框架会自动加载
  "websocket": JwtAuthMiddleware(
        # 多个url合并一起使用，多个子路由列表相加:a+b
        URLRouter(
            websocket_urlpatterns
        )
    ),
})

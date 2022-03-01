from apps.oauth.views import get_wechat_xcx_access_token_url
from django.core.management.base import BaseCommand
import json
from django.core.cache import cache

"""
7200秒 2小时（时间可以设置小于7200秒）
定时获取微信小程序的access_token，放到缓存（redis）中，默认access_token过期时间2小时
"""
class Command(BaseCommand):
    def handle(self, *args, **options):
        restoken = get_wechat_xcx_access_token_url()
        if restoken.status_code == 200:
            json_data = json.loads(restoken.content)
            if 'errcode' not in json_data:  # 如果获取失败返回失败信息
                access_token = json_data['access_token']
                expires_in = json_data['expires_in']
                cache.set('xcx_access_token', access_token,7000)
                # cache.expire('xcx_access_token', expires_in)


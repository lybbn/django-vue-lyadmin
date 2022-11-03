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
# 极光推送
# ------------------------------

from config import JIGUANG_APPKEY,JIGUANG_SECRET
import jpush
import logging
logger = logging.getLogger(__name__)

_jpush = jpush.JPush(JIGUANG_APPKEY,JIGUANG_SECRET)
_jpush.set_logging("DEBUG")  # 设置日志

def jpush_msg(id,messages):
    """
    id:要发送的标志数组(这里设置发送标识未userid) ['xxxxxx','xxxxxxx']
    messages:要发送的消息
    """

    push = _jpush.create_push()
    #push.audience = jpush.all_#推送给所有人
    push.audience = {'alias':id}
    push.platform = jpush.all_ #设置推送所有平台
    #push.platform = jpush.platform("android")  # 设置推送指定平台，关键字为"android", "ios","winphone"
    push.notification = jpush.notification(alert=messages)  # 第一个值似乎没有什么用,另外这个push目前只发送至android
    #push.message = jpush.message(msg_content, title=None, content_type=None, extras=None)  # 指定消息内容
    #push.smsmessage = jpush.smsmessage(content,delay_time)  # 指定短信内容和延迟时间（单位为秒，不能超过24小时。设置为0，表示立即发送短信。该参数仅对android平台有效，iOS 和 Winphone平台则会立即发送短信）
    try:
        push.send()
    except Exception as e:
        logger.error("极光推送服务错误，推送给：%s，推送内容：%s" % (str(id),str(e)))
if __name__=="__main__":
    device_id = '001023123123'  # device_id 需要事先获得
    message = "This is a test"
    jpush_msg(device_id,message)
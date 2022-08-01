#!/bin/python
#coding: utf-8
# +-------------------------------------------------------------------
# | django-vue3-lyadmin
# +-------------------------------------------------------------------
# | Author: lybbn
# +-------------------------------------------------------------------
# | QQ: 1042594286
# +-------------------------------------------------------------------

# ------------------------------
# websocket方法封装
# ------------------------------
import json
import time
import sys,os
from asgiref.sync import async_to_sync
from channels.generic.websocket import WebsocketConsumer
from django.contrib.auth.models import AnonymousUser
from io import BytesIO, StringIO
import paramiko
from threading import Thread
from apps.lywebsocket.models import TerminalServer
from django.http.request import QueryDict
from channels.db import database_sync_to_async
from django.conf import settings

SSH_LOG_PATH = os.path.join(settings.BASE_DIR,'logs','terminal.log')

def get_host_info(id):
    instance = TerminalServer.objects.filter(id=id).first()
    if not instance:
        return None
    return instance

#服务器终端websocket 、继承的WebsocketConsumer为同步方法
class TerminalConsumer(WebsocketConsumer):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.ssh_client = None
        self.chan = None
        self.id = None
        self.ssh_info = None

    # websocket建立连接时执行方法
    def connect(self):
        # self.scope["query_string"].decode() 获取websocket中传递的参数
        # print(self.scope["query_string"].decode())
        params = self.scope["query_string"].decode()
        dict_params = QueryDict(query_string=params, encoding='utf-8')
        self.id = dict_params.get('id',None)
        if not self.id:
            self.close()
        self.ssh_info = get_host_info(self.id)
        if not self.ssh_info:
            self.close()
        # 接受所有websocket请求,自定义Sec-WebSocket-Protocol头部返回时也要加上
        self.accept("JWTLYADMIN")
        self.initssh()

    def get_client(self):
        paramiko.util.log_to_file(SSH_LOG_PATH)
        # 创建SSH客户端
        ssh = paramiko.SSHClient()
        # SSH客户端Host策略,目的是接受不在本地Known_host文件下的主机。
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        # SSH客户端开启连接
        if self.ssh_info.type == 0:
            ssh.connect(
                hostname=self.ssh_info.host,
                port=self.ssh_info.port,
                username=self.ssh_info.username,
                password=self.ssh_info.password
            )
        else:
            tmppkey = self.ssh_info.pkey.encode('utf-8')
            if sys.version_info[0] == 2:
                p_file = BytesIO(tmppkey)
            else:
                p_file = StringIO(tmppkey)
            pkey = paramiko.RSAKey.from_private_key(p_file)
            ssh.connect(
                hostname=self.ssh_info.host,
                port=self.ssh_info.port,
                username=self.ssh_info.username,
                pkey=pkey
            )
        return ssh

    def loop_read(self):
        while True:
            data = self.chan.recv(1024)
            if not data:
                self.close()
                break

            self.send(bytes_data=data)

    def initssh(self):
        """
        建立ssh连接
        """
        self.send(bytes_data=b'Connecting ...\r\n')
        try:
            self.ssh_client = self.get_client()
            # 建立交互式shell连接
            self.chan = self.ssh_client.invoke_shell(term='xterm')
            self.chan.transport.set_keepalive(30)
            rv = Thread(target=self.loop_read)
            rv.start()

        except Exception as e:
            e = str(e)
            errors = ""
            if e.find('Authentication failed') != -1:
                errors = '认证失败{}'.format(e)
            elif e.find('Bad authentication type; allowed types') != -1:
                errors ='认证失败{}'.format(e)
            elif e.find('Connection reset by peer') != -1:
                errors ='目标服务器主动拒绝连接'
            elif e.find('Error reading SSH protocol banner') != -1:
                errors ='协议头响应超时'
            elif not e:
                errors ='SSH协议握手超时'
            else:
                import traceback
                errorMsg = traceback.format_exc()
                errors = '未知错误: {}'.format(errorMsg)
            self.send(text_data='Exception: %s\r\n'%errors)
            self.close()

    # websocket断开时执行方法
    def disconnect(self, close_code):
        try:
            if self.chan:
                self.chan.close()
            if self.ssh_client:
                self.ssh_client.close()
        except:
            pass

    # 从websocket接收到消息时执行函数
    def receive(self, text_data=None, bytes_data=None):
        data = text_data or bytes_data
        if len(data) > 10:
            if data.find('"resize":1') != -1:
                self.resize(data)
            else:
                if self.chan:
                    self.chan.send(data)
                else:
                    self.close()
        else:
            if self.chan:
                self.chan.send(data)
            else:
                self.close()

    def resize(self, data):
        '''
        @name 调整终端大小
        @param data<dict> 终端尺寸数据
        {
            cols: int 列
            rows: int 行
        }
        '''
        try:
            data = json.loads(data)
            self.chan.resize_pty(width=data['cols'], height=data['rows'])
        except:
            pass


from django.db import models
from utils.models import CoreModel,BaseModel
# Create your models here.
# ================================================= #
# ************** 终端服务器信息 model************** #
# ================================================= #

class TerminalServer(CoreModel):
    TYPE_CHOICES = (
        (0, "密码验证"),
        (1, "私钥验证"),
    )
    host = models.CharField(max_length=100, verbose_name="服务器IP/域名")
    port = models.IntegerField(verbose_name="端口号", default=22,help_text="端口号")
    remark = models.CharField(max_length=100,verbose_name="备注",null=True,blank=True)
    username = models.CharField(max_length=200, verbose_name="用户名")
    password = models.CharField(max_length=200, verbose_name="密码",null=True,blank=True)
    pkey = models.CharField(max_length=255, verbose_name="私钥",null=True,blank=True)
    pkey_passwd = models.CharField(max_length=255, verbose_name="私钥密码",null=True,blank=True)
    type = models.SmallIntegerField(choices=TYPE_CHOICES, verbose_name="验证方式", default=0,help_text="验证方式")

    class Meta:
        db_table = 'tb_terminalserver'
        verbose_name = "终端服务器列表"
        verbose_name_plural = verbose_name

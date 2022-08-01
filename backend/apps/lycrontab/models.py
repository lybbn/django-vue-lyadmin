from django.db import models
from utils.modles import CoreModel,BaseModel
# Create your models here.

# ================================================= #
# ************** 服务端计划任务 model************** #
# ================================================= #

class CrontabManage(CoreModel):
    STATUS_CHOICES = (
        (1, "正常"),
        (2, "停用"),
    )
    TASK_TYPE_CHOICES = (
        (1, "Shell脚本"),
        (2, "Celery任务"),
        (5, "访问URL"),
    )
    TYPE_CHOICES = (
        (1, "每天"),
        (2, "每N天"),
        (3, "每小时"),
        (4, "N小时"),
        (5, "N分钟"),
        (6, "每周"),
        (7, "每月"),
    )
    name = models.CharField(max_length=100, verbose_name="任务名称")
    status = models.SmallIntegerField(choices=STATUS_CHOICES,default=1,verbose_name="任务状态")
    tasktype = models.SmallIntegerField(choices=TASK_TYPE_CHOICES,default=1,verbose_name="任务类型")
    cycle = models.CharField(max_length=100, verbose_name="任务周期")
    type = models.SmallIntegerField(choices=TYPE_CHOICES, default=1, verbose_name="周期类型")
    body = models.TextField(verbose_name="脚本内容", null=True,blank=True)
    week = models.SmallIntegerField(default=0,verbose_name="周")
    day = models.SmallIntegerField(default=0,verbose_name="天")
    hour = models.SmallIntegerField(default=0, verbose_name="小时")
    minute = models.SmallIntegerField(default=0, verbose_name="分钟")
    urladdress = models.CharField(max_length=255, verbose_name="url地址", null=True,blank=True)

    class Meta:
        db_table = 'tb_crontab'
        verbose_name = "计划任务"
        verbose_name_plural = verbose_name
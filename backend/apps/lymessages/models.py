from django.db import models
from utils.modles import CoreModel,BaseModel
from mysystem.models import Users

# Create your models here.
# ================================================= #
# ************** 用户消息 model************** #
# ================================================= #
#消息模板
class MyMessageTemplate(CoreModel):
    code = models.CharField(max_length=100,unique=True, verbose_name="模板code")
    title = models.CharField(max_length=100, verbose_name="消息标题")
    content = models.TextField(verbose_name="消息模板内容")

    class Meta:
        db_table = 'tb_message_template'
        verbose_name = '消息模板'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.title

#消息表
class MyMessage(CoreModel):
    msg_chanel = models.IntegerField(choices=((1, u'系统通知'),(2, u'平台公告')), verbose_name="消息渠道",default=1)
    msg_type = models.ForeignKey(MyMessageTemplate,verbose_name="消息类型",on_delete=models.PROTECT, null=True, blank=True)  # 消息模板，主要用于消息过滤
    public = models.BooleanField(default=False, verbose_name="是否公开")  # 1是，0不是，默认不是
    msg_title = models.CharField(max_length=100, verbose_name="消息标题", null=True, blank=True)
    msg_content = models.TextField(verbose_name="消息内容",null=True, blank=True)
    to_path = models.CharField(max_length=256, verbose_name="跳转路径", null=True, blank=True, )
    status = models.BooleanField(default=True, verbose_name="通知状态")#待发送，已发送

    class Meta:
        db_table = 'tb_message'
        verbose_name = '消息中心'
        verbose_name_plural = verbose_name

    def __str__(self):
        return f"{self.msg_title}"


#附表用于用户的操作获取行为
class MyMessageUser(BaseModel):
    messageid = models.ForeignKey(MyMessage, verbose_name="消息ID", on_delete=models.CASCADE)
    senduserid = models.ForeignKey(Users, verbose_name="发送者用户ID",on_delete=models.CASCADE,related_name='messagesenduserid',null=True, blank=True)
    revuserid = models.ForeignKey(Users, verbose_name="接收者用户ID",on_delete=models.CASCADE,related_name='messagerevuserid')
    read_at = models.DateTimeField(verbose_name='读取时间',null=True, blank=True)
    is_delete = models.BooleanField(default=False, verbose_name="是否删除")#0不删除，1删除
    is_read = models.BooleanField(default=False, verbose_name="是否已读")  # 0没读，1已读

    class Meta:
        db_table = 'tb_message_user'
        verbose_name = '用户消息'
        verbose_name_plural = verbose_name

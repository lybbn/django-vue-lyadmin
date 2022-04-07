from django.db import models
from utils.modles import CoreModel,BaseModel
from mysystem.models import Users

# Create your models here.

# ================================================= #
# ************** 轮播图设置 model************** #
# ================================================= #
LUNBOTU_CHOICES = (
        (1, "首页轮播图"),
        (2, "分类首页轮播图"),
    )

class LunbotuManage(CoreModel):
    title = models.CharField(max_length=100, verbose_name='标题',null=True,blank=True)
    type = models.IntegerField(choices=LUNBOTU_CHOICES, verbose_name="轮播图类型")
    status = models.BooleanField(default=True,verbose_name="状态")
    sort = models.IntegerField(default=1, verbose_name="排序", help_text="显示顺序")
    image = models.CharField(max_length=255, verbose_name="图片", default="")
    link = models.CharField(max_length=100, verbose_name="链接", default="")

    class Meta:
        db_table = 'tb_lunbo_manage'
        verbose_name = "轮播图设置"
        verbose_name_plural = verbose_name

# ================================================= #
# ************** 其他设置 model************** #
# ================================================= #

class OtherManage(CoreModel):
    TYPE_CHOICES = (
        (1, "正常值"),
        (2, "富文本"),
        (3, "图片"),
    )
    status = models.BooleanField(default=True,verbose_name="状态")
    type = models.IntegerField(choices=TYPE_CHOICES,default=1,verbose_name="类型")
    name = models.CharField(max_length=50, verbose_name="名称", default="")
    key = models.CharField(max_length=50,verbose_name="键名",default="")
    value = models.TextField(verbose_name="键值", default="")
    sort = models.IntegerField(default=1, verbose_name="排序", help_text="显示顺序")

    class Meta:
        db_table = 'tb_other_manage'
        verbose_name = "平台其他设置"
        verbose_name_plural = verbose_name

# ================================================= #
# ************** 意见反馈 model************** #
# ================================================= #
class UserLeavingMessage(CoreModel):
    """
    意见反馈/留言
    """
    MESSAGE_CHOICES = (
        (1, "留言"),
        (2, "投诉"),
        (3, "询问"),
        (4, "售后"),
        (5, "求购"),
    )
    user = models.ForeignKey(Users, on_delete=models.CASCADE,related_name='leavingmessage_user', verbose_name="用户")
    message_type = models.SmallIntegerField(default=1, choices=MESSAGE_CHOICES, verbose_name="留言类型",help_text=u"留言类型: 1(留言),2(投诉),3(询问),4(售后),5(求购)")
    subject = models.CharField(max_length=100, default="", verbose_name="主题",null=True,blank=True)
    message = models.TextField(default="", verbose_name="留言内容", help_text="留言内容")
    images = models.CharField(max_length=3000, default="", verbose_name="上传的图片", null=True, blank=True)

    class Meta:
        db_table = 'tb_user_leaving'
        verbose_name = "用户反馈"
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.message
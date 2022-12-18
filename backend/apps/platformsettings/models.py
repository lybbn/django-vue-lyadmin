from django.db import models
from utils.models import CoreModel,BaseModel,table_prefix
from mysystem.models import Users

# Create your models here.

# ================================================= #
# ************** 轮播图设置 model************** #
# ================================================= #

class LunbotuManage(CoreModel):
    """
    轮播图
    """
    LUNBOTU_CHOICES = (
        (1, "首页轮播图"),
        (2, "分类首页轮播图"),
    )
    LINK_TYPE_CHOICES = (
        (0, "无"),
        (1, "链接"),
        (2, "富文本"),
    )
    title = models.CharField(max_length=100, verbose_name='标题',null=True,blank=True)
    type = models.IntegerField(choices=LUNBOTU_CHOICES, verbose_name="轮播图类型")
    status = models.BooleanField(default=True,verbose_name="状态")
    sort = models.IntegerField(default=1, verbose_name="排序", help_text="显示顺序")
    image = models.CharField(max_length=255, verbose_name="图片", default="")
    link = models.TextField(verbose_name="链接/富文本内容", default="", null=True, blank=True)
    link_type = models.IntegerField(choices=LINK_TYPE_CHOICES, verbose_name="跳转类型", default=0)


    class Meta:
        db_table = 'tb_lunbo_manage'
        verbose_name = "轮播图设置"
        verbose_name_plural = verbose_name

# ================================================= #
# ************** 参数设置 model************** #
# ================================================= #

class OtherManage(CoreModel):
    TYPE_CHOICES = (
        (1, "正常值"),
        (2, "富文本"),
        (3, "图片"),
        (4, "视频"),
    )
    status = models.BooleanField(default=True,verbose_name="状态")
    type = models.IntegerField(choices=TYPE_CHOICES, default=1, verbose_name="类型")
    name = models.CharField(max_length=50, verbose_name="名称", default="")
    key = models.CharField(max_length=50,verbose_name="键名",default="")
    value = models.TextField(verbose_name="键值", default="")
    sort = models.IntegerField(default=1, verbose_name="排序", help_text="显示顺序")

    class Meta:
        db_table = 'tb_other_manage'
        verbose_name = "参数设置"
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

# ================================================= #
# ************** 系统配置 model************** #
# ================================================= #

class SystemConfig(CoreModel):
    """
    系统配置
    """
    CHOICE_FORM_ITEM_TYPE_LIST = (
        (0, "text"),
        (1, "datetime"),
        (2, "date"),
        (3, "textarea"),
        (4, "select"),
        (5, "checkbox"),
        (6, "radio"),
        (7, "image"),
        (8, "file"),
        (9, "switch"),
        (10, "number"),
        (11, "array"),
        (12, "images"),
        (13, "time"),
        (14, "richtext"),
    )
    parent = models.ForeignKey(to="self",verbose_name="父级",on_delete=models.CASCADE,db_constraint=False,null=True,blank=True, help_text="父级")
    title = models.CharField(max_length=50, verbose_name="标题", help_text="标题")
    key = models.CharField(max_length=20, verbose_name="键名", help_text="键名", db_index=True)
    value = models.JSONField(max_length=100, verbose_name="键值", help_text="键值", null=True, blank=True)
    sort = models.IntegerField(default=0, verbose_name="排序", help_text="排序", blank=True)
    status = models.BooleanField(default=True, verbose_name="启用状态", help_text="启用状态")
    data_options = models.JSONField(verbose_name="数据options", help_text="数据options", null=True, blank=True)
    form_item_type = models.SmallIntegerField(choices=CHOICE_FORM_ITEM_TYPE_LIST, verbose_name="表单类型", help_text="表单类型", default=0, blank=True)
    rule = models.JSONField(null=True, blank=True, verbose_name="校验规则", help_text="校验规则")
    placeholder = models.CharField(max_length=50, null=True, blank=True, verbose_name="提示信息", help_text="提示信息")
    setting = models.JSONField(null=True, blank=True, verbose_name="配置", help_text="配置")

    class Meta:
        db_table = table_prefix + "system_config"
        verbose_name = "系统配置表"
        verbose_name_plural = verbose_name
        ordering = ("sort",)
        unique_together = (("key", "parent_id"),)

    def __str__(self):
        return f"{self.title}"
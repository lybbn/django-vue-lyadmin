from django.db import models
from utils.modles import CoreModel,BaseModel

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
    status = models.BooleanField(default=True,verbose_name="状态")
    name = models.CharField(max_length=50, verbose_name="名称", default="")
    key = models.CharField(max_length=50,verbose_name="键名",default="")
    value = models.TextField(verbose_name="键值", default="")
    sort = models.IntegerField(default=1, verbose_name="排序", help_text="显示顺序")

    class Meta:
        db_table = 'tb_other_manage'
        verbose_name = "平台其他设置"
        verbose_name_plural = verbose_name
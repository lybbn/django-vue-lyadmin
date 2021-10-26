from django.db import models
from utils.modles import CoreModel,BaseModel

# Create your models here.
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
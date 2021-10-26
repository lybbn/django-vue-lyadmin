from django.db import models
from utils.modles import BaseModel
from mysystem.models import Users
# Create your models here.

# ================================================= #
# ************** 全国省区市 model************** #
# ================================================= #

class Area(models.Model):
    """省市区"""
    name = models.CharField(max_length=50, verbose_name='名称')
    parent = models.ForeignKey('self', on_delete=models.SET_NULL, related_name='subs', null=True, blank=True, verbose_name='上级行政区划')#外键链接自己
    #related_name='subs' ，意思为如果想找自己的子级，就可以通过area.subs找到自己下级所有的area区域,我们也可以这样调用获取市: area.area_set.all() ==> area.subs.all()
    #on_delete=models.SET_NULL:  如果省删掉了,省内其他的信息为 NULL
    class Meta:
        db_table = 'tb_areas'
        verbose_name = '省市区'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name


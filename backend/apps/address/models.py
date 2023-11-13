from django.db import models
from utils.models import BaseModel,CoreModel
from mysystem.models import Users
# Create your models here.

# ================================================= #
# ************** 全国省区市 model************** #
# ================================================= #

class Area(CoreModel):
    """省市区"""
    name = models.CharField(max_length=50, verbose_name='名称')
    parent = models.ForeignKey('self', on_delete=models.SET_NULL, related_name='subs', null=True, blank=True,db_constraint=False, verbose_name='上级行政区划')#外键链接自己
    citycode = models.CharField(max_length=20, verbose_name="城市编码", help_text="城市编码", db_index=True, null=True, blank=True)
    level = models.PositiveIntegerField(default=0,verbose_name="地区层级(1省份 2城市 3区县 4乡镇/街道级)")
    status = models.BooleanField(default=True,verbose_name="状态")
    #related_name='subs' ，意思为如果想找自己的子级，就可以通过area.subs找到自己下级所有的area区域,我们也可以这样调用获取市: area.area_set.all() ==> area.subs.all()
    #on_delete=models.SET_NULL:  如果省删掉了,省内其他的信息为 NULL
    class Meta:
        db_table = 'tb_areas'
        verbose_name = '省市区'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name

# ================================================= #
# ************** 用户地址model************** #
# ================================================= #

class Address(BaseModel):
    """用户地址"""
    user = models.ForeignKey(Users, on_delete=models.CASCADE, related_name='addresses', verbose_name='所属用户') # 一对多
    receiver = models.CharField(max_length=20,null=True, blank=True, verbose_name='收货人')
    province = models.CharField(max_length=32, null=True, blank=True,verbose_name='省')
    city = models.CharField(max_length=32,null=True, blank=True, verbose_name='市')
    district = models.CharField(max_length=32, null=True, blank=True,verbose_name='区')
    street = models.CharField(max_length=32, null=True, blank=True,verbose_name='街道')
    place = models.CharField(max_length=50, verbose_name='收货地址')#详细地址
    mobile = models.CharField(max_length=11, verbose_name='手机号')
    longitude = models.FloatField(verbose_name='经度',null=True, blank=True)
    latitude = models.FloatField(verbose_name='纬度',null=True, blank=True)
    is_default = models.BooleanField(default=False, verbose_name='是否默认')
    is_deleted = models.BooleanField(default=False, verbose_name='逻辑删除')#是否有效，是否显示

    def get_region_format(self):
        """省市区"""
        return "{self.province}{self.city}{self.district}".format(self=self)

    class Meta:
        db_table = 'tb_address'
        verbose_name = '用户地址'
        verbose_name_plural = verbose_name


    def __str__(self):
        if self.street:
            return self.get_region_format() + self.street + self.place
        else:
            return self.get_region_format() + self.place
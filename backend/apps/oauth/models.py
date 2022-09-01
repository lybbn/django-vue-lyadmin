from django.db import models
from utils.modles import CoreModel,BaseModel
from mysystem.models import Users
from django.db.models.signals import post_save
from django.dispatch import receiver
# Create your models here.
# ================================================= #
# ************** 第三方认证快捷登录model************** #
# ================================================= #

class OAuthWXUser(BaseModel):
    """微信登录用户数据"""

    user = models.OneToOneField(Users, on_delete=models.CASCADE, verbose_name='用户')# 一对一
    xcx_openid = models.CharField(max_length=100, db_index=True,null=True,blank=True,verbose_name='小程序openid')
    gzh_openid = models.CharField(max_length=100, db_index=True, null=True, blank=True,verbose_name='公众号openid')
    avatarUrl = models.CharField(max_length=900, verbose_name='用户头像',null=True, blank=True)
    nick = models.CharField(max_length=40, verbose_name='用户昵称',null=True, blank=True)
    sex = models.CharField(max_length=100, null=True, blank=True)
    city = models.CharField(max_length=100, null=True, blank=True)
    province = models.CharField(max_length=100, null=True, blank=True)
    country = models.CharField(max_length=100, null=True, blank=True)
    unionId = models.CharField(max_length=255, null=True, blank=True)
    session_key = models.CharField(max_length=255, null=True, blank=True)
    xcx_access_token = models.CharField(max_length=255, null=True, blank=True, verbose_name='小程序access_token')
    gzh_access_token = models.CharField(max_length=255, null=True, blank=True,verbose_name='公众号access_token')
    gzh_refresh_token = models.CharField(max_length=255, null=True, blank=True,verbose_name='公众号refresh_token')
    gzh_scope = models.CharField(max_length=255, null=True, blank=True,verbose_name='公众号scope')
    mobilePhoneNumber = models.CharField(max_length=11, verbose_name="微信小程序绑定的手机号码", default="")

    class Meta:
        db_table = 'tb_oauth_wx'
        verbose_name = '微信登录用户数据'
        verbose_name_plural = verbose_name


# @receiver(post_save, sender=Users)
# def create_wechat_user(sender, instance, created, **kwargs):
#     if created:#新增时
#         OAuthWXUser.objects.create(user=instance,nick='')
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.db import transaction
from mysystem.models import MenuButton,Menu,Button

#利用django信号机制实现，创建菜单时自动为其添加菜单按钮权限（查询、删除、修改、新增、单例）
@transaction.atomic#事务
@receiver(post_save, sender=Menu)
def auto_create_menu_button_permission(sender, instance=None, created=False, **kwargs):
    if created:#新增时
        if instance.isautopm:#是否自动创建按钮权限
            buttons = Button.objects.all()
            for i in buttons:
                MenuButton.objects.create(menu=instance,name=i.name,value=i.value)
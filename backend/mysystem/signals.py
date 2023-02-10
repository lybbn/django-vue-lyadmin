from django.db.models.signals import post_save
from django.dispatch import receiver
from django.db import transaction
from mysystem.models import MenuButton,Menu,Button

CRUD_BUTTON = ['Create','Delete','Update','Retrieve','Search']
METHOD_CHOICES = [1,3,2,0,0]#(0, "GET"),(1, "POST"),(2, "PUT"),(3, "DELETE")

#利用django信号机制实现，创建菜单时自动为其添加菜单按钮权限（查询、删除、修改、新增、单例）
@transaction.atomic#事务
@receiver(post_save, sender=Menu)
def auto_create_menu_button_permission(sender, instance=None, created=False, **kwargs):
    if created:#新增时
        if instance.isautopm:#是否自动创建按钮权限
            buttons = Button.objects.all()
            intance_list = []
            for i in buttons:
                if i.value in CRUD_BUTTON:
                    obj = MenuButton(menu=instance,name=i.name,value=i.value,method=METHOD_CHOICES[CRUD_BUTTON.index(i.value)])
                    intance_list.append(obj)
            MenuButton.objects.bulk_create(intance_list)
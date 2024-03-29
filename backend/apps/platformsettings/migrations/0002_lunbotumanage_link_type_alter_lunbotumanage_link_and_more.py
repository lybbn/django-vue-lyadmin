# Generated by Django 4.0.5 on 2022-07-28 23:11

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import utils.models


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('platformsettings', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='lunbotumanage',
            name='link_type',
            field=models.IntegerField(choices=[(0, '无'), (1, '链接'), (2, '富文本')], default=0, verbose_name='跳转类型'),
        ),
        migrations.AlterField(
            model_name='lunbotumanage',
            name='link',
            field=models.TextField(blank=True, default='', null=True, verbose_name='链接/富文本内容'),
        ),
        migrations.CreateModel(
            name='UserLeavingMessage',
            fields=[
                ('id', models.CharField(default=utils.models.make_uuid, help_text='Id', max_length=100, primary_key=True, serialize=False, verbose_name='Id')),
                ('description', models.CharField(blank=True, help_text='描述', max_length=100, null=True, verbose_name='描述')),
                ('modifier', models.CharField(blank=True, help_text='修改人', max_length=100, null=True, verbose_name='修改人')),
                ('dept_belong_id', models.CharField(blank=True, help_text='数据归属部门', max_length=100, null=True, verbose_name='数据归属部门')),
                ('update_datetime', models.DateTimeField(auto_now=True, help_text='修改时间', null=True, verbose_name='修改时间')),
                ('create_datetime', models.DateTimeField(auto_now_add=True, help_text='创建时间', null=True, verbose_name='创建时间')),
                ('message_type', models.SmallIntegerField(choices=[(1, '留言'), (2, '投诉'), (3, '询问'), (4, '售后'), (5, '求购')], default=1, help_text='留言类型: 1(留言),2(投诉),3(询问),4(售后),5(求购)', verbose_name='留言类型')),
                ('subject', models.CharField(blank=True, default='', max_length=100, null=True, verbose_name='主题')),
                ('message', models.TextField(default='', help_text='留言内容', verbose_name='留言内容')),
                ('images', models.CharField(blank=True, default='', max_length=3000, null=True, verbose_name='上传的图片')),
                ('creator', models.ForeignKey(db_constraint=False, help_text='创建人', null=True, on_delete=django.db.models.deletion.SET_NULL, related_query_name='creator_query', to=settings.AUTH_USER_MODEL, verbose_name='创建人')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='leavingmessage_user', to=settings.AUTH_USER_MODEL, verbose_name='用户')),
            ],
            options={
                'verbose_name': '用户反馈',
                'verbose_name_plural': '用户反馈',
                'db_table': 'tb_user_leaving',
            },
        ),
    ]

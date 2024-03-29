# Generated by Django 4.0.5 on 2022-07-09 12:08

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import utils.models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='MonitorManage',
            fields=[
                ('id', models.CharField(default=utils.models.make_uuid, help_text='Id', max_length=100, primary_key=True, serialize=False, verbose_name='Id')),
                ('description', models.CharField(blank=True, help_text='描述', max_length=100, null=True, verbose_name='描述')),
                ('modifier', models.CharField(blank=True, help_text='修改人', max_length=100, null=True, verbose_name='修改人')),
                ('dept_belong_id', models.CharField(blank=True, help_text='数据归属部门', max_length=100, null=True, verbose_name='数据归属部门')),
                ('update_datetime', models.DateTimeField(auto_now=True, help_text='修改时间', null=True, verbose_name='修改时间')),
                ('create_datetime', models.DateTimeField(auto_now_add=True, help_text='创建时间', null=True, verbose_name='创建时间')),
                ('ip', models.CharField(blank=True, max_length=50, null=True, verbose_name='服务器IP')),
                ('name', models.CharField(blank=True, max_length=50, null=True, verbose_name='名称')),
                ('os', models.CharField(blank=True, max_length=50, null=True, verbose_name='系统名称')),
                ('online', models.BooleanField(default=False, verbose_name='在线状态')),
                ('status', models.BooleanField(default=True, verbose_name='监控状态')),
                ('days', models.SmallIntegerField(default=30, verbose_name='日志保留天数')),
                ('interval', models.SmallIntegerField(default=5, verbose_name='监控日志刷新间隔')),
                ('islocal', models.BooleanField(default=False, verbose_name='是否是本机监控')),
                ('creator', models.ForeignKey(db_constraint=False, help_text='创建人', null=True, on_delete=django.db.models.deletion.SET_NULL, related_query_name='creator_query', to=settings.AUTH_USER_MODEL, verbose_name='创建人')),
            ],
            options={
                'verbose_name': '服务监控',
                'verbose_name_plural': '服务监控',
                'db_table': 'tb_monitor',
            },
        ),
    ]

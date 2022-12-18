# Generated by Django 4.0.8 on 2022-11-13 16:53

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import utils.models


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('platformsettings', '0004_alter_othermanage_options'),
    ]

    operations = [
        migrations.CreateModel(
            name='SystemConfig',
            fields=[
                ('id', models.CharField(default=utils.models.make_uuid, help_text='Id', max_length=100, primary_key=True, serialize=False, verbose_name='Id')),
                ('description', models.CharField(blank=True, help_text='描述', max_length=100, null=True, verbose_name='描述')),
                ('modifier', models.CharField(blank=True, help_text='修改人', max_length=100, null=True, verbose_name='修改人')),
                ('dept_belong_id', models.CharField(blank=True, help_text='数据归属部门', max_length=100, null=True, verbose_name='数据归属部门')),
                ('update_datetime', models.DateTimeField(auto_now=True, help_text='修改时间', null=True, verbose_name='修改时间')),
                ('create_datetime', models.DateTimeField(auto_now_add=True, help_text='创建时间', null=True, verbose_name='创建时间')),
                ('title', models.CharField(help_text='标题', max_length=50, verbose_name='标题')),
                ('key', models.CharField(db_index=True, help_text='键名', max_length=20, verbose_name='键名')),
                ('value', models.JSONField(blank=True, help_text='键值', max_length=100, null=True, verbose_name='键值')),
                ('sort', models.IntegerField(blank=True, default=0, help_text='排序', verbose_name='排序')),
                ('status', models.BooleanField(default=True, help_text='启用状态', verbose_name='启用状态')),
                ('data_options', models.JSONField(blank=True, help_text='数据options', null=True, verbose_name='数据options')),
                ('form_item_type', models.SmallIntegerField(blank=True, choices=[(0, 'text'), (1, 'datetime'), (2, 'date'), (3, 'textarea'), (4, 'select'), (5, 'checkbox'), (6, 'radio'), (7, 'img'), (8, 'file'), (9, 'switch'), (10, 'number'), (11, 'array'), (12, 'imgs'), (13, 'foreignkey'), (14, 'manytomany'), (15, 'time')], default=0, help_text='表单类型', verbose_name='表单类型')),
                ('rule', models.JSONField(blank=True, help_text='校验规则', null=True, verbose_name='校验规则')),
                ('placeholder', models.CharField(blank=True, help_text='提示信息', max_length=50, null=True, verbose_name='提示信息')),
                ('setting', models.JSONField(blank=True, help_text='配置', null=True, verbose_name='配置')),
                ('creator', models.ForeignKey(db_constraint=False, help_text='创建人', null=True, on_delete=django.db.models.deletion.SET_NULL, related_query_name='creator_query', to=settings.AUTH_USER_MODEL, verbose_name='创建人')),
                ('parent', models.ForeignKey(blank=True, db_constraint=False, help_text='父级', null=True, on_delete=django.db.models.deletion.CASCADE, to='platformsettings.systemconfig', verbose_name='父级')),
            ],
            options={
                'verbose_name': '系统配置表',
                'verbose_name_plural': '系统配置表',
                'db_table': 'lyadmin_system_config',
                'ordering': ('sort',),
                'unique_together': {('key', 'parent_id')},
            },
        ),
    ]

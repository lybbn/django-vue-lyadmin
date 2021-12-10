# Django-Vue-Lyadmin

[![img](https://img.shields.io/badge/python-%3E=3.6.x-green.svg)](https://python.org/)  [![PyPI - Django Version badge](https://img.shields.io/badge/django%20versions-3.2-blue)](https://docs.djangoproject.com/zh-hans/3.2/) [![img](https://img.shields.io/badge/node-%3E%3D%2012.0.0-brightgreen)](https://nodejs.org/zh-cn/) [![img](https://gitee.com/lybbn/django-vue-lyadmin/badge/star.svg?theme=dark)](https://gitee.com/lybbn/django-vue-lyadmin)

[群聊](https://jq.qq.com/?_wv=1027&k=StAkGqk5) 

## 平台简介

django-vue-lyadmin 是一套python django web前后端分离的管理后台快速开发平台，去繁从简、还你一个干净的后台管理系统

* 前端采用Vue（element-ui）
* 后端采用Python语言Django框架
* 权限认证使用JWT（djangorestframework-simplejwt），支持多终端认证系统
* 接口采用（drf）djangorestframework
* 支持加载动态权限菜单，内置常用模块，多方式轻松权限控制
* 适合刚入门或苦于寻找django web快速开发框架的小伙伴们

特别鸣谢：本平台后端设计模式，其部分参考[django-vue-admin-pro](https://gitee.com/dvadmin/django-vue-admin-pro)

## 交流

- QQ群号：755277564 <a target="_blank" href="https://jq.qq.com/?_wv=1027&k=oPz6bqmL"><img border="0" src="//pub.idqqimg.com/wpa/images/group.png" alt="django-vue-lyadmin交流01群" title="django-vue-lyadmin交流01群"></a>
- 二维码：

<img src='https://gitee.com/lybbn/django-vue-lyadmin/raw/master/frontend/src/assets/img/qq.jpg' width='200'>

## 源码地址

gitee地址(主推)：https://gitee.com/lybbn/django-vue-lyadmin

## 内置功能

1.  部门管理：配置系统组织机构（公司、部门、角色），树结构展现支持数据权限。
2.  菜单管理：配置系统菜单，操作权限，按钮权限标识、后端接口权限等。
3.  角色管理：角色菜单权限、数据权限、设置角色按部门进行数据范围权限划分。
4.  权限管理：授权角色的权限范围。
5.  管理员管理：主要管理系统管理员账号。
6.  用户管理：主要管理前端用户。
7.  个人中心：主要设置登录系统的个人昵称、密码等账号信息。
7.  操作日志：系统正常操作日志记录和查询；系统异常信息日志记录和查询。
8.  平台设置：系统设置如字典参数、轮播图
9.  其他功能：内置微信登录、小程序登录、短信登录、密码登录、微信企业到零钱等API

## django-vue-lyadmin项目启动视频讲解

[![Watch the video](https://gitee.com/lybbn/django-vue-lyadmin/raw/master/frontend/src/assets/img/01.png)](https://v.kuaishouapp.com/s/VIJPdIx6)

## lyadmin后端

~~~bash
1. 进入项目目录
2. 在 config.py 中配置数据库信息
	mysql数据库版本建议：8.0
	mysql数据库字符集：utf8mb4
    mysql数据库对应的表关于事务处理的确保是：innodb引擎（能回滚）
3. 设置数据库隔离级别（悲观锁、乐观锁）
    全局设置mysql数据库隔离级别为READ-COMMITTED（临时生效，重启就没了）：SET GLOBAL tx_isolation='READ-COMMITTED';
    全局设置mysql数据库隔离级别为READ-COMMITTED（永久有效）：修改配置文件my.cnf 的[mysqld]中增加 transaction-isolation=Read-Committed 
    当数据库当前会话的隔离级别：set tx_isolation='READ-COMMITTED';
    查询当前会话的数据库隔离级别：select @@tx_isolation;
    查询数据库mysql的隔离级别：select @@global.tx_isolation;
    
4. 安装依赖环境
	pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
5. 执行迁移命令：
	python3 manage.py makemigrations
	python3 manage.py migrate
6. 初始化数据
	python3 manage.py init
7. 启动项目
	python3 manage.py runserver 127.0.0.1:8000
    或使用 daphne :
    daphne -b 0.0.0.0 -p 8000 --proxy-headers application.asgi:application
初始账号：superadmin 密码：123456

~~~

## 其他说明

1、使用本项目记得要更改application-->settings-->SECRET_KEY
~~~bash
可以运行python manage.py shell
from django.core.management import utils
utils.get_random_secret_key()
获取生成的新SECRET_KEY替换原来的老KEY
~~~

## lyadmin前端

#### 介绍

django-vue-lyadmin 是一套前后端分离的前端后台管理框架，是适配 django-vue-lyadmin 的 python django 后台管理项目的专属框架，基于原生 vue 开发，灵活自定义，可发挥空间大

#### 软件架构


```
1、VUE
2、富文本编辑器 vue-quill-editor
```

#### 安装教程


```
cd frontend
npm install --registry=https://registry.npm.taobao.org
```


#### 使用说明

调试开发直接运行： 

```
npm start
```


#### 打包


```
npm run build
```


打包后静态文件在 dist 目录中

## 演示图

![image-01](https://gitee.com/lybbn/django-vue-lyadmin/raw/master/frontend/src/assets/img/01.png)

![image-04](https://gitee.com/lybbn/django-vue-lyadmin/raw/master/frontend/src/assets/img/04.png)

![image-02](https://gitee.com/lybbn/django-vue-lyadmin/raw/master/frontend/src/assets/img/02.png)

![image-03](https://gitee.com/lybbn/django-vue-lyadmin/raw/master/frontend/src/assets/img/03.png)

![image-05](https://gitee.com/lybbn/django-vue-lyadmin/raw/master/frontend/src/assets/img/05.png)
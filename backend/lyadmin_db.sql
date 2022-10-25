﻿# Host: localhost  (Version: 5.7.26)
# Date: 2022-10-26 00:27:41
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "auth_group"
#

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='group';

#
# Data for table "auth_group"
#


#
# Structure for table "captcha_captchastore"
#

CREATE TABLE `captcha_captchastore` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge` varchar(32) NOT NULL,
  `response` varchar(32) NOT NULL,
  `hashkey` varchar(40) NOT NULL,
  `expiration` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hashkey` (`hashkey`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COMMENT='captcha store';

#
# Data for table "captcha_captchastore"
#

REPLACE INTO `captcha_captchastore` VALUES (2,'1+9=','10','b30a8d21f0d1d95c53b69b994c154e8189cc7c80','2022-07-04 21:33:33.914140'),(6,'3-2=','1','f3dfa2a7cbf3bda32a53298be602874fffaf6c68','2022-07-09 12:12:33.322567'),(8,'8*9=','72','2c7d94480f0c98db4137380db0e194acc258e9a6','2022-07-16 15:01:48.225074'),(9,'5*5=','25','ffd0b6d67099501f4bcdf5240553a22f84669d30','2022-07-17 09:44:46.330850'),(11,'1*6=','6','8150b2d7af32cc9cf1ef2e7f32f47c18079e32ae','2022-07-17 23:58:02.858469'),(13,'5+7=','12','84015e072e7fe570ba8d34deb9f8fc120d115cc4','2022-07-18 09:10:43.608250'),(14,'7+9=','16','37a0cc3cc181ff52f1e993278e883be76b51d9d7','2022-07-18 09:11:06.525042'),(23,'5*2=','10','af73bce2f14be6416917dd639b2fe4690d7352df','2022-07-18 09:26:25.032743'),(24,'3+8=','11','a9d26b51f99fe104a65733bc3be041ed40008d6a','2022-08-02 09:08:52.197430'),(27,'10-9=','1','50102a7a749b50b079b5ac170ebe7020d0934dcb','2022-10-24 21:06:05.242609'),(28,'10*6=','60','ed25bd111e161e961df851693df3a4d62a5ab178','2022-10-24 21:20:03.404962');

#
# Structure for table "django_celery_beat_clockedschedule"
#

CREATE TABLE `django_celery_beat_clockedschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clocked_time` datetime(6) NOT NULL COMMENT 'Run the task at clocked time',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='clocked';

#
# Data for table "django_celery_beat_clockedschedule"
#


#
# Structure for table "django_celery_beat_crontabschedule"
#

CREATE TABLE `django_celery_beat_crontabschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `minute` varchar(240) NOT NULL COMMENT 'Cron Minutes to Run. Use "*" for "all". (Example: "0,30")',
  `hour` varchar(96) NOT NULL COMMENT 'Cron Hours to Run. Use "*" for "all". (Example: "8,20")',
  `day_of_week` varchar(64) NOT NULL COMMENT 'Cron Days Of The Week to Run. Use "*" for "all". (Example: "0,5")',
  `day_of_month` varchar(124) NOT NULL COMMENT 'Cron Days Of The Month to Run. Use "*" for "all". (Example: "1,15")',
  `month_of_year` varchar(64) NOT NULL COMMENT 'Cron Months Of The Year to Run. Use "*" for "all". (Example: "0,6")',
  `timezone` varchar(63) NOT NULL COMMENT 'Timezone to Run the Cron Schedule on. Default is UTC.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='crontab';

#
# Data for table "django_celery_beat_crontabschedule"
#

REPLACE INTO `django_celery_beat_crontabschedule` VALUES (6,'*/2','*','*','*','*','Asia/Shanghai'),(7,'0','4','*','*','*','Asia/Shanghai');

#
# Structure for table "django_celery_beat_intervalschedule"
#

CREATE TABLE `django_celery_beat_intervalschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `every` int(11) NOT NULL COMMENT 'Number of interval periods to wait before running the task again',
  `period` varchar(24) NOT NULL COMMENT 'The type of period between task runs (Example: days)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='interval';

#
# Data for table "django_celery_beat_intervalschedule"
#


#
# Structure for table "django_celery_beat_periodictasks"
#

CREATE TABLE `django_celery_beat_periodictasks` (
  `ident` smallint(6) NOT NULL,
  `last_update` datetime(6) NOT NULL,
  PRIMARY KEY (`ident`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='periodic tasks';

#
# Data for table "django_celery_beat_periodictasks"
#

REPLACE INTO `django_celery_beat_periodictasks` VALUES (1,'2022-10-25 23:01:55.561344');

#
# Structure for table "django_celery_beat_solarschedule"
#

CREATE TABLE `django_celery_beat_solarschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event` varchar(24) NOT NULL COMMENT 'The type of solar event when the job should run',
  `latitude` decimal(9,6) NOT NULL COMMENT 'Run the task when the event happens at this latitude',
  `longitude` decimal(9,6) NOT NULL COMMENT 'Run the task when the event happens at this longitude',
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_celery_beat_solar_event_latitude_longitude_ba64999a_uniq` (`event`,`latitude`,`longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='solar event';

#
# Data for table "django_celery_beat_solarschedule"
#


#
# Structure for table "django_celery_beat_periodictask"
#

CREATE TABLE `django_celery_beat_periodictask` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL COMMENT 'Short Description For This Task',
  `task` varchar(200) NOT NULL COMMENT 'The Name of the Celery Task that Should be Run.  (Example: "proj.tasks.import_contacts")',
  `args` longtext NOT NULL COMMENT 'JSON encoded positional arguments (Example: ["arg1", "arg2"])',
  `kwargs` longtext NOT NULL COMMENT 'JSON encoded keyword arguments (Example: {"argument": "value"})',
  `queue` varchar(200) DEFAULT NULL COMMENT 'Queue defined in CELERY_TASK_QUEUES. Leave None for default queuing.',
  `exchange` varchar(200) DEFAULT NULL COMMENT 'Override Exchange for low-level AMQP routing',
  `routing_key` varchar(200) DEFAULT NULL COMMENT 'Override Routing Key for low-level AMQP routing',
  `expires` datetime(6) DEFAULT NULL COMMENT 'Datetime after which the schedule will no longer trigger the task to run',
  `enabled` tinyint(1) NOT NULL COMMENT 'Set to False to disable the schedule',
  `last_run_at` datetime(6) DEFAULT NULL COMMENT 'Datetime that the schedule last triggered the task to run. Reset to None if enabled is set to False.',
  `total_run_count` int(10) unsigned NOT NULL COMMENT 'Running count of how many times the schedule has triggered the task',
  `date_changed` datetime(6) NOT NULL COMMENT 'Datetime that this PeriodicTask was last modified',
  `description` longtext NOT NULL COMMENT 'Detailed description about the details of this Periodic Task',
  `crontab_id` int(11) DEFAULT NULL COMMENT 'Crontab Schedule to run the task on.  Set only one schedule type, leave the others null.',
  `interval_id` int(11) DEFAULT NULL COMMENT 'Interval Schedule to run the task on.  Set only one schedule type, leave the others null.',
  `solar_id` int(11) DEFAULT NULL COMMENT 'Solar Schedule to run the task on.  Set only one schedule type, leave the others null.',
  `one_off` tinyint(1) NOT NULL COMMENT 'If True, the schedule will only run the task a single time',
  `start_time` datetime(6) DEFAULT NULL COMMENT 'Datetime when the schedule should begin triggering the task to run',
  `priority` int(10) unsigned DEFAULT NULL COMMENT 'Priority Number between 0 and 255. Supported by: RabbitMQ, Redis (priority reversed, 0 is highest).',
  `headers` longtext NOT NULL COMMENT 'JSON encoded message headers for the AMQP message.',
  `clocked_id` int(11) DEFAULT NULL COMMENT 'Clocked Schedule to run the task on.  Set only one schedule type, leave the others null.',
  `expire_seconds` int(10) unsigned DEFAULT NULL COMMENT 'Timedelta with seconds which the schedule will no longer trigger the task to run',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `django_celery_beat_p_crontab_id_d3cba168_fk_django_ce` (`crontab_id`),
  KEY `django_celery_beat_p_interval_id_a8ca27da_fk_django_ce` (`interval_id`),
  KEY `django_celery_beat_p_solar_id_a87ce72c_fk_django_ce` (`solar_id`),
  KEY `django_celery_beat_p_clocked_id_47a69f82_fk_django_ce` (`clocked_id`),
  CONSTRAINT `django_celery_beat_p_clocked_id_47a69f82_fk_django_ce` FOREIGN KEY (`clocked_id`) REFERENCES `django_celery_beat_clockedschedule` (`id`),
  CONSTRAINT `django_celery_beat_p_crontab_id_d3cba168_fk_django_ce` FOREIGN KEY (`crontab_id`) REFERENCES `django_celery_beat_crontabschedule` (`id`),
  CONSTRAINT `django_celery_beat_p_interval_id_a8ca27da_fk_django_ce` FOREIGN KEY (`interval_id`) REFERENCES `django_celery_beat_intervalschedule` (`id`),
  CONSTRAINT `django_celery_beat_p_solar_id_a87ce72c_fk_django_ce` FOREIGN KEY (`solar_id`) REFERENCES `django_celery_beat_solarschedule` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='periodic task';

#
# Data for table "django_celery_beat_periodictask"
#

REPLACE INTO `django_celery_beat_periodictask` VALUES (1,'测试任务','apps.lycrontab.tasks.lytask_test','[]','{}',NULL,NULL,NULL,NULL,1,'2022-10-25 15:08:00.008743',182,'2022-10-25 23:09:15.157031','测试任务',6,NULL,NULL,0,NULL,1,'{\"periodic_task_name\": \"\\u6d4b\\u8bd5\\u4efb\\u52a1\", \"task_name\": \"apps.lycrontab.tasks.lytask_test\"}',NULL,NULL),(2,'celery.backend_cleanup','celery.backend_cleanup','[]','{}',NULL,NULL,NULL,NULL,1,NULL,0,'2022-10-25 23:01:48.565715','',7,NULL,NULL,0,NULL,NULL,'{}',NULL,43200);

#
# Structure for table "django_celery_results_chordcounter"
#

CREATE TABLE `django_celery_results_chordcounter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(255) NOT NULL COMMENT 'Celery ID for the Chord header group',
  `sub_tasks` longtext NOT NULL COMMENT 'JSON serialized list of task result tuples. use .group_result() to decode',
  `count` int(10) unsigned NOT NULL COMMENT 'Starts at len(chord header) and decrements after each task is finished',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='chord counter';

#
# Data for table "django_celery_results_chordcounter"
#


#
# Structure for table "django_celery_results_groupresult"
#

CREATE TABLE `django_celery_results_groupresult` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(255) NOT NULL COMMENT 'Celery ID for the Group that was run',
  `date_created` datetime(6) NOT NULL COMMENT 'Datetime field when the group result was created in UTC',
  `date_done` datetime(6) NOT NULL COMMENT 'Datetime field when the group was completed in UTC',
  `content_type` varchar(128) NOT NULL COMMENT 'Content type of the result data',
  `content_encoding` varchar(64) NOT NULL COMMENT 'The encoding used to save the task result data',
  `result` longtext COMMENT 'The data returned by the task.  Use content_encoding and content_type fields to read.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`),
  KEY `django_cele_date_cr_bd6c1d_idx` (`date_created`),
  KEY `django_cele_date_do_caae0e_idx` (`date_done`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='group result';

#
# Data for table "django_celery_results_groupresult"
#


#
# Structure for table "django_celery_results_taskresult"
#

CREATE TABLE `django_celery_results_taskresult` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` varchar(255) NOT NULL COMMENT 'Celery ID for the Task that was run',
  `status` varchar(50) NOT NULL COMMENT 'Current state of the task being run',
  `content_type` varchar(128) NOT NULL COMMENT 'Content type of the result data',
  `content_encoding` varchar(64) NOT NULL COMMENT 'The encoding used to save the task result data',
  `result` longtext COMMENT 'The data returned by the task.  Use content_encoding and content_type fields to read.',
  `date_done` datetime(6) NOT NULL COMMENT 'Datetime field when the task was completed in UTC',
  `traceback` longtext COMMENT 'Text of the traceback if the task generated one',
  `meta` longtext COMMENT 'JSON meta information about the task, such as information on child tasks',
  `task_args` longtext COMMENT 'JSON representation of the positional arguments used with the task',
  `task_kwargs` longtext COMMENT 'JSON representation of the named arguments used with the task',
  `task_name` varchar(255) DEFAULT NULL COMMENT 'Name of the Task which was run',
  `worker` varchar(100) DEFAULT NULL COMMENT 'Worker that executes the task',
  `date_created` datetime(6) NOT NULL COMMENT 'Datetime field when the task result was created in UTC',
  `periodic_task_name` varchar(255) DEFAULT NULL COMMENT 'Name of the Periodic Task which was run',
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_id` (`task_id`),
  KEY `django_cele_task_na_08aec9_idx` (`task_name`),
  KEY `django_cele_status_9b6201_idx` (`status`),
  KEY `django_cele_worker_d54dd8_idx` (`worker`),
  KEY `django_cele_date_cr_f04a50_idx` (`date_created`),
  KEY `django_cele_date_do_f59aad_idx` (`date_done`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8mb4 COMMENT='task result';

#
# Data for table "django_celery_results_taskresult"
#

REPLACE INTO `django_celery_results_taskresult` VALUES (175,'e5763b89-7ffd-4e83-bf0e-03dd58d52ff4','SUCCESS','application/json','utf-8','\"django-vue-lyadmin lycrontab running\"','2022-10-25 23:00:00.038914',NULL,'{\"children\": []}','\"()\"','\"{}\"','apps.lycrontab.tasks.lytask_test','celery@lybbn','2022-10-25 23:00:00.038914','测试任务'),(176,'f599fc36-6f0e-45ef-840a-28c637347a45','SUCCESS','application/json','utf-8','\"django-vue-lyadmin lycrontab running\"','2022-10-25 23:02:00.032690',NULL,'{\"children\": []}','\"()\"','\"{}\"','apps.lycrontab.tasks.lytask_test','celery@lybbn','2022-10-25 23:02:00.032690','测试任务'),(177,'fd2cb51a-d717-4103-a1dd-235efad01259','SUCCESS','application/json','utf-8','\"django-vue-lyadmin lycrontab running\"','2022-10-25 23:04:00.024369',NULL,'{\"children\": []}','\"()\"','\"{}\"','apps.lycrontab.tasks.lytask_test','celery@lybbn','2022-10-25 23:04:00.024369','测试任务'),(178,'2cb746cd-5bd5-4253-bfa7-51220177ad7d','SUCCESS','application/json','utf-8','\"django-vue-lyadmin lycrontab running\"','2022-10-25 23:06:00.022733',NULL,'{\"children\": []}','\"()\"','\"{}\"','apps.lycrontab.tasks.lytask_test','celery@lybbn','2022-10-25 23:06:00.022733','测试任务'),(179,'35dbfa39-b419-4480-a176-99adf5e313df','SUCCESS','application/json','utf-8','\"django-vue-lyadmin lycrontab running\"','2022-10-25 23:08:00.024386',NULL,'{\"children\": []}','\"()\"','\"{}\"','apps.lycrontab.tasks.lytask_test','celery@lybbn','2022-10-25 23:08:00.024386','测试任务');

#
# Structure for table "django_content_type"
#

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COMMENT='content type';

#
# Data for table "django_content_type"
#

REPLACE INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','permission'),(3,'auth','group'),(4,'contenttypes','contenttype'),(5,'sessions','session'),(6,'captcha','captchastore'),(7,'mysystem','users'),(8,'mysystem','dept'),(9,'mysystem','dictionary'),(10,'mysystem','menu'),(11,'mysystem','menubutton'),(12,'mysystem','sysdictionarylist'),(13,'mysystem','role'),(14,'mysystem','post'),(15,'mysystem','operationlog'),(16,'mysystem','loginlog'),(17,'mysystem','button'),(18,'lymessages','mymessage'),(19,'lymessages','mymessagetemplate'),(20,'lymessages','mymessageuser'),(21,'address','area'),(22,'oauth','oauthwxuser'),(23,'platformsettings','othermanage'),(24,'platformsettings','lunbotumanage'),(25,'lymonitor','monitormanage'),(26,'lywebsocket','terminalserver'),(27,'address','address'),(28,'platformsettings','userleavingmessage'),(29,'mall','orderinfo'),(30,'mall','goodsspectemplate'),(31,'mall','goodscategory'),(32,'mall','spuspecification'),(33,'mall','goodsbrand'),(34,'mall','ordergoods'),(35,'mall','skuspecification'),(36,'mall','sku'),(37,'mall','couponrecord'),(38,'mall','skuimage'),(39,'mall','spuspecificationoption'),(40,'mall','spu'),(41,'mall','orderrefunds'),(42,'mall','goodscoupon'),(43,'django_celery_results','taskresult'),(44,'django_celery_results','chordcounter'),(45,'django_celery_results','groupresult'),(46,'django_celery_beat','crontabschedule'),(47,'django_celery_beat','intervalschedule'),(48,'django_celery_beat','periodictask'),(49,'django_celery_beat','periodictasks'),(50,'django_celery_beat','solarschedule'),(51,'django_celery_beat','clockedschedule');

#
# Structure for table "auth_permission"
#

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COMMENT='permission';

#
# Data for table "auth_permission"
#

REPLACE INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add captcha store',6,'add_captchastore'),(22,'Can change captcha store',6,'change_captchastore'),(23,'Can delete captcha store',6,'delete_captchastore'),(24,'Can view captcha store',6,'view_captchastore'),(25,'Can add 用户表',7,'add_users'),(26,'Can change 用户表',7,'change_users'),(27,'Can delete 用户表',7,'delete_users'),(28,'Can view 用户表',7,'view_users'),(29,'Can add 部门表',8,'add_dept'),(30,'Can change 部门表',8,'change_dept'),(31,'Can delete 部门表',8,'delete_dept'),(32,'Can view 部门表',8,'view_dept'),(33,'Can add 字典表',9,'add_dictionary'),(34,'Can change 字典表',9,'change_dictionary'),(35,'Can delete 字典表',9,'delete_dictionary'),(36,'Can view 字典表',9,'view_dictionary'),(37,'Can add 菜单表',10,'add_menu'),(38,'Can change 菜单表',10,'change_menu'),(39,'Can delete 菜单表',10,'delete_menu'),(40,'Can view 菜单表',10,'view_menu'),(41,'Can add 菜单权限表',11,'add_menubutton'),(42,'Can change 菜单权限表',11,'change_menubutton'),(43,'Can delete 菜单权限表',11,'delete_menubutton'),(44,'Can view 菜单权限表',11,'view_menubutton'),(45,'Can add 字典详细表',12,'add_sysdictionarylist'),(46,'Can change 字典详细表',12,'change_sysdictionarylist'),(47,'Can delete 字典详细表',12,'delete_sysdictionarylist'),(48,'Can view 字典详细表',12,'view_sysdictionarylist'),(49,'Can add 角色表',13,'add_role'),(50,'Can change 角色表',13,'change_role'),(51,'Can delete 角色表',13,'delete_role'),(52,'Can view 角色表',13,'view_role'),(53,'Can add 岗位表',14,'add_post'),(54,'Can change 岗位表',14,'change_post'),(55,'Can delete 岗位表',14,'delete_post'),(56,'Can view 岗位表',14,'view_post'),(57,'Can add 操作日志',15,'add_operationlog'),(58,'Can change 操作日志',15,'change_operationlog'),(59,'Can delete 操作日志',15,'delete_operationlog'),(60,'Can view 操作日志',15,'view_operationlog'),(61,'Can add 登录日志',16,'add_loginlog'),(62,'Can change 登录日志',16,'change_loginlog'),(63,'Can delete 登录日志',16,'delete_loginlog'),(64,'Can view 登录日志',16,'view_loginlog'),(65,'Can add 权限标识表',17,'add_button'),(66,'Can change 权限标识表',17,'change_button'),(67,'Can delete 权限标识表',17,'delete_button'),(68,'Can view 权限标识表',17,'view_button'),(69,'Can add 消息中心',18,'add_mymessage'),(70,'Can change 消息中心',18,'change_mymessage'),(71,'Can delete 消息中心',18,'delete_mymessage'),(72,'Can view 消息中心',18,'view_mymessage'),(73,'Can add 消息模板',19,'add_mymessagetemplate'),(74,'Can change 消息模板',19,'change_mymessagetemplate'),(75,'Can delete 消息模板',19,'delete_mymessagetemplate'),(76,'Can view 消息模板',19,'view_mymessagetemplate'),(77,'Can add 用户消息',20,'add_mymessageuser'),(78,'Can change 用户消息',20,'change_mymessageuser'),(79,'Can delete 用户消息',20,'delete_mymessageuser'),(80,'Can view 用户消息',20,'view_mymessageuser'),(81,'Can add 省市区',21,'add_area'),(82,'Can change 省市区',21,'change_area'),(83,'Can delete 省市区',21,'delete_area'),(84,'Can view 省市区',21,'view_area'),(85,'Can add 微信登录用户数据',22,'add_oauthwxuser'),(86,'Can change 微信登录用户数据',22,'change_oauthwxuser'),(87,'Can delete 微信登录用户数据',22,'delete_oauthwxuser'),(88,'Can view 微信登录用户数据',22,'view_oauthwxuser'),(89,'Can add 平台其他设置',23,'add_othermanage'),(90,'Can change 平台其他设置',23,'change_othermanage'),(91,'Can delete 平台其他设置',23,'delete_othermanage'),(92,'Can view 平台其他设置',23,'view_othermanage'),(93,'Can add 轮播图设置',24,'add_lunbotumanage'),(94,'Can change 轮播图设置',24,'change_lunbotumanage'),(95,'Can delete 轮播图设置',24,'delete_lunbotumanage'),(96,'Can view 轮播图设置',24,'view_lunbotumanage'),(97,'Can add 服务监控',25,'add_monitormanage'),(98,'Can change 服务监控',25,'change_monitormanage'),(99,'Can delete 服务监控',25,'delete_monitormanage'),(100,'Can view 服务监控',25,'view_monitormanage'),(101,'Can add 终端服务器列表',26,'add_terminalserver'),(102,'Can change 终端服务器列表',26,'change_terminalserver'),(103,'Can delete 终端服务器列表',26,'delete_terminalserver'),(104,'Can view 终端服务器列表',26,'view_terminalserver'),(105,'Can add 用户地址',27,'add_address'),(106,'Can change 用户地址',27,'change_address'),(107,'Can delete 用户地址',27,'delete_address'),(108,'Can view 用户地址',27,'view_address'),(109,'Can add 用户反馈',28,'add_userleavingmessage'),(110,'Can change 用户反馈',28,'change_userleavingmessage'),(111,'Can delete 用户反馈',28,'delete_userleavingmessage'),(112,'Can view 用户反馈',28,'view_userleavingmessage'),(113,'Can add 订单基本信息',29,'add_orderinfo'),(114,'Can change 订单基本信息',29,'change_orderinfo'),(115,'Can delete 订单基本信息',29,'delete_orderinfo'),(116,'Can view 订单基本信息',29,'view_orderinfo'),(117,'Can add 商品规格模板',30,'add_goodsspectemplate'),(118,'Can change 商品规格模板',30,'change_goodsspectemplate'),(119,'Can delete 商品规格模板',30,'delete_goodsspectemplate'),(120,'Can view 商品规格模板',30,'view_goodsspectemplate'),(121,'Can add 商品类别',31,'add_goodscategory'),(122,'Can change 商品类别',31,'change_goodscategory'),(123,'Can delete 商品类别',31,'delete_goodscategory'),(124,'Can view 商品类别',31,'view_goodscategory'),(125,'Can add 商品SPU规格',32,'add_spuspecification'),(126,'Can change 商品SPU规格',32,'change_spuspecification'),(127,'Can delete 商品SPU规格',32,'delete_spuspecification'),(128,'Can view 商品SPU规格',32,'view_spuspecification'),(129,'Can add 商品品牌',33,'add_goodsbrand'),(130,'Can change 商品品牌',33,'change_goodsbrand'),(131,'Can delete 商品品牌',33,'delete_goodsbrand'),(132,'Can view 商品品牌',33,'view_goodsbrand'),(133,'Can add 订单商品',34,'add_ordergoods'),(134,'Can change 订单商品',34,'change_ordergoods'),(135,'Can delete 订单商品',34,'delete_ordergoods'),(136,'Can view 订单商品',34,'view_ordergoods'),(137,'Can add SKU规格',35,'add_skuspecification'),(138,'Can change SKU规格',35,'change_skuspecification'),(139,'Can delete SKU规格',35,'delete_skuspecification'),(140,'Can view SKU规格',35,'view_skuspecification'),(141,'Can add 商品SKU',36,'add_sku'),(142,'Can change 商品SKU',36,'change_sku'),(143,'Can delete 商品SKU',36,'delete_sku'),(144,'Can view 商品SKU',36,'view_sku'),(145,'Can add 用户持券表',37,'add_couponrecord'),(146,'Can change 用户持券表',37,'change_couponrecord'),(147,'Can delete 用户持券表',37,'delete_couponrecord'),(148,'Can view 用户持券表',37,'view_couponrecord'),(149,'Can add SKU图片',38,'add_skuimage'),(150,'Can change SKU图片',38,'change_skuimage'),(151,'Can delete SKU图片',38,'delete_skuimage'),(152,'Can view SKU图片',38,'view_skuimage'),(153,'Can add 规格选项',39,'add_spuspecificationoption'),(154,'Can change 规格选项',39,'change_spuspecificationoption'),(155,'Can delete 规格选项',39,'delete_spuspecificationoption'),(156,'Can view 规格选项',39,'view_spuspecificationoption'),(157,'Can add 商品SPU',40,'add_spu'),(158,'Can change 商品SPU',40,'change_spu'),(159,'Can delete 商品SPU',40,'delete_spu'),(160,'Can view 商品SPU',40,'view_spu'),(161,'Can add 商城订单退款',41,'add_orderrefunds'),(162,'Can change 商城订单退款',41,'change_orderrefunds'),(163,'Can delete 商城订单退款',41,'delete_orderrefunds'),(164,'Can view 商城订单退款',41,'view_orderrefunds'),(165,'Can add 商品优惠券',42,'add_goodscoupon'),(166,'Can change 商品优惠券',42,'change_goodscoupon'),(167,'Can delete 商品优惠券',42,'delete_goodscoupon'),(168,'Can view 商品优惠券',42,'view_goodscoupon'),(169,'Can add task result',43,'add_taskresult'),(170,'Can change task result',43,'change_taskresult'),(171,'Can delete task result',43,'delete_taskresult'),(172,'Can view task result',43,'view_taskresult'),(173,'Can add chord counter',44,'add_chordcounter'),(174,'Can change chord counter',44,'change_chordcounter'),(175,'Can delete chord counter',44,'delete_chordcounter'),(176,'Can view chord counter',44,'view_chordcounter'),(177,'Can add group result',45,'add_groupresult'),(178,'Can change group result',45,'change_groupresult'),(179,'Can delete group result',45,'delete_groupresult'),(180,'Can view group result',45,'view_groupresult'),(181,'Can add crontab',46,'add_crontabschedule'),(182,'Can change crontab',46,'change_crontabschedule'),(183,'Can delete crontab',46,'delete_crontabschedule'),(184,'Can view crontab',46,'view_crontabschedule'),(185,'Can add interval',47,'add_intervalschedule'),(186,'Can change interval',47,'change_intervalschedule'),(187,'Can delete interval',47,'delete_intervalschedule'),(188,'Can view interval',47,'view_intervalschedule'),(189,'Can add periodic task',48,'add_periodictask'),(190,'Can change periodic task',48,'change_periodictask'),(191,'Can delete periodic task',48,'delete_periodictask'),(192,'Can view periodic task',48,'view_periodictask'),(193,'Can add periodic tasks',49,'add_periodictasks'),(194,'Can change periodic tasks',49,'change_periodictasks'),(195,'Can delete periodic tasks',49,'delete_periodictasks'),(196,'Can view periodic tasks',49,'view_periodictasks'),(197,'Can add solar event',50,'add_solarschedule'),(198,'Can change solar event',50,'change_solarschedule'),(199,'Can delete solar event',50,'delete_solarschedule'),(200,'Can view solar event',50,'view_solarschedule'),(201,'Can add clocked',51,'add_clockedschedule'),(202,'Can change clocked',51,'change_clockedschedule'),(203,'Can delete clocked',51,'delete_clockedschedule'),(204,'Can view clocked',51,'view_clockedschedule');

#
# Structure for table "auth_group_permissions"
#

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

#
# Data for table "auth_group_permissions"
#


#
# Structure for table "django_migrations"
#

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4;

#
# Data for table "django_migrations"
#

REPLACE INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2022-06-27 13:55:53.748972'),(2,'contenttypes','0002_remove_content_type_name','2022-06-27 13:55:53.787329'),(3,'auth','0001_initial','2022-06-27 13:55:53.890403'),(4,'auth','0002_alter_permission_name_max_length','2022-06-27 13:55:53.913113'),(5,'auth','0003_alter_user_email_max_length','2022-06-27 13:55:53.918102'),(6,'auth','0004_alter_user_username_opts','2022-06-27 13:55:53.922090'),(7,'auth','0005_alter_user_last_login_null','2022-06-27 13:55:53.928074'),(8,'auth','0006_require_contenttypes_0002','2022-06-27 13:55:53.929641'),(9,'auth','0007_alter_validators_add_error_messages','2022-06-27 13:55:53.934220'),(10,'auth','0008_alter_user_username_max_length','2022-06-27 13:55:53.938209'),(11,'auth','0009_alter_user_last_name_max_length','2022-06-27 13:55:53.942192'),(12,'auth','0010_alter_group_name_max_length','2022-06-27 13:55:53.953329'),(13,'auth','0011_update_proxy_permissions','2022-06-27 13:55:53.958316'),(14,'auth','0012_alter_user_first_name_max_length','2022-06-27 13:55:53.963303'),(15,'mysystem','0001_initial','2022-06-27 13:55:54.513606'),(16,'address','0001_initial','2022-06-27 13:55:54.526244'),(17,'address','0002_initial','2022-06-27 13:55:54.593635'),(18,'admin','0001_initial','2022-06-27 13:55:54.654455'),(19,'admin','0002_logentry_remove_auto_add','2022-06-27 13:55:54.673376'),(20,'admin','0003_logentry_add_action_flag_choices','2022-06-27 13:55:54.725238'),(21,'captcha','0001_initial','2022-06-27 13:55:54.737297'),(22,'captcha','0002_alter_captchastore_id','2022-06-27 13:55:54.741287'),(23,'lymessages','0001_initial','2022-06-27 13:55:54.790558'),(24,'lymessages','0002_initial','2022-06-27 13:55:54.966977'),(25,'oauth','0001_initial','2022-06-27 13:55:55.027418'),(26,'platformsettings','0001_initial','2022-06-27 13:55:55.094296'),(27,'sessions','0001_initial','2022-06-27 13:55:55.113233'),(28,'lymonitor','0001_initial','2022-07-09 12:09:04.885260'),(29,'lywebsocket','0001_initial','2022-07-17 17:05:46.479597'),(30,'lywebsocket','0002_terminalserver_port','2022-07-17 17:47:03.222975'),(31,'address','0003_address','2022-07-28 23:11:24.792968'),(32,'platformsettings','0002_lunbotumanage_link_type_alter_lunbotumanage_link_and_more','2022-07-28 23:11:27.979944'),(33,'mall','0001_initial','2022-07-28 23:18:16.290271'),(34,'mall','0002_alter_sku_options_alter_skuspecification_options_and_more','2022-07-31 22:47:25.341862'),(35,'django_celery_beat','0001_initial','2022-10-23 09:55:18.293036'),(36,'django_celery_beat','0002_auto_20161118_0346','2022-10-23 09:55:18.402212'),(37,'django_celery_beat','0003_auto_20161209_0049','2022-10-23 09:55:18.433176'),(38,'django_celery_beat','0004_auto_20170221_0000','2022-10-23 09:55:18.441921'),(39,'django_celery_beat','0005_add_solarschedule_events_choices','2022-10-23 09:55:18.450929'),(40,'django_celery_beat','0006_auto_20180322_0932','2022-10-23 09:55:18.535599'),(41,'django_celery_beat','0007_auto_20180521_0826','2022-10-23 09:55:18.652596'),(42,'django_celery_beat','0008_auto_20180914_1922','2022-10-23 09:55:18.670194'),(43,'django_celery_beat','0006_auto_20180210_1226','2022-10-23 09:55:18.683140'),(44,'django_celery_beat','0006_periodictask_priority','2022-10-23 09:55:18.746533'),(45,'django_celery_beat','0009_periodictask_headers','2022-10-23 09:55:18.803436'),(46,'django_celery_beat','0010_auto_20190429_0326','2022-10-23 09:55:18.883826'),(47,'django_celery_beat','0011_auto_20190508_0153','2022-10-23 09:55:18.988147'),(48,'django_celery_beat','0012_periodictask_expire_seconds','2022-10-23 09:55:19.049062'),(49,'django_celery_beat','0013_auto_20200609_0727','2022-10-23 09:55:19.058651'),(50,'django_celery_beat','0014_remove_clockedschedule_enabled','2022-10-23 09:55:19.105641'),(51,'django_celery_beat','0015_edit_solarschedule_events_choices','2022-10-23 09:55:19.115018'),(52,'django_celery_beat','0016_alter_crontabschedule_timezone','2022-10-23 09:55:19.124035'),(53,'django_celery_results','0001_initial','2022-10-23 09:55:19.178461'),(54,'django_celery_results','0002_add_task_name_args_kwargs','2022-10-23 09:55:19.336008'),(55,'django_celery_results','0003_auto_20181106_1101','2022-10-23 09:55:19.349672'),(56,'django_celery_results','0004_auto_20190516_0412','2022-10-23 09:55:19.440410'),(57,'django_celery_results','0005_taskresult_worker','2022-10-23 09:55:19.533985'),(58,'django_celery_results','0006_taskresult_date_created','2022-10-23 09:55:19.647751'),(59,'django_celery_results','0007_remove_taskresult_hidden','2022-10-23 09:55:19.714334'),(60,'django_celery_results','0008_chordcounter','2022-10-23 09:55:19.744689'),(61,'django_celery_results','0009_groupresult','2022-10-23 09:55:20.581146'),(62,'django_celery_results','0010_remove_duplicate_indices','2022-10-23 09:55:20.594296'),(63,'django_celery_results','0011_taskresult_periodic_task_name','2022-10-23 09:55:20.660684'),(64,'mysystem','0002_alter_users_identity_alter_users_mobile','2022-10-23 09:55:20.718751'),(65,'oauth','0002_alter_oauthwxuser_mobilephonenumber','2022-10-23 09:55:20.797735'),(66,'platformsettings','0003_alter_othermanage_type','2022-10-23 09:55:20.826744');

#
# Structure for table "django_session"
#

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='session';

#
# Data for table "django_session"
#


#
# Structure for table "lyadmin_button"
#

CREATE TABLE `lyadmin_button` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '权限名称',
  `value` varchar(64) NOT NULL COMMENT '权限值',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `lyadmin_button_creator_id_8ed6f8c5` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限标识表';

#
# Data for table "lyadmin_button"
#

REPLACE INTO `lyadmin_button` VALUES ('09134d7643504804a6c7cc3d16e06684',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-10-25 23:09:53.863898','2022-10-25 23:09:53.863898','日志','Logs','456b688c-8ad5-46de-bc2e-d41d8047bd42'),('2d763a6d6dcf409d87056efd06aace0a',NULL,NULL,NULL,'2022-06-27 13:56:06.159513','2022-06-27 13:56:06.159513','修改密码','Changepassword',NULL),('43d89c33967545a387a3ac27c02460b6',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-08-01 23:16:24.046679','2022-08-01 23:16:24.046679','统计','Statistics','456b688c-8ad5-46de-bc2e-d41d8047bd42'),('4547b93a-36b9-410d-987c-3c52a9b51156',NULL,NULL,NULL,'2022-06-27 13:56:06.149563','2022-06-27 13:56:06.149563','编辑','Update',NULL),('4a410769-6b0a-4ed3-90f0-b5d89a6f802c',NULL,NULL,NULL,'2022-06-27 13:56:06.151529','2022-06-27 13:56:06.151529','删除','Delete',NULL),('5bf695439e9d4c4d9601bf4fb558b3a2',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-10-26 00:05:18.024132','2022-10-26 00:05:18.024132','任务列表','Tasklist','456b688c-8ad5-46de-bc2e-d41d8047bd42'),('644e9c34-e3d6-4518-b795-a603a6e9a137',NULL,NULL,NULL,'2022-06-27 13:56:06.153525','2022-06-27 13:56:06.153525','单例','Retrieve',NULL),('6e0a41e5308c44a8b0d2785e05b2c07a',NULL,NULL,NULL,'2022-06-27 13:56:06.161507','2022-06-27 13:56:06.161507','禁用','Disable',NULL),('80cb145b-5035-4517-a28a-7d59426f73f8',NULL,NULL,NULL,'2022-06-27 13:56:06.154522','2022-06-27 13:56:06.154522','新增','Create',NULL),('83a9b774-4669-4d2f-b61d-8ee4944c2316',NULL,NULL,NULL,'2022-06-27 13:56:06.158517','2022-06-27 13:56:06.158517','保存','Save',NULL),('c66a0ab23a6044189ae0beb530ac68cf',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-08-01 23:16:11.387119','2022-08-01 23:16:11.387119','发货','Deliver','456b688c-8ad5-46de-bc2e-d41d8047bd42'),('ccc3f35f-c80c-4929-b8cc-67531698f397',NULL,NULL,NULL,'2022-06-27 13:56:06.156517','2022-06-27 13:56:06.156517','查询','Search',NULL),('f3f365e9bfab44f587cbd91e3691ef0f',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-18 10:33:33.017933','2022-07-18 10:33:33.017933','终端','Terminal','456b688c-8ad5-46de-bc2e-d41d8047bd42');

#
# Structure for table "lyadmin_dept"
#

CREATE TABLE `lyadmin_dept` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '部门名称',
  `sort` int(11) NOT NULL COMMENT '显示排序',
  `owner` varchar(32) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(32) DEFAULT NULL COMMENT '邮箱',
  `status` smallint(6) DEFAULT NULL COMMENT '部门状态',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `parent_id` varchar(100) DEFAULT NULL COMMENT '上级部门',
  PRIMARY KEY (`id`),
  KEY `lyadmin_dept_creator_id_bb4dafb6` (`creator_id`),
  KEY `lyadmin_dept_parent_id_c856ab90` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='部门表';

#
# Data for table "lyadmin_dept"
#

REPLACE INTO `lyadmin_dept` VALUES ('cae96ade-7483-4827-bb0d-d2bd63ec1cc4',NULL,NULL,NULL,'2022-06-27 13:56:06.141286','2022-06-27 13:56:06.141286','财务部门',1,NULL,NULL,NULL,1,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3'),('d2c03bd9-dad0-4262-88ca-c3681d224fc3',NULL,NULL,NULL,'2022-06-27 13:56:06.144084','2022-06-27 13:56:06.144084','lyadmin团队',1,NULL,NULL,NULL,1,NULL,NULL),('fd8230ca-67bd-4347-8a9b-57eb19be5d9e',NULL,NULL,NULL,'2022-06-27 13:56:06.146078','2022-06-27 13:56:06.146078','研发部门',2,NULL,NULL,NULL,1,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3');

#
# Structure for table "lyadmin_dictionary"
#

CREATE TABLE `lyadmin_dictionary` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `code` varchar(100) DEFAULT NULL COMMENT '编码',
  `name` varchar(100) DEFAULT NULL COMMENT '名称',
  `status` smallint(6) NOT NULL COMMENT '状态',
  `sort` int(11) DEFAULT NULL COMMENT '显示排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `parent_id` varchar(100) DEFAULT NULL COMMENT '父级',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `lyadmin_dictionary_creator_id_f75d1c0b` (`creator_id`),
  KEY `lyadmin_dictionary_parent_id_9d47f813` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典表';

#
# Data for table "lyadmin_dictionary"
#


#
# Structure for table "lyadmin_dictionary_detail"
#

CREATE TABLE `lyadmin_dictionary_detail` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `code` varchar(100) DEFAULT NULL COMMENT '编码',
  `label` varchar(100) DEFAULT NULL COMMENT '显示名称',
  `value` varchar(100) DEFAULT NULL COMMENT '实际值',
  `status` smallint(6) NOT NULL COMMENT '状态',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `dict_id` varchar(100) DEFAULT NULL COMMENT '关联主表',
  PRIMARY KEY (`id`),
  KEY `lyadmin_dictionary_detail_creator_id_6422260d` (`creator_id`),
  KEY `lyadmin_dictionary_detail_dict_id_418a11f9` (`dict_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典详细表';

#
# Data for table "lyadmin_dictionary_detail"
#


#
# Structure for table "lyadmin_login_log"
#

CREATE TABLE `lyadmin_login_log` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `username` varchar(32) DEFAULT NULL COMMENT '登录用户名',
  `ip` varchar(32) DEFAULT NULL COMMENT '登录ip',
  `agent` varchar(1500) DEFAULT NULL COMMENT 'agent信息',
  `browser` varchar(200) DEFAULT NULL COMMENT '浏览器名',
  `os` varchar(150) DEFAULT NULL COMMENT '操作系统',
  `login_type` int(11) NOT NULL COMMENT '登录类型',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `lyadmin_login_log_creator_id_2aae8b60` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='登录日志';

#
# Data for table "lyadmin_login_log"
#

REPLACE INTO `lyadmin_login_log` VALUES ('277174d7a6a145a5b2bac1b111cba012',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3','2022-10-22 20:41:58.336842','2022-10-22 20:41:58.336842','superadmin','127.0.0.1','PC / Windows 10 / Chrome 106.0.0','Chrome 106.0.0','Windows 10',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42'),('41334fd06cb344dbb71e1962b3db7747',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3','2022-10-24 21:19:16.635721','2022-10-24 21:19:16.635721','superadmin','127.0.0.1','PC / Windows 10 / Chrome 106.0.0','Chrome 106.0.0','Windows 10',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42'),('58db56729b02424fab6e6f1055e30b17',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3','2022-10-24 17:28:21.946728','2022-10-24 17:28:21.946728','superadmin','127.0.0.1','PC / Windows 10 / Chrome 106.0.0','Chrome 106.0.0','Windows 10',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42'),('593f5858843d4ab69378b68b01919fe3',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3','2022-10-25 23:32:02.749615','2022-10-25 23:32:02.749615','superadmin','127.0.0.1','PC / Windows 10 / Chrome 106.0.0','Chrome 106.0.0','Windows 10',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42'),('634ed476fe6847cca27c53039c9f8262',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3','2022-10-23 10:58:12.433010','2022-10-23 10:58:12.433010','superadmin','127.0.0.1','PC / Windows 10 / Chrome 106.0.0','Chrome 106.0.0','Windows 10',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42'),('bfa2d22a86354772af64096a246ab5c4',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3','2022-10-25 11:36:16.288896','2022-10-25 11:36:16.288896','superadmin','127.0.0.1','PC / Windows 10 / Chrome 106.0.0','Chrome 106.0.0','Windows 10',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42'),('eb5dd52660734e8aadb15bc309ef5689',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3','2022-10-24 20:05:01.526327','2022-10-24 20:05:01.526327','superadmin','127.0.0.1','PC / Windows 10 / Chrome 106.0.0','Chrome 106.0.0','Windows 10',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42');

#
# Structure for table "lyadmin_menu"
#

CREATE TABLE `lyadmin_menu` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `icon` varchar(64) DEFAULT NULL COMMENT '菜单图标',
  `name` varchar(64) NOT NULL COMMENT '菜单名称',
  `sort` int(11) DEFAULT NULL COMMENT '显示排序',
  `is_link` smallint(6) NOT NULL COMMENT '是否外链',
  `web_path` varchar(128) DEFAULT NULL COMMENT '路由地址',
  `component` varchar(128) DEFAULT NULL COMMENT '组件地址',
  `component_name` varchar(50) DEFAULT NULL COMMENT '组件名称',
  `status` smallint(6) NOT NULL COMMENT '菜单状态',
  `isautopm` smallint(6) NOT NULL COMMENT '自动创建按钮权限',
  `cache` smallint(6) NOT NULL COMMENT '是否页面缓存',
  `visible` smallint(6) NOT NULL COMMENT '侧边栏中是否显示',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `parent_id` varchar(100) DEFAULT NULL COMMENT '上级菜单',
  PRIMARY KEY (`id`),
  KEY `lyadmin_menu_creator_id_39b95522` (`creator_id`),
  KEY `lyadmin_menu_parent_id_4a6f3129` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单表';

#
# Data for table "lyadmin_menu"
#

REPLACE INTO `lyadmin_menu` VALUES ('02c24003527546359b5a77ae07adc7d5',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-28 23:20:39.410418','2022-07-28 23:20:39.410418','','地区管理',7,0,'areaManage',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','54f769b0-3dff-416c-8102-e55ec44827cc'),('09a42810d4dd4b2eb939f8eb0b01d9d1',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-04 21:53:54.572593','2022-07-04 20:52:44.855447','','计划任务',20,0,'crontab',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','77edf447326b4e0dbc6f9719c1de8a12'),('151035da-77a3-4a62-b474-fce6824571fb',NULL,NULL,NULL,'2022-06-27 13:56:06.189196','2022-06-27 13:56:06.189196','','按钮管理',6,0,'buttonManage','system/button','buttonManage',1,0,0,0,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('15c9ebc5-d12f-470a-a560-938a7dc57570',NULL,NULL,NULL,'2022-06-27 13:56:06.185699','2022-06-27 13:56:06.185699','','角色管理',3,0,'roleManage','system/role','role',1,0,0,1,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('244b28685cd14a39a383189981510d4a',NULL,NULL,NULL,'2022-06-27 13:56:06.167116','2022-06-27 13:56:06.167116','user-filled','用户管理',5,0,'userManage',NULL,NULL,1,0,0,1,NULL,NULL),('25735adb-d051-4b7b-bbb7-1154526f3e4c',NULL,'superadmin',NULL,'2022-07-30 21:34:32.844919','2022-06-27 13:56:06.192188','user','个人中心',866,0,'personalCenter',NULL,NULL,1,0,0,1,NULL,NULL),('2a7c0142f7514dacb7999383e4e67aca',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-28 23:37:41.163539','2022-07-28 23:36:59.277661','WalletFilled','财务管理',299,0,'',NULL,NULL,1,0,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL),('2e07b715d5e24e2ca45997527430e9d3',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-28 23:35:05.583982','2022-07-28 23:35:05.583982','','商城订单',1,0,'mallOrderManage',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','a524f17e9ac74be3baf9d113f014184c'),('2e3438c8-3ddc-43ff-b8d8-cca328e4856e',NULL,'superadmin',NULL,'2022-07-03 15:19:35.715872','2022-06-27 13:56:06.165122','avatar','管理员管理',3,0,'adminManage',NULL,NULL,1,0,0,1,NULL,NULL),('3171db16eda048ae92b16536fc1241b6',NULL,NULL,NULL,'2022-06-27 13:56:06.173100','2022-06-27 13:56:06.173100','','平台公告',5,0,'messagNotice',NULL,NULL,1,0,0,1,NULL,'d4e2fe169a8b40f3846421ac04e4fccb'),('3c13161f70f1469a913d539e7616c577',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-28 23:40:08.355309','2022-07-28 23:40:08.355309','','意见反馈',8,0,'userFeekback',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','d4e2fe169a8b40f3846421ac04e4fccb'),('4236eb70-1558-43a0-9cf2-037230c547f9',NULL,NULL,NULL,'2022-06-27 13:56:06.177090','2022-06-27 13:56:06.177090','','部门管理',1,0,'departmentManage','system/dept','dept',1,0,0,1,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('4ba07859-8b73-4524-a1a6-bbff36d98337',NULL,NULL,NULL,'2022-06-27 13:56:06.179629','2022-06-27 13:56:06.179629','','操作日志',1,0,'journalManage','system/log/operationLog','operationLog',1,0,0,1,NULL,'c236fb6b-ddaa-4deb-b79b-16e42d9f347f'),('54f769b0-3dff-416c-8102-e55ec44827cc',NULL,'superadmin',NULL,'2022-07-29 23:08:25.510853','2022-06-27 13:56:06.190193','tools','系统管理',990,0,'',NULL,NULL,1,0,0,1,NULL,NULL),('56c3f341-4f46-4b04-9cfc-c8a14701707e',NULL,NULL,NULL,'2022-06-27 13:56:06.181311','2022-06-27 13:56:06.181311','','菜单管理',2,0,'menuManage','system/menu','menu',1,0,0,1,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('718daec1b94b456c96d773889648173e',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-13 21:07:49.624609','2022-07-13 21:07:49.624609','','终端服务',30,0,'terminal',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','77edf447326b4e0dbc6f9719c1de8a12'),('77edf447326b4e0dbc6f9719c1de8a12',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-29 23:09:12.270076','2022-07-04 21:53:39.904375','TrendCharts','系统监控',888,0,'',NULL,NULL,1,0,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL),('80a340eae92b430abe17635468c2df1d',NULL,NULL,NULL,'2022-06-27 13:56:06.175095','2022-06-27 13:56:06.175095','','其他设置',12,0,'platformSettingsother',NULL,NULL,1,0,0,1,NULL,'d4e2fe169a8b40f3846421ac04e4fccb'),('9065cb5445ac42ef93eb9e75e6287792',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-03 15:21:19.325170','2022-07-03 15:21:19.325170','DataLine','DashBoard',1,0,'analysis',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL),('a28f8ca682d04c8fb2953fdeb3d9e2e6',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-28 23:28:27.995427','2022-07-28 23:28:27.995427','GoodsFilled','商城管理',188,0,'',NULL,NULL,1,0,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL),('a524f17e9ac74be3baf9d113f014184c',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-28 23:36:05.228039','2022-07-28 23:34:37.194181','List','订单管理',199,0,'',NULL,NULL,1,0,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL),('a607e820-36e5-45c0-aabf-85a8e4e2c7ac',NULL,NULL,NULL,'2022-06-27 13:56:06.187402','2022-06-27 13:56:06.187402','','权限管理',4,0,'authorityManage','system/rolePermission','rolePermission',1,0,0,1,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('ae5629946df4497cbec10419e8375dd9',NULL,NULL,NULL,'2022-06-27 13:56:06.171105','2022-06-27 13:56:06.171105','','轮播图设置',1,0,'carouselSettingsimg',NULL,NULL,1,0,0,1,NULL,'d4e2fe169a8b40f3846421ac04e4fccb'),('b999c50996864465b851575e378c5aea',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-28 23:33:28.192894','2022-07-28 23:33:28.192894','','商品分类',2,0,'goodsType',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','a28f8ca682d04c8fb2953fdeb3d9e2e6'),('bcbeeee5c91a4e2ea2c2a31237e33616',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-04 21:55:07.612049','2022-07-04 21:54:47.113335','','服务监控',10,0,'server',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','77edf447326b4e0dbc6f9719c1de8a12'),('c236fb6b-ddaa-4deb-b79b-16e42d9f347f',NULL,NULL,NULL,'2022-06-27 13:56:06.194704','2022-06-27 13:56:06.194704','info-filled','日志管理',999,0,'journalManage',NULL,NULL,1,0,0,1,NULL,NULL),('d470ab18859a4472b525e605ae96c325',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-28 23:32:40.170495','2022-07-28 23:32:40.170495','','商品管理',1,0,'goodsManage',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','a28f8ca682d04c8fb2953fdeb3d9e2e6'),('d4e2fe169a8b40f3846421ac04e4fccb',NULL,'superadmin',NULL,'2022-07-28 23:39:31.143220','2022-06-27 13:56:06.170108','platform','基础管理',9,0,'',NULL,NULL,1,0,0,1,NULL,NULL),('d73f73a399af48cea6a8490ac508d7a0',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-06-28 21:24:17.622516','2022-06-28 21:23:46.339354','user-filled','用户管理CRUD',7,0,'userManageCrud',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL),('dc8c173b425048e7a8c9b59513596c7f',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-28 23:38:06.926563','2022-07-28 23:38:06.926563','','商品财务流水',1,0,'financeStatisticsGoods',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','2a7c0142f7514dacb7999383e4e67aca'),('e0f53902-e901-490c-83f3-331e60b97fcf',NULL,NULL,NULL,'2022-06-27 13:56:06.183705','2022-06-27 13:56:06.183705','','按钮配置',2,0,'buttonConfig/:id/:name','system/ menuButton',NULL,1,0,0,0,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc');

#
# Structure for table "lyadmin_menu_button"
#

CREATE TABLE `lyadmin_menu_button` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '名称',
  `value` varchar(64) NOT NULL COMMENT '权限值',
  `api` varchar(64) NOT NULL COMMENT '接口地址',
  `method` smallint(6) DEFAULT NULL COMMENT '接口请求方法',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `menu_id` varchar(100) NOT NULL COMMENT '关联菜单',
  PRIMARY KEY (`id`),
  KEY `lyadmin_menu_button_creator_id_e2b5a076` (`creator_id`),
  KEY `lyadmin_menu_button_menu_id_74205633` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

#
# Data for table "lyadmin_menu_button"
#

REPLACE INTO `lyadmin_menu_button` VALUES ('0088e172566f4ee388092ec2be3584ee',NULL,NULL,NULL,'2022-06-27 13:56:06.287261','2022-06-27 13:56:06.287261','删除','Delete','/api/platformsettings/lunboimg/{id}/',3,NULL,'ae5629946df4497cbec10419e8375dd9'),('0209de89-6b9f-4d8a-84d3-ccfc3cc8b4da',NULL,NULL,NULL,'2022-06-27 13:56:06.201693','2022-06-27 13:56:06.201693','编辑','Update','/api/system/button/{id}/',2,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('04896a47-0f3a-4e2f-a111-bfe15f9e31c5',NULL,NULL,NULL,'2022-06-27 13:56:06.203687','2022-06-27 13:56:06.203687','编辑','Update','/api/system/menu/{id}/',2,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('05932c39ad444ac5aaf880d281620611',NULL,'superadmin',NULL,'2022-08-01 23:11:56.827373','2022-07-28 23:40:08.471133','查询','Search','/api/platformsettings/userfeeckback/',0,NULL,'3c13161f70f1469a913d539e7616c577'),('09a0908dfb0c433c90037851da126e9b',NULL,NULL,NULL,'2022-06-28 21:23:46.377456','2022-06-28 21:23:46.377456','编辑','Update','',0,NULL,'d73f73a399af48cea6a8490ac508d7a0'),('0b5bf0f1caac45beabf54fb5d930187b',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-10-25 23:31:40.412955','2022-10-25 23:31:40.412955','日志','Logs','/api/crontab/taskresult/',0,'456b688c-8ad5-46de-bc2e-d41d8047bd42','09a42810d4dd4b2eb939f8eb0b01d9d1'),('0ce04d99cbd249a9af88fe1496591a89',NULL,NULL,NULL,'2022-10-26 00:04:28.355226','2022-07-04 20:52:44.985788','禁用','Disable','/api/crontab/periodictask/enabled/{id}/',2,NULL,'09a42810d4dd4b2eb939f8eb0b01d9d1'),('0d931efc-2f80-418f-b4a0-5251f0a88f69',NULL,NULL,NULL,'2022-06-27 13:56:06.252411','2022-06-27 13:56:06.252411','新增','Create','/api/system/operation_log/',1,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('10610c56-cec2-4774-9468-e1c763e59e70',NULL,NULL,NULL,'2022-06-27 13:56:06.253408','2022-06-27 13:56:06.253408','新增','Create','/api/system/dept/',1,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('118ce77cc07140a08d9a92ab8800f2cf',NULL,'superadmin',NULL,'2022-08-01 23:14:14.316050','2022-07-28 23:33:28.308230','单例','Retrieve','/api/mall/goodstype/{id}/',0,NULL,'b999c50996864465b851575e378c5aea'),('11d334fcadf1490e85e6a045126dea78',NULL,'superadmin',NULL,'2022-08-01 23:12:19.447102','2022-07-28 23:40:08.471133','单例','Retrieve','/api/platformsettings/userfeeckback/{id}/',0,NULL,'3c13161f70f1469a913d539e7616c577'),('140166e2-471e-455e-9dcd-05cebbbab95d',NULL,NULL,NULL,'2022-06-27 13:56:06.225629','2022-06-27 13:56:06.225629','查询','Search','/api/system/role/',0,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('14e7088f-a39b-47ae-bd67-b9bbcabae96b',NULL,NULL,NULL,'2022-06-27 13:56:06.270827','2022-06-27 13:56:06.270827','单例','Retrieve','/api/users/users/{id}/',0,NULL,'244b28685cd14a39a383189981510d4a'),('19d01a929bc9414cac1a8defd48597c9',NULL,NULL,NULL,'2022-10-26 00:03:55.514029','2022-07-04 20:52:45.061625','新增','Create','/api/crontab/periodictask/',1,NULL,'09a42810d4dd4b2eb939f8eb0b01d9d1'),('1a0c96cf-09a6-43b4-b08a-0c5b6e2f7bb8',NULL,NULL,NULL,'2022-06-27 13:56:06.306497','2022-06-27 13:56:06.306497','保存','Retrieve','/api/system/permission/{id}/',2,NULL,'a607e820-36e5-45c0-aabf-85a8e4e2c7ac'),('1a16836d2cec4d14a1307b3228e3cfdd',NULL,NULL,NULL,'2022-10-26 00:03:39.767412','2022-07-04 20:52:44.940088','编辑','Update','/api/crontab/periodictask/{id}/',2,NULL,'09a42810d4dd4b2eb939f8eb0b01d9d1'),('1b4f27a7-8ab8-4388-ae57-46e29976cf0e',NULL,NULL,NULL,'2022-06-27 13:56:06.255493','2022-06-27 13:56:06.255493','新增','Create','/api/system/button/',1,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('1d4441fdc418499f856c23aa4e1be2c0',NULL,NULL,NULL,'2022-06-27 13:56:06.268833','2022-06-27 13:56:06.268833','单例','Retrieve','/api/platformsettings/other/{id}/',0,NULL,'80a340eae92b430abe17635468c2df1d'),('220fa39fd56e47e1ab9558c6bd10106e',NULL,'superadmin',NULL,'2022-08-01 23:13:04.683126','2022-07-28 23:32:40.227672','新增','Create','/api/mall/goodsspu/',1,NULL,'d470ab18859a4472b525e605ae96c325'),('2235160bd56c423880572f5450b94f16',NULL,'superadmin',NULL,'2022-08-01 23:13:08.892253','2022-07-28 23:32:40.228673','单例','Retrieve','/api/mall/goodsspu/{id}/',0,NULL,'d470ab18859a4472b525e605ae96c325'),('264cc3d69f7a46d5a117997e9c78506c',NULL,NULL,NULL,'2022-06-27 13:56:06.289257','2022-06-27 13:56:06.289257','删除','Delete','/api/platformsettings/other/{id}/',3,NULL,'80a340eae92b430abe17635468c2df1d'),('281ad1aad421441a965f7bc6b397eb30',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-18 10:34:57.549325','2022-07-18 10:34:57.549325','删除','Delete','/api/terminal/terminal/{id}/',3,'456b688c-8ad5-46de-bc2e-d41d8047bd42','718daec1b94b456c96d773889648173e'),('2a3d4756-4d51-4129-b3c4-b2c7a00dbb8a',NULL,NULL,NULL,'2022-06-27 13:56:06.256490','2022-06-27 13:56:06.257488','新增','Create','/api/system/role/',1,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('2c53efc8-e6a4-4192-8688-03baed0874a4',NULL,NULL,NULL,'2022-06-27 13:56:06.291460','2022-06-27 13:56:06.291460','删除','Delete','/api/system/user/{id}/',3,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('2c5b748c5dce4f34bd24b1201faf09c2',NULL,'superadmin',NULL,'2022-08-01 23:14:21.042896','2022-07-28 23:33:28.308230','查询','Search','/api/mall/goodstype/',0,NULL,'b999c50996864465b851575e378c5aea'),('324776a3-48ec-4bca-bdd9-1838e2b6f7cc',NULL,NULL,NULL,'2022-06-27 13:56:06.228619','2022-06-27 13:56:06.228619','查询','Search','/api/system/user/',0,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('353595a28cb1463b830cfbf79fea60b5',NULL,NULL,NULL,'2022-06-27 13:56:06.308464','2022-06-27 13:56:06.308464','禁用','Disable','/api/users/users/disableuser/{id}/',2,NULL,'244b28685cd14a39a383189981510d4a'),('3688b715-4689-468f-bf3e-6f910259f837',NULL,NULL,NULL,'2022-06-27 13:56:06.230614','2022-06-27 13:56:06.230614','查询','Search','/api/system/user/user_info/',0,NULL,'25735adb-d051-4b7b-bbb7-1154526f3e4c'),('3737d4afa1e2437b93e8cdcd7116180a',NULL,'superadmin',NULL,'2022-08-01 23:15:35.531217','2022-07-28 23:35:05.624087','单例','Retrieve','/api/mall/goodsorder/{id}/',0,NULL,'2e07b715d5e24e2ca45997527430e9d3'),('37462e31-3cdf-4576-af10-5958f53b1bef',NULL,NULL,NULL,'2022-06-27 13:56:06.232609','2022-06-27 13:56:06.232609','查询','Search','/api/system/operation_log/',0,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('3cadf44d739b45d4a94ad23939e19716',NULL,'superadmin',NULL,'2022-08-01 23:15:40.121650','2022-07-28 23:35:05.624087','删除','Delete','/api/mall/goodsorder/{id}/',3,NULL,'2e07b715d5e24e2ca45997527430e9d3'),('3e11db64-b8e8-4558-963b-71d063a7db16',NULL,NULL,NULL,'2022-06-27 13:56:06.205682','2022-06-27 13:56:06.205682','编辑','Update','/api/system/dept/{id}/',2,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('3fd6ae6c-fd76-4465-b2b6-db672f4bd79e',NULL,NULL,NULL,'2022-06-27 13:56:06.293448','2022-06-27 13:56:06.293448','删除','Delete','/api/system/role/{id}/',3,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('4281eaced4e943ababeefb66a6a7f13d',NULL,'superadmin',NULL,'2022-08-01 23:12:52.747252','2022-07-28 23:32:40.227672','编辑','Update','/api/mall/goodsspu/{id}/',2,NULL,'d470ab18859a4472b525e605ae96c325'),('42ad6e05-7c84-444f-bcae-09de84f4988b',NULL,NULL,NULL,'2022-06-27 13:56:06.234604','2022-06-27 13:56:06.234604','查询','Search','/api/system/menu/',0,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('43696212-ecba-4e66-8678-33c9bc935c76',NULL,NULL,NULL,'2022-06-27 13:56:06.236599','2022-06-27 13:56:06.236599','查询','Search','/api/users/users/',0,NULL,'244b28685cd14a39a383189981510d4a'),('43a779c3e1634e84bb1a32c675b5f744',NULL,'superadmin',NULL,'2022-08-01 23:12:58.658399','2022-07-28 23:32:40.227672','查询','Search','/api/mall/goodsspu/',0,NULL,'d470ab18859a4472b525e605ae96c325'),('4450d80871eb44a1aaa4fbb5429885f0',NULL,NULL,NULL,'2022-10-26 00:03:48.087557','2022-07-04 20:52:45.023288','查询','Search','/api/crontab/periodictask/',0,NULL,'09a42810d4dd4b2eb939f8eb0b01d9d1'),('4b73b1669e49495f93de36d63cc2c0d8',NULL,'superadmin',NULL,'2022-08-01 23:15:04.426969','2022-07-28 23:35:05.624087','编辑','Update','/api/mall/goodsorder/{id}/',2,NULL,'2e07b715d5e24e2ca45997527430e9d3'),('4fe4b7f5-0bc8-4375-9f39-747e06ec285a',NULL,NULL,NULL,'2022-06-27 13:56:06.294445','2022-06-27 13:56:06.294445','删除','Delete','/api/system/menu_button/{id}/',3,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf'),('51085c21-2279-490f-8878-594f059f7616',NULL,NULL,NULL,'2022-06-27 13:56:06.296440','2022-06-27 13:56:06.296440','删除','Delete','/api/system/button/{id}/',3,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('53e6d5a4192c4f0f8bdd7f5647124147',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-08-01 23:18:12.051727','2022-08-01 23:18:12.051727','统计','Statistics','/api/mall/goodsforderinfo/orderstatistics/',0,'456b688c-8ad5-46de-bc2e-d41d8047bd42','dc8c173b425048e7a8c9b59513596c7f'),('576008b6046f4afcb88d8139ff34e228',NULL,NULL,NULL,'2022-10-26 00:04:05.356416','2022-07-04 20:52:45.137118','删除','Delete','/api/crontab/periodictask/{id}/',3,NULL,'09a42810d4dd4b2eb939f8eb0b01d9d1'),('59db5099a03f44c8adb883faa340c15a',NULL,NULL,NULL,'2022-06-27 13:56:06.221639','2022-06-27 13:56:06.221639','查询','Search','/api/platformsettings/lunboimg/',0,NULL,'ae5629946df4497cbec10419e8375dd9'),('5aac29b0-5a32-45fb-81c5-437b48f4a5df',NULL,NULL,NULL,'2022-06-27 13:56:06.239397','2022-06-27 13:56:06.239397','查询','Search','/api/system/menu_button/',0,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf'),('5d77d14e-b199-481f-a97d-6e4c0e84fe71',NULL,NULL,NULL,'2022-06-27 13:56:06.207676','2022-06-27 13:56:06.207676','修改密码','Changepassword','/api/system/user/change_password/{id}/',2,NULL,'25735adb-d051-4b7b-bbb7-1154526f3e4c'),('6208f412-6bca-4d7b-a5a0-0103b7ba6091',NULL,NULL,NULL,'2022-06-27 13:56:06.272856','2022-06-27 13:56:06.272856','单例','Retrieve','/api/system/button/{id}/',0,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('62e89e16b7cf460fbbbb949771156946',NULL,NULL,NULL,'2022-06-28 21:23:46.499751','2022-06-28 21:23:46.499751','单例','Retrieve','',0,NULL,'d73f73a399af48cea6a8490ac508d7a0'),('6300774a-d19c-43ad-8102-d7bf341eff33',NULL,NULL,NULL,'2022-06-27 13:56:06.274561','2022-06-27 13:56:06.274561','单例','Retrieve','/api/system/dept/{id}/',0,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('646e9790-24f5-4606-abc4-0b5eede12f66',NULL,NULL,NULL,'2022-06-27 13:56:06.241497','2022-06-27 13:56:06.241497','查询','Search','/api/system/dept/',0,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('676e32850165441cad01782e453de925',NULL,'superadmin',NULL,'2022-08-01 23:14:29.559247','2022-07-28 23:33:28.308230','新增','Create','/api/mall/goodstype/',1,NULL,'b999c50996864465b851575e378c5aea'),('6a21329f0dcd4781a64fc4f62324e4c0',NULL,'superadmin',NULL,'2022-08-01 23:18:18.674075','2022-07-28 23:38:06.974691','查询','Search','/api/mall/goodsforderinfo/',0,NULL,'dc8c173b425048e7a8c9b59513596c7f'),('6af0929440a345238c28ee9b1fe341ba',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-18 10:33:53.037646','2022-07-16 21:41:09.432762','终端','Terminal','/ws/webssh/',5,'456b688c-8ad5-46de-bc2e-d41d8047bd42','718daec1b94b456c96d773889648173e'),('6b88361b326a4e55a8a5135c08ba66f1',NULL,NULL,NULL,'2022-06-27 13:56:06.284841','2022-06-27 13:56:06.284841','单例','Retrieve','/api/messages/messagenotice/{id}/',0,NULL,'3171db16eda048ae92b16536fc1241b6'),('6d6b6689d1224900b09c8101b3344f42',NULL,NULL,NULL,'2022-06-27 13:56:06.285840','2022-06-27 13:56:06.285840','单例','Retrieve','/api/system/role_id_to_menu/{id}/',0,NULL,'a607e820-36e5-45c0-aabf-85a8e4e2c7ac'),('6e27757847c64e228934b60ae81baedf',NULL,NULL,NULL,'2022-10-26 00:04:00.698622','2022-07-04 20:52:45.097918','单例','Retrieve','/api/crontab/periodictask/{id}/',0,NULL,'09a42810d4dd4b2eb939f8eb0b01d9d1'),('6e4251a948f348ccaa419a777a118048',NULL,NULL,NULL,'2022-06-27 13:56:06.199697','2022-06-27 13:56:06.199697','编辑','Update','/api/platformsettings/other/{id}/',2,NULL,'80a340eae92b430abe17635468c2df1d'),('6e9d454742f74437928959c02be42456',NULL,'superadmin',NULL,'2022-08-01 23:18:24.012206','2022-07-28 23:38:06.974691','单例','Retrieve','/api/mall/goodsforderinfo/{id}/',0,NULL,'dc8c173b425048e7a8c9b59513596c7f'),('716480cd8ac645239405763834326f7e',NULL,'superadmin',NULL,'2022-08-01 23:14:05.106215','2022-07-28 23:33:28.308230','编辑','Update','/api/mall/goodstype/{id}/',2,NULL,'b999c50996864465b851575e378c5aea'),('77096cd56a6441699345e6e4f22d0ec3',NULL,NULL,NULL,'2022-06-27 13:56:06.250624','2022-06-27 13:56:06.250624','新增','Create','/api/platformsettings/other/',1,NULL,'80a340eae92b430abe17635468c2df1d'),('7aef1da4647844e3944a2745cef1bc6d',NULL,NULL,NULL,'2022-06-27 13:56:06.248754','2022-06-27 13:56:06.248754','新增','Create','/api/platformsettings/lunboimg/',1,NULL,'ae5629946df4497cbec10419e8375dd9'),('80c8eb6939a245e9890dede241b5d1d6',NULL,NULL,NULL,'2022-06-28 21:23:46.410518','2022-06-28 21:23:46.410518','禁用','Disable','',0,NULL,'d73f73a399af48cea6a8490ac508d7a0'),('80efc041695a42e4a9a04c010c6c7004',NULL,NULL,NULL,'2022-06-27 13:56:06.223634','2022-06-27 13:56:06.223634','查询','Search','/api/platformsettings/other/',0,NULL,'80a340eae92b430abe17635468c2df1d'),('8228955d67bc4dc89638b523f58108ee',NULL,'superadmin',NULL,'2022-08-02 11:38:40.959948','2022-07-28 23:20:39.635039','新增','Create','/api/address/area/',1,NULL,'02c24003527546359b5a77ae07adc7d5'),('873138b279274536bc93c2774b1be815',NULL,NULL,NULL,'2022-06-28 21:23:46.440593','2022-06-28 21:23:46.440593','查询','Search','',0,NULL,'d73f73a399af48cea6a8490ac508d7a0'),('875bdfeb-0c34-441d-8ee3-bb93c21e17dd',NULL,NULL,NULL,'2022-06-27 13:56:06.209670','2022-06-27 13:56:06.209670','编辑','Update','/api/users/users/{id}/',2,NULL,'244b28685cd14a39a383189981510d4a'),('8ae924bd-576c-4ae1-92eb-b0a98148baae',NULL,NULL,NULL,'2022-06-27 13:56:06.297757','2022-06-27 13:56:06.298756','删除','Delete','/api/system/menu/{id}/',3,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('8b7a0e79-a6ef-4946-87c6-8c042b887e1c',NULL,NULL,NULL,'2022-06-27 13:56:06.275558','2022-06-27 13:56:06.275558','单例','Retrieve','/api/system/operation_log/{id}/',0,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('8d65733d401c40f8b27cc6bcfed78bc3',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-18 10:34:34.257924','2022-07-18 10:34:34.257924','新增','Create','/api/terminal/terminal/',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','718daec1b94b456c96d773889648173e'),('8f465aa674744313890cc8c59d3d0fd2',NULL,'superadmin',NULL,'2022-08-02 11:38:31.173998','2022-07-28 23:20:39.597940','查询','Search','/api/address/area/area_root/',0,NULL,'02c24003527546359b5a77ae07adc7d5'),('96022ae5-6425-47b9-8f89-01edc33eb2b7',NULL,NULL,NULL,'2022-06-27 13:56:06.277792','2022-06-27 13:56:06.277792','单例','Retrieve','/api/system/role/{id}/',0,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('989ad685ce654dd1b367f41dedfdd0b9',NULL,'superadmin',NULL,'2022-08-01 23:12:24.716344','2022-07-28 23:40:08.471133','删除','Delete','/api/platformsettings/userfeeckback/{id}/',3,NULL,'3c13161f70f1469a913d539e7616c577'),('98c953b2d74d4d9d83d18433a7fc85ba',NULL,'superadmin',NULL,'2022-08-01 23:14:09.732505','2022-07-28 23:33:28.308230','删除','Delete','/api/mall/goodstype/{id}/',3,NULL,'b999c50996864465b851575e378c5aea'),('9e6b2376-1ab0-4966-8d5d-4ad4f911d13c',NULL,NULL,NULL,'2022-06-27 13:56:06.258457','2022-06-27 13:56:06.258457','新增','Create','/api/system/user/',1,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('9fc8436a-1996-478f-a155-5de7939a54dc',NULL,NULL,NULL,'2022-06-27 13:56:06.260903','2022-06-27 13:56:06.260903','新增','Create','/api/users/users/',1,NULL,'244b28685cd14a39a383189981510d4a'),('a20a200c721c489b9925cdd5b5e6708c',NULL,'superadmin',NULL,'2022-08-02 11:38:57.902026','2022-07-28 23:20:39.726782','删除','Delete','/api/address/area/{id}/',3,NULL,'02c24003527546359b5a77ae07adc7d5'),('a2df144069a44af8afbd5863740e2228',NULL,NULL,NULL,'2022-06-28 21:23:46.469675','2022-06-28 21:23:46.469675','新增','Create','',0,NULL,'d73f73a399af48cea6a8490ac508d7a0'),('a3088120763d49ad93498eb515c7c244',NULL,NULL,NULL,'2022-06-27 13:56:06.267835','2022-06-27 13:56:06.267835','单例','Retrieve','/api/platformsettings/lunboimg/{id}/',0,NULL,'ae5629946df4497cbec10419e8375dd9'),('a45559c4cc6f48e2b7194c2dc577af3a',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-08-01 23:13:34.998856','2022-08-01 23:13:34.998856','禁用','Disable','/api/mall/goodsspu/islaunched/{id}/',2,'456b688c-8ad5-46de-bc2e-d41d8047bd42','d470ab18859a4472b525e605ae96c325'),('a69fb746c0aa4bd0b31b1480c9e4dcc0',NULL,'superadmin',NULL,'2022-07-10 11:36:13.663585','2022-07-04 21:54:47.257805','查询','Search','/api/monitor/getsysteminfo/',0,NULL,'bcbeeee5c91a4e2ea2c2a31237e33616'),('abe5c07f-0cab-4053-ac24-e782792e9d7f',NULL,NULL,NULL,'2022-06-27 13:56:06.262849','2022-06-27 13:56:06.262849','新增','Create','/api/system/menu/',1,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('ac302c9907b94ab59ac3c40975add57b',NULL,'superadmin',NULL,'2022-08-01 23:13:13.618579','2022-07-28 23:32:40.228673','删除','Delete','/api/mall/goodsspu/{id}/',3,NULL,'d470ab18859a4472b525e605ae96c325'),('acfde861-1872-47e2-a1f1-abeda5175b7f',NULL,NULL,NULL,'2022-06-27 13:56:06.299753','2022-06-27 13:56:06.299753','删除','Delete','/api/system/operation_log/{id}/',3,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('af60d628-73b1-4c5d-b34e-7c70ab9bd87e',NULL,NULL,NULL,'2022-06-27 13:56:06.243491','2022-06-27 13:56:06.243491','查询','Search','/api/system/button/',0,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('b10f7d08-2592-4b54-8557-b5ca864a029a',NULL,NULL,NULL,'2022-06-27 13:56:06.301748','2022-06-27 13:56:06.301748','删除','Delete','/api/system/dept/{id}/',3,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('b4cbe8ed35a04155b14c7809fad6b2ef',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-18 10:35:09.558179','2022-07-18 10:35:09.558179','编辑','Update','/api/terminal/terminal/{id}/',2,'456b688c-8ad5-46de-bc2e-d41d8047bd42','718daec1b94b456c96d773889648173e'),('bb7de9ee-5fd1-46f5-9849-088c522f49c7',NULL,NULL,NULL,'2022-06-27 13:56:06.303743','2022-06-27 13:56:06.303743','删除','Delete','/api/users/users/{id}/',3,NULL,'244b28685cd14a39a383189981510d4a'),('bc114580-e62d-4e08-b707-843759817344',NULL,NULL,NULL,'2022-06-27 13:56:06.211665','2022-06-27 13:56:06.211665','编辑','Update','/api/system/user/{id}/',2,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('bc6104a0-f487-4dfd-a368-fb587d6d57d8',NULL,NULL,NULL,'2022-06-27 13:56:06.213660','2022-06-27 13:56:06.213660','编辑','Update','/api/system/menu_button/{id}/',2,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf'),('be860f07c5be4114a6ea0ceefb97a22a',NULL,NULL,NULL,'2022-06-28 21:23:46.527856','2022-06-28 21:23:46.527856','删除','Delete','',0,NULL,'d73f73a399af48cea6a8490ac508d7a0'),('bec59f93068a4d7aaaf5b4ccfbc12265',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-08-01 23:17:19.950117','2022-08-01 23:17:19.950117','统计','Statistics','/api/mall/goodsorder/orderstatistics/',0,'456b688c-8ad5-46de-bc2e-d41d8047bd42','2e07b715d5e24e2ca45997527430e9d3'),('c2490dfba1644cae8f8ff85e2d6f1d3d',NULL,NULL,NULL,'2022-07-03 15:21:19.444049','2022-07-03 15:21:19.444049','查询','Search','',0,NULL,'9065cb5445ac42ef93eb9e75e6287792'),('c28461a142d7464f8865752c969d82de',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-08-01 23:17:35.849075','2022-08-01 23:17:35.849075','发货','Deliver','/api/mall/goodsorder/sendoutgoods/',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','2e07b715d5e24e2ca45997527430e9d3'),('c2cac9993f9142cca5f531565a14f840',NULL,'superadmin',NULL,'2022-08-01 23:18:30.331326','2022-07-28 23:38:06.974691','删除','Delete','/api/mall/goodsforderinfo/{id}/',3,NULL,'dc8c173b425048e7a8c9b59513596c7f'),('c8eee7f68c1845169b8d2af946502077',NULL,NULL,NULL,'2022-06-27 13:56:06.304489','2022-06-27 13:56:06.305470','删除','Delete','/api/messages/messagenotice/{id}/',3,NULL,'3171db16eda048ae92b16536fc1241b6'),('ca69833045ed4cf78c8586f7e55ba6db',NULL,NULL,NULL,'2022-06-27 13:56:06.219644','2022-06-27 13:56:06.219644','编辑','Update','/api/messages/messagenotice/{id}/',2,NULL,'3171db16eda048ae92b16536fc1241b6'),('cf50028007164569a136fbdeaff7619c',NULL,'superadmin',NULL,'2022-08-02 11:38:17.509976','2022-07-28 23:20:39.447527','编辑','Update','/api/address/area/{id}/',2,NULL,'02c24003527546359b5a77ae07adc7d5'),('d1b3c15f0c664857aeca1d9065d9c499',NULL,NULL,NULL,'2022-06-27 13:56:06.246483','2022-06-27 13:56:06.246483','查询','Search','/api/messages/messagenotice/',0,NULL,'3171db16eda048ae92b16536fc1241b6'),('d22c0176-96e0-48b3-b81e-13443f306af5',NULL,NULL,NULL,'2022-06-27 13:56:06.214657','2022-06-27 13:56:06.214657','编辑','Update','/api/system/role/{id}/',2,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('d2e0608b5b4941ef8c3ff834977caeef',NULL,NULL,NULL,'2022-06-27 13:56:06.265841','2022-06-27 13:56:06.265841','新增','Create','/api/messages/messagenotice/',1,NULL,'3171db16eda048ae92b16536fc1241b6'),('dcc58831-08d1-4469-8b01-fca71e0f497f',NULL,NULL,NULL,'2022-06-27 13:56:06.216652','2022-06-27 13:56:06.216652','编辑','Update','/api/system/user/user_info/',2,NULL,'25735adb-d051-4b7b-bbb7-1154526f3e4c'),('e1ddf86666364a39be76c963c277b009',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-18 10:34:25.828153','2022-07-18 10:34:25.828153','查询','Search','/api/terminal/terminal/',0,'456b688c-8ad5-46de-bc2e-d41d8047bd42','718daec1b94b456c96d773889648173e'),('e6b93920-2236-46ec-841b-cff6f63ce788',NULL,NULL,NULL,'2022-06-27 13:56:06.218647','2022-06-27 13:56:06.218647','编辑','Update','/api/system/operation_log/{id}/',2,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('e7fa30290d37447585ea7583d9d01f1b',NULL,NULL,NULL,'2022-06-27 13:56:06.197698','2022-06-27 13:56:06.197698','编辑','Update','/api/platformsettings/lunboimg/{id}/',2,NULL,'ae5629946df4497cbec10419e8375dd9'),('ea18bb51400b482a8aad5dc18357bcab',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-18 10:34:48.832019','2022-07-18 10:34:48.832019','单例','Retrieve','/api/terminal/terminal/{id}/',0,'456b688c-8ad5-46de-bc2e-d41d8047bd42','718daec1b94b456c96d773889648173e'),('efcbf104971a4266a26d9469e58c1327',NULL,'superadmin',NULL,'2022-08-02 11:38:48.614359','2022-07-28 23:20:39.692186','单例','Retrieve','/api/address/area/{id}/',0,NULL,'02c24003527546359b5a77ae07adc7d5'),('f0e080c0-275d-4085-b56c-735b49510eff',NULL,NULL,NULL,'2022-06-27 13:56:06.279787','2022-06-27 13:56:06.279787','单例','Retrieve','/api/system/user/{id}/',0,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('f19826f7df9842089cee94a795681b2e',NULL,NULL,NULL,'2022-07-03 15:21:19.526449','2022-07-03 15:21:19.526449','单例','Retrieve','',0,NULL,'9065cb5445ac42ef93eb9e75e6287792'),('f5818e4cd46947daabe046c511dfbd63',NULL,'superadmin',NULL,'2022-08-01 23:15:19.978173','2022-07-28 23:35:05.624087','查询','Search','/api/mall/goodsorder/',0,NULL,'2e07b715d5e24e2ca45997527430e9d3'),('fa8d945124b74379aba32bcf34ea5383',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-10-26 00:06:00.943849','2022-10-26 00:06:00.943849','任务列表','Tasklist','/api/crontab/periodictask/tasklist/',0,'456b688c-8ad5-46de-bc2e-d41d8047bd42','09a42810d4dd4b2eb939f8eb0b01d9d1'),('fc71b446-fde1-439f-ab41-c38f30230caa',NULL,NULL,NULL,'2022-06-27 13:56:06.263846','2022-06-27 13:56:06.263846','新增','Create','/api/system/menu_button/',1,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf'),('fcbe4cec-cc2d-436d-92ba-023f8c9ad31c',NULL,NULL,NULL,'2022-06-27 13:56:06.280734','2022-06-27 13:56:06.280734','单例','Retrieve','/api/system/menu/{id}/',0,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('fe96f32c-6124-4b24-b809-4964186f5163',NULL,NULL,NULL,'2022-06-27 13:56:06.283356','2022-06-27 13:56:06.283356','单例','Retrieve','/api/system/menu_button/{id}/',0,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf');

#
# Structure for table "lyadmin_operation_log"
#

CREATE TABLE `lyadmin_operation_log` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `request_modular` varchar(64) DEFAULT NULL COMMENT '请求模块',
  `request_path` longtext COMMENT '请求地址',
  `request_body` longtext COMMENT '请求参数',
  `request_method` varchar(8) DEFAULT NULL COMMENT '请求方式',
  `request_msg` longtext COMMENT '操作说明',
  `request_ip` varchar(32) DEFAULT NULL COMMENT '请求ip地址',
  `request_browser` varchar(64) DEFAULT NULL COMMENT '请求浏览器',
  `response_code` varchar(32) DEFAULT NULL COMMENT '响应状态码',
  `request_os` varchar(64) DEFAULT NULL COMMENT '操作系统',
  `json_result` longtext COMMENT '返回信息',
  `status` tinyint(1) NOT NULL COMMENT '响应状态',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `lyadmin_operation_log_creator_id_7b08f4e1` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志';

#
# Data for table "lyadmin_operation_log"
#

REPLACE INTO `lyadmin_operation_log` VALUES ('2b32f52997424911b73a79344de20c5b',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3','2022-10-26 00:26:55.991783','2022-10-26 00:26:55.991783','操作日志','/api/system/operation_log/deletealllogs/','{}','DELETE',NULL,'127.0.0.1','Chrome 106.0.0','2000','Windows 10','{\'code\': 2000, \'msg\': \'清空成功\'}',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42');

#
# Structure for table "lyadmin_post"
#

CREATE TABLE `lyadmin_post` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '岗位名称',
  `code` varchar(32) NOT NULL COMMENT '岗位编码',
  `sort` int(11) NOT NULL COMMENT '岗位顺序',
  `status` int(11) NOT NULL COMMENT '岗位状态',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `lyadmin_post_creator_id_15f90961` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='岗位表';

#
# Data for table "lyadmin_post"
#


#
# Structure for table "lyadmin_role"
#

CREATE TABLE `lyadmin_role` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(64) NOT NULL COMMENT '角色名称',
  `key` varchar(64) NOT NULL COMMENT '权限字符',
  `sort` int(11) NOT NULL COMMENT '角色顺序',
  `status` smallint(6) NOT NULL COMMENT '角色状态',
  `admin` smallint(6) NOT NULL COMMENT '是否为admin',
  `data_range` smallint(6) NOT NULL COMMENT '数据权限范围',
  `remark` longtext COMMENT '备注',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `lyadmin_role_creator_id_858b8a61` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

#
# Data for table "lyadmin_role"
#

REPLACE INTO `lyadmin_role` VALUES ('35b58d98-b506-4f93-be79-ed1e109da071',NULL,NULL,NULL,'2022-06-27 13:56:06.322600','2022-06-27 13:56:06.322600','普通用户','public',2,1,0,4,NULL,NULL),('36001d1a-1b3e-4413-bdfe-b3bc04375f46',NULL,'superadmin',NULL,'2022-10-26 00:26:48.482054','2022-06-27 13:56:06.311456','管理员','admin',1,1,1,3,NULL,NULL);

#
# Structure for table "lyadmin_role_dept"
#

CREATE TABLE `lyadmin_role_dept` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` varchar(100) NOT NULL,
  `dept_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lyadmin_role_dept_role_id_dept_id_75a8409d_uniq` (`role_id`,`dept_id`),
  KEY `lyadmin_role_dept_role_id_bf2e0106` (`role_id`),
  KEY `lyadmin_role_dept_dept_id_4efa5a2b` (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

#
# Data for table "lyadmin_role_dept"
#

REPLACE INTO `lyadmin_role_dept` VALUES (1,'35b58d98-b506-4f93-be79-ed1e109da071','fd8230ca-67bd-4347-8a9b-57eb19be5d9e'),(2,'35b58d98-b506-4f93-be79-ed1e109da071','d2c03bd9-dad0-4262-88ca-c3681d224fc3');

#
# Structure for table "lyadmin_role_menu"
#

CREATE TABLE `lyadmin_role_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` varchar(100) NOT NULL,
  `menu_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lyadmin_role_menu_role_id_menu_id_ee3d26d9_uniq` (`role_id`,`menu_id`),
  KEY `lyadmin_role_menu_role_id_68ec079a` (`role_id`),
  KEY `lyadmin_role_menu_menu_id_27af6f62` (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4;

#
# Data for table "lyadmin_role_menu"
#

REPLACE INTO `lyadmin_role_menu` VALUES (1,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),(2,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','c236fb6b-ddaa-4deb-b79b-16e42d9f347f'),(3,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','4ba07859-8b73-4524-a1a6-bbff36d98337'),(4,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3171db16eda048ae92b16536fc1241b6'),(5,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','80a340eae92b430abe17635468c2df1d'),(6,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','15c9ebc5-d12f-470a-a560-938a7dc57570'),(7,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','ae5629946df4497cbec10419e8375dd9'),(8,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','25735adb-d051-4b7b-bbb7-1154526f3e4c'),(9,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','151035da-77a3-4a62-b474-fce6824571fb'),(10,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','e0f53902-e901-490c-83f3-331e60b97fcf'),(11,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','56c3f341-4f46-4b04-9cfc-c8a14701707e'),(12,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a607e820-36e5-45c0-aabf-85a8e4e2c7ac'),(13,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','54f769b0-3dff-416c-8102-e55ec44827cc'),(14,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','d4e2fe169a8b40f3846421ac04e4fccb'),(15,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','4236eb70-1558-43a0-9cf2-037230c547f9'),(16,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','244b28685cd14a39a383189981510d4a'),(17,'35b58d98-b506-4f93-be79-ed1e109da071','15c9ebc5-d12f-470a-a560-938a7dc57570'),(18,'35b58d98-b506-4f93-be79-ed1e109da071','56c3f341-4f46-4b04-9cfc-c8a14701707e'),(19,'35b58d98-b506-4f93-be79-ed1e109da071','54f769b0-3dff-416c-8102-e55ec44827cc'),(20,'35b58d98-b506-4f93-be79-ed1e109da071','4236eb70-1558-43a0-9cf2-037230c547f9'),(21,'35b58d98-b506-4f93-be79-ed1e109da071','244b28685cd14a39a383189981510d4a'),(22,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','d73f73a399af48cea6a8490ac508d7a0'),(23,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','9065cb5445ac42ef93eb9e75e6287792'),(24,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','bcbeeee5c91a4e2ea2c2a31237e33616'),(25,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','77edf447326b4e0dbc6f9719c1de8a12'),(26,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','718daec1b94b456c96d773889648173e'),(27,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','02c24003527546359b5a77ae07adc7d5'),(28,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','b999c50996864465b851575e378c5aea'),(29,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2e07b715d5e24e2ca45997527430e9d3'),(30,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','dc8c173b425048e7a8c9b59513596c7f'),(31,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','d470ab18859a4472b525e605ae96c325'),(32,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3c13161f70f1469a913d539e7616c577'),(33,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a28f8ca682d04c8fb2953fdeb3d9e2e6'),(34,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2a7c0142f7514dacb7999383e4e67aca'),(35,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a524f17e9ac74be3baf9d113f014184c'),(36,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','09a42810d4dd4b2eb939f8eb0b01d9d1');

#
# Structure for table "lyadmin_role_permission"
#

CREATE TABLE `lyadmin_role_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` varchar(100) NOT NULL,
  `menubutton_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lyadmin_role_permission_role_id_menubutton_id_dfd195d1_uniq` (`role_id`,`menubutton_id`),
  KEY `lyadmin_role_permission_role_id_610a95e1` (`role_id`),
  KEY `lyadmin_role_permission_menubutton_id_539eb394` (`menubutton_id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4;

#
# Data for table "lyadmin_role_permission"
#

REPLACE INTO `lyadmin_role_permission` VALUES (1,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','646e9790-24f5-4606-abc4-0b5eede12f66'),(2,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','51085c21-2279-490f-8878-594f059f7616'),(3,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','1b4f27a7-8ab8-4388-ae57-46e29976cf0e'),(4,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','f0e080c0-275d-4085-b56c-735b49510eff'),(5,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','bc6104a0-f487-4dfd-a368-fb587d6d57d8'),(6,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','14e7088f-a39b-47ae-bd67-b9bbcabae96b'),(7,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2c53efc8-e6a4-4192-8688-03baed0874a4'),(8,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','8ae924bd-576c-4ae1-92eb-b0a98148baae'),(9,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','324776a3-48ec-4bca-bdd9-1838e2b6f7cc'),(10,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','353595a28cb1463b830cfbf79fea60b5'),(11,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','d1b3c15f0c664857aeca1d9065d9c499'),(12,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','e6b93920-2236-46ec-841b-cff6f63ce788'),(13,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','bb7de9ee-5fd1-46f5-9849-088c522f49c7'),(14,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','e7fa30290d37447585ea7583d9d01f1b'),(15,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','04896a47-0f3a-4e2f-a111-bfe15f9e31c5'),(16,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','77096cd56a6441699345e6e4f22d0ec3'),(17,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','43696212-ecba-4e66-8678-33c9bc935c76'),(18,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','80efc041695a42e4a9a04c010c6c7004'),(19,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','59db5099a03f44c8adb883faa340c15a'),(20,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','5d77d14e-b199-481f-a97d-6e4c0e84fe71'),(21,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','d22c0176-96e0-48b3-b81e-13443f306af5'),(22,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3688b715-4689-468f-bf3e-6f910259f837'),(23,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','fcbe4cec-cc2d-436d-92ba-023f8c9ad31c'),(24,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','4fe4b7f5-0bc8-4375-9f39-747e06ec285a'),(25,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','dcc58831-08d1-4469-8b01-fca71e0f497f'),(26,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','0d931efc-2f80-418f-b4a0-5251f0a88f69'),(27,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6d6b6689d1224900b09c8101b3344f42'),(28,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6208f412-6bca-4d7b-a5a0-0103b7ba6091'),(29,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','7aef1da4647844e3944a2745cef1bc6d'),(30,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6300774a-d19c-43ad-8102-d7bf341eff33'),(31,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6e4251a948f348ccaa419a777a118048'),(32,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','fc71b446-fde1-439f-ab41-c38f30230caa'),(33,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','b10f7d08-2592-4b54-8557-b5ca864a029a'),(34,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','abe5c07f-0cab-4053-ac24-e782792e9d7f'),(35,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2a3d4756-4d51-4129-b3c4-b2c7a00dbb8a'),(36,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','fe96f32c-6124-4b24-b809-4964186f5163'),(37,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','1d4441fdc418499f856c23aa4e1be2c0'),(38,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','ca69833045ed4cf78c8586f7e55ba6db'),(39,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','5aac29b0-5a32-45fb-81c5-437b48f4a5df'),(40,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','bc114580-e62d-4e08-b707-843759817344'),(41,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','9fc8436a-1996-478f-a155-5de7939a54dc'),(42,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','0088e172566f4ee388092ec2be3584ee'),(43,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','c8eee7f68c1845169b8d2af946502077'),(44,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','af60d628-73b1-4c5d-b34e-7c70ab9bd87e'),(45,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','140166e2-471e-455e-9dcd-05cebbbab95d'),(46,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','37462e31-3cdf-4576-af10-5958f53b1bef'),(47,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','42ad6e05-7c84-444f-bcae-09de84f4988b'),(48,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','d2e0608b5b4941ef8c3ff834977caeef'),(49,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3fd6ae6c-fd76-4465-b2b6-db672f4bd79e'),(50,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','96022ae5-6425-47b9-8f89-01edc33eb2b7'),(51,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6b88361b326a4e55a8a5135c08ba66f1'),(52,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','0209de89-6b9f-4d8a-84d3-ccfc3cc8b4da'),(54,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','10610c56-cec2-4774-9468-e1c763e59e70'),(55,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a3088120763d49ad93498eb515c7c244'),(56,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','875bdfeb-0c34-441d-8ee3-bb93c21e17dd'),(57,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3e11db64-b8e8-4558-963b-71d063a7db16'),(58,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','acfde861-1872-47e2-a1f1-abeda5175b7f'),(59,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','8b7a0e79-a6ef-4946-87c6-8c042b887e1c'),(60,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','264cc3d69f7a46d5a117997e9c78506c'),(61,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','9e6b2376-1ab0-4966-8d5d-4ad4f911d13c'),(62,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','62e89e16b7cf460fbbbb949771156946'),(63,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a2df144069a44af8afbd5863740e2228'),(64,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','873138b279274536bc93c2774b1be815'),(65,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','80c8eb6939a245e9890dede241b5d1d6'),(66,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','f19826f7df9842089cee94a795681b2e'),(67,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a69fb746c0aa4bd0b31b1480c9e4dcc0'),(68,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','c2490dfba1644cae8f8ff85e2d6f1d3d'),(70,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6af0929440a345238c28ee9b1fe341ba'),(71,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','8d65733d401c40f8b27cc6bcfed78bc3'),(72,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','e1ddf86666364a39be76c963c277b009'),(73,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','b4cbe8ed35a04155b14c7809fad6b2ef'),(74,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','ea18bb51400b482a8aad5dc18357bcab'),(75,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','281ad1aad421441a965f7bc6b397eb30'),(76,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','be860f07c5be4114a6ea0ceefb97a22a'),(77,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','43a779c3e1634e84bb1a32c675b5f744'),(79,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','09a0908dfb0c433c90037851da126e9b'),(80,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','118ce77cc07140a08d9a92ab8800f2cf'),(81,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','989ad685ce654dd1b367f41dedfdd0b9'),(82,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','676e32850165441cad01782e453de925'),(83,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6e9d454742f74437928959c02be42456'),(84,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','4b73b1669e49495f93de36d63cc2c0d8'),(85,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','ac302c9907b94ab59ac3c40975add57b'),(86,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','716480cd8ac645239405763834326f7e'),(87,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3737d4afa1e2437b93e8cdcd7116180a'),(88,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','4281eaced4e943ababeefb66a6a7f13d'),(89,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3cadf44d739b45d4a94ad23939e19716'),(90,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','05932c39ad444ac5aaf880d281620611'),(92,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','efcbf104971a4266a26d9469e58c1327'),(93,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','8228955d67bc4dc89638b523f58108ee'),(94,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2235160bd56c423880572f5450b94f16'),(95,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','cf50028007164569a136fbdeaff7619c'),(97,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','8f465aa674744313890cc8c59d3d0fd2'),(98,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6a21329f0dcd4781a64fc4f62324e4c0'),(99,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','220fa39fd56e47e1ab9558c6bd10106e'),(100,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','f5818e4cd46947daabe046c511dfbd63'),(101,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a20a200c721c489b9925cdd5b5e6708c'),(102,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2c5b748c5dce4f34bd24b1201faf09c2'),(103,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','98c953b2d74d4d9d83d18433a7fc85ba'),(104,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','11d334fcadf1490e85e6a045126dea78'),(107,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','c2cac9993f9142cca5f531565a14f840'),(108,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','c28461a142d7464f8865752c969d82de'),(109,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','4450d80871eb44a1aaa4fbb5429885f0'),(110,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','576008b6046f4afcb88d8139ff34e228'),(111,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a45559c4cc6f48e2b7194c2dc577af3a'),(112,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','19d01a929bc9414cac1a8defd48597c9'),(113,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','0b5bf0f1caac45beabf54fb5d930187b'),(114,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','0ce04d99cbd249a9af88fe1496591a89'),(115,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','bec59f93068a4d7aaaf5b4ccfbc12265'),(116,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','fa8d945124b74379aba32bcf34ea5383'),(117,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','1a16836d2cec4d14a1307b3228e3cfdd'),(118,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','53e6d5a4192c4f0f8bdd7f5647124147'),(119,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6e27757847c64e228934b60ae81baedf');

#
# Structure for table "lyadmin_users"
#

CREATE TABLE `lyadmin_users` (
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL COMMENT 'Designates that this user has all permissions without explicitly assigning them.',
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL COMMENT 'Designates whether the user can log into this admin site.',
  `is_active` tinyint(1) NOT NULL COMMENT 'Designates whether this user should be treated as active. Unselect this instead of deleting accounts.',
  `date_joined` datetime(6) NOT NULL,
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `username` varchar(50) NOT NULL COMMENT '用户账号',
  `email` varchar(60) DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(30) DEFAULT NULL COMMENT '电话',
  `avatar` varchar(200) DEFAULT NULL COMMENT '头像',
  `name` varchar(40) NOT NULL COMMENT '姓名',
  `nickname` varchar(100) NOT NULL COMMENT '用户昵称',
  `gender` smallint(6) DEFAULT NULL COMMENT '性别',
  `identity` smallint(6) DEFAULT NULL COMMENT '身份标识',
  `balance` decimal(10,2) NOT NULL,
  `is_delete` tinyint(1) NOT NULL COMMENT '是否逻辑删除',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `dept_id` varchar(100) DEFAULT NULL COMMENT '关联部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `lyadmin_users_creator_id_92824513` (`creator_id`),
  KEY `lyadmin_users_dept_id_ba5fbf41` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

#
# Data for table "lyadmin_users"
#

REPLACE INTO `lyadmin_users` VALUES ('pbkdf2_sha256$260000$oivECWOjB0GJyMjPsrqb3t$9FvnYtXtsNWDva2P3A/eIg6cRMLOp7kiIOuwfLKyDAY=',NULL,0,'','',0,1,'2022-06-27 13:56:06.339555','244b28685cd14a39a383189981510d4a',NULL,NULL,NULL,'2022-07-02 14:40:23.055520','2022-06-27 13:56:06.339555','test',NULL,'18888888888',NULL,'测试用户','测试用户',NULL,2,0.00,0,NULL,''),('pbkdf2_sha256$320000$wEE8ovuKZXpANn2INi7geU$d2fM0PwOkjL74kZcWk7KfHfAz7XHI6wLIMLBDAwOZ14=',NULL,1,'','',1,1,'2022-06-27 13:56:06.331576','456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,NULL,NULL,'2022-06-27 13:56:06.331576','2022-06-27 13:56:06.331576','superadmin',NULL,NULL,NULL,'超级管理员','',NULL,0,0.00,0,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3'),('pbkdf2_sha256$320000$fNyAAOrrZNjACpme8Qgv4T$CkpJIXe3XJcm/dyAR7b9G55AZVLcJOPQOBY/9GA5LI0=',NULL,0,'','',1,1,'2022-06-27 13:56:06.334568','d1431450-5068-4461-b57e-7862c005a547',NULL,NULL,NULL,'2022-06-27 13:56:06.334568','2022-06-27 13:56:06.334568','admin',NULL,NULL,NULL,'管理员','',NULL,1,0.00,0,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3');

#
# Structure for table "django_admin_log"
#

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_lyadmin_users_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_lyadmin_users_id` FOREIGN KEY (`user_id`) REFERENCES `lyadmin_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='log entry';

#
# Data for table "django_admin_log"
#


#
# Structure for table "lyadmin_users_groups"
#

CREATE TABLE `lyadmin_users_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `users_id` varchar(100) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lyadmin_users_groups_users_id_group_id_a79dc867_uniq` (`users_id`,`group_id`),
  KEY `lyadmin_users_groups_group_id_c57fd8d6_fk_auth_group_id` (`group_id`),
  CONSTRAINT `lyadmin_users_groups_group_id_c57fd8d6_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `lyadmin_users_groups_users_id_8bf861d7_fk_lyadmin_users_id` FOREIGN KEY (`users_id`) REFERENCES `lyadmin_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

#
# Data for table "lyadmin_users_groups"
#


#
# Structure for table "lyadmin_users_post"
#

CREATE TABLE `lyadmin_users_post` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `users_id` varchar(100) NOT NULL,
  `post_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lyadmin_users_post_users_id_post_id_b358d223_uniq` (`users_id`,`post_id`),
  KEY `lyadmin_users_post_users_id_f3295aea` (`users_id`),
  KEY `lyadmin_users_post_post_id_67f9ae2a` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

#
# Data for table "lyadmin_users_post"
#


#
# Structure for table "lyadmin_users_role"
#

CREATE TABLE `lyadmin_users_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `users_id` varchar(100) NOT NULL,
  `role_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lyadmin_users_role_users_id_role_id_475ae0d5_uniq` (`users_id`,`role_id`),
  KEY `lyadmin_users_role_users_id_25f578a0` (`users_id`),
  KEY `lyadmin_users_role_role_id_0f927f87` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

#
# Data for table "lyadmin_users_role"
#

REPLACE INTO `lyadmin_users_role` VALUES (1,'d1431450-5068-4461-b57e-7862c005a547','36001d1a-1b3e-4413-bdfe-b3bc04375f46');

#
# Structure for table "lyadmin_users_user_permissions"
#

CREATE TABLE `lyadmin_users_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `users_id` varchar(100) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lyadmin_users_user_permi_users_id_permission_id_b174f27e_uniq` (`users_id`,`permission_id`),
  KEY `lyadmin_users_user_p_permission_id_0555113f_fk_auth_perm` (`permission_id`),
  CONSTRAINT `lyadmin_users_user_p_permission_id_0555113f_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `lyadmin_users_user_p_users_id_7212a3dc_fk_lyadmin_u` FOREIGN KEY (`users_id`) REFERENCES `lyadmin_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

#
# Data for table "lyadmin_users_user_permissions"
#


#
# Structure for table "tb_address"
#

CREATE TABLE `tb_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `update_datetime` datetime(6) DEFAULT NULL,
  `create_datetime` datetime(6) DEFAULT NULL,
  `receiver` varchar(20) DEFAULT NULL,
  `province` varchar(32) DEFAULT NULL,
  `city` varchar(32) DEFAULT NULL,
  `district` varchar(32) DEFAULT NULL,
  `street` varchar(32) DEFAULT NULL,
  `place` varchar(50) NOT NULL,
  `mobile` varchar(11) NOT NULL,
  `longitude` double DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_address_user_id_476bb898_fk_lyadmin_users_id` (`user_id`),
  CONSTRAINT `tb_address_user_id_476bb898_fk_lyadmin_users_id` FOREIGN KEY (`user_id`) REFERENCES `lyadmin_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户地址';

#
# Data for table "tb_address"
#


#
# Structure for table "tb_areas"
#

CREATE TABLE `tb_areas` (
  `id` varchar(100) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL,
  `parent_id` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `create_datetime` datetime(6) DEFAULT NULL,
  `update_datetime` datetime(6) DEFAULT NULL,
  `description` longtext CHARACTER SET utf8mb4,
  `creator_id` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `modifier` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `dept_belong_id` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_areas_parent_id_bae67575` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='省市区';

#
# Data for table "tb_areas"
#

REPLACE INTO `tb_areas` VALUES ('110000','北京市',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('110100','北京市','110000',1,NULL,NULL,NULL,NULL,NULL,NULL),('110101','东城区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110102','西城区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110105','朝阳区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110106','丰台区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110107','石景山区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110108','海淀区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110109','门头沟区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110111','房山区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110112','通州区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110113','顺义区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110114','昌平区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110115','大兴区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110116','怀柔区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110117','平谷区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110118','密云区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('110119','延庆区','110100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120000','天津市',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('120100','天津市','120000',1,NULL,NULL,NULL,NULL,NULL,NULL),('120101','和平区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120102','河东区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120103','河西区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120104','南开区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120105','河北区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120106','红桥区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120110','东丽区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120111','西青区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120112','津南区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120113','北辰区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120114','武清区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120115','宝坻区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120116','滨海新区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120117','宁河区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120118','静海区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('120119','蓟州区','120100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130000','河北省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('130100','石家庄市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('130102','长安区','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130104','桥西区','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130105','新华区','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130107','井陉矿区','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130108','裕华区','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130109','藁城区','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130110','鹿泉区','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130111','栾城区','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130121','井陉县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130123','正定县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130125','行唐县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130126','灵寿县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130127','高邑县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130128','深泽县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130129','赞皇县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130130','无极县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130131','平山县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130132','元氏县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130133','赵县','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130181','辛集市','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130183','晋州市','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130184','新乐市','130100',1,NULL,NULL,NULL,NULL,NULL,NULL),('130200','唐山市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('130202','路南区','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130203','路北区','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130204','古冶区','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130205','开平区','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130207','丰南区','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130208','丰润区','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130209','曹妃甸区','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130223','滦县','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130224','滦南县','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130225','乐亭县','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130227','迁西县','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130229','玉田县','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130281','遵化市','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130283','迁安市','130200',1,NULL,NULL,NULL,NULL,NULL,NULL),('130300','秦皇岛市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('130302','海港区','130300',1,NULL,NULL,NULL,NULL,NULL,NULL),('130303','山海关区','130300',1,NULL,NULL,NULL,NULL,NULL,NULL),('130304','北戴河区','130300',1,NULL,NULL,NULL,NULL,NULL,NULL),('130306','抚宁区','130300',1,NULL,NULL,NULL,NULL,NULL,NULL),('130321','青龙满族自治县','130300',1,NULL,NULL,NULL,NULL,NULL,NULL),('130322','昌黎县','130300',1,NULL,NULL,NULL,NULL,NULL,NULL),('130324','卢龙县','130300',1,NULL,NULL,NULL,NULL,NULL,NULL),('130400','邯郸市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('130402','邯山区','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130403','丛台区','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130404','复兴区','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130406','峰峰矿区','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130421','邯郸县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130423','临漳县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130424','成安县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130425','大名县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130426','涉县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130427','磁县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130428','肥乡县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130429','永年县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130430','邱县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130431','鸡泽县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130432','广平县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130433','馆陶县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130434','魏县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130435','曲周县','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130481','武安市','130400',1,NULL,NULL,NULL,NULL,NULL,NULL),('130500','邢台市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('130502','桥东区','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130503','桥西区','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130521','邢台县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130522','临城县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130523','内丘县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130524','柏乡县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130525','隆尧县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130526','任县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130527','南和县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130528','宁晋县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130529','巨鹿县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130530','新河县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130531','广宗县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130532','平乡县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130533','威县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130534','清河县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130535','临西县','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130581','南宫市','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130582','沙河市','130500',1,NULL,NULL,NULL,NULL,NULL,NULL),('130600','保定市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('130602','竞秀区','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130606','莲池区','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130607','满城区','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130608','清苑区','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130609','徐水区','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130623','涞水县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130624','阜平县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130626','定兴县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130627','唐县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130628','高阳县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130629','容城县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130630','涞源县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130631','望都县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130632','安新县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130633','易县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130634','曲阳县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130635','蠡县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130636','顺平县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130637','博野县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130638','雄县','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130681','涿州市','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130682','定州市','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130683','安国市','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130684','高碑店市','130600',1,NULL,NULL,NULL,NULL,NULL,NULL),('130700','张家口市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('130702','桥东区','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130703','桥西区','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130705','宣化区','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130706','下花园区','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130708','万全区','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130709','崇礼区','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130722','张北县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130723','康保县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130724','沽源县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130725','尚义县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130726','蔚县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130727','阳原县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130728','怀安县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130730','怀来县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130731','涿鹿县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130732','赤城县','130700',1,NULL,NULL,NULL,NULL,NULL,NULL),('130800','承德市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('130802','双桥区','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130803','双滦区','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130804','鹰手营子矿区','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130821','承德县','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130822','兴隆县','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130823','平泉县','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130824','滦平县','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130825','隆化县','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130826','丰宁满族自治县','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130827','宽城满族自治县','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130828','围场满族蒙古族自治县','130800',1,NULL,NULL,NULL,NULL,NULL,NULL),('130900','沧州市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('130902','新华区','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130903','运河区','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130921','沧县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130922','青县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130923','东光县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130924','海兴县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130925','盐山县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130926','肃宁县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130927','南皮县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130928','吴桥县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130929','献县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130930','孟村回族自治县','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130981','泊头市','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130982','任丘市','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130983','黄骅市','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('130984','河间市','130900',1,NULL,NULL,NULL,NULL,NULL,NULL),('131000','廊坊市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131002','安次区','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131003','广阳区','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131022','固安县','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131023','永清县','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131024','香河县','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131025','大城县','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131026','文安县','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131028','大厂回族自治县','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131081','霸州市','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131082','三河市','131000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131100','衡水市','130000',1,NULL,NULL,NULL,NULL,NULL,NULL),('131102','桃城区','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131103','冀州区','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131121','枣强县','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131122','武邑县','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131123','武强县','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131124','饶阳县','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131125','安平县','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131126','故城县','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131127','景县','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131128','阜城县','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('131182','深州市','131100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140000','山西省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('140100','太原市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('140105','小店区','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140106','迎泽区','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140107','杏花岭区','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140108','尖草坪区','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140109','万柏林区','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140110','晋源区','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140121','清徐县','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140122','阳曲县','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140123','娄烦县','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140181','古交市','140100',1,NULL,NULL,NULL,NULL,NULL,NULL),('140200','大同市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('140202','城区','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140203','矿区','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140211','南郊区','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140212','新荣区','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140221','阳高县','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140222','天镇县','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140223','广灵县','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140224','灵丘县','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140225','浑源县','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140226','左云县','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140227','大同县','140200',1,NULL,NULL,NULL,NULL,NULL,NULL),('140300','阳泉市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('140302','城区','140300',1,NULL,NULL,NULL,NULL,NULL,NULL),('140303','矿区','140300',1,NULL,NULL,NULL,NULL,NULL,NULL),('140311','郊区','140300',1,NULL,NULL,NULL,NULL,NULL,NULL),('140321','平定县','140300',1,NULL,NULL,NULL,NULL,NULL,NULL),('140322','盂县','140300',1,NULL,NULL,NULL,NULL,NULL,NULL),('140400','长治市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('140402','城区','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140411','郊区','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140421','长治县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140423','襄垣县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140424','屯留县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140425','平顺县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140426','黎城县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140427','壶关县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140428','长子县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140429','武乡县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140430','沁县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140431','沁源县','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140481','潞城市','140400',1,NULL,NULL,NULL,NULL,NULL,NULL),('140500','晋城市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('140502','城区','140500',1,NULL,NULL,NULL,NULL,NULL,NULL),('140521','沁水县','140500',1,NULL,NULL,NULL,NULL,NULL,NULL),('140522','阳城县','140500',1,NULL,NULL,NULL,NULL,NULL,NULL),('140524','陵川县','140500',1,NULL,NULL,NULL,NULL,NULL,NULL),('140525','泽州县','140500',1,NULL,NULL,NULL,NULL,NULL,NULL),('140581','高平市','140500',1,NULL,NULL,NULL,NULL,NULL,NULL),('140600','朔州市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('140602','朔城区','140600',1,NULL,NULL,NULL,NULL,NULL,NULL),('140603','平鲁区','140600',1,NULL,NULL,NULL,NULL,NULL,NULL),('140621','山阴县','140600',1,NULL,NULL,NULL,NULL,NULL,NULL),('140622','应县','140600',1,NULL,NULL,NULL,NULL,NULL,NULL),('140623','右玉县','140600',1,NULL,NULL,NULL,NULL,NULL,NULL),('140624','怀仁县','140600',1,NULL,NULL,NULL,NULL,NULL,NULL),('140700','晋中市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('140702','榆次区','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140721','榆社县','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140722','左权县','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140723','和顺县','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140724','昔阳县','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140725','寿阳县','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140726','太谷县','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140727','祁县','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140728','平遥县','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140729','灵石县','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140781','介休市','140700',1,NULL,NULL,NULL,NULL,NULL,NULL),('140800','运城市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('140802','盐湖区','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140821','临猗县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140822','万荣县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140823','闻喜县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140824','稷山县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140825','新绛县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140826','绛县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140827','垣曲县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140828','夏县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140829','平陆县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140830','芮城县','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140881','永济市','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140882','河津市','140800',1,NULL,NULL,NULL,NULL,NULL,NULL),('140900','忻州市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('140902','忻府区','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140921','定襄县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140922','五台县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140923','代县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140924','繁峙县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140925','宁武县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140926','静乐县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140927','神池县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140928','五寨县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140929','岢岚县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140930','河曲县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140931','保德县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140932','偏关县','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('140981','原平市','140900',1,NULL,NULL,NULL,NULL,NULL,NULL),('141000','临汾市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141002','尧都区','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141021','曲沃县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141022','翼城县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141023','襄汾县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141024','洪洞县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141025','古县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141026','安泽县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141027','浮山县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141028','吉县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141029','乡宁县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141030','大宁县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141031','隰县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141032','永和县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141033','蒲县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141034','汾西县','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141081','侯马市','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141082','霍州市','141000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141100','吕梁市','140000',1,NULL,NULL,NULL,NULL,NULL,NULL),('141102','离石区','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141121','文水县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141122','交城县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141123','兴县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141124','临县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141125','柳林县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141126','石楼县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141127','岚县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141128','方山县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141129','中阳县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141130','交口县','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141181','孝义市','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('141182','汾阳市','141100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150000','内蒙古自治区',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('150100','呼和浩特市','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('150102','新城区','150100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150103','回民区','150100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150104','玉泉区','150100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150105','赛罕区','150100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150121','土默特左旗','150100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150122','托克托县','150100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150123','和林格尔县','150100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150124','清水河县','150100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150125','武川县','150100',1,NULL,NULL,NULL,NULL,NULL,NULL),('150200','包头市','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('150202','东河区','150200',1,NULL,NULL,NULL,NULL,NULL,NULL),('150203','昆都仑区','150200',1,NULL,NULL,NULL,NULL,NULL,NULL),('150204','青山区','150200',1,NULL,NULL,NULL,NULL,NULL,NULL),('150205','石拐区','150200',1,NULL,NULL,NULL,NULL,NULL,NULL),('150206','白云鄂博矿区','150200',1,NULL,NULL,NULL,NULL,NULL,NULL),('150207','九原区','150200',1,NULL,NULL,NULL,NULL,NULL,NULL),('150221','土默特右旗','150200',1,NULL,NULL,NULL,NULL,NULL,NULL),('150222','固阳县','150200',1,NULL,NULL,NULL,NULL,NULL,NULL),('150223','达尔罕茂明安联合旗','150200',1,NULL,NULL,NULL,NULL,NULL,NULL),('150300','乌海市','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('150302','海勃湾区','150300',1,NULL,NULL,NULL,NULL,NULL,NULL),('150303','海南区','150300',1,NULL,NULL,NULL,NULL,NULL,NULL),('150304','乌达区','150300',1,NULL,NULL,NULL,NULL,NULL,NULL),('150400','赤峰市','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('150402','红山区','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150403','元宝山区','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150404','松山区','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150421','阿鲁科尔沁旗','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150422','巴林左旗','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150423','巴林右旗','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150424','林西县','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150425','克什克腾旗','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150426','翁牛特旗','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150428','喀喇沁旗','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150429','宁城县','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150430','敖汉旗','150400',1,NULL,NULL,NULL,NULL,NULL,NULL),('150500','通辽市','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('150502','科尔沁区','150500',1,NULL,NULL,NULL,NULL,NULL,NULL),('150521','科尔沁左翼中旗','150500',1,NULL,NULL,NULL,NULL,NULL,NULL),('150522','科尔沁左翼后旗','150500',1,NULL,NULL,NULL,NULL,NULL,NULL),('150523','开鲁县','150500',1,NULL,NULL,NULL,NULL,NULL,NULL),('150524','库伦旗','150500',1,NULL,NULL,NULL,NULL,NULL,NULL),('150525','奈曼旗','150500',1,NULL,NULL,NULL,NULL,NULL,NULL),('150526','扎鲁特旗','150500',1,NULL,NULL,NULL,NULL,NULL,NULL),('150581','霍林郭勒市','150500',1,NULL,NULL,NULL,NULL,NULL,NULL),('150600','鄂尔多斯市','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('150602','东胜区','150600',1,NULL,NULL,NULL,NULL,NULL,NULL),('150603','康巴什区','150600',1,NULL,NULL,NULL,NULL,NULL,NULL),('150621','达拉特旗','150600',1,NULL,NULL,NULL,NULL,NULL,NULL),('150622','准格尔旗','150600',1,NULL,NULL,NULL,NULL,NULL,NULL),('150623','鄂托克前旗','150600',1,NULL,NULL,NULL,NULL,NULL,NULL),('150624','鄂托克旗','150600',1,NULL,NULL,NULL,NULL,NULL,NULL),('150625','杭锦旗','150600',1,NULL,NULL,NULL,NULL,NULL,NULL),('150626','乌审旗','150600',1,NULL,NULL,NULL,NULL,NULL,NULL),('150627','伊金霍洛旗','150600',1,NULL,NULL,NULL,NULL,NULL,NULL),('150700','呼伦贝尔市','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('150702','海拉尔区','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150703','扎赉诺尔区','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150721','阿荣旗','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150722','莫力达瓦达斡尔族自治旗','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150723','鄂伦春自治旗','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150724','鄂温克族自治旗','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150725','陈巴尔虎旗','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150726','新巴尔虎左旗','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150727','新巴尔虎右旗','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150781','满洲里市','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150782','牙克石市','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150783','扎兰屯市','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150784','额尔古纳市','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150785','根河市','150700',1,NULL,NULL,NULL,NULL,NULL,NULL),('150800','巴彦淖尔市','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('150802','临河区','150800',1,NULL,NULL,NULL,NULL,NULL,NULL),('150821','五原县','150800',1,NULL,NULL,NULL,NULL,NULL,NULL),('150822','磴口县','150800',1,NULL,NULL,NULL,NULL,NULL,NULL),('150823','乌拉特前旗','150800',1,NULL,NULL,NULL,NULL,NULL,NULL),('150824','乌拉特中旗','150800',1,NULL,NULL,NULL,NULL,NULL,NULL),('150825','乌拉特后旗','150800',1,NULL,NULL,NULL,NULL,NULL,NULL),('150826','杭锦后旗','150800',1,NULL,NULL,NULL,NULL,NULL,NULL),('150900','乌兰察布市','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('150902','集宁区','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150921','卓资县','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150922','化德县','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150923','商都县','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150924','兴和县','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150925','凉城县','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150926','察哈尔右翼前旗','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150927','察哈尔右翼中旗','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150928','察哈尔右翼后旗','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150929','四子王旗','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('150981','丰镇市','150900',1,NULL,NULL,NULL,NULL,NULL,NULL),('152200','兴安盟','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('152201','乌兰浩特市','152200',1,NULL,NULL,NULL,NULL,NULL,NULL),('152202','阿尔山市','152200',1,NULL,NULL,NULL,NULL,NULL,NULL),('152221','科尔沁右翼前旗','152200',1,NULL,NULL,NULL,NULL,NULL,NULL),('152222','科尔沁右翼中旗','152200',1,NULL,NULL,NULL,NULL,NULL,NULL),('152223','扎赉特旗','152200',1,NULL,NULL,NULL,NULL,NULL,NULL),('152224','突泉县','152200',1,NULL,NULL,NULL,NULL,NULL,NULL),('152500','锡林郭勒盟','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('152501','二连浩特市','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152502','锡林浩特市','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152522','阿巴嘎旗','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152523','苏尼特左旗','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152524','苏尼特右旗','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152525','东乌珠穆沁旗','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152526','西乌珠穆沁旗','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152527','太仆寺旗','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152528','镶黄旗','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152529','正镶白旗','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152530','正蓝旗','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152531','多伦县','152500',1,NULL,NULL,NULL,NULL,NULL,NULL),('152900','阿拉善盟','150000',1,NULL,NULL,NULL,NULL,NULL,NULL),('152921','阿拉善左旗','152900',1,NULL,NULL,NULL,NULL,NULL,NULL),('152922','阿拉善右旗','152900',1,NULL,NULL,NULL,NULL,NULL,NULL),('152923','额济纳旗','152900',1,NULL,NULL,NULL,NULL,NULL,NULL),('210000','辽宁省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('210100','沈阳市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('210102','和平区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210103','沈河区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210104','大东区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210105','皇姑区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210106','铁西区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210111','苏家屯区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210112','浑南区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210113','沈北新区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210114','于洪区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210115','辽中区','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210123','康平县','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210124','法库县','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210181','新民市','210100',1,NULL,NULL,NULL,NULL,NULL,NULL),('210200','大连市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('210202','中山区','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210203','西岗区','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210204','沙河口区','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210211','甘井子区','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210212','旅顺口区','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210213','金州区','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210214','普兰店区','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210224','长海县','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210281','瓦房店市','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210283','庄河市','210200',1,NULL,NULL,NULL,NULL,NULL,NULL),('210300','鞍山市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('210302','铁东区','210300',1,NULL,NULL,NULL,NULL,NULL,NULL),('210303','铁西区','210300',1,NULL,NULL,NULL,NULL,NULL,NULL),('210304','立山区','210300',1,NULL,NULL,NULL,NULL,NULL,NULL),('210311','千山区','210300',1,NULL,NULL,NULL,NULL,NULL,NULL),('210321','台安县','210300',1,NULL,NULL,NULL,NULL,NULL,NULL),('210323','岫岩满族自治县','210300',1,NULL,NULL,NULL,NULL,NULL,NULL),('210381','海城市','210300',1,NULL,NULL,NULL,NULL,NULL,NULL),('210400','抚顺市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('210402','新抚区','210400',1,NULL,NULL,NULL,NULL,NULL,NULL),('210403','东洲区','210400',1,NULL,NULL,NULL,NULL,NULL,NULL),('210404','望花区','210400',1,NULL,NULL,NULL,NULL,NULL,NULL),('210411','顺城区','210400',1,NULL,NULL,NULL,NULL,NULL,NULL),('210421','抚顺县','210400',1,NULL,NULL,NULL,NULL,NULL,NULL),('210422','新宾满族自治县','210400',1,NULL,NULL,NULL,NULL,NULL,NULL),('210423','清原满族自治县','210400',1,NULL,NULL,NULL,NULL,NULL,NULL),('210500','本溪市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('210502','平山区','210500',1,NULL,NULL,NULL,NULL,NULL,NULL),('210503','溪湖区','210500',1,NULL,NULL,NULL,NULL,NULL,NULL),('210504','明山区','210500',1,NULL,NULL,NULL,NULL,NULL,NULL),('210505','南芬区','210500',1,NULL,NULL,NULL,NULL,NULL,NULL),('210521','本溪满族自治县','210500',1,NULL,NULL,NULL,NULL,NULL,NULL),('210522','桓仁满族自治县','210500',1,NULL,NULL,NULL,NULL,NULL,NULL),('210600','丹东市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('210602','元宝区','210600',1,NULL,NULL,NULL,NULL,NULL,NULL),('210603','振兴区','210600',1,NULL,NULL,NULL,NULL,NULL,NULL),('210604','振安区','210600',1,NULL,NULL,NULL,NULL,NULL,NULL),('210624','宽甸满族自治县','210600',1,NULL,NULL,NULL,NULL,NULL,NULL),('210681','东港市','210600',1,NULL,NULL,NULL,NULL,NULL,NULL),('210682','凤城市','210600',1,NULL,NULL,NULL,NULL,NULL,NULL),('210700','锦州市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('210702','古塔区','210700',1,NULL,NULL,NULL,NULL,NULL,NULL),('210703','凌河区','210700',1,NULL,NULL,NULL,NULL,NULL,NULL),('210711','太和区','210700',1,NULL,NULL,NULL,NULL,NULL,NULL),('210726','黑山县','210700',1,NULL,NULL,NULL,NULL,NULL,NULL),('210727','义县','210700',1,NULL,NULL,NULL,NULL,NULL,NULL),('210781','凌海市','210700',1,NULL,NULL,NULL,NULL,NULL,NULL),('210782','北镇市','210700',1,NULL,NULL,NULL,NULL,NULL,NULL),('210800','营口市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('210802','站前区','210800',1,NULL,NULL,NULL,NULL,NULL,NULL),('210803','西市区','210800',1,NULL,NULL,NULL,NULL,NULL,NULL),('210804','鲅鱼圈区','210800',1,NULL,NULL,NULL,NULL,NULL,NULL),('210811','老边区','210800',1,NULL,NULL,NULL,NULL,NULL,NULL),('210881','盖州市','210800',1,NULL,NULL,NULL,NULL,NULL,NULL),('210882','大石桥市','210800',1,NULL,NULL,NULL,NULL,NULL,NULL),('210900','阜新市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('210902','海州区','210900',1,NULL,NULL,NULL,NULL,NULL,NULL),('210903','新邱区','210900',1,NULL,NULL,NULL,NULL,NULL,NULL),('210904','太平区','210900',1,NULL,NULL,NULL,NULL,NULL,NULL),('210905','清河门区','210900',1,NULL,NULL,NULL,NULL,NULL,NULL),('210911','细河区','210900',1,NULL,NULL,NULL,NULL,NULL,NULL),('210921','阜新蒙古族自治县','210900',1,NULL,NULL,NULL,NULL,NULL,NULL),('210922','彰武县','210900',1,NULL,NULL,NULL,NULL,NULL,NULL),('211000','辽阳市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211002','白塔区','211000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211003','文圣区','211000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211004','宏伟区','211000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211005','弓长岭区','211000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211011','太子河区','211000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211021','辽阳县','211000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211081','灯塔市','211000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211100','盘锦市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211102','双台子区','211100',1,NULL,NULL,NULL,NULL,NULL,NULL),('211103','兴隆台区','211100',1,NULL,NULL,NULL,NULL,NULL,NULL),('211104','大洼区','211100',1,NULL,NULL,NULL,NULL,NULL,NULL),('211122','盘山县','211100',1,NULL,NULL,NULL,NULL,NULL,NULL),('211200','铁岭市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211202','银州区','211200',1,NULL,NULL,NULL,NULL,NULL,NULL),('211204','清河区','211200',1,NULL,NULL,NULL,NULL,NULL,NULL),('211221','铁岭县','211200',1,NULL,NULL,NULL,NULL,NULL,NULL),('211223','西丰县','211200',1,NULL,NULL,NULL,NULL,NULL,NULL),('211224','昌图县','211200',1,NULL,NULL,NULL,NULL,NULL,NULL),('211281','调兵山市','211200',1,NULL,NULL,NULL,NULL,NULL,NULL),('211282','开原市','211200',1,NULL,NULL,NULL,NULL,NULL,NULL),('211300','朝阳市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211302','双塔区','211300',1,NULL,NULL,NULL,NULL,NULL,NULL),('211303','龙城区','211300',1,NULL,NULL,NULL,NULL,NULL,NULL),('211321','朝阳县','211300',1,NULL,NULL,NULL,NULL,NULL,NULL),('211322','建平县','211300',1,NULL,NULL,NULL,NULL,NULL,NULL),('211324','喀喇沁左翼蒙古族自治县','211300',1,NULL,NULL,NULL,NULL,NULL,NULL),('211381','北票市','211300',1,NULL,NULL,NULL,NULL,NULL,NULL),('211382','凌源市','211300',1,NULL,NULL,NULL,NULL,NULL,NULL),('211400','葫芦岛市','210000',1,NULL,NULL,NULL,NULL,NULL,NULL),('211402','连山区','211400',1,NULL,NULL,NULL,NULL,NULL,NULL),('211403','龙港区','211400',1,NULL,NULL,NULL,NULL,NULL,NULL),('211404','南票区','211400',1,NULL,NULL,NULL,NULL,NULL,NULL),('211421','绥中县','211400',1,NULL,NULL,NULL,NULL,NULL,NULL),('211422','建昌县','211400',1,NULL,NULL,NULL,NULL,NULL,NULL),('211481','兴城市','211400',1,NULL,NULL,NULL,NULL,NULL,NULL),('220000','吉林省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('220100','长春市','220000',1,NULL,NULL,NULL,NULL,NULL,NULL),('220102','南关区','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220103','宽城区','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220104','朝阳区','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220105','二道区','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220106','绿园区','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220112','双阳区','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220113','九台区','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220122','农安县','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220182','榆树市','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220183','德惠市','220100',1,NULL,NULL,NULL,NULL,NULL,NULL),('220200','吉林市','220000',1,NULL,NULL,NULL,NULL,NULL,NULL),('220202','昌邑区','220200',1,NULL,NULL,NULL,NULL,NULL,NULL),('220203','龙潭区','220200',1,NULL,NULL,NULL,NULL,NULL,NULL),('220204','船营区','220200',1,NULL,NULL,NULL,NULL,NULL,NULL),('220211','丰满区','220200',1,NULL,NULL,NULL,NULL,NULL,NULL),('220221','永吉县','220200',1,NULL,NULL,NULL,NULL,NULL,NULL),('220281','蛟河市','220200',1,NULL,NULL,NULL,NULL,NULL,NULL),('220282','桦甸市','220200',1,NULL,NULL,NULL,NULL,NULL,NULL),('220283','舒兰市','220200',1,NULL,NULL,NULL,NULL,NULL,NULL),('220284','磐石市','220200',1,NULL,NULL,NULL,NULL,NULL,NULL),('220300','四平市','220000',1,NULL,NULL,NULL,NULL,NULL,NULL),('220302','铁西区','220300',1,NULL,NULL,NULL,NULL,NULL,NULL),('220303','铁东区','220300',1,NULL,NULL,NULL,NULL,NULL,NULL),('220322','梨树县','220300',1,NULL,NULL,NULL,NULL,NULL,NULL),('220323','伊通满族自治县','220300',1,NULL,NULL,NULL,NULL,NULL,NULL),('220381','公主岭市','220300',1,NULL,NULL,NULL,NULL,NULL,NULL),('220382','双辽市','220300',1,NULL,NULL,NULL,NULL,NULL,NULL),('220400','辽源市','220000',1,NULL,NULL,NULL,NULL,NULL,NULL),('220402','龙山区','220400',1,NULL,NULL,NULL,NULL,NULL,NULL),('220403','西安区','220400',1,NULL,NULL,NULL,NULL,NULL,NULL),('220421','东丰县','220400',1,NULL,NULL,NULL,NULL,NULL,NULL),('220422','东辽县','220400',1,NULL,NULL,NULL,NULL,NULL,NULL),('220500','通化市','220000',1,NULL,NULL,NULL,NULL,NULL,NULL),('220502','东昌区','220500',1,NULL,NULL,NULL,NULL,NULL,NULL),('220503','二道江区','220500',1,NULL,NULL,NULL,NULL,NULL,NULL),('220521','通化县','220500',1,NULL,NULL,NULL,NULL,NULL,NULL),('220523','辉南县','220500',1,NULL,NULL,NULL,NULL,NULL,NULL),('220524','柳河县','220500',1,NULL,NULL,NULL,NULL,NULL,NULL),('220581','梅河口市','220500',1,NULL,NULL,NULL,NULL,NULL,NULL),('220582','集安市','220500',1,NULL,NULL,NULL,NULL,NULL,NULL),('220600','白山市','220000',1,NULL,NULL,NULL,NULL,NULL,NULL),('220602','浑江区','220600',1,NULL,NULL,NULL,NULL,NULL,NULL),('220605','江源区','220600',1,NULL,NULL,NULL,NULL,NULL,NULL),('220621','抚松县','220600',1,NULL,NULL,NULL,NULL,NULL,NULL),('220622','靖宇县','220600',1,NULL,NULL,NULL,NULL,NULL,NULL),('220623','长白朝鲜族自治县','220600',1,NULL,NULL,NULL,NULL,NULL,NULL),('220681','临江市','220600',1,NULL,NULL,NULL,NULL,NULL,NULL),('220700','松原市','220000',1,NULL,NULL,NULL,NULL,NULL,NULL),('220702','宁江区','220700',1,NULL,NULL,NULL,NULL,NULL,NULL),('220721','前郭尔罗斯蒙古族自治县','220700',1,NULL,NULL,NULL,NULL,NULL,NULL),('220722','长岭县','220700',1,NULL,NULL,NULL,NULL,NULL,NULL),('220723','乾安县','220700',1,NULL,NULL,NULL,NULL,NULL,NULL),('220781','扶余市','220700',1,NULL,NULL,NULL,NULL,NULL,NULL),('220800','白城市','220000',1,NULL,NULL,NULL,NULL,NULL,NULL),('220802','洮北区','220800',1,NULL,NULL,NULL,NULL,NULL,NULL),('220821','镇赉县','220800',1,NULL,NULL,NULL,NULL,NULL,NULL),('220822','通榆县','220800',1,NULL,NULL,NULL,NULL,NULL,NULL),('220881','洮南市','220800',1,NULL,NULL,NULL,NULL,NULL,NULL),('220882','大安市','220800',1,NULL,NULL,NULL,NULL,NULL,NULL),('222400','延边朝鲜族自治州','220000',1,NULL,NULL,NULL,NULL,NULL,NULL),('222401','延吉市','222400',1,NULL,NULL,NULL,NULL,NULL,NULL),('222402','图们市','222400',1,NULL,NULL,NULL,NULL,NULL,NULL),('222403','敦化市','222400',1,NULL,NULL,NULL,NULL,NULL,NULL),('222404','珲春市','222400',1,NULL,NULL,NULL,NULL,NULL,NULL),('222405','龙井市','222400',1,NULL,NULL,NULL,NULL,NULL,NULL),('222406','和龙市','222400',1,NULL,NULL,NULL,NULL,NULL,NULL),('222424','汪清县','222400',1,NULL,NULL,NULL,NULL,NULL,NULL),('222426','安图县','222400',1,NULL,NULL,NULL,NULL,NULL,NULL),('230000','黑龙江省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('230100','哈尔滨市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('230102','道里区','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230103','南岗区','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230104','道外区','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230108','平房区','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230109','松北区','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230110','香坊区','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230111','呼兰区','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230112','阿城区','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230113','双城区','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230123','依兰县','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230124','方正县','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230125','宾县','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230126','巴彦县','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230127','木兰县','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230128','通河县','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230129','延寿县','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230183','尚志市','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230184','五常市','230100',1,NULL,NULL,NULL,NULL,NULL,NULL),('230200','齐齐哈尔市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('230202','龙沙区','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230203','建华区','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230204','铁锋区','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230205','昂昂溪区','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230206','富拉尔基区','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230207','碾子山区','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230208','梅里斯达斡尔族区','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230221','龙江县','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230223','依安县','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230224','泰来县','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230225','甘南县','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230227','富裕县','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230229','克山县','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230230','克东县','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230231','拜泉县','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230281','讷河市','230200',1,NULL,NULL,NULL,NULL,NULL,NULL),('230300','鸡西市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('230302','鸡冠区','230300',1,NULL,NULL,NULL,NULL,NULL,NULL),('230303','恒山区','230300',1,NULL,NULL,NULL,NULL,NULL,NULL),('230304','滴道区','230300',1,NULL,NULL,NULL,NULL,NULL,NULL),('230305','梨树区','230300',1,NULL,NULL,NULL,NULL,NULL,NULL),('230306','城子河区','230300',1,NULL,NULL,NULL,NULL,NULL,NULL),('230307','麻山区','230300',1,NULL,NULL,NULL,NULL,NULL,NULL),('230321','鸡东县','230300',1,NULL,NULL,NULL,NULL,NULL,NULL),('230381','虎林市','230300',1,NULL,NULL,NULL,NULL,NULL,NULL),('230382','密山市','230300',1,NULL,NULL,NULL,NULL,NULL,NULL),('230400','鹤岗市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('230402','向阳区','230400',1,NULL,NULL,NULL,NULL,NULL,NULL),('230403','工农区','230400',1,NULL,NULL,NULL,NULL,NULL,NULL),('230404','南山区','230400',1,NULL,NULL,NULL,NULL,NULL,NULL),('230405','兴安区','230400',1,NULL,NULL,NULL,NULL,NULL,NULL),('230406','东山区','230400',1,NULL,NULL,NULL,NULL,NULL,NULL),('230407','兴山区','230400',1,NULL,NULL,NULL,NULL,NULL,NULL),('230421','萝北县','230400',1,NULL,NULL,NULL,NULL,NULL,NULL),('230422','绥滨县','230400',1,NULL,NULL,NULL,NULL,NULL,NULL),('230500','双鸭山市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('230502','尖山区','230500',1,NULL,NULL,NULL,NULL,NULL,NULL),('230503','岭东区','230500',1,NULL,NULL,NULL,NULL,NULL,NULL),('230505','四方台区','230500',1,NULL,NULL,NULL,NULL,NULL,NULL),('230506','宝山区','230500',1,NULL,NULL,NULL,NULL,NULL,NULL),('230521','集贤县','230500',1,NULL,NULL,NULL,NULL,NULL,NULL),('230522','友谊县','230500',1,NULL,NULL,NULL,NULL,NULL,NULL),('230523','宝清县','230500',1,NULL,NULL,NULL,NULL,NULL,NULL),('230524','饶河县','230500',1,NULL,NULL,NULL,NULL,NULL,NULL),('230600','大庆市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('230602','萨尔图区','230600',1,NULL,NULL,NULL,NULL,NULL,NULL),('230603','龙凤区','230600',1,NULL,NULL,NULL,NULL,NULL,NULL),('230604','让胡路区','230600',1,NULL,NULL,NULL,NULL,NULL,NULL),('230605','红岗区','230600',1,NULL,NULL,NULL,NULL,NULL,NULL),('230606','大同区','230600',1,NULL,NULL,NULL,NULL,NULL,NULL),('230621','肇州县','230600',1,NULL,NULL,NULL,NULL,NULL,NULL),('230622','肇源县','230600',1,NULL,NULL,NULL,NULL,NULL,NULL),('230623','林甸县','230600',1,NULL,NULL,NULL,NULL,NULL,NULL),('230624','杜尔伯特蒙古族自治县','230600',1,NULL,NULL,NULL,NULL,NULL,NULL),('230700','伊春市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('230702','伊春区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230703','南岔区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230704','友好区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230705','西林区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230706','翠峦区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230707','新青区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230708','美溪区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230709','金山屯区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230710','五营区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230711','乌马河区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230712','汤旺河区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230713','带岭区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230714','乌伊岭区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230715','红星区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230716','上甘岭区','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230722','嘉荫县','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230781','铁力市','230700',1,NULL,NULL,NULL,NULL,NULL,NULL),('230800','佳木斯市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('230803','向阳区','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230804','前进区','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230805','东风区','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230811','郊区','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230822','桦南县','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230826','桦川县','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230828','汤原县','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230881','同江市','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230882','富锦市','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230883','抚远市','230800',1,NULL,NULL,NULL,NULL,NULL,NULL),('230900','七台河市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('230902','新兴区','230900',1,NULL,NULL,NULL,NULL,NULL,NULL),('230903','桃山区','230900',1,NULL,NULL,NULL,NULL,NULL,NULL),('230904','茄子河区','230900',1,NULL,NULL,NULL,NULL,NULL,NULL),('230921','勃利县','230900',1,NULL,NULL,NULL,NULL,NULL,NULL),('231000','牡丹江市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231002','东安区','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231003','阳明区','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231004','爱民区','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231005','西安区','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231025','林口县','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231081','绥芬河市','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231083','海林市','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231084','宁安市','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231085','穆棱市','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231086','东宁市','231000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231100','黑河市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231102','爱辉区','231100',1,NULL,NULL,NULL,NULL,NULL,NULL),('231121','嫩江县','231100',1,NULL,NULL,NULL,NULL,NULL,NULL),('231123','逊克县','231100',1,NULL,NULL,NULL,NULL,NULL,NULL),('231124','孙吴县','231100',1,NULL,NULL,NULL,NULL,NULL,NULL),('231181','北安市','231100',1,NULL,NULL,NULL,NULL,NULL,NULL),('231182','五大连池市','231100',1,NULL,NULL,NULL,NULL,NULL,NULL),('231200','绥化市','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('231202','北林区','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('231221','望奎县','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('231222','兰西县','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('231223','青冈县','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('231224','庆安县','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('231225','明水县','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('231226','绥棱县','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('231281','安达市','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('231282','肇东市','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('231283','海伦市','231200',1,NULL,NULL,NULL,NULL,NULL,NULL),('232700','大兴安岭地区','230000',1,NULL,NULL,NULL,NULL,NULL,NULL),('232721','呼玛县','232700',1,NULL,NULL,NULL,NULL,NULL,NULL),('232722','塔河县','232700',1,NULL,NULL,NULL,NULL,NULL,NULL),('232723','漠河县','232700',1,NULL,NULL,NULL,NULL,NULL,NULL),('310000','上海市',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('310100','上海市','310000',1,NULL,NULL,NULL,NULL,NULL,NULL),('310101','黄浦区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310104','徐汇区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310105','长宁区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310106','静安区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310107','普陀区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310109','虹口区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310110','杨浦区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310112','闵行区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310113','宝山区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310114','嘉定区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310115','浦东新区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310116','金山区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310117','松江区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310118','青浦区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310120','奉贤区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('310151','崇明区','310100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320000','江苏省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('320100','南京市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('320102','玄武区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320104','秦淮区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320105','建邺区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320106','鼓楼区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320111','浦口区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320113','栖霞区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320114','雨花台区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320115','江宁区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320116','六合区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320117','溧水区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320118','高淳区','320100',1,NULL,NULL,NULL,NULL,NULL,NULL),('320200','无锡市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('320205','锡山区','320200',1,NULL,NULL,NULL,NULL,NULL,NULL),('320206','惠山区','320200',1,NULL,NULL,NULL,NULL,NULL,NULL),('320211','滨湖区','320200',1,NULL,NULL,NULL,NULL,NULL,NULL),('320213','梁溪区','320200',1,NULL,NULL,NULL,NULL,NULL,NULL),('320214','新吴区','320200',1,NULL,NULL,NULL,NULL,NULL,NULL),('320281','江阴市','320200',1,NULL,NULL,NULL,NULL,NULL,NULL),('320282','宜兴市','320200',1,NULL,NULL,NULL,NULL,NULL,NULL),('320300','徐州市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('320302','鼓楼区','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320303','云龙区','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320305','贾汪区','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320311','泉山区','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320312','铜山区','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320321','丰县','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320322','沛县','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320324','睢宁县','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320381','新沂市','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320382','邳州市','320300',1,NULL,NULL,NULL,NULL,NULL,NULL),('320400','常州市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('320402','天宁区','320400',1,NULL,NULL,NULL,NULL,NULL,NULL),('320404','钟楼区','320400',1,NULL,NULL,NULL,NULL,NULL,NULL),('320411','新北区','320400',1,NULL,NULL,NULL,NULL,NULL,NULL),('320412','武进区','320400',1,NULL,NULL,NULL,NULL,NULL,NULL),('320413','金坛区','320400',1,NULL,NULL,NULL,NULL,NULL,NULL),('320481','溧阳市','320400',1,NULL,NULL,NULL,NULL,NULL,NULL),('320500','苏州市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('320505','虎丘区','320500',1,NULL,NULL,NULL,NULL,NULL,NULL),('320506','吴中区','320500',1,NULL,NULL,NULL,NULL,NULL,NULL),('320507','相城区','320500',1,NULL,NULL,NULL,NULL,NULL,NULL),('320508','姑苏区','320500',1,NULL,NULL,NULL,NULL,NULL,NULL),('320509','吴江区','320500',1,NULL,NULL,NULL,NULL,NULL,NULL),('320581','常熟市','320500',1,NULL,NULL,NULL,NULL,NULL,NULL),('320582','张家港市','320500',1,NULL,NULL,NULL,NULL,NULL,NULL),('320583','昆山市','320500',1,NULL,NULL,NULL,NULL,NULL,NULL),('320585','太仓市','320500',1,NULL,NULL,NULL,NULL,NULL,NULL),('320600','南通市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('320602','崇川区','320600',1,NULL,NULL,NULL,NULL,NULL,NULL),('320611','港闸区','320600',1,NULL,NULL,NULL,NULL,NULL,NULL),('320612','通州区','320600',1,NULL,NULL,NULL,NULL,NULL,NULL),('320621','海安县','320600',1,NULL,NULL,NULL,NULL,NULL,NULL),('320623','如东县','320600',1,NULL,NULL,NULL,NULL,NULL,NULL),('320681','启东市','320600',1,NULL,NULL,NULL,NULL,NULL,NULL),('320682','如皋市','320600',1,NULL,NULL,NULL,NULL,NULL,NULL),('320684','海门市','320600',1,NULL,NULL,NULL,NULL,NULL,NULL),('320700','连云港市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('320703','连云区','320700',1,NULL,NULL,NULL,NULL,NULL,NULL),('320706','海州区','320700',1,NULL,NULL,NULL,NULL,NULL,NULL),('320707','赣榆区','320700',1,NULL,NULL,NULL,NULL,NULL,NULL),('320722','东海县','320700',1,NULL,NULL,NULL,NULL,NULL,NULL),('320723','灌云县','320700',1,NULL,NULL,NULL,NULL,NULL,NULL),('320724','灌南县','320700',1,NULL,NULL,NULL,NULL,NULL,NULL),('320800','淮安市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('320803','淮安区','320800',1,NULL,NULL,NULL,NULL,NULL,NULL),('320804','淮阴区','320800',1,NULL,NULL,NULL,NULL,NULL,NULL),('320812','清江浦区','320800',1,NULL,NULL,NULL,NULL,NULL,NULL),('320813','洪泽区','320800',1,NULL,NULL,NULL,NULL,NULL,NULL),('320826','涟水县','320800',1,NULL,NULL,NULL,NULL,NULL,NULL),('320830','盱眙县','320800',1,NULL,NULL,NULL,NULL,NULL,NULL),('320831','金湖县','320800',1,NULL,NULL,NULL,NULL,NULL,NULL),('320900','盐城市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('320902','亭湖区','320900',1,NULL,NULL,NULL,NULL,NULL,NULL),('320903','盐都区','320900',1,NULL,NULL,NULL,NULL,NULL,NULL),('320904','大丰区','320900',1,NULL,NULL,NULL,NULL,NULL,NULL),('320921','响水县','320900',1,NULL,NULL,NULL,NULL,NULL,NULL),('320922','滨海县','320900',1,NULL,NULL,NULL,NULL,NULL,NULL),('320923','阜宁县','320900',1,NULL,NULL,NULL,NULL,NULL,NULL),('320924','射阳县','320900',1,NULL,NULL,NULL,NULL,NULL,NULL),('320925','建湖县','320900',1,NULL,NULL,NULL,NULL,NULL,NULL),('320981','东台市','320900',1,NULL,NULL,NULL,NULL,NULL,NULL),('321000','扬州市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321002','广陵区','321000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321003','邗江区','321000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321012','江都区','321000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321023','宝应县','321000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321081','仪征市','321000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321084','高邮市','321000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321100','镇江市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321102','京口区','321100',1,NULL,NULL,NULL,NULL,NULL,NULL),('321111','润州区','321100',1,NULL,NULL,NULL,NULL,NULL,NULL),('321112','丹徒区','321100',1,NULL,NULL,NULL,NULL,NULL,NULL),('321181','丹阳市','321100',1,NULL,NULL,NULL,NULL,NULL,NULL),('321182','扬中市','321100',1,NULL,NULL,NULL,NULL,NULL,NULL),('321183','句容市','321100',1,NULL,NULL,NULL,NULL,NULL,NULL),('321200','泰州市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321202','海陵区','321200',1,NULL,NULL,NULL,NULL,NULL,NULL),('321203','高港区','321200',1,NULL,NULL,NULL,NULL,NULL,NULL),('321204','姜堰区','321200',1,NULL,NULL,NULL,NULL,NULL,NULL),('321281','兴化市','321200',1,NULL,NULL,NULL,NULL,NULL,NULL),('321282','靖江市','321200',1,NULL,NULL,NULL,NULL,NULL,NULL),('321283','泰兴市','321200',1,NULL,NULL,NULL,NULL,NULL,NULL),('321300','宿迁市','320000',1,NULL,NULL,NULL,NULL,NULL,NULL),('321302','宿城区','321300',1,NULL,NULL,NULL,NULL,NULL,NULL),('321311','宿豫区','321300',1,NULL,NULL,NULL,NULL,NULL,NULL),('321322','沭阳县','321300',1,NULL,NULL,NULL,NULL,NULL,NULL),('321323','泗阳县','321300',1,NULL,NULL,NULL,NULL,NULL,NULL),('321324','泗洪县','321300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330000','浙江省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('330100','杭州市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('330102','上城区','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330103','下城区','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330104','江干区','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330105','拱墅区','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330106','西湖区','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330108','滨江区','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330109','萧山区','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330110','余杭区','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330111','富阳区','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330122','桐庐县','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330127','淳安县','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330182','建德市','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330185','临安市','330100',1,NULL,NULL,NULL,NULL,NULL,NULL),('330200','宁波市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('330203','海曙区','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330204','江东区','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330205','江北区','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330206','北仑区','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330211','镇海区','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330212','鄞州区','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330225','象山县','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330226','宁海县','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330281','余姚市','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330282','慈溪市','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330283','奉化市','330200',1,NULL,NULL,NULL,NULL,NULL,NULL),('330300','温州市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('330302','鹿城区','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330303','龙湾区','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330304','瓯海区','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330305','洞头区','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330324','永嘉县','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330326','平阳县','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330327','苍南县','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330328','文成县','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330329','泰顺县','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330381','瑞安市','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330382','乐清市','330300',1,NULL,NULL,NULL,NULL,NULL,NULL),('330400','嘉兴市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('330402','南湖区','330400',1,NULL,NULL,NULL,NULL,NULL,NULL),('330411','秀洲区','330400',1,NULL,NULL,NULL,NULL,NULL,NULL),('330421','嘉善县','330400',1,NULL,NULL,NULL,NULL,NULL,NULL),('330424','海盐县','330400',1,NULL,NULL,NULL,NULL,NULL,NULL),('330481','海宁市','330400',1,NULL,NULL,NULL,NULL,NULL,NULL),('330482','平湖市','330400',1,NULL,NULL,NULL,NULL,NULL,NULL),('330483','桐乡市','330400',1,NULL,NULL,NULL,NULL,NULL,NULL),('330500','湖州市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('330502','吴兴区','330500',1,NULL,NULL,NULL,NULL,NULL,NULL),('330503','南浔区','330500',1,NULL,NULL,NULL,NULL,NULL,NULL),('330521','德清县','330500',1,NULL,NULL,NULL,NULL,NULL,NULL),('330522','长兴县','330500',1,NULL,NULL,NULL,NULL,NULL,NULL),('330523','安吉县','330500',1,NULL,NULL,NULL,NULL,NULL,NULL),('330600','绍兴市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('330602','越城区','330600',1,NULL,NULL,NULL,NULL,NULL,NULL),('330603','柯桥区','330600',1,NULL,NULL,NULL,NULL,NULL,NULL),('330604','上虞区','330600',1,NULL,NULL,NULL,NULL,NULL,NULL),('330624','新昌县','330600',1,NULL,NULL,NULL,NULL,NULL,NULL),('330681','诸暨市','330600',1,NULL,NULL,NULL,NULL,NULL,NULL),('330683','嵊州市','330600',1,NULL,NULL,NULL,NULL,NULL,NULL),('330700','金华市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('330702','婺城区','330700',1,NULL,NULL,NULL,NULL,NULL,NULL),('330703','金东区','330700',1,NULL,NULL,NULL,NULL,NULL,NULL),('330723','武义县','330700',1,NULL,NULL,NULL,NULL,NULL,NULL),('330726','浦江县','330700',1,NULL,NULL,NULL,NULL,NULL,NULL),('330727','磐安县','330700',1,NULL,NULL,NULL,NULL,NULL,NULL),('330781','兰溪市','330700',1,NULL,NULL,NULL,NULL,NULL,NULL),('330782','义乌市','330700',1,NULL,NULL,NULL,NULL,NULL,NULL),('330783','东阳市','330700',1,NULL,NULL,NULL,NULL,NULL,NULL),('330784','永康市','330700',1,NULL,NULL,NULL,NULL,NULL,NULL),('330800','衢州市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('330802','柯城区','330800',1,NULL,NULL,NULL,NULL,NULL,NULL),('330803','衢江区','330800',1,NULL,NULL,NULL,NULL,NULL,NULL),('330822','常山县','330800',1,NULL,NULL,NULL,NULL,NULL,NULL),('330824','开化县','330800',1,NULL,NULL,NULL,NULL,NULL,NULL),('330825','龙游县','330800',1,NULL,NULL,NULL,NULL,NULL,NULL),('330881','江山市','330800',1,NULL,NULL,NULL,NULL,NULL,NULL),('330900','舟山市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('330902','定海区','330900',1,NULL,NULL,NULL,NULL,NULL,NULL),('330903','普陀区','330900',1,NULL,NULL,NULL,NULL,NULL,NULL),('330921','岱山县','330900',1,NULL,NULL,NULL,NULL,NULL,NULL),('330922','嵊泗县','330900',1,NULL,NULL,NULL,NULL,NULL,NULL),('331000','台州市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331002','椒江区','331000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331003','黄岩区','331000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331004','路桥区','331000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331021','玉环县','331000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331022','三门县','331000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331023','天台县','331000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331024','仙居县','331000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331081','温岭市','331000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331082','临海市','331000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331100','丽水市','330000',1,NULL,NULL,NULL,NULL,NULL,NULL),('331102','莲都区','331100',1,NULL,NULL,NULL,NULL,NULL,NULL),('331121','青田县','331100',1,NULL,NULL,NULL,NULL,NULL,NULL),('331122','缙云县','331100',1,NULL,NULL,NULL,NULL,NULL,NULL),('331123','遂昌县','331100',1,NULL,NULL,NULL,NULL,NULL,NULL),('331124','松阳县','331100',1,NULL,NULL,NULL,NULL,NULL,NULL),('331125','云和县','331100',1,NULL,NULL,NULL,NULL,NULL,NULL),('331126','庆元县','331100',1,NULL,NULL,NULL,NULL,NULL,NULL),('331127','景宁畲族自治县','331100',1,NULL,NULL,NULL,NULL,NULL,NULL),('331181','龙泉市','331100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340000','安徽省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('340100','合肥市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('340102','瑶海区','340100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340103','庐阳区','340100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340104','蜀山区','340100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340111','包河区','340100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340121','长丰县','340100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340122','肥东县','340100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340123','肥西县','340100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340124','庐江县','340100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340181','巢湖市','340100',1,NULL,NULL,NULL,NULL,NULL,NULL),('340200','芜湖市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('340202','镜湖区','340200',1,NULL,NULL,NULL,NULL,NULL,NULL),('340203','弋江区','340200',1,NULL,NULL,NULL,NULL,NULL,NULL),('340207','鸠江区','340200',1,NULL,NULL,NULL,NULL,NULL,NULL),('340208','三山区','340200',1,NULL,NULL,NULL,NULL,NULL,NULL),('340221','芜湖县','340200',1,NULL,NULL,NULL,NULL,NULL,NULL),('340222','繁昌县','340200',1,NULL,NULL,NULL,NULL,NULL,NULL),('340223','南陵县','340200',1,NULL,NULL,NULL,NULL,NULL,NULL),('340225','无为县','340200',1,NULL,NULL,NULL,NULL,NULL,NULL),('340300','蚌埠市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('340302','龙子湖区','340300',1,NULL,NULL,NULL,NULL,NULL,NULL),('340303','蚌山区','340300',1,NULL,NULL,NULL,NULL,NULL,NULL),('340304','禹会区','340300',1,NULL,NULL,NULL,NULL,NULL,NULL),('340311','淮上区','340300',1,NULL,NULL,NULL,NULL,NULL,NULL),('340321','怀远县','340300',1,NULL,NULL,NULL,NULL,NULL,NULL),('340322','五河县','340300',1,NULL,NULL,NULL,NULL,NULL,NULL),('340323','固镇县','340300',1,NULL,NULL,NULL,NULL,NULL,NULL),('340400','淮南市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('340402','大通区','340400',1,NULL,NULL,NULL,NULL,NULL,NULL),('340403','田家庵区','340400',1,NULL,NULL,NULL,NULL,NULL,NULL),('340404','谢家集区','340400',1,NULL,NULL,NULL,NULL,NULL,NULL),('340405','八公山区','340400',1,NULL,NULL,NULL,NULL,NULL,NULL),('340406','潘集区','340400',1,NULL,NULL,NULL,NULL,NULL,NULL),('340421','凤台县','340400',1,NULL,NULL,NULL,NULL,NULL,NULL),('340422','寿县','340400',1,NULL,NULL,NULL,NULL,NULL,NULL),('340500','马鞍山市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('340503','花山区','340500',1,NULL,NULL,NULL,NULL,NULL,NULL),('340504','雨山区','340500',1,NULL,NULL,NULL,NULL,NULL,NULL),('340506','博望区','340500',1,NULL,NULL,NULL,NULL,NULL,NULL),('340521','当涂县','340500',1,NULL,NULL,NULL,NULL,NULL,NULL),('340522','含山县','340500',1,NULL,NULL,NULL,NULL,NULL,NULL),('340523','和县','340500',1,NULL,NULL,NULL,NULL,NULL,NULL),('340600','淮北市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('340602','杜集区','340600',1,NULL,NULL,NULL,NULL,NULL,NULL),('340603','相山区','340600',1,NULL,NULL,NULL,NULL,NULL,NULL),('340604','烈山区','340600',1,NULL,NULL,NULL,NULL,NULL,NULL),('340621','濉溪县','340600',1,NULL,NULL,NULL,NULL,NULL,NULL),('340700','铜陵市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('340705','铜官区','340700',1,NULL,NULL,NULL,NULL,NULL,NULL),('340706','义安区','340700',1,NULL,NULL,NULL,NULL,NULL,NULL),('340711','郊区','340700',1,NULL,NULL,NULL,NULL,NULL,NULL),('340722','枞阳县','340700',1,NULL,NULL,NULL,NULL,NULL,NULL),('340800','安庆市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('340802','迎江区','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('340803','大观区','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('340811','宜秀区','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('340822','怀宁县','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('340824','潜山县','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('340825','太湖县','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('340826','宿松县','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('340827','望江县','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('340828','岳西县','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('340881','桐城市','340800',1,NULL,NULL,NULL,NULL,NULL,NULL),('341000','黄山市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341002','屯溪区','341000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341003','黄山区','341000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341004','徽州区','341000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341021','歙县','341000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341022','休宁县','341000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341023','黟县','341000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341024','祁门县','341000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341100','滁州市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341102','琅琊区','341100',1,NULL,NULL,NULL,NULL,NULL,NULL),('341103','南谯区','341100',1,NULL,NULL,NULL,NULL,NULL,NULL),('341122','来安县','341100',1,NULL,NULL,NULL,NULL,NULL,NULL),('341124','全椒县','341100',1,NULL,NULL,NULL,NULL,NULL,NULL),('341125','定远县','341100',1,NULL,NULL,NULL,NULL,NULL,NULL),('341126','凤阳县','341100',1,NULL,NULL,NULL,NULL,NULL,NULL),('341181','天长市','341100',1,NULL,NULL,NULL,NULL,NULL,NULL),('341182','明光市','341100',1,NULL,NULL,NULL,NULL,NULL,NULL),('341200','阜阳市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341202','颍州区','341200',1,NULL,NULL,NULL,NULL,NULL,NULL),('341203','颍东区','341200',1,NULL,NULL,NULL,NULL,NULL,NULL),('341204','颍泉区','341200',1,NULL,NULL,NULL,NULL,NULL,NULL),('341221','临泉县','341200',1,NULL,NULL,NULL,NULL,NULL,NULL),('341222','太和县','341200',1,NULL,NULL,NULL,NULL,NULL,NULL),('341225','阜南县','341200',1,NULL,NULL,NULL,NULL,NULL,NULL),('341226','颍上县','341200',1,NULL,NULL,NULL,NULL,NULL,NULL),('341282','界首市','341200',1,NULL,NULL,NULL,NULL,NULL,NULL),('341300','宿州市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341302','埇桥区','341300',1,NULL,NULL,NULL,NULL,NULL,NULL),('341321','砀山县','341300',1,NULL,NULL,NULL,NULL,NULL,NULL),('341322','萧县','341300',1,NULL,NULL,NULL,NULL,NULL,NULL),('341323','灵璧县','341300',1,NULL,NULL,NULL,NULL,NULL,NULL),('341324','泗县','341300',1,NULL,NULL,NULL,NULL,NULL,NULL),('341500','六安市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341502','金安区','341500',1,NULL,NULL,NULL,NULL,NULL,NULL),('341503','裕安区','341500',1,NULL,NULL,NULL,NULL,NULL,NULL),('341504','叶集区','341500',1,NULL,NULL,NULL,NULL,NULL,NULL),('341522','霍邱县','341500',1,NULL,NULL,NULL,NULL,NULL,NULL),('341523','舒城县','341500',1,NULL,NULL,NULL,NULL,NULL,NULL),('341524','金寨县','341500',1,NULL,NULL,NULL,NULL,NULL,NULL),('341525','霍山县','341500',1,NULL,NULL,NULL,NULL,NULL,NULL),('341600','亳州市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341602','谯城区','341600',1,NULL,NULL,NULL,NULL,NULL,NULL),('341621','涡阳县','341600',1,NULL,NULL,NULL,NULL,NULL,NULL),('341622','蒙城县','341600',1,NULL,NULL,NULL,NULL,NULL,NULL),('341623','利辛县','341600',1,NULL,NULL,NULL,NULL,NULL,NULL),('341700','池州市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341702','贵池区','341700',1,NULL,NULL,NULL,NULL,NULL,NULL),('341721','东至县','341700',1,NULL,NULL,NULL,NULL,NULL,NULL),('341722','石台县','341700',1,NULL,NULL,NULL,NULL,NULL,NULL),('341723','青阳县','341700',1,NULL,NULL,NULL,NULL,NULL,NULL),('341800','宣城市','340000',1,NULL,NULL,NULL,NULL,NULL,NULL),('341802','宣州区','341800',1,NULL,NULL,NULL,NULL,NULL,NULL),('341821','郎溪县','341800',1,NULL,NULL,NULL,NULL,NULL,NULL),('341822','广德县','341800',1,NULL,NULL,NULL,NULL,NULL,NULL),('341823','泾县','341800',1,NULL,NULL,NULL,NULL,NULL,NULL),('341824','绩溪县','341800',1,NULL,NULL,NULL,NULL,NULL,NULL),('341825','旌德县','341800',1,NULL,NULL,NULL,NULL,NULL,NULL),('341881','宁国市','341800',1,NULL,NULL,NULL,NULL,NULL,NULL),('350000','福建省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('350100','福州市','350000',1,NULL,NULL,NULL,NULL,NULL,NULL),('350102','鼓楼区','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350103','台江区','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350104','仓山区','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350105','马尾区','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350111','晋安区','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350121','闽侯县','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350122','连江县','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350123','罗源县','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350124','闽清县','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350125','永泰县','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350128','平潭县','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350181','福清市','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350182','长乐市','350100',1,NULL,NULL,NULL,NULL,NULL,NULL),('350200','厦门市','350000',1,NULL,NULL,NULL,NULL,NULL,NULL),('350203','思明区','350200',1,NULL,NULL,NULL,NULL,NULL,NULL),('350205','海沧区','350200',1,NULL,NULL,NULL,NULL,NULL,NULL),('350206','湖里区','350200',1,NULL,NULL,NULL,NULL,NULL,NULL),('350211','集美区','350200',1,NULL,NULL,NULL,NULL,NULL,NULL),('350212','同安区','350200',1,NULL,NULL,NULL,NULL,NULL,NULL),('350213','翔安区','350200',1,NULL,NULL,NULL,NULL,NULL,NULL),('350300','莆田市','350000',1,NULL,NULL,NULL,NULL,NULL,NULL),('350302','城厢区','350300',1,NULL,NULL,NULL,NULL,NULL,NULL),('350303','涵江区','350300',1,NULL,NULL,NULL,NULL,NULL,NULL),('350304','荔城区','350300',1,NULL,NULL,NULL,NULL,NULL,NULL),('350305','秀屿区','350300',1,NULL,NULL,NULL,NULL,NULL,NULL),('350322','仙游县','350300',1,NULL,NULL,NULL,NULL,NULL,NULL),('350400','三明市','350000',1,NULL,NULL,NULL,NULL,NULL,NULL),('350402','梅列区','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350403','三元区','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350421','明溪县','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350423','清流县','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350424','宁化县','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350425','大田县','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350426','尤溪县','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350427','沙县','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350428','将乐县','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350429','泰宁县','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350430','建宁县','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350481','永安市','350400',1,NULL,NULL,NULL,NULL,NULL,NULL),('350500','泉州市','350000',1,NULL,NULL,NULL,NULL,NULL,NULL),('350502','鲤城区','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350503','丰泽区','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350504','洛江区','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350505','泉港区','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350521','惠安县','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350524','安溪县','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350525','永春县','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350526','德化县','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350527','金门县','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350581','石狮市','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350582','晋江市','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350583','南安市','350500',1,NULL,NULL,NULL,NULL,NULL,NULL),('350600','漳州市','350000',1,NULL,NULL,NULL,NULL,NULL,NULL),('350602','芗城区','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350603','龙文区','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350622','云霄县','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350623','漳浦县','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350624','诏安县','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350625','长泰县','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350626','东山县','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350627','南靖县','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350628','平和县','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350629','华安县','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350681','龙海市','350600',1,NULL,NULL,NULL,NULL,NULL,NULL),('350700','南平市','350000',1,NULL,NULL,NULL,NULL,NULL,NULL),('350702','延平区','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350703','建阳区','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350721','顺昌县','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350722','浦城县','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350723','光泽县','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350724','松溪县','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350725','政和县','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350781','邵武市','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350782','武夷山市','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350783','建瓯市','350700',1,NULL,NULL,NULL,NULL,NULL,NULL),('350800','龙岩市','350000',1,NULL,NULL,NULL,NULL,NULL,NULL),('350802','新罗区','350800',1,NULL,NULL,NULL,NULL,NULL,NULL),('350803','永定区','350800',1,NULL,NULL,NULL,NULL,NULL,NULL),('350821','长汀县','350800',1,NULL,NULL,NULL,NULL,NULL,NULL),('350823','上杭县','350800',1,NULL,NULL,NULL,NULL,NULL,NULL),('350824','武平县','350800',1,NULL,NULL,NULL,NULL,NULL,NULL),('350825','连城县','350800',1,NULL,NULL,NULL,NULL,NULL,NULL),('350881','漳平市','350800',1,NULL,NULL,NULL,NULL,NULL,NULL),('350900','宁德市','350000',1,NULL,NULL,NULL,NULL,NULL,NULL),('350902','蕉城区','350900',1,NULL,NULL,NULL,NULL,NULL,NULL),('350921','霞浦县','350900',1,NULL,NULL,NULL,NULL,NULL,NULL),('350922','古田县','350900',1,NULL,NULL,NULL,NULL,NULL,NULL),('350923','屏南县','350900',1,NULL,NULL,NULL,NULL,NULL,NULL),('350924','寿宁县','350900',1,NULL,NULL,NULL,NULL,NULL,NULL),('350925','周宁县','350900',1,NULL,NULL,NULL,NULL,NULL,NULL),('350926','柘荣县','350900',1,NULL,NULL,NULL,NULL,NULL,NULL),('350981','福安市','350900',1,NULL,NULL,NULL,NULL,NULL,NULL),('350982','福鼎市','350900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360000','江西省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('360100','南昌市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('360102','东湖区','360100',1,NULL,NULL,NULL,NULL,NULL,NULL),('360103','西湖区','360100',1,NULL,NULL,NULL,NULL,NULL,NULL),('360104','青云谱区','360100',1,NULL,NULL,NULL,NULL,NULL,NULL),('360105','湾里区','360100',1,NULL,NULL,NULL,NULL,NULL,NULL),('360111','青山湖区','360100',1,NULL,NULL,NULL,NULL,NULL,NULL),('360112','新建区','360100',1,NULL,NULL,NULL,NULL,NULL,NULL),('360121','南昌县','360100',1,NULL,NULL,NULL,NULL,NULL,NULL),('360123','安义县','360100',1,NULL,NULL,NULL,NULL,NULL,NULL),('360124','进贤县','360100',1,NULL,NULL,NULL,NULL,NULL,NULL),('360200','景德镇市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('360202','昌江区','360200',1,NULL,NULL,NULL,NULL,NULL,NULL),('360203','珠山区','360200',1,NULL,NULL,NULL,NULL,NULL,NULL),('360222','浮梁县','360200',1,NULL,NULL,NULL,NULL,NULL,NULL),('360281','乐平市','360200',1,NULL,NULL,NULL,NULL,NULL,NULL),('360300','萍乡市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('360302','安源区','360300',1,NULL,NULL,NULL,NULL,NULL,NULL),('360313','湘东区','360300',1,NULL,NULL,NULL,NULL,NULL,NULL),('360321','莲花县','360300',1,NULL,NULL,NULL,NULL,NULL,NULL),('360322','上栗县','360300',1,NULL,NULL,NULL,NULL,NULL,NULL),('360323','芦溪县','360300',1,NULL,NULL,NULL,NULL,NULL,NULL),('360400','九江市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('360402','濂溪区','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360403','浔阳区','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360421','九江县','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360423','武宁县','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360424','修水县','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360425','永修县','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360426','德安县','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360428','都昌县','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360429','湖口县','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360430','彭泽县','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360481','瑞昌市','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360482','共青城市','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360483','庐山市','360400',1,NULL,NULL,NULL,NULL,NULL,NULL),('360500','新余市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('360502','渝水区','360500',1,NULL,NULL,NULL,NULL,NULL,NULL),('360521','分宜县','360500',1,NULL,NULL,NULL,NULL,NULL,NULL),('360600','鹰潭市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('360602','月湖区','360600',1,NULL,NULL,NULL,NULL,NULL,NULL),('360622','余江县','360600',1,NULL,NULL,NULL,NULL,NULL,NULL),('360681','贵溪市','360600',1,NULL,NULL,NULL,NULL,NULL,NULL),('360700','赣州市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('360702','章贡区','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360703','南康区','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360721','赣县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360722','信丰县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360723','大余县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360724','上犹县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360725','崇义县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360726','安远县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360727','龙南县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360728','定南县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360729','全南县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360730','宁都县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360731','于都县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360732','兴国县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360733','会昌县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360734','寻乌县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360735','石城县','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360781','瑞金市','360700',1,NULL,NULL,NULL,NULL,NULL,NULL),('360800','吉安市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('360802','吉州区','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360803','青原区','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360821','吉安县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360822','吉水县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360823','峡江县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360824','新干县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360825','永丰县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360826','泰和县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360827','遂川县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360828','万安县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360829','安福县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360830','永新县','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360881','井冈山市','360800',1,NULL,NULL,NULL,NULL,NULL,NULL),('360900','宜春市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('360902','袁州区','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360921','奉新县','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360922','万载县','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360923','上高县','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360924','宜丰县','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360925','靖安县','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360926','铜鼓县','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360981','丰城市','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360982','樟树市','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('360983','高安市','360900',1,NULL,NULL,NULL,NULL,NULL,NULL),('361000','抚州市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361002','临川区','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361021','南城县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361022','黎川县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361023','南丰县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361024','崇仁县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361025','乐安县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361026','宜黄县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361027','金溪县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361028','资溪县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361029','东乡县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361030','广昌县','361000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361100','上饶市','360000',1,NULL,NULL,NULL,NULL,NULL,NULL),('361102','信州区','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361103','广丰区','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361121','上饶县','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361123','玉山县','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361124','铅山县','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361125','横峰县','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361126','弋阳县','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361127','余干县','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361128','鄱阳县','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361129','万年县','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361130','婺源县','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('361181','德兴市','361100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370000','山东省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('370100','济南市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('370102','历下区','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370103','市中区','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370104','槐荫区','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370105','天桥区','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370112','历城区','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370113','长清区','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370124','平阴县','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370125','济阳县','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370126','商河县','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370181','章丘市','370100',1,NULL,NULL,NULL,NULL,NULL,NULL),('370200','青岛市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('370202','市南区','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370203','市北区','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370211','黄岛区','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370212','崂山区','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370213','李沧区','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370214','城阳区','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370281','胶州市','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370282','即墨市','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370283','平度市','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370285','莱西市','370200',1,NULL,NULL,NULL,NULL,NULL,NULL),('370300','淄博市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('370302','淄川区','370300',1,NULL,NULL,NULL,NULL,NULL,NULL),('370303','张店区','370300',1,NULL,NULL,NULL,NULL,NULL,NULL),('370304','博山区','370300',1,NULL,NULL,NULL,NULL,NULL,NULL),('370305','临淄区','370300',1,NULL,NULL,NULL,NULL,NULL,NULL),('370306','周村区','370300',1,NULL,NULL,NULL,NULL,NULL,NULL),('370321','桓台县','370300',1,NULL,NULL,NULL,NULL,NULL,NULL),('370322','高青县','370300',1,NULL,NULL,NULL,NULL,NULL,NULL),('370323','沂源县','370300',1,NULL,NULL,NULL,NULL,NULL,NULL),('370400','枣庄市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('370402','市中区','370400',1,NULL,NULL,NULL,NULL,NULL,NULL),('370403','薛城区','370400',1,NULL,NULL,NULL,NULL,NULL,NULL),('370404','峄城区','370400',1,NULL,NULL,NULL,NULL,NULL,NULL),('370405','台儿庄区','370400',1,NULL,NULL,NULL,NULL,NULL,NULL),('370406','山亭区','370400',1,NULL,NULL,NULL,NULL,NULL,NULL),('370481','滕州市','370400',1,NULL,NULL,NULL,NULL,NULL,NULL),('370500','东营市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('370502','东营区','370500',1,NULL,NULL,NULL,NULL,NULL,NULL),('370503','河口区','370500',1,NULL,NULL,NULL,NULL,NULL,NULL),('370505','垦利区','370500',1,NULL,NULL,NULL,NULL,NULL,NULL),('370522','利津县','370500',1,NULL,NULL,NULL,NULL,NULL,NULL),('370523','广饶县','370500',1,NULL,NULL,NULL,NULL,NULL,NULL),('370600','烟台市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('370602','芝罘区','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370611','福山区','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370612','牟平区','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370613','莱山区','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370634','长岛县','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370681','龙口市','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370682','莱阳市','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370683','莱州市','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370684','蓬莱市','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370685','招远市','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370686','栖霞市','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370687','海阳市','370600',1,NULL,NULL,NULL,NULL,NULL,NULL),('370700','潍坊市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('370702','潍城区','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370703','寒亭区','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370704','坊子区','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370705','奎文区','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370724','临朐县','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370725','昌乐县','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370781','青州市','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370782','诸城市','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370783','寿光市','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370784','安丘市','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370785','高密市','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370786','昌邑市','370700',1,NULL,NULL,NULL,NULL,NULL,NULL),('370800','济宁市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('370811','任城区','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370812','兖州区','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370826','微山县','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370827','鱼台县','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370828','金乡县','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370829','嘉祥县','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370830','汶上县','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370831','泗水县','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370832','梁山县','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370881','曲阜市','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370883','邹城市','370800',1,NULL,NULL,NULL,NULL,NULL,NULL),('370900','泰安市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('370902','泰山区','370900',1,NULL,NULL,NULL,NULL,NULL,NULL),('370911','岱岳区','370900',1,NULL,NULL,NULL,NULL,NULL,NULL),('370921','宁阳县','370900',1,NULL,NULL,NULL,NULL,NULL,NULL),('370923','东平县','370900',1,NULL,NULL,NULL,NULL,NULL,NULL),('370982','新泰市','370900',1,NULL,NULL,NULL,NULL,NULL,NULL),('370983','肥城市','370900',1,NULL,NULL,NULL,NULL,NULL,NULL),('371000','威海市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371002','环翠区','371000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371003','文登区','371000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371082','荣成市','371000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371083','乳山市','371000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371100','日照市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371102','东港区','371100',1,NULL,NULL,NULL,NULL,NULL,NULL),('371103','岚山区','371100',1,NULL,NULL,NULL,NULL,NULL,NULL),('371121','五莲县','371100',1,NULL,NULL,NULL,NULL,NULL,NULL),('371122','莒县','371100',1,NULL,NULL,NULL,NULL,NULL,NULL),('371200','莱芜市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371202','莱城区','371200',1,NULL,NULL,NULL,NULL,NULL,NULL),('371203','钢城区','371200',1,NULL,NULL,NULL,NULL,NULL,NULL),('371300','临沂市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371302','兰山区','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371311','罗庄区','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371312','河东区','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371321','沂南县','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371322','郯城县','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371323','沂水县','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371324','兰陵县','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371325','费县','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371326','平邑县','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371327','莒南县','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371328','蒙阴县','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371329','临沭县','371300',1,NULL,NULL,NULL,NULL,NULL,NULL),('371400','德州市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371402','德城区','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371403','陵城区','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371422','宁津县','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371423','庆云县','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371424','临邑县','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371425','齐河县','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371426','平原县','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371427','夏津县','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371428','武城县','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371481','乐陵市','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371482','禹城市','371400',1,NULL,NULL,NULL,NULL,NULL,NULL),('371500','聊城市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371502','东昌府区','371500',1,NULL,NULL,NULL,NULL,NULL,NULL),('371521','阳谷县','371500',1,NULL,NULL,NULL,NULL,NULL,NULL),('371522','莘县','371500',1,NULL,NULL,NULL,NULL,NULL,NULL),('371523','茌平县','371500',1,NULL,NULL,NULL,NULL,NULL,NULL),('371524','东阿县','371500',1,NULL,NULL,NULL,NULL,NULL,NULL),('371525','冠县','371500',1,NULL,NULL,NULL,NULL,NULL,NULL),('371526','高唐县','371500',1,NULL,NULL,NULL,NULL,NULL,NULL),('371581','临清市','371500',1,NULL,NULL,NULL,NULL,NULL,NULL),('371600','滨州市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371602','滨城区','371600',1,NULL,NULL,NULL,NULL,NULL,NULL),('371603','沾化区','371600',1,NULL,NULL,NULL,NULL,NULL,NULL),('371621','惠民县','371600',1,NULL,NULL,NULL,NULL,NULL,NULL),('371622','阳信县','371600',1,NULL,NULL,NULL,NULL,NULL,NULL),('371623','无棣县','371600',1,NULL,NULL,NULL,NULL,NULL,NULL),('371625','博兴县','371600',1,NULL,NULL,NULL,NULL,NULL,NULL),('371626','邹平县','371600',1,NULL,NULL,NULL,NULL,NULL,NULL),('371700','菏泽市','370000',1,NULL,NULL,NULL,NULL,NULL,NULL),('371702','牡丹区','371700',1,NULL,NULL,NULL,NULL,NULL,NULL),('371703','定陶区','371700',1,NULL,NULL,NULL,NULL,NULL,NULL),('371721','曹县','371700',1,NULL,NULL,NULL,NULL,NULL,NULL),('371722','单县','371700',1,NULL,NULL,NULL,NULL,NULL,NULL),('371723','成武县','371700',1,NULL,NULL,NULL,NULL,NULL,NULL),('371724','巨野县','371700',1,NULL,NULL,NULL,NULL,NULL,NULL),('371725','郓城县','371700',1,NULL,NULL,NULL,NULL,NULL,NULL),('371726','鄄城县','371700',1,NULL,NULL,NULL,NULL,NULL,NULL),('371728','东明县','371700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410000','河南省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('410100','郑州市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('410102','中原区','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410103','二七区','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410104','管城回族区','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410105','金水区','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410106','上街区','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410108','惠济区','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410122','中牟县','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410181','巩义市','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410182','荥阳市','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410183','新密市','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410184','新郑市','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410185','登封市','410100',1,NULL,NULL,NULL,NULL,NULL,NULL),('410200','开封市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('410202','龙亭区','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410203','顺河回族区','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410204','鼓楼区','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410205','禹王台区','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410211','金明区','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410212','祥符区','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410221','杞县','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410222','通许县','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410223','尉氏县','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410225','兰考县','410200',1,NULL,NULL,NULL,NULL,NULL,NULL),('410300','洛阳市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('410302','老城区','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410303','西工区','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410304','瀍河回族区','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410305','涧西区','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410306','吉利区','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410311','洛龙区','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410322','孟津县','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410323','新安县','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410324','栾川县','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410325','嵩县','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410326','汝阳县','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410327','宜阳县','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410328','洛宁县','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410329','伊川县','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410381','偃师市','410300',1,NULL,NULL,NULL,NULL,NULL,NULL),('410400','平顶山市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('410402','新华区','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410403','卫东区','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410404','石龙区','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410411','湛河区','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410421','宝丰县','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410422','叶县','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410423','鲁山县','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410425','郏县','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410481','舞钢市','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410482','汝州市','410400',1,NULL,NULL,NULL,NULL,NULL,NULL),('410500','安阳市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('410502','文峰区','410500',1,NULL,NULL,NULL,NULL,NULL,NULL),('410503','北关区','410500',1,NULL,NULL,NULL,NULL,NULL,NULL),('410505','殷都区','410500',1,NULL,NULL,NULL,NULL,NULL,NULL),('410506','龙安区','410500',1,NULL,NULL,NULL,NULL,NULL,NULL),('410522','安阳县','410500',1,NULL,NULL,NULL,NULL,NULL,NULL),('410523','汤阴县','410500',1,NULL,NULL,NULL,NULL,NULL,NULL),('410526','滑县','410500',1,NULL,NULL,NULL,NULL,NULL,NULL),('410527','内黄县','410500',1,NULL,NULL,NULL,NULL,NULL,NULL),('410581','林州市','410500',1,NULL,NULL,NULL,NULL,NULL,NULL),('410600','鹤壁市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('410602','鹤山区','410600',1,NULL,NULL,NULL,NULL,NULL,NULL),('410603','山城区','410600',1,NULL,NULL,NULL,NULL,NULL,NULL),('410611','淇滨区','410600',1,NULL,NULL,NULL,NULL,NULL,NULL),('410621','浚县','410600',1,NULL,NULL,NULL,NULL,NULL,NULL),('410622','淇县','410600',1,NULL,NULL,NULL,NULL,NULL,NULL),('410700','新乡市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('410702','红旗区','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410703','卫滨区','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410704','凤泉区','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410711','牧野区','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410721','新乡县','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410724','获嘉县','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410725','原阳县','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410726','延津县','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410727','封丘县','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410728','长垣县','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410781','卫辉市','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410782','辉县市','410700',1,NULL,NULL,NULL,NULL,NULL,NULL),('410800','焦作市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('410802','解放区','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410803','中站区','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410804','马村区','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410811','山阳区','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410821','修武县','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410822','博爱县','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410823','武陟县','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410825','温县','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410882','沁阳市','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410883','孟州市','410800',1,NULL,NULL,NULL,NULL,NULL,NULL),('410900','濮阳市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('410902','华龙区','410900',1,NULL,NULL,NULL,NULL,NULL,NULL),('410922','清丰县','410900',1,NULL,NULL,NULL,NULL,NULL,NULL),('410923','南乐县','410900',1,NULL,NULL,NULL,NULL,NULL,NULL),('410926','范县','410900',1,NULL,NULL,NULL,NULL,NULL,NULL),('410927','台前县','410900',1,NULL,NULL,NULL,NULL,NULL,NULL),('410928','濮阳县','410900',1,NULL,NULL,NULL,NULL,NULL,NULL),('411000','许昌市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411002','魏都区','411000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411023','许昌县','411000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411024','鄢陵县','411000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411025','襄城县','411000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411081','禹州市','411000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411082','长葛市','411000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411100','漯河市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411102','源汇区','411100',1,NULL,NULL,NULL,NULL,NULL,NULL),('411103','郾城区','411100',1,NULL,NULL,NULL,NULL,NULL,NULL),('411104','召陵区','411100',1,NULL,NULL,NULL,NULL,NULL,NULL),('411121','舞阳县','411100',1,NULL,NULL,NULL,NULL,NULL,NULL),('411122','临颍县','411100',1,NULL,NULL,NULL,NULL,NULL,NULL),('411200','三门峡市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411202','湖滨区','411200',1,NULL,NULL,NULL,NULL,NULL,NULL),('411203','陕州区','411200',1,NULL,NULL,NULL,NULL,NULL,NULL),('411221','渑池县','411200',1,NULL,NULL,NULL,NULL,NULL,NULL),('411224','卢氏县','411200',1,NULL,NULL,NULL,NULL,NULL,NULL),('411281','义马市','411200',1,NULL,NULL,NULL,NULL,NULL,NULL),('411282','灵宝市','411200',1,NULL,NULL,NULL,NULL,NULL,NULL),('411300','南阳市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411302','宛城区','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411303','卧龙区','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411321','南召县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411322','方城县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411323','西峡县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411324','镇平县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411325','内乡县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411326','淅川县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411327','社旗县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411328','唐河县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411329','新野县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411330','桐柏县','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411381','邓州市','411300',1,NULL,NULL,NULL,NULL,NULL,NULL),('411400','商丘市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411402','梁园区','411400',1,NULL,NULL,NULL,NULL,NULL,NULL),('411403','睢阳区','411400',1,NULL,NULL,NULL,NULL,NULL,NULL),('411421','民权县','411400',1,NULL,NULL,NULL,NULL,NULL,NULL),('411422','睢县','411400',1,NULL,NULL,NULL,NULL,NULL,NULL),('411423','宁陵县','411400',1,NULL,NULL,NULL,NULL,NULL,NULL),('411424','柘城县','411400',1,NULL,NULL,NULL,NULL,NULL,NULL),('411425','虞城县','411400',1,NULL,NULL,NULL,NULL,NULL,NULL),('411426','夏邑县','411400',1,NULL,NULL,NULL,NULL,NULL,NULL),('411481','永城市','411400',1,NULL,NULL,NULL,NULL,NULL,NULL),('411500','信阳市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411502','浉河区','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411503','平桥区','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411521','罗山县','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411522','光山县','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411523','新县','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411524','商城县','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411525','固始县','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411526','潢川县','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411527','淮滨县','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411528','息县','411500',1,NULL,NULL,NULL,NULL,NULL,NULL),('411600','周口市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411602','川汇区','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411621','扶沟县','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411622','西华县','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411623','商水县','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411624','沈丘县','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411625','郸城县','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411626','淮阳县','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411627','太康县','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411628','鹿邑县','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411681','项城市','411600',1,NULL,NULL,NULL,NULL,NULL,NULL),('411700','驻马店市','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('411702','驿城区','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('411721','西平县','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('411722','上蔡县','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('411723','平舆县','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('411724','正阳县','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('411725','确山县','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('411726','泌阳县','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('411727','汝南县','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('411728','遂平县','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('411729','新蔡县','411700',1,NULL,NULL,NULL,NULL,NULL,NULL),('419000','省直辖县级行政区划','410000',1,NULL,NULL,NULL,NULL,NULL,NULL),('419001','济源市','419000',1,NULL,NULL,NULL,NULL,NULL,NULL),('420000','湖北省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('420100','武汉市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('420102','江岸区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420103','江汉区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420104','硚口区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420105','汉阳区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420106','武昌区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420107','青山区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420111','洪山区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420112','东西湖区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420113','汉南区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420114','蔡甸区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420115','江夏区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420116','黄陂区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420117','新洲区','420100',1,NULL,NULL,NULL,NULL,NULL,NULL),('420200','黄石市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('420202','黄石港区','420200',1,NULL,NULL,NULL,NULL,NULL,NULL),('420203','西塞山区','420200',1,NULL,NULL,NULL,NULL,NULL,NULL),('420204','下陆区','420200',1,NULL,NULL,NULL,NULL,NULL,NULL),('420205','铁山区','420200',1,NULL,NULL,NULL,NULL,NULL,NULL),('420222','阳新县','420200',1,NULL,NULL,NULL,NULL,NULL,NULL),('420281','大冶市','420200',1,NULL,NULL,NULL,NULL,NULL,NULL),('420300','十堰市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('420302','茅箭区','420300',1,NULL,NULL,NULL,NULL,NULL,NULL),('420303','张湾区','420300',1,NULL,NULL,NULL,NULL,NULL,NULL),('420304','郧阳区','420300',1,NULL,NULL,NULL,NULL,NULL,NULL),('420322','郧西县','420300',1,NULL,NULL,NULL,NULL,NULL,NULL),('420323','竹山县','420300',1,NULL,NULL,NULL,NULL,NULL,NULL),('420324','竹溪县','420300',1,NULL,NULL,NULL,NULL,NULL,NULL),('420325','房县','420300',1,NULL,NULL,NULL,NULL,NULL,NULL),('420381','丹江口市','420300',1,NULL,NULL,NULL,NULL,NULL,NULL),('420500','宜昌市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('420502','西陵区','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420503','伍家岗区','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420504','点军区','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420505','猇亭区','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420506','夷陵区','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420525','远安县','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420526','兴山县','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420527','秭归县','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420528','长阳土家族自治县','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420529','五峰土家族自治县','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420581','宜都市','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420582','当阳市','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420583','枝江市','420500',1,NULL,NULL,NULL,NULL,NULL,NULL),('420600','襄阳市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('420602','襄城区','420600',1,NULL,NULL,NULL,NULL,NULL,NULL),('420606','樊城区','420600',1,NULL,NULL,NULL,NULL,NULL,NULL),('420607','襄州区','420600',1,NULL,NULL,NULL,NULL,NULL,NULL),('420624','南漳县','420600',1,NULL,NULL,NULL,NULL,NULL,NULL),('420625','谷城县','420600',1,NULL,NULL,NULL,NULL,NULL,NULL),('420626','保康县','420600',1,NULL,NULL,NULL,NULL,NULL,NULL),('420682','老河口市','420600',1,NULL,NULL,NULL,NULL,NULL,NULL),('420683','枣阳市','420600',1,NULL,NULL,NULL,NULL,NULL,NULL),('420684','宜城市','420600',1,NULL,NULL,NULL,NULL,NULL,NULL),('420700','鄂州市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('420702','梁子湖区','420700',1,NULL,NULL,NULL,NULL,NULL,NULL),('420703','华容区','420700',1,NULL,NULL,NULL,NULL,NULL,NULL),('420704','鄂城区','420700',1,NULL,NULL,NULL,NULL,NULL,NULL),('420800','荆门市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('420802','东宝区','420800',1,NULL,NULL,NULL,NULL,NULL,NULL),('420804','掇刀区','420800',1,NULL,NULL,NULL,NULL,NULL,NULL),('420821','京山县','420800',1,NULL,NULL,NULL,NULL,NULL,NULL),('420822','沙洋县','420800',1,NULL,NULL,NULL,NULL,NULL,NULL),('420881','钟祥市','420800',1,NULL,NULL,NULL,NULL,NULL,NULL),('420900','孝感市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('420902','孝南区','420900',1,NULL,NULL,NULL,NULL,NULL,NULL),('420921','孝昌县','420900',1,NULL,NULL,NULL,NULL,NULL,NULL),('420922','大悟县','420900',1,NULL,NULL,NULL,NULL,NULL,NULL),('420923','云梦县','420900',1,NULL,NULL,NULL,NULL,NULL,NULL),('420981','应城市','420900',1,NULL,NULL,NULL,NULL,NULL,NULL),('420982','安陆市','420900',1,NULL,NULL,NULL,NULL,NULL,NULL),('420984','汉川市','420900',1,NULL,NULL,NULL,NULL,NULL,NULL),('421000','荆州市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421002','沙市区','421000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421003','荆州区','421000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421022','公安县','421000',1,NULL,NULL,NULL,NULL,NULL,NULL);
REPLACE INTO `tb_areas` VALUES ('421023','监利县','421000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421024','江陵县','421000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421081','石首市','421000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421083','洪湖市','421000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421087','松滋市','421000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421100','黄冈市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421102','黄州区','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421121','团风县','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421122','红安县','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421123','罗田县','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421124','英山县','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421125','浠水县','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421126','蕲春县','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421127','黄梅县','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421181','麻城市','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421182','武穴市','421100',1,NULL,NULL,NULL,NULL,NULL,NULL),('421200','咸宁市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421202','咸安区','421200',1,NULL,NULL,NULL,NULL,NULL,NULL),('421221','嘉鱼县','421200',1,NULL,NULL,NULL,NULL,NULL,NULL),('421222','通城县','421200',1,NULL,NULL,NULL,NULL,NULL,NULL),('421223','崇阳县','421200',1,NULL,NULL,NULL,NULL,NULL,NULL),('421224','通山县','421200',1,NULL,NULL,NULL,NULL,NULL,NULL),('421281','赤壁市','421200',1,NULL,NULL,NULL,NULL,NULL,NULL),('421300','随州市','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('421303','曾都区','421300',1,NULL,NULL,NULL,NULL,NULL,NULL),('421321','随县','421300',1,NULL,NULL,NULL,NULL,NULL,NULL),('421381','广水市','421300',1,NULL,NULL,NULL,NULL,NULL,NULL),('422800','恩施土家族苗族自治州','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('422801','恩施市','422800',1,NULL,NULL,NULL,NULL,NULL,NULL),('422802','利川市','422800',1,NULL,NULL,NULL,NULL,NULL,NULL),('422822','建始县','422800',1,NULL,NULL,NULL,NULL,NULL,NULL),('422823','巴东县','422800',1,NULL,NULL,NULL,NULL,NULL,NULL),('422825','宣恩县','422800',1,NULL,NULL,NULL,NULL,NULL,NULL),('422826','咸丰县','422800',1,NULL,NULL,NULL,NULL,NULL,NULL),('422827','来凤县','422800',1,NULL,NULL,NULL,NULL,NULL,NULL),('422828','鹤峰县','422800',1,NULL,NULL,NULL,NULL,NULL,NULL),('429000','省直辖县级行政区划','420000',1,NULL,NULL,NULL,NULL,NULL,NULL),('429004','仙桃市','429000',1,NULL,NULL,NULL,NULL,NULL,NULL),('429005','潜江市','429000',1,NULL,NULL,NULL,NULL,NULL,NULL),('429006','天门市','429000',1,NULL,NULL,NULL,NULL,NULL,NULL),('429021','神农架林区','429000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430000','湖南省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('430100','长沙市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430102','芙蓉区','430100',1,NULL,NULL,NULL,NULL,NULL,NULL),('430103','天心区','430100',1,NULL,NULL,NULL,NULL,NULL,NULL),('430104','岳麓区','430100',1,NULL,NULL,NULL,NULL,NULL,NULL),('430105','开福区','430100',1,NULL,NULL,NULL,NULL,NULL,NULL),('430111','雨花区','430100',1,NULL,NULL,NULL,NULL,NULL,NULL),('430112','望城区','430100',1,NULL,NULL,NULL,NULL,NULL,NULL),('430121','长沙县','430100',1,NULL,NULL,NULL,NULL,NULL,NULL),('430124','宁乡县','430100',1,NULL,NULL,NULL,NULL,NULL,NULL),('430181','浏阳市','430100',1,NULL,NULL,NULL,NULL,NULL,NULL),('430200','株洲市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430202','荷塘区','430200',1,NULL,NULL,NULL,NULL,NULL,NULL),('430203','芦淞区','430200',1,NULL,NULL,NULL,NULL,NULL,NULL),('430204','石峰区','430200',1,NULL,NULL,NULL,NULL,NULL,NULL),('430211','天元区','430200',1,NULL,NULL,NULL,NULL,NULL,NULL),('430221','株洲县','430200',1,NULL,NULL,NULL,NULL,NULL,NULL),('430223','攸县','430200',1,NULL,NULL,NULL,NULL,NULL,NULL),('430224','茶陵县','430200',1,NULL,NULL,NULL,NULL,NULL,NULL),('430225','炎陵县','430200',1,NULL,NULL,NULL,NULL,NULL,NULL),('430281','醴陵市','430200',1,NULL,NULL,NULL,NULL,NULL,NULL),('430300','湘潭市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430302','雨湖区','430300',1,NULL,NULL,NULL,NULL,NULL,NULL),('430304','岳塘区','430300',1,NULL,NULL,NULL,NULL,NULL,NULL),('430321','湘潭县','430300',1,NULL,NULL,NULL,NULL,NULL,NULL),('430381','湘乡市','430300',1,NULL,NULL,NULL,NULL,NULL,NULL),('430382','韶山市','430300',1,NULL,NULL,NULL,NULL,NULL,NULL),('430400','衡阳市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430405','珠晖区','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430406','雁峰区','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430407','石鼓区','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430408','蒸湘区','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430412','南岳区','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430421','衡阳县','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430422','衡南县','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430423','衡山县','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430424','衡东县','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430426','祁东县','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430481','耒阳市','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430482','常宁市','430400',1,NULL,NULL,NULL,NULL,NULL,NULL),('430500','邵阳市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430502','双清区','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430503','大祥区','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430511','北塔区','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430521','邵东县','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430522','新邵县','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430523','邵阳县','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430524','隆回县','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430525','洞口县','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430527','绥宁县','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430528','新宁县','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430529','城步苗族自治县','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430581','武冈市','430500',1,NULL,NULL,NULL,NULL,NULL,NULL),('430600','岳阳市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430602','岳阳楼区','430600',1,NULL,NULL,NULL,NULL,NULL,NULL),('430603','云溪区','430600',1,NULL,NULL,NULL,NULL,NULL,NULL),('430611','君山区','430600',1,NULL,NULL,NULL,NULL,NULL,NULL),('430621','岳阳县','430600',1,NULL,NULL,NULL,NULL,NULL,NULL),('430623','华容县','430600',1,NULL,NULL,NULL,NULL,NULL,NULL),('430624','湘阴县','430600',1,NULL,NULL,NULL,NULL,NULL,NULL),('430626','平江县','430600',1,NULL,NULL,NULL,NULL,NULL,NULL),('430681','汨罗市','430600',1,NULL,NULL,NULL,NULL,NULL,NULL),('430682','临湘市','430600',1,NULL,NULL,NULL,NULL,NULL,NULL),('430700','常德市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430702','武陵区','430700',1,NULL,NULL,NULL,NULL,NULL,NULL),('430703','鼎城区','430700',1,NULL,NULL,NULL,NULL,NULL,NULL),('430721','安乡县','430700',1,NULL,NULL,NULL,NULL,NULL,NULL),('430722','汉寿县','430700',1,NULL,NULL,NULL,NULL,NULL,NULL),('430723','澧县','430700',1,NULL,NULL,NULL,NULL,NULL,NULL),('430724','临澧县','430700',1,NULL,NULL,NULL,NULL,NULL,NULL),('430725','桃源县','430700',1,NULL,NULL,NULL,NULL,NULL,NULL),('430726','石门县','430700',1,NULL,NULL,NULL,NULL,NULL,NULL),('430781','津市市','430700',1,NULL,NULL,NULL,NULL,NULL,NULL),('430800','张家界市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430802','永定区','430800',1,NULL,NULL,NULL,NULL,NULL,NULL),('430811','武陵源区','430800',1,NULL,NULL,NULL,NULL,NULL,NULL),('430821','慈利县','430800',1,NULL,NULL,NULL,NULL,NULL,NULL),('430822','桑植县','430800',1,NULL,NULL,NULL,NULL,NULL,NULL),('430900','益阳市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('430902','资阳区','430900',1,NULL,NULL,NULL,NULL,NULL,NULL),('430903','赫山区','430900',1,NULL,NULL,NULL,NULL,NULL,NULL),('430921','南县','430900',1,NULL,NULL,NULL,NULL,NULL,NULL),('430922','桃江县','430900',1,NULL,NULL,NULL,NULL,NULL,NULL),('430923','安化县','430900',1,NULL,NULL,NULL,NULL,NULL,NULL),('430981','沅江市','430900',1,NULL,NULL,NULL,NULL,NULL,NULL),('431000','郴州市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431002','北湖区','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431003','苏仙区','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431021','桂阳县','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431022','宜章县','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431023','永兴县','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431024','嘉禾县','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431025','临武县','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431026','汝城县','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431027','桂东县','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431028','安仁县','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431081','资兴市','431000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431100','永州市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431102','零陵区','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431103','冷水滩区','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431121','祁阳县','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431122','东安县','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431123','双牌县','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431124','道县','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431125','江永县','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431126','宁远县','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431127','蓝山县','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431128','新田县','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431129','江华瑶族自治县','431100',1,NULL,NULL,NULL,NULL,NULL,NULL),('431200','怀化市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431202','鹤城区','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431221','中方县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431222','沅陵县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431223','辰溪县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431224','溆浦县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431225','会同县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431226','麻阳苗族自治县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431227','新晃侗族自治县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431228','芷江侗族自治县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431229','靖州苗族侗族自治县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431230','通道侗族自治县','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431281','洪江市','431200',1,NULL,NULL,NULL,NULL,NULL,NULL),('431300','娄底市','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('431302','娄星区','431300',1,NULL,NULL,NULL,NULL,NULL,NULL),('431321','双峰县','431300',1,NULL,NULL,NULL,NULL,NULL,NULL),('431322','新化县','431300',1,NULL,NULL,NULL,NULL,NULL,NULL),('431381','冷水江市','431300',1,NULL,NULL,NULL,NULL,NULL,NULL),('431382','涟源市','431300',1,NULL,NULL,NULL,NULL,NULL,NULL),('433100','湘西土家族苗族自治州','430000',1,NULL,NULL,NULL,NULL,NULL,NULL),('433101','吉首市','433100',1,NULL,NULL,NULL,NULL,NULL,NULL),('433122','泸溪县','433100',1,NULL,NULL,NULL,NULL,NULL,NULL),('433123','凤凰县','433100',1,NULL,NULL,NULL,NULL,NULL,NULL),('433124','花垣县','433100',1,NULL,NULL,NULL,NULL,NULL,NULL),('433125','保靖县','433100',1,NULL,NULL,NULL,NULL,NULL,NULL),('433126','古丈县','433100',1,NULL,NULL,NULL,NULL,NULL,NULL),('433127','永顺县','433100',1,NULL,NULL,NULL,NULL,NULL,NULL),('433130','龙山县','433100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440000','广东省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('440100','广州市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('440103','荔湾区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440104','越秀区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440105','海珠区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440106','天河区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440111','白云区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440112','黄埔区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440113','番禺区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440114','花都区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440115','南沙区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440117','从化区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440118','增城区','440100',1,NULL,NULL,NULL,NULL,NULL,NULL),('440200','韶关市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('440203','武江区','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440204','浈江区','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440205','曲江区','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440222','始兴县','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440224','仁化县','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440229','翁源县','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440232','乳源瑶族自治县','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440233','新丰县','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440281','乐昌市','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440282','南雄市','440200',1,NULL,NULL,NULL,NULL,NULL,NULL),('440300','深圳市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('440303','罗湖区','440300',1,NULL,NULL,NULL,NULL,NULL,NULL),('440304','福田区','440300',1,NULL,NULL,NULL,NULL,NULL,NULL),('440305','南山区','440300',1,NULL,NULL,NULL,NULL,NULL,NULL),('440306','宝安区','440300',1,NULL,NULL,NULL,NULL,NULL,NULL),('440307','龙岗区','440300',1,NULL,NULL,NULL,NULL,NULL,NULL),('440308','盐田区','440300',1,NULL,NULL,NULL,NULL,NULL,NULL),('440400','珠海市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('440402','香洲区','440400',1,NULL,NULL,NULL,NULL,NULL,NULL),('440403','斗门区','440400',1,NULL,NULL,NULL,NULL,NULL,NULL),('440404','金湾区','440400',1,NULL,NULL,NULL,NULL,NULL,NULL),('440500','汕头市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('440507','龙湖区','440500',1,NULL,NULL,NULL,NULL,NULL,NULL),('440511','金平区','440500',1,NULL,NULL,NULL,NULL,NULL,NULL),('440512','濠江区','440500',1,NULL,NULL,NULL,NULL,NULL,NULL),('440513','潮阳区','440500',1,NULL,NULL,NULL,NULL,NULL,NULL),('440514','潮南区','440500',1,NULL,NULL,NULL,NULL,NULL,NULL),('440515','澄海区','440500',1,NULL,NULL,NULL,NULL,NULL,NULL),('440523','南澳县','440500',1,NULL,NULL,NULL,NULL,NULL,NULL),('440600','佛山市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('440604','禅城区','440600',1,NULL,NULL,NULL,NULL,NULL,NULL),('440605','南海区','440600',1,NULL,NULL,NULL,NULL,NULL,NULL),('440606','顺德区','440600',1,NULL,NULL,NULL,NULL,NULL,NULL),('440607','三水区','440600',1,NULL,NULL,NULL,NULL,NULL,NULL),('440608','高明区','440600',1,NULL,NULL,NULL,NULL,NULL,NULL),('440700','江门市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('440703','蓬江区','440700',1,NULL,NULL,NULL,NULL,NULL,NULL),('440704','江海区','440700',1,NULL,NULL,NULL,NULL,NULL,NULL),('440705','新会区','440700',1,NULL,NULL,NULL,NULL,NULL,NULL),('440781','台山市','440700',1,NULL,NULL,NULL,NULL,NULL,NULL),('440783','开平市','440700',1,NULL,NULL,NULL,NULL,NULL,NULL),('440784','鹤山市','440700',1,NULL,NULL,NULL,NULL,NULL,NULL),('440785','恩平市','440700',1,NULL,NULL,NULL,NULL,NULL,NULL),('440800','湛江市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('440802','赤坎区','440800',1,NULL,NULL,NULL,NULL,NULL,NULL),('440803','霞山区','440800',1,NULL,NULL,NULL,NULL,NULL,NULL),('440804','坡头区','440800',1,NULL,NULL,NULL,NULL,NULL,NULL),('440811','麻章区','440800',1,NULL,NULL,NULL,NULL,NULL,NULL),('440823','遂溪县','440800',1,NULL,NULL,NULL,NULL,NULL,NULL),('440825','徐闻县','440800',1,NULL,NULL,NULL,NULL,NULL,NULL),('440881','廉江市','440800',1,NULL,NULL,NULL,NULL,NULL,NULL),('440882','雷州市','440800',1,NULL,NULL,NULL,NULL,NULL,NULL),('440883','吴川市','440800',1,NULL,NULL,NULL,NULL,NULL,NULL),('440900','茂名市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('440902','茂南区','440900',1,NULL,NULL,NULL,NULL,NULL,NULL),('440904','电白区','440900',1,NULL,NULL,NULL,NULL,NULL,NULL),('440981','高州市','440900',1,NULL,NULL,NULL,NULL,NULL,NULL),('440982','化州市','440900',1,NULL,NULL,NULL,NULL,NULL,NULL),('440983','信宜市','440900',1,NULL,NULL,NULL,NULL,NULL,NULL),('441200','肇庆市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('441202','端州区','441200',1,NULL,NULL,NULL,NULL,NULL,NULL),('441203','鼎湖区','441200',1,NULL,NULL,NULL,NULL,NULL,NULL),('441204','高要区','441200',1,NULL,NULL,NULL,NULL,NULL,NULL),('441223','广宁县','441200',1,NULL,NULL,NULL,NULL,NULL,NULL),('441224','怀集县','441200',1,NULL,NULL,NULL,NULL,NULL,NULL),('441225','封开县','441200',1,NULL,NULL,NULL,NULL,NULL,NULL),('441226','德庆县','441200',1,NULL,NULL,NULL,NULL,NULL,NULL),('441284','四会市','441200',1,NULL,NULL,NULL,NULL,NULL,NULL),('441300','惠州市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('441302','惠城区','441300',1,NULL,NULL,NULL,NULL,NULL,NULL),('441303','惠阳区','441300',1,NULL,NULL,NULL,NULL,NULL,NULL),('441322','博罗县','441300',1,NULL,NULL,NULL,NULL,NULL,NULL),('441323','惠东县','441300',1,NULL,NULL,NULL,NULL,NULL,NULL),('441324','龙门县','441300',1,NULL,NULL,NULL,NULL,NULL,NULL),('441400','梅州市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('441402','梅江区','441400',1,NULL,NULL,NULL,NULL,NULL,NULL),('441403','梅县区','441400',1,NULL,NULL,NULL,NULL,NULL,NULL),('441422','大埔县','441400',1,NULL,NULL,NULL,NULL,NULL,NULL),('441423','丰顺县','441400',1,NULL,NULL,NULL,NULL,NULL,NULL),('441424','五华县','441400',1,NULL,NULL,NULL,NULL,NULL,NULL),('441426','平远县','441400',1,NULL,NULL,NULL,NULL,NULL,NULL),('441427','蕉岭县','441400',1,NULL,NULL,NULL,NULL,NULL,NULL),('441481','兴宁市','441400',1,NULL,NULL,NULL,NULL,NULL,NULL),('441500','汕尾市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('441502','城区','441500',1,NULL,NULL,NULL,NULL,NULL,NULL),('441521','海丰县','441500',1,NULL,NULL,NULL,NULL,NULL,NULL),('441523','陆河县','441500',1,NULL,NULL,NULL,NULL,NULL,NULL),('441581','陆丰市','441500',1,NULL,NULL,NULL,NULL,NULL,NULL),('441600','河源市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('441602','源城区','441600',1,NULL,NULL,NULL,NULL,NULL,NULL),('441621','紫金县','441600',1,NULL,NULL,NULL,NULL,NULL,NULL),('441622','龙川县','441600',1,NULL,NULL,NULL,NULL,NULL,NULL),('441623','连平县','441600',1,NULL,NULL,NULL,NULL,NULL,NULL),('441624','和平县','441600',1,NULL,NULL,NULL,NULL,NULL,NULL),('441625','东源县','441600',1,NULL,NULL,NULL,NULL,NULL,NULL),('441700','阳江市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('441702','江城区','441700',1,NULL,NULL,NULL,NULL,NULL,NULL),('441704','阳东区','441700',1,NULL,NULL,NULL,NULL,NULL,NULL),('441721','阳西县','441700',1,NULL,NULL,NULL,NULL,NULL,NULL),('441781','阳春市','441700',1,NULL,NULL,NULL,NULL,NULL,NULL),('441800','清远市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('441802','清城区','441800',1,NULL,NULL,NULL,NULL,NULL,NULL),('441803','清新区','441800',1,NULL,NULL,NULL,NULL,NULL,NULL),('441821','佛冈县','441800',1,NULL,NULL,NULL,NULL,NULL,NULL),('441823','阳山县','441800',1,NULL,NULL,NULL,NULL,NULL,NULL),('441825','连山壮族瑶族自治县','441800',1,NULL,NULL,NULL,NULL,NULL,NULL),('441826','连南瑶族自治县','441800',1,NULL,NULL,NULL,NULL,NULL,NULL),('441881','英德市','441800',1,NULL,NULL,NULL,NULL,NULL,NULL),('441882','连州市','441800',1,NULL,NULL,NULL,NULL,NULL,NULL),('441900','东莞市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('442000','中山市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('445100','潮州市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('445102','湘桥区','445100',1,NULL,NULL,NULL,NULL,NULL,NULL),('445103','潮安区','445100',1,NULL,NULL,NULL,NULL,NULL,NULL),('445122','饶平县','445100',1,NULL,NULL,NULL,NULL,NULL,NULL),('445200','揭阳市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('445202','榕城区','445200',1,NULL,NULL,NULL,NULL,NULL,NULL),('445203','揭东区','445200',1,NULL,NULL,NULL,NULL,NULL,NULL),('445222','揭西县','445200',1,NULL,NULL,NULL,NULL,NULL,NULL),('445224','惠来县','445200',1,NULL,NULL,NULL,NULL,NULL,NULL),('445281','普宁市','445200',1,NULL,NULL,NULL,NULL,NULL,NULL),('445300','云浮市','440000',1,NULL,NULL,NULL,NULL,NULL,NULL),('445302','云城区','445300',1,NULL,NULL,NULL,NULL,NULL,NULL),('445303','云安区','445300',1,NULL,NULL,NULL,NULL,NULL,NULL),('445321','新兴县','445300',1,NULL,NULL,NULL,NULL,NULL,NULL),('445322','郁南县','445300',1,NULL,NULL,NULL,NULL,NULL,NULL),('445381','罗定市','445300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450000','广西壮族自治区',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('450100','南宁市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('450102','兴宁区','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450103','青秀区','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450105','江南区','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450107','西乡塘区','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450108','良庆区','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450109','邕宁区','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450110','武鸣区','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450123','隆安县','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450124','马山县','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450125','上林县','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450126','宾阳县','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450127','横县','450100',1,NULL,NULL,NULL,NULL,NULL,NULL),('450200','柳州市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('450202','城中区','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450203','鱼峰区','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450204','柳南区','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450205','柳北区','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450206','柳江区','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450222','柳城县','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450223','鹿寨县','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450224','融安县','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450225','融水苗族自治县','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450226','三江侗族自治县','450200',1,NULL,NULL,NULL,NULL,NULL,NULL),('450300','桂林市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('450302','秀峰区','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450303','叠彩区','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450304','象山区','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450305','七星区','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450311','雁山区','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450312','临桂区','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450321','阳朔县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450323','灵川县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450324','全州县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450325','兴安县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450326','永福县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450327','灌阳县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450328','龙胜各族自治县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450329','资源县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450330','平乐县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450331','荔浦县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450332','恭城瑶族自治县','450300',1,NULL,NULL,NULL,NULL,NULL,NULL),('450400','梧州市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('450403','万秀区','450400',1,NULL,NULL,NULL,NULL,NULL,NULL),('450405','长洲区','450400',1,NULL,NULL,NULL,NULL,NULL,NULL),('450406','龙圩区','450400',1,NULL,NULL,NULL,NULL,NULL,NULL),('450421','苍梧县','450400',1,NULL,NULL,NULL,NULL,NULL,NULL),('450422','藤县','450400',1,NULL,NULL,NULL,NULL,NULL,NULL),('450423','蒙山县','450400',1,NULL,NULL,NULL,NULL,NULL,NULL),('450481','岑溪市','450400',1,NULL,NULL,NULL,NULL,NULL,NULL),('450500','北海市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('450502','海城区','450500',1,NULL,NULL,NULL,NULL,NULL,NULL),('450503','银海区','450500',1,NULL,NULL,NULL,NULL,NULL,NULL),('450512','铁山港区','450500',1,NULL,NULL,NULL,NULL,NULL,NULL),('450521','合浦县','450500',1,NULL,NULL,NULL,NULL,NULL,NULL),('450600','防城港市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('450602','港口区','450600',1,NULL,NULL,NULL,NULL,NULL,NULL),('450603','防城区','450600',1,NULL,NULL,NULL,NULL,NULL,NULL),('450621','上思县','450600',1,NULL,NULL,NULL,NULL,NULL,NULL),('450681','东兴市','450600',1,NULL,NULL,NULL,NULL,NULL,NULL),('450700','钦州市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('450702','钦南区','450700',1,NULL,NULL,NULL,NULL,NULL,NULL),('450703','钦北区','450700',1,NULL,NULL,NULL,NULL,NULL,NULL),('450721','灵山县','450700',1,NULL,NULL,NULL,NULL,NULL,NULL),('450722','浦北县','450700',1,NULL,NULL,NULL,NULL,NULL,NULL),('450800','贵港市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('450802','港北区','450800',1,NULL,NULL,NULL,NULL,NULL,NULL),('450803','港南区','450800',1,NULL,NULL,NULL,NULL,NULL,NULL),('450804','覃塘区','450800',1,NULL,NULL,NULL,NULL,NULL,NULL),('450821','平南县','450800',1,NULL,NULL,NULL,NULL,NULL,NULL),('450881','桂平市','450800',1,NULL,NULL,NULL,NULL,NULL,NULL),('450900','玉林市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('450902','玉州区','450900',1,NULL,NULL,NULL,NULL,NULL,NULL),('450903','福绵区','450900',1,NULL,NULL,NULL,NULL,NULL,NULL),('450921','容县','450900',1,NULL,NULL,NULL,NULL,NULL,NULL),('450922','陆川县','450900',1,NULL,NULL,NULL,NULL,NULL,NULL),('450923','博白县','450900',1,NULL,NULL,NULL,NULL,NULL,NULL),('450924','兴业县','450900',1,NULL,NULL,NULL,NULL,NULL,NULL),('450981','北流市','450900',1,NULL,NULL,NULL,NULL,NULL,NULL),('451000','百色市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451002','右江区','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451021','田阳县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451022','田东县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451023','平果县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451024','德保县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451026','那坡县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451027','凌云县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451028','乐业县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451029','田林县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451030','西林县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451031','隆林各族自治县','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451081','靖西市','451000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451100','贺州市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451102','八步区','451100',1,NULL,NULL,NULL,NULL,NULL,NULL),('451103','平桂区','451100',1,NULL,NULL,NULL,NULL,NULL,NULL),('451121','昭平县','451100',1,NULL,NULL,NULL,NULL,NULL,NULL),('451122','钟山县','451100',1,NULL,NULL,NULL,NULL,NULL,NULL),('451123','富川瑶族自治县','451100',1,NULL,NULL,NULL,NULL,NULL,NULL),('451200','河池市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451202','金城江区','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451221','南丹县','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451222','天峨县','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451223','凤山县','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451224','东兰县','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451225','罗城仫佬族自治县','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451226','环江毛南族自治县','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451227','巴马瑶族自治县','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451228','都安瑶族自治县','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451229','大化瑶族自治县','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451281','宜州市','451200',1,NULL,NULL,NULL,NULL,NULL,NULL),('451300','来宾市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451302','兴宾区','451300',1,NULL,NULL,NULL,NULL,NULL,NULL),('451321','忻城县','451300',1,NULL,NULL,NULL,NULL,NULL,NULL),('451322','象州县','451300',1,NULL,NULL,NULL,NULL,NULL,NULL),('451323','武宣县','451300',1,NULL,NULL,NULL,NULL,NULL,NULL),('451324','金秀瑶族自治县','451300',1,NULL,NULL,NULL,NULL,NULL,NULL),('451381','合山市','451300',1,NULL,NULL,NULL,NULL,NULL,NULL),('451400','崇左市','450000',1,NULL,NULL,NULL,NULL,NULL,NULL),('451402','江州区','451400',1,NULL,NULL,NULL,NULL,NULL,NULL),('451421','扶绥县','451400',1,NULL,NULL,NULL,NULL,NULL,NULL),('451422','宁明县','451400',1,NULL,NULL,NULL,NULL,NULL,NULL),('451423','龙州县','451400',1,NULL,NULL,NULL,NULL,NULL,NULL),('451424','大新县','451400',1,NULL,NULL,NULL,NULL,NULL,NULL),('451425','天等县','451400',1,NULL,NULL,NULL,NULL,NULL,NULL),('451481','凭祥市','451400',1,NULL,NULL,NULL,NULL,NULL,NULL),('460000','海南省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('460100','海口市','460000',1,NULL,NULL,NULL,NULL,NULL,NULL),('460105','秀英区','460100',1,NULL,NULL,NULL,NULL,NULL,NULL),('460106','龙华区','460100',1,NULL,NULL,NULL,NULL,NULL,NULL),('460107','琼山区','460100',1,NULL,NULL,NULL,NULL,NULL,NULL),('460108','美兰区','460100',1,NULL,NULL,NULL,NULL,NULL,NULL),('460200','三亚市','460000',1,NULL,NULL,NULL,NULL,NULL,NULL),('460202','海棠区','460200',1,NULL,NULL,NULL,NULL,NULL,NULL),('460203','吉阳区','460200',1,NULL,NULL,NULL,NULL,NULL,NULL),('460204','天涯区','460200',1,NULL,NULL,NULL,NULL,NULL,NULL),('460205','崖州区','460200',1,NULL,NULL,NULL,NULL,NULL,NULL),('460300','三沙市','460000',1,NULL,NULL,NULL,NULL,NULL,NULL),('460400','儋州市','460000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469000','省直辖县级行政区划','460000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469001','五指山市','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469002','琼海市','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469005','文昌市','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469006','万宁市','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469007','东方市','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469021','定安县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469022','屯昌县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469023','澄迈县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469024','临高县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469025','白沙黎族自治县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469026','昌江黎族自治县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469027','乐东黎族自治县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469028','陵水黎族自治县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469029','保亭黎族苗族自治县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('469030','琼中黎族苗族自治县','469000',1,NULL,NULL,NULL,NULL,NULL,NULL),('500000','重庆市',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('500100','重庆市','500000',1,NULL,NULL,NULL,NULL,NULL,NULL),('500101','万州区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500102','涪陵区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500103','渝中区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500104','大渡口区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500105','江北区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500106','沙坪坝区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500107','九龙坡区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500108','南岸区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500109','北碚区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500110','綦江区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500111','大足区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500112','渝北区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500113','巴南区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500114','黔江区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500115','长寿区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500116','江津区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500117','合川区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500118','永川区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500119','南川区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500120','璧山区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500151','铜梁区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500152','潼南区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500153','荣昌区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500154','开州区','500100',1,NULL,NULL,NULL,NULL,NULL,NULL),('500200','县','500000',1,NULL,NULL,NULL,NULL,NULL,NULL),('500228','梁平县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500229','城口县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500230','丰都县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500231','垫江县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500232','武隆县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500233','忠县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500235','云阳县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500236','奉节县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500237','巫山县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500238','巫溪县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500240','石柱土家族自治县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500241','秀山土家族苗族自治县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500242','酉阳土家族苗族自治县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('500243','彭水苗族土家族自治县','500200',1,NULL,NULL,NULL,NULL,NULL,NULL),('510000','四川省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('510100','成都市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('510104','锦江区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510105','青羊区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510106','金牛区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510107','武侯区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510108','成华区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510112','龙泉驿区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510113','青白江区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510114','新都区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510115','温江区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510116','双流区','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510121','金堂县','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510124','郫县','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510129','大邑县','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510131','蒲江县','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510132','新津县','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510181','都江堰市','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510182','彭州市','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510183','邛崃市','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510184','崇州市','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510185','简阳市','510100',1,NULL,NULL,NULL,NULL,NULL,NULL),('510300','自贡市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('510302','自流井区','510300',1,NULL,NULL,NULL,NULL,NULL,NULL),('510303','贡井区','510300',1,NULL,NULL,NULL,NULL,NULL,NULL),('510304','大安区','510300',1,NULL,NULL,NULL,NULL,NULL,NULL),('510311','沿滩区','510300',1,NULL,NULL,NULL,NULL,NULL,NULL),('510321','荣县','510300',1,NULL,NULL,NULL,NULL,NULL,NULL),('510322','富顺县','510300',1,NULL,NULL,NULL,NULL,NULL,NULL),('510400','攀枝花市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('510402','东区','510400',1,NULL,NULL,NULL,NULL,NULL,NULL),('510403','西区','510400',1,NULL,NULL,NULL,NULL,NULL,NULL),('510411','仁和区','510400',1,NULL,NULL,NULL,NULL,NULL,NULL),('510421','米易县','510400',1,NULL,NULL,NULL,NULL,NULL,NULL),('510422','盐边县','510400',1,NULL,NULL,NULL,NULL,NULL,NULL),('510500','泸州市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('510502','江阳区','510500',1,NULL,NULL,NULL,NULL,NULL,NULL),('510503','纳溪区','510500',1,NULL,NULL,NULL,NULL,NULL,NULL),('510504','龙马潭区','510500',1,NULL,NULL,NULL,NULL,NULL,NULL),('510521','泸县','510500',1,NULL,NULL,NULL,NULL,NULL,NULL),('510522','合江县','510500',1,NULL,NULL,NULL,NULL,NULL,NULL),('510524','叙永县','510500',1,NULL,NULL,NULL,NULL,NULL,NULL),('510525','古蔺县','510500',1,NULL,NULL,NULL,NULL,NULL,NULL),('510600','德阳市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('510603','旌阳区','510600',1,NULL,NULL,NULL,NULL,NULL,NULL),('510623','中江县','510600',1,NULL,NULL,NULL,NULL,NULL,NULL),('510626','罗江县','510600',1,NULL,NULL,NULL,NULL,NULL,NULL),('510681','广汉市','510600',1,NULL,NULL,NULL,NULL,NULL,NULL),('510682','什邡市','510600',1,NULL,NULL,NULL,NULL,NULL,NULL),('510683','绵竹市','510600',1,NULL,NULL,NULL,NULL,NULL,NULL),('510700','绵阳市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('510703','涪城区','510700',1,NULL,NULL,NULL,NULL,NULL,NULL),('510704','游仙区','510700',1,NULL,NULL,NULL,NULL,NULL,NULL),('510705','安州区','510700',1,NULL,NULL,NULL,NULL,NULL,NULL),('510722','三台县','510700',1,NULL,NULL,NULL,NULL,NULL,NULL),('510723','盐亭县','510700',1,NULL,NULL,NULL,NULL,NULL,NULL),('510725','梓潼县','510700',1,NULL,NULL,NULL,NULL,NULL,NULL),('510726','北川羌族自治县','510700',1,NULL,NULL,NULL,NULL,NULL,NULL),('510727','平武县','510700',1,NULL,NULL,NULL,NULL,NULL,NULL),('510781','江油市','510700',1,NULL,NULL,NULL,NULL,NULL,NULL),('510800','广元市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('510802','利州区','510800',1,NULL,NULL,NULL,NULL,NULL,NULL),('510811','昭化区','510800',1,NULL,NULL,NULL,NULL,NULL,NULL),('510812','朝天区','510800',1,NULL,NULL,NULL,NULL,NULL,NULL),('510821','旺苍县','510800',1,NULL,NULL,NULL,NULL,NULL,NULL),('510822','青川县','510800',1,NULL,NULL,NULL,NULL,NULL,NULL),('510823','剑阁县','510800',1,NULL,NULL,NULL,NULL,NULL,NULL),('510824','苍溪县','510800',1,NULL,NULL,NULL,NULL,NULL,NULL),('510900','遂宁市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('510903','船山区','510900',1,NULL,NULL,NULL,NULL,NULL,NULL),('510904','安居区','510900',1,NULL,NULL,NULL,NULL,NULL,NULL),('510921','蓬溪县','510900',1,NULL,NULL,NULL,NULL,NULL,NULL),('510922','射洪县','510900',1,NULL,NULL,NULL,NULL,NULL,NULL),('510923','大英县','510900',1,NULL,NULL,NULL,NULL,NULL,NULL),('511000','内江市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511002','市中区','511000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511011','东兴区','511000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511024','威远县','511000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511025','资中县','511000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511028','隆昌县','511000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511100','乐山市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511102','市中区','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511111','沙湾区','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511112','五通桥区','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511113','金口河区','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511123','犍为县','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511124','井研县','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511126','夹江县','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511129','沐川县','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511132','峨边彝族自治县','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511133','马边彝族自治县','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511181','峨眉山市','511100',1,NULL,NULL,NULL,NULL,NULL,NULL),('511300','南充市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511302','顺庆区','511300',1,NULL,NULL,NULL,NULL,NULL,NULL),('511303','高坪区','511300',1,NULL,NULL,NULL,NULL,NULL,NULL),('511304','嘉陵区','511300',1,NULL,NULL,NULL,NULL,NULL,NULL),('511321','南部县','511300',1,NULL,NULL,NULL,NULL,NULL,NULL),('511322','营山县','511300',1,NULL,NULL,NULL,NULL,NULL,NULL),('511323','蓬安县','511300',1,NULL,NULL,NULL,NULL,NULL,NULL),('511324','仪陇县','511300',1,NULL,NULL,NULL,NULL,NULL,NULL),('511325','西充县','511300',1,NULL,NULL,NULL,NULL,NULL,NULL),('511381','阆中市','511300',1,NULL,NULL,NULL,NULL,NULL,NULL),('511400','眉山市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511402','东坡区','511400',1,NULL,NULL,NULL,NULL,NULL,NULL),('511403','彭山区','511400',1,NULL,NULL,NULL,NULL,NULL,NULL),('511421','仁寿县','511400',1,NULL,NULL,NULL,NULL,NULL,NULL),('511423','洪雅县','511400',1,NULL,NULL,NULL,NULL,NULL,NULL),('511424','丹棱县','511400',1,NULL,NULL,NULL,NULL,NULL,NULL),('511425','青神县','511400',1,NULL,NULL,NULL,NULL,NULL,NULL),('511500','宜宾市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511502','翠屏区','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511503','南溪区','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511521','宜宾县','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511523','江安县','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511524','长宁县','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511525','高县','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511526','珙县','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511527','筠连县','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511528','兴文县','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511529','屏山县','511500',1,NULL,NULL,NULL,NULL,NULL,NULL),('511600','广安市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511602','广安区','511600',1,NULL,NULL,NULL,NULL,NULL,NULL),('511603','前锋区','511600',1,NULL,NULL,NULL,NULL,NULL,NULL),('511621','岳池县','511600',1,NULL,NULL,NULL,NULL,NULL,NULL),('511622','武胜县','511600',1,NULL,NULL,NULL,NULL,NULL,NULL),('511623','邻水县','511600',1,NULL,NULL,NULL,NULL,NULL,NULL),('511681','华蓥市','511600',1,NULL,NULL,NULL,NULL,NULL,NULL),('511700','达州市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511702','通川区','511700',1,NULL,NULL,NULL,NULL,NULL,NULL),('511703','达川区','511700',1,NULL,NULL,NULL,NULL,NULL,NULL),('511722','宣汉县','511700',1,NULL,NULL,NULL,NULL,NULL,NULL),('511723','开江县','511700',1,NULL,NULL,NULL,NULL,NULL,NULL),('511724','大竹县','511700',1,NULL,NULL,NULL,NULL,NULL,NULL),('511725','渠县','511700',1,NULL,NULL,NULL,NULL,NULL,NULL),('511781','万源市','511700',1,NULL,NULL,NULL,NULL,NULL,NULL),('511800','雅安市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511802','雨城区','511800',1,NULL,NULL,NULL,NULL,NULL,NULL),('511803','名山区','511800',1,NULL,NULL,NULL,NULL,NULL,NULL),('511822','荥经县','511800',1,NULL,NULL,NULL,NULL,NULL,NULL),('511823','汉源县','511800',1,NULL,NULL,NULL,NULL,NULL,NULL),('511824','石棉县','511800',1,NULL,NULL,NULL,NULL,NULL,NULL),('511825','天全县','511800',1,NULL,NULL,NULL,NULL,NULL,NULL),('511826','芦山县','511800',1,NULL,NULL,NULL,NULL,NULL,NULL),('511827','宝兴县','511800',1,NULL,NULL,NULL,NULL,NULL,NULL),('511900','巴中市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('511902','巴州区','511900',1,NULL,NULL,NULL,NULL,NULL,NULL),('511903','恩阳区','511900',1,NULL,NULL,NULL,NULL,NULL,NULL),('511921','通江县','511900',1,NULL,NULL,NULL,NULL,NULL,NULL),('511922','南江县','511900',1,NULL,NULL,NULL,NULL,NULL,NULL),('511923','平昌县','511900',1,NULL,NULL,NULL,NULL,NULL,NULL),('512000','资阳市','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('512002','雁江区','512000',1,NULL,NULL,NULL,NULL,NULL,NULL),('512021','安岳县','512000',1,NULL,NULL,NULL,NULL,NULL,NULL),('512022','乐至县','512000',1,NULL,NULL,NULL,NULL,NULL,NULL),('513200','阿坝藏族羌族自治州','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('513201','马尔康市','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513221','汶川县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513222','理县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513223','茂县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513224','松潘县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513225','九寨沟县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513226','金川县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513227','小金县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513228','黑水县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513230','壤塘县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513231','阿坝县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513232','若尔盖县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513233','红原县','513200',1,NULL,NULL,NULL,NULL,NULL,NULL),('513300','甘孜藏族自治州','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('513301','康定市','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513322','泸定县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513323','丹巴县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513324','九龙县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513325','雅江县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513326','道孚县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513327','炉霍县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513328','甘孜县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513329','新龙县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513330','德格县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513331','白玉县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513332','石渠县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513333','色达县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513334','理塘县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513335','巴塘县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513336','乡城县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513337','稻城县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513338','得荣县','513300',1,NULL,NULL,NULL,NULL,NULL,NULL),('513400','凉山彝族自治州','510000',1,NULL,NULL,NULL,NULL,NULL,NULL),('513401','西昌市','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513422','木里藏族自治县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513423','盐源县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513424','德昌县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513425','会理县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513426','会东县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513427','宁南县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513428','普格县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513429','布拖县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513430','金阳县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513431','昭觉县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513432','喜德县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513433','冕宁县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513434','越西县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513435','甘洛县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513436','美姑县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('513437','雷波县','513400',1,NULL,NULL,NULL,NULL,NULL,NULL),('520000','贵州省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('520100','贵阳市','520000',1,NULL,NULL,NULL,NULL,NULL,NULL),('520102','南明区','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520103','云岩区','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520111','花溪区','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520112','乌当区','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520113','白云区','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520115','观山湖区','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520121','开阳县','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520122','息烽县','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520123','修文县','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520181','清镇市','520100',1,NULL,NULL,NULL,NULL,NULL,NULL),('520200','六盘水市','520000',1,NULL,NULL,NULL,NULL,NULL,NULL),('520201','钟山区','520200',1,NULL,NULL,NULL,NULL,NULL,NULL),('520203','六枝特区','520200',1,NULL,NULL,NULL,NULL,NULL,NULL),('520221','水城县','520200',1,NULL,NULL,NULL,NULL,NULL,NULL),('520222','盘县','520200',1,NULL,NULL,NULL,NULL,NULL,NULL),('520300','遵义市','520000',1,NULL,NULL,NULL,NULL,NULL,NULL),('520302','红花岗区','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520303','汇川区','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520304','播州区','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520322','桐梓县','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520323','绥阳县','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520324','正安县','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520325','道真仡佬族苗族自治县','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520326','务川仡佬族苗族自治县','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520327','凤冈县','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520328','湄潭县','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520329','余庆县','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520330','习水县','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520381','赤水市','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520382','仁怀市','520300',1,NULL,NULL,NULL,NULL,NULL,NULL),('520400','安顺市','520000',1,NULL,NULL,NULL,NULL,NULL,NULL),('520402','西秀区','520400',1,NULL,NULL,NULL,NULL,NULL,NULL),('520403','平坝区','520400',1,NULL,NULL,NULL,NULL,NULL,NULL),('520422','普定县','520400',1,NULL,NULL,NULL,NULL,NULL,NULL),('520423','镇宁布依族苗族自治县','520400',1,NULL,NULL,NULL,NULL,NULL,NULL),('520424','关岭布依族苗族自治县','520400',1,NULL,NULL,NULL,NULL,NULL,NULL),('520425','紫云苗族布依族自治县','520400',1,NULL,NULL,NULL,NULL,NULL,NULL),('520500','毕节市','520000',1,NULL,NULL,NULL,NULL,NULL,NULL),('520502','七星关区','520500',1,NULL,NULL,NULL,NULL,NULL,NULL),('520521','大方县','520500',1,NULL,NULL,NULL,NULL,NULL,NULL),('520522','黔西县','520500',1,NULL,NULL,NULL,NULL,NULL,NULL),('520523','金沙县','520500',1,NULL,NULL,NULL,NULL,NULL,NULL),('520524','织金县','520500',1,NULL,NULL,NULL,NULL,NULL,NULL),('520525','纳雍县','520500',1,NULL,NULL,NULL,NULL,NULL,NULL),('520526','威宁彝族回族苗族自治县','520500',1,NULL,NULL,NULL,NULL,NULL,NULL),('520527','赫章县','520500',1,NULL,NULL,NULL,NULL,NULL,NULL),('520600','铜仁市','520000',1,NULL,NULL,NULL,NULL,NULL,NULL),('520602','碧江区','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('520603','万山区','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('520621','江口县','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('520622','玉屏侗族自治县','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('520623','石阡县','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('520624','思南县','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('520625','印江土家族苗族自治县','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('520626','德江县','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('520627','沿河土家族自治县','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('520628','松桃苗族自治县','520600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522300','黔西南布依族苗族自治州','520000',1,NULL,NULL,NULL,NULL,NULL,NULL),('522301','兴义市','522300',1,NULL,NULL,NULL,NULL,NULL,NULL),('522322','兴仁县','522300',1,NULL,NULL,NULL,NULL,NULL,NULL),('522323','普安县','522300',1,NULL,NULL,NULL,NULL,NULL,NULL),('522324','晴隆县','522300',1,NULL,NULL,NULL,NULL,NULL,NULL),('522325','贞丰县','522300',1,NULL,NULL,NULL,NULL,NULL,NULL),('522326','望谟县','522300',1,NULL,NULL,NULL,NULL,NULL,NULL),('522327','册亨县','522300',1,NULL,NULL,NULL,NULL,NULL,NULL),('522328','安龙县','522300',1,NULL,NULL,NULL,NULL,NULL,NULL),('522600','黔东南苗族侗族自治州','520000',1,NULL,NULL,NULL,NULL,NULL,NULL),('522601','凯里市','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522622','黄平县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522623','施秉县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522624','三穗县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522625','镇远县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522626','岑巩县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522627','天柱县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522628','锦屏县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522629','剑河县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522630','台江县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522631','黎平县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522632','榕江县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522633','从江县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522634','雷山县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522635','麻江县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522636','丹寨县','522600',1,NULL,NULL,NULL,NULL,NULL,NULL),('522700','黔南布依族苗族自治州','520000',1,NULL,NULL,NULL,NULL,NULL,NULL),('522701','都匀市','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522702','福泉市','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522722','荔波县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522723','贵定县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522725','瓮安县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522726','独山县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522727','平塘县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522728','罗甸县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522729','长顺县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522730','龙里县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522731','惠水县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('522732','三都水族自治县','522700',1,NULL,NULL,NULL,NULL,NULL,NULL),('530000','云南省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('530100','昆明市','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('530102','五华区','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530103','盘龙区','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530111','官渡区','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530112','西山区','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530113','东川区','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530114','呈贡区','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530122','晋宁县','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530124','富民县','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530125','宜良县','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530126','石林彝族自治县','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530127','嵩明县','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530128','禄劝彝族苗族自治县','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530129','寻甸回族彝族自治县','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530181','安宁市','530100',1,NULL,NULL,NULL,NULL,NULL,NULL),('530300','曲靖市','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('530302','麒麟区','530300',1,NULL,NULL,NULL,NULL,NULL,NULL),('530303','沾益区','530300',1,NULL,NULL,NULL,NULL,NULL,NULL),('530321','马龙县','530300',1,NULL,NULL,NULL,NULL,NULL,NULL),('530322','陆良县','530300',1,NULL,NULL,NULL,NULL,NULL,NULL),('530323','师宗县','530300',1,NULL,NULL,NULL,NULL,NULL,NULL),('530324','罗平县','530300',1,NULL,NULL,NULL,NULL,NULL,NULL),('530325','富源县','530300',1,NULL,NULL,NULL,NULL,NULL,NULL),('530326','会泽县','530300',1,NULL,NULL,NULL,NULL,NULL,NULL),('530381','宣威市','530300',1,NULL,NULL,NULL,NULL,NULL,NULL),('530400','玉溪市','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('530402','红塔区','530400',1,NULL,NULL,NULL,NULL,NULL,NULL),('530403','江川区','530400',1,NULL,NULL,NULL,NULL,NULL,NULL),('530422','澄江县','530400',1,NULL,NULL,NULL,NULL,NULL,NULL),('530423','通海县','530400',1,NULL,NULL,NULL,NULL,NULL,NULL),('530424','华宁县','530400',1,NULL,NULL,NULL,NULL,NULL,NULL),('530425','易门县','530400',1,NULL,NULL,NULL,NULL,NULL,NULL),('530426','峨山彝族自治县','530400',1,NULL,NULL,NULL,NULL,NULL,NULL),('530427','新平彝族傣族自治县','530400',1,NULL,NULL,NULL,NULL,NULL,NULL),('530428','元江哈尼族彝族傣族自治县','530400',1,NULL,NULL,NULL,NULL,NULL,NULL),('530500','保山市','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('530502','隆阳区','530500',1,NULL,NULL,NULL,NULL,NULL,NULL),('530521','施甸县','530500',1,NULL,NULL,NULL,NULL,NULL,NULL),('530523','龙陵县','530500',1,NULL,NULL,NULL,NULL,NULL,NULL),('530524','昌宁县','530500',1,NULL,NULL,NULL,NULL,NULL,NULL),('530581','腾冲市','530500',1,NULL,NULL,NULL,NULL,NULL,NULL),('530600','昭通市','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('530602','昭阳区','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530621','鲁甸县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530622','巧家县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530623','盐津县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530624','大关县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530625','永善县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530626','绥江县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530627','镇雄县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530628','彝良县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530629','威信县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530630','水富县','530600',1,NULL,NULL,NULL,NULL,NULL,NULL),('530700','丽江市','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('530702','古城区','530700',1,NULL,NULL,NULL,NULL,NULL,NULL),('530721','玉龙纳西族自治县','530700',1,NULL,NULL,NULL,NULL,NULL,NULL),('530722','永胜县','530700',1,NULL,NULL,NULL,NULL,NULL,NULL),('530723','华坪县','530700',1,NULL,NULL,NULL,NULL,NULL,NULL),('530724','宁蒗彝族自治县','530700',1,NULL,NULL,NULL,NULL,NULL,NULL),('530800','普洱市','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('530802','思茅区','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530821','宁洱哈尼族彝族自治县','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530822','墨江哈尼族自治县','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530823','景东彝族自治县','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530824','景谷傣族彝族自治县','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530825','镇沅彝族哈尼族拉祜族自治县','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530826','江城哈尼族彝族自治县','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530827','孟连傣族拉祜族佤族自治县','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530828','澜沧拉祜族自治县','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530829','西盟佤族自治县','530800',1,NULL,NULL,NULL,NULL,NULL,NULL),('530900','临沧市','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('530902','临翔区','530900',1,NULL,NULL,NULL,NULL,NULL,NULL),('530921','凤庆县','530900',1,NULL,NULL,NULL,NULL,NULL,NULL),('530922','云县','530900',1,NULL,NULL,NULL,NULL,NULL,NULL),('530923','永德县','530900',1,NULL,NULL,NULL,NULL,NULL,NULL),('530924','镇康县','530900',1,NULL,NULL,NULL,NULL,NULL,NULL),('530925','双江拉祜族佤族布朗族傣族自治县','530900',1,NULL,NULL,NULL,NULL,NULL,NULL),('530926','耿马傣族佤族自治县','530900',1,NULL,NULL,NULL,NULL,NULL,NULL),('530927','沧源佤族自治县','530900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532300','楚雄彝族自治州','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('532301','楚雄市','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532322','双柏县','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532323','牟定县','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532324','南华县','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532325','姚安县','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532326','大姚县','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532327','永仁县','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532328','元谋县','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532329','武定县','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532331','禄丰县','532300',1,NULL,NULL,NULL,NULL,NULL,NULL),('532500','红河哈尼族彝族自治州','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('532501','个旧市','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532502','开远市','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532503','蒙自市','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532504','弥勒市','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532523','屏边苗族自治县','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532524','建水县','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532525','石屏县','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532527','泸西县','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532528','元阳县','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532529','红河县','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532530','金平苗族瑶族傣族自治县','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532531','绿春县','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532532','河口瑶族自治县','532500',1,NULL,NULL,NULL,NULL,NULL,NULL),('532600','文山壮族苗族自治州','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('532601','文山市','532600',1,NULL,NULL,NULL,NULL,NULL,NULL),('532622','砚山县','532600',1,NULL,NULL,NULL,NULL,NULL,NULL),('532623','西畴县','532600',1,NULL,NULL,NULL,NULL,NULL,NULL),('532624','麻栗坡县','532600',1,NULL,NULL,NULL,NULL,NULL,NULL),('532625','马关县','532600',1,NULL,NULL,NULL,NULL,NULL,NULL),('532626','丘北县','532600',1,NULL,NULL,NULL,NULL,NULL,NULL),('532627','广南县','532600',1,NULL,NULL,NULL,NULL,NULL,NULL),('532628','富宁县','532600',1,NULL,NULL,NULL,NULL,NULL,NULL),('532800','西双版纳傣族自治州','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('532801','景洪市','532800',1,NULL,NULL,NULL,NULL,NULL,NULL),('532822','勐海县','532800',1,NULL,NULL,NULL,NULL,NULL,NULL),('532823','勐腊县','532800',1,NULL,NULL,NULL,NULL,NULL,NULL),('532900','大理白族自治州','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('532901','大理市','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532922','漾濞彝族自治县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532923','祥云县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532924','宾川县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532925','弥渡县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532926','南涧彝族自治县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532927','巍山彝族回族自治县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532928','永平县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532929','云龙县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532930','洱源县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532931','剑川县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('532932','鹤庆县','532900',1,NULL,NULL,NULL,NULL,NULL,NULL),('533100','德宏傣族景颇族自治州','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('533102','瑞丽市','533100',1,NULL,NULL,NULL,NULL,NULL,NULL),('533103','芒市','533100',1,NULL,NULL,NULL,NULL,NULL,NULL),('533122','梁河县','533100',1,NULL,NULL,NULL,NULL,NULL,NULL),('533123','盈江县','533100',1,NULL,NULL,NULL,NULL,NULL,NULL),('533124','陇川县','533100',1,NULL,NULL,NULL,NULL,NULL,NULL),('533300','怒江傈僳族自治州','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('533301','泸水市','533300',1,NULL,NULL,NULL,NULL,NULL,NULL),('533323','福贡县','533300',1,NULL,NULL,NULL,NULL,NULL,NULL),('533324','贡山独龙族怒族自治县','533300',1,NULL,NULL,NULL,NULL,NULL,NULL),('533325','兰坪白族普米族自治县','533300',1,NULL,NULL,NULL,NULL,NULL,NULL),('533400','迪庆藏族自治州','530000',1,NULL,NULL,NULL,NULL,NULL,NULL),('533401','香格里拉市','533400',1,NULL,NULL,NULL,NULL,NULL,NULL),('533422','德钦县','533400',1,NULL,NULL,NULL,NULL,NULL,NULL),('533423','维西傈僳族自治县','533400',1,NULL,NULL,NULL,NULL,NULL,NULL),('540000','西藏自治区',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('540100','拉萨市','540000',1,NULL,NULL,NULL,NULL,NULL,NULL),('540102','城关区','540100',1,NULL,NULL,NULL,NULL,NULL,NULL),('540103','堆龙德庆区','540100',1,NULL,NULL,NULL,NULL,NULL,NULL),('540121','林周县','540100',1,NULL,NULL,NULL,NULL,NULL,NULL),('540122','当雄县','540100',1,NULL,NULL,NULL,NULL,NULL,NULL),('540123','尼木县','540100',1,NULL,NULL,NULL,NULL,NULL,NULL),('540124','曲水县','540100',1,NULL,NULL,NULL,NULL,NULL,NULL),('540126','达孜县','540100',1,NULL,NULL,NULL,NULL,NULL,NULL),('540127','墨竹工卡县','540100',1,NULL,NULL,NULL,NULL,NULL,NULL),('540200','日喀则市','540000',1,NULL,NULL,NULL,NULL,NULL,NULL),('540202','桑珠孜区','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540221','南木林县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540222','江孜县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540223','定日县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540224','萨迦县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540225','拉孜县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540226','昂仁县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540227','谢通门县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540228','白朗县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540229','仁布县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540230','康马县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540231','定结县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540232','仲巴县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540233','亚东县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540234','吉隆县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540235','聂拉木县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540236','萨嘎县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540237','岗巴县','540200',1,NULL,NULL,NULL,NULL,NULL,NULL),('540300','昌都市','540000',1,NULL,NULL,NULL,NULL,NULL,NULL),('540302','卡若区','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540321','江达县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540322','贡觉县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540323','类乌齐县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540324','丁青县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540325','察雅县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540326','八宿县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540327','左贡县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540328','芒康县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540329','洛隆县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540330','边坝县','540300',1,NULL,NULL,NULL,NULL,NULL,NULL),('540400','林芝市','540000',1,NULL,NULL,NULL,NULL,NULL,NULL),('540402','巴宜区','540400',1,NULL,NULL,NULL,NULL,NULL,NULL),('540421','工布江达县','540400',1,NULL,NULL,NULL,NULL,NULL,NULL),('540422','米林县','540400',1,NULL,NULL,NULL,NULL,NULL,NULL),('540423','墨脱县','540400',1,NULL,NULL,NULL,NULL,NULL,NULL),('540424','波密县','540400',1,NULL,NULL,NULL,NULL,NULL,NULL),('540425','察隅县','540400',1,NULL,NULL,NULL,NULL,NULL,NULL),('540426','朗县','540400',1,NULL,NULL,NULL,NULL,NULL,NULL),('540500','山南市','540000',1,NULL,NULL,NULL,NULL,NULL,NULL),('540502','乃东区','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540521','扎囊县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540522','贡嘎县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540523','桑日县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540524','琼结县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540525','曲松县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540526','措美县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540527','洛扎县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540528','加查县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540529','隆子县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540530','错那县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('540531','浪卡子县','540500',1,NULL,NULL,NULL,NULL,NULL,NULL),('542400','那曲地区','540000',1,NULL,NULL,NULL,NULL,NULL,NULL),('542421','那曲县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542422','嘉黎县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542423','比如县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542424','聂荣县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542425','安多县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542426','申扎县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542427','索县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542428','班戈县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542429','巴青县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542430','尼玛县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542431','双湖县','542400',1,NULL,NULL,NULL,NULL,NULL,NULL),('542500','阿里地区','540000',1,NULL,NULL,NULL,NULL,NULL,NULL),('542521','普兰县','542500',1,NULL,NULL,NULL,NULL,NULL,NULL),('542522','札达县','542500',1,NULL,NULL,NULL,NULL,NULL,NULL),('542523','噶尔县','542500',1,NULL,NULL,NULL,NULL,NULL,NULL),('542524','日土县','542500',1,NULL,NULL,NULL,NULL,NULL,NULL),('542525','革吉县','542500',1,NULL,NULL,NULL,NULL,NULL,NULL),('542526','改则县','542500',1,NULL,NULL,NULL,NULL,NULL,NULL),('542527','措勤县','542500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610000','陕西省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('610100','西安市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('610102','新城区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610103','碑林区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610104','莲湖区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610111','灞桥区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610112','未央区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610113','雁塔区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610114','阎良区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610115','临潼区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610116','长安区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610117','高陵区','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610122','蓝田县','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610124','周至县','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610125','户县','610100',1,NULL,NULL,NULL,NULL,NULL,NULL),('610200','铜川市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('610202','王益区','610200',1,NULL,NULL,NULL,NULL,NULL,NULL),('610203','印台区','610200',1,NULL,NULL,NULL,NULL,NULL,NULL),('610204','耀州区','610200',1,NULL,NULL,NULL,NULL,NULL,NULL),('610222','宜君县','610200',1,NULL,NULL,NULL,NULL,NULL,NULL),('610300','宝鸡市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('610302','渭滨区','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610303','金台区','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610304','陈仓区','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610322','凤翔县','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610323','岐山县','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610324','扶风县','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610326','眉县','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610327','陇县','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610328','千阳县','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610329','麟游县','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610330','凤县','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610331','太白县','610300',1,NULL,NULL,NULL,NULL,NULL,NULL),('610400','咸阳市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('610402','秦都区','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610403','杨陵区','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610404','渭城区','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610422','三原县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610423','泾阳县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610424','乾县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610425','礼泉县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610426','永寿县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610427','彬县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610428','长武县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610429','旬邑县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610430','淳化县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610431','武功县','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610481','兴平市','610400',1,NULL,NULL,NULL,NULL,NULL,NULL),('610500','渭南市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('610502','临渭区','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610503','华州区','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610522','潼关县','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610523','大荔县','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610524','合阳县','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610525','澄城县','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610526','蒲城县','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610527','白水县','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610528','富平县','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610581','韩城市','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610582','华阴市','610500',1,NULL,NULL,NULL,NULL,NULL,NULL),('610600','延安市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('610602','宝塔区','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610603','安塞区','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610621','延长县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610622','延川县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610623','子长县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610625','志丹县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610626','吴起县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610627','甘泉县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610628','富县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610629','洛川县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610630','宜川县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610631','黄龙县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610632','黄陵县','610600',1,NULL,NULL,NULL,NULL,NULL,NULL),('610700','汉中市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('610702','汉台区','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610721','南郑县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610722','城固县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610723','洋县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610724','西乡县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610725','勉县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610726','宁强县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610727','略阳县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610728','镇巴县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610729','留坝县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610730','佛坪县','610700',1,NULL,NULL,NULL,NULL,NULL,NULL),('610800','榆林市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('610802','榆阳区','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610803','横山区','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610821','神木县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610822','府谷县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610824','靖边县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610825','定边县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610826','绥德县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610827','米脂县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610828','佳县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610829','吴堡县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610830','清涧县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610831','子洲县','610800',1,NULL,NULL,NULL,NULL,NULL,NULL),('610900','安康市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('610902','汉滨区','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('610921','汉阴县','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('610922','石泉县','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('610923','宁陕县','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('610924','紫阳县','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('610925','岚皋县','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('610926','平利县','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('610927','镇坪县','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('610928','旬阳县','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('610929','白河县','610900',1,NULL,NULL,NULL,NULL,NULL,NULL),('611000','商洛市','610000',1,NULL,NULL,NULL,NULL,NULL,NULL),('611002','商州区','611000',1,NULL,NULL,NULL,NULL,NULL,NULL),('611021','洛南县','611000',1,NULL,NULL,NULL,NULL,NULL,NULL),('611022','丹凤县','611000',1,NULL,NULL,NULL,NULL,NULL,NULL),('611023','商南县','611000',1,NULL,NULL,NULL,NULL,NULL,NULL),('611024','山阳县','611000',1,NULL,NULL,NULL,NULL,NULL,NULL),('611025','镇安县','611000',1,NULL,NULL,NULL,NULL,NULL,NULL),('611026','柞水县','611000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620000','甘肃省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('620100','兰州市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620102','城关区','620100',1,NULL,NULL,NULL,NULL,NULL,NULL),('620103','七里河区','620100',1,NULL,NULL,NULL,NULL,NULL,NULL),('620104','西固区','620100',1,NULL,NULL,NULL,NULL,NULL,NULL),('620105','安宁区','620100',1,NULL,NULL,NULL,NULL,NULL,NULL),('620111','红古区','620100',1,NULL,NULL,NULL,NULL,NULL,NULL),('620121','永登县','620100',1,NULL,NULL,NULL,NULL,NULL,NULL),('620122','皋兰县','620100',1,NULL,NULL,NULL,NULL,NULL,NULL),('620123','榆中县','620100',1,NULL,NULL,NULL,NULL,NULL,NULL),('620200','嘉峪关市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620300','金昌市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620302','金川区','620300',1,NULL,NULL,NULL,NULL,NULL,NULL),('620321','永昌县','620300',1,NULL,NULL,NULL,NULL,NULL,NULL),('620400','白银市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620402','白银区','620400',1,NULL,NULL,NULL,NULL,NULL,NULL),('620403','平川区','620400',1,NULL,NULL,NULL,NULL,NULL,NULL),('620421','靖远县','620400',1,NULL,NULL,NULL,NULL,NULL,NULL),('620422','会宁县','620400',1,NULL,NULL,NULL,NULL,NULL,NULL),('620423','景泰县','620400',1,NULL,NULL,NULL,NULL,NULL,NULL),('620500','天水市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620502','秦州区','620500',1,NULL,NULL,NULL,NULL,NULL,NULL),('620503','麦积区','620500',1,NULL,NULL,NULL,NULL,NULL,NULL),('620521','清水县','620500',1,NULL,NULL,NULL,NULL,NULL,NULL),('620522','秦安县','620500',1,NULL,NULL,NULL,NULL,NULL,NULL),('620523','甘谷县','620500',1,NULL,NULL,NULL,NULL,NULL,NULL),('620524','武山县','620500',1,NULL,NULL,NULL,NULL,NULL,NULL),('620525','张家川回族自治县','620500',1,NULL,NULL,NULL,NULL,NULL,NULL),('620600','武威市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620602','凉州区','620600',1,NULL,NULL,NULL,NULL,NULL,NULL),('620621','民勤县','620600',1,NULL,NULL,NULL,NULL,NULL,NULL),('620622','古浪县','620600',1,NULL,NULL,NULL,NULL,NULL,NULL),('620623','天祝藏族自治县','620600',1,NULL,NULL,NULL,NULL,NULL,NULL),('620700','张掖市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620702','甘州区','620700',1,NULL,NULL,NULL,NULL,NULL,NULL),('620721','肃南裕固族自治县','620700',1,NULL,NULL,NULL,NULL,NULL,NULL),('620722','民乐县','620700',1,NULL,NULL,NULL,NULL,NULL,NULL),('620723','临泽县','620700',1,NULL,NULL,NULL,NULL,NULL,NULL),('620724','高台县','620700',1,NULL,NULL,NULL,NULL,NULL,NULL),('620725','山丹县','620700',1,NULL,NULL,NULL,NULL,NULL,NULL),('620800','平凉市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620802','崆峒区','620800',1,NULL,NULL,NULL,NULL,NULL,NULL),('620821','泾川县','620800',1,NULL,NULL,NULL,NULL,NULL,NULL),('620822','灵台县','620800',1,NULL,NULL,NULL,NULL,NULL,NULL),('620823','崇信县','620800',1,NULL,NULL,NULL,NULL,NULL,NULL),('620824','华亭县','620800',1,NULL,NULL,NULL,NULL,NULL,NULL),('620825','庄浪县','620800',1,NULL,NULL,NULL,NULL,NULL,NULL),('620826','静宁县','620800',1,NULL,NULL,NULL,NULL,NULL,NULL),('620900','酒泉市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('620902','肃州区','620900',1,NULL,NULL,NULL,NULL,NULL,NULL),('620921','金塔县','620900',1,NULL,NULL,NULL,NULL,NULL,NULL),('620922','瓜州县','620900',1,NULL,NULL,NULL,NULL,NULL,NULL),('620923','肃北蒙古族自治县','620900',1,NULL,NULL,NULL,NULL,NULL,NULL),('620924','阿克塞哈萨克族自治县','620900',1,NULL,NULL,NULL,NULL,NULL,NULL),('620981','玉门市','620900',1,NULL,NULL,NULL,NULL,NULL,NULL),('620982','敦煌市','620900',1,NULL,NULL,NULL,NULL,NULL,NULL),('621000','庆阳市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621002','西峰区','621000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621021','庆城县','621000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621022','环县','621000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621023','华池县','621000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621024','合水县','621000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621025','正宁县','621000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621026','宁县','621000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621027','镇原县','621000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621100','定西市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621102','安定区','621100',1,NULL,NULL,NULL,NULL,NULL,NULL),('621121','通渭县','621100',1,NULL,NULL,NULL,NULL,NULL,NULL),('621122','陇西县','621100',1,NULL,NULL,NULL,NULL,NULL,NULL),('621123','渭源县','621100',1,NULL,NULL,NULL,NULL,NULL,NULL),('621124','临洮县','621100',1,NULL,NULL,NULL,NULL,NULL,NULL),('621125','漳县','621100',1,NULL,NULL,NULL,NULL,NULL,NULL),('621126','岷县','621100',1,NULL,NULL,NULL,NULL,NULL,NULL),('621200','陇南市','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('621202','武都区','621200',1,NULL,NULL,NULL,NULL,NULL,NULL),('621221','成县','621200',1,NULL,NULL,NULL,NULL,NULL,NULL),('621222','文县','621200',1,NULL,NULL,NULL,NULL,NULL,NULL),('621223','宕昌县','621200',1,NULL,NULL,NULL,NULL,NULL,NULL),('621224','康县','621200',1,NULL,NULL,NULL,NULL,NULL,NULL),('621225','西和县','621200',1,NULL,NULL,NULL,NULL,NULL,NULL),('621226','礼县','621200',1,NULL,NULL,NULL,NULL,NULL,NULL),('621227','徽县','621200',1,NULL,NULL,NULL,NULL,NULL,NULL),('621228','两当县','621200',1,NULL,NULL,NULL,NULL,NULL,NULL),('622900','临夏回族自治州','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('622901','临夏市','622900',1,NULL,NULL,NULL,NULL,NULL,NULL),('622921','临夏县','622900',1,NULL,NULL,NULL,NULL,NULL,NULL),('622922','康乐县','622900',1,NULL,NULL,NULL,NULL,NULL,NULL),('622923','永靖县','622900',1,NULL,NULL,NULL,NULL,NULL,NULL),('622924','广河县','622900',1,NULL,NULL,NULL,NULL,NULL,NULL),('622925','和政县','622900',1,NULL,NULL,NULL,NULL,NULL,NULL),('622926','东乡族自治县','622900',1,NULL,NULL,NULL,NULL,NULL,NULL),('622927','积石山保安族东乡族撒拉族自治县','622900',1,NULL,NULL,NULL,NULL,NULL,NULL),('623000','甘南藏族自治州','620000',1,NULL,NULL,NULL,NULL,NULL,NULL),('623001','合作市','623000',1,NULL,NULL,NULL,NULL,NULL,NULL),('623021','临潭县','623000',1,NULL,NULL,NULL,NULL,NULL,NULL),('623022','卓尼县','623000',1,NULL,NULL,NULL,NULL,NULL,NULL),('623023','舟曲县','623000',1,NULL,NULL,NULL,NULL,NULL,NULL),('623024','迭部县','623000',1,NULL,NULL,NULL,NULL,NULL,NULL),('623025','玛曲县','623000',1,NULL,NULL,NULL,NULL,NULL,NULL),('623026','碌曲县','623000',1,NULL,NULL,NULL,NULL,NULL,NULL),('623027','夏河县','623000',1,NULL,NULL,NULL,NULL,NULL,NULL),('630000','青海省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('630100','西宁市','630000',1,NULL,NULL,NULL,NULL,NULL,NULL),('630102','城东区','630100',1,NULL,NULL,NULL,NULL,NULL,NULL),('630103','城中区','630100',1,NULL,NULL,NULL,NULL,NULL,NULL),('630104','城西区','630100',1,NULL,NULL,NULL,NULL,NULL,NULL),('630105','城北区','630100',1,NULL,NULL,NULL,NULL,NULL,NULL),('630121','大通回族土族自治县','630100',1,NULL,NULL,NULL,NULL,NULL,NULL),('630122','湟中县','630100',1,NULL,NULL,NULL,NULL,NULL,NULL),('630123','湟源县','630100',1,NULL,NULL,NULL,NULL,NULL,NULL),('630200','海东市','630000',1,NULL,NULL,NULL,NULL,NULL,NULL),('630202','乐都区','630200',1,NULL,NULL,NULL,NULL,NULL,NULL),('630203','平安区','630200',1,NULL,NULL,NULL,NULL,NULL,NULL),('630222','民和回族土族自治县','630200',1,NULL,NULL,NULL,NULL,NULL,NULL),('630223','互助土族自治县','630200',1,NULL,NULL,NULL,NULL,NULL,NULL),('630224','化隆回族自治县','630200',1,NULL,NULL,NULL,NULL,NULL,NULL),('630225','循化撒拉族自治县','630200',1,NULL,NULL,NULL,NULL,NULL,NULL),('632200','海北藏族自治州','630000',1,NULL,NULL,NULL,NULL,NULL,NULL),('632221','门源回族自治县','632200',1,NULL,NULL,NULL,NULL,NULL,NULL),('632222','祁连县','632200',1,NULL,NULL,NULL,NULL,NULL,NULL),('632223','海晏县','632200',1,NULL,NULL,NULL,NULL,NULL,NULL),('632224','刚察县','632200',1,NULL,NULL,NULL,NULL,NULL,NULL),('632300','黄南藏族自治州','630000',1,NULL,NULL,NULL,NULL,NULL,NULL),('632321','同仁县','632300',1,NULL,NULL,NULL,NULL,NULL,NULL),('632322','尖扎县','632300',1,NULL,NULL,NULL,NULL,NULL,NULL),('632323','泽库县','632300',1,NULL,NULL,NULL,NULL,NULL,NULL),('632324','河南蒙古族自治县','632300',1,NULL,NULL,NULL,NULL,NULL,NULL),('632500','海南藏族自治州','630000',1,NULL,NULL,NULL,NULL,NULL,NULL),('632521','共和县','632500',1,NULL,NULL,NULL,NULL,NULL,NULL),('632522','同德县','632500',1,NULL,NULL,NULL,NULL,NULL,NULL),('632523','贵德县','632500',1,NULL,NULL,NULL,NULL,NULL,NULL),('632524','兴海县','632500',1,NULL,NULL,NULL,NULL,NULL,NULL),('632525','贵南县','632500',1,NULL,NULL,NULL,NULL,NULL,NULL),('632600','果洛藏族自治州','630000',1,NULL,NULL,NULL,NULL,NULL,NULL),('632621','玛沁县','632600',1,NULL,NULL,NULL,NULL,NULL,NULL),('632622','班玛县','632600',1,NULL,NULL,NULL,NULL,NULL,NULL),('632623','甘德县','632600',1,NULL,NULL,NULL,NULL,NULL,NULL),('632624','达日县','632600',1,NULL,NULL,NULL,NULL,NULL,NULL),('632625','久治县','632600',1,NULL,NULL,NULL,NULL,NULL,NULL),('632626','玛多县','632600',1,NULL,NULL,NULL,NULL,NULL,NULL),('632700','玉树藏族自治州','630000',1,NULL,NULL,NULL,NULL,NULL,NULL),('632701','玉树市','632700',1,NULL,NULL,NULL,NULL,NULL,NULL),('632722','杂多县','632700',1,NULL,NULL,NULL,NULL,NULL,NULL),('632723','称多县','632700',1,NULL,NULL,NULL,NULL,NULL,NULL),('632724','治多县','632700',1,NULL,NULL,NULL,NULL,NULL,NULL),('632725','囊谦县','632700',1,NULL,NULL,NULL,NULL,NULL,NULL),('632726','曲麻莱县','632700',1,NULL,NULL,NULL,NULL,NULL,NULL),('632800','海西蒙古族藏族自治州','630000',1,NULL,NULL,NULL,NULL,NULL,NULL),('632801','格尔木市','632800',1,NULL,NULL,NULL,NULL,NULL,NULL),('632802','德令哈市','632800',1,NULL,NULL,NULL,NULL,NULL,NULL),('632821','乌兰县','632800',1,NULL,NULL,NULL,NULL,NULL,NULL),('632822','都兰县','632800',1,NULL,NULL,NULL,NULL,NULL,NULL),('632823','天峻县','632800',1,NULL,NULL,NULL,NULL,NULL,NULL),('640000','宁夏回族自治区',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('640100','银川市','640000',1,NULL,NULL,NULL,NULL,NULL,NULL),('640104','兴庆区','640100',1,NULL,NULL,NULL,NULL,NULL,NULL),('640105','西夏区','640100',1,NULL,NULL,NULL,NULL,NULL,NULL),('640106','金凤区','640100',1,NULL,NULL,NULL,NULL,NULL,NULL),('640121','永宁县','640100',1,NULL,NULL,NULL,NULL,NULL,NULL),('640122','贺兰县','640100',1,NULL,NULL,NULL,NULL,NULL,NULL),('640181','灵武市','640100',1,NULL,NULL,NULL,NULL,NULL,NULL),('640200','石嘴山市','640000',1,NULL,NULL,NULL,NULL,NULL,NULL),('640202','大武口区','640200',1,NULL,NULL,NULL,NULL,NULL,NULL),('640205','惠农区','640200',1,NULL,NULL,NULL,NULL,NULL,NULL),('640221','平罗县','640200',1,NULL,NULL,NULL,NULL,NULL,NULL),('640300','吴忠市','640000',1,NULL,NULL,NULL,NULL,NULL,NULL),('640302','利通区','640300',1,NULL,NULL,NULL,NULL,NULL,NULL),('640303','红寺堡区','640300',1,NULL,NULL,NULL,NULL,NULL,NULL),('640323','盐池县','640300',1,NULL,NULL,NULL,NULL,NULL,NULL),('640324','同心县','640300',1,NULL,NULL,NULL,NULL,NULL,NULL),('640381','青铜峡市','640300',1,NULL,NULL,NULL,NULL,NULL,NULL),('640400','固原市','640000',1,NULL,NULL,NULL,NULL,NULL,NULL),('640402','原州区','640400',1,NULL,NULL,NULL,NULL,NULL,NULL),('640422','西吉县','640400',1,NULL,NULL,NULL,NULL,NULL,NULL),('640423','隆德县','640400',1,NULL,NULL,NULL,NULL,NULL,NULL),('640424','泾源县','640400',1,NULL,NULL,NULL,NULL,NULL,NULL),('640425','彭阳县','640400',1,NULL,NULL,NULL,NULL,NULL,NULL),('640500','中卫市','640000',1,NULL,NULL,NULL,NULL,NULL,NULL),('640502','沙坡头区','640500',1,NULL,NULL,NULL,NULL,NULL,NULL),('640521','中宁县','640500',1,NULL,NULL,NULL,NULL,NULL,NULL),('640522','海原县','640500',1,NULL,NULL,NULL,NULL,NULL,NULL),('650000','新疆维吾尔自治区',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('650100','乌鲁木齐市','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('650102','天山区','650100',1,NULL,NULL,NULL,NULL,NULL,NULL),('650103','沙依巴克区','650100',1,NULL,NULL,NULL,NULL,NULL,NULL),('650104','新市区','650100',1,NULL,NULL,NULL,NULL,NULL,NULL),('650105','水磨沟区','650100',1,NULL,NULL,NULL,NULL,NULL,NULL),('650106','头屯河区','650100',1,NULL,NULL,NULL,NULL,NULL,NULL),('650107','达坂城区','650100',1,NULL,NULL,NULL,NULL,NULL,NULL),('650109','米东区','650100',1,NULL,NULL,NULL,NULL,NULL,NULL),('650121','乌鲁木齐县','650100',1,NULL,NULL,NULL,NULL,NULL,NULL),('650200','克拉玛依市','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('650202','独山子区','650200',1,NULL,NULL,NULL,NULL,NULL,NULL),('650203','克拉玛依区','650200',1,NULL,NULL,NULL,NULL,NULL,NULL),('650204','白碱滩区','650200',1,NULL,NULL,NULL,NULL,NULL,NULL),('650205','乌尔禾区','650200',1,NULL,NULL,NULL,NULL,NULL,NULL),('650400','吐鲁番市','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('650402','高昌区','650400',1,NULL,NULL,NULL,NULL,NULL,NULL),('650421','鄯善县','650400',1,NULL,NULL,NULL,NULL,NULL,NULL),('650422','托克逊县','650400',1,NULL,NULL,NULL,NULL,NULL,NULL),('650500','哈密市','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('650502','伊州区','650500',1,NULL,NULL,NULL,NULL,NULL,NULL),('650521','巴里坤哈萨克自治县','650500',1,NULL,NULL,NULL,NULL,NULL,NULL),('650522','伊吾县','650500',1,NULL,NULL,NULL,NULL,NULL,NULL),('652300','昌吉回族自治州','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('652301','昌吉市','652300',1,NULL,NULL,NULL,NULL,NULL,NULL),('652302','阜康市','652300',1,NULL,NULL,NULL,NULL,NULL,NULL),('652323','呼图壁县','652300',1,NULL,NULL,NULL,NULL,NULL,NULL),('652324','玛纳斯县','652300',1,NULL,NULL,NULL,NULL,NULL,NULL),('652325','奇台县','652300',1,NULL,NULL,NULL,NULL,NULL,NULL),('652327','吉木萨尔县','652300',1,NULL,NULL,NULL,NULL,NULL,NULL),('652328','木垒哈萨克自治县','652300',1,NULL,NULL,NULL,NULL,NULL,NULL),('652700','博尔塔拉蒙古自治州','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('652701','博乐市','652700',1,NULL,NULL,NULL,NULL,NULL,NULL),('652702','阿拉山口市','652700',1,NULL,NULL,NULL,NULL,NULL,NULL),('652722','精河县','652700',1,NULL,NULL,NULL,NULL,NULL,NULL),('652723','温泉县','652700',1,NULL,NULL,NULL,NULL,NULL,NULL),('652800','巴音郭楞蒙古自治州','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('652801','库尔勒市','652800',1,NULL,NULL,NULL,NULL,NULL,NULL),('652822','轮台县','652800',1,NULL,NULL,NULL,NULL,NULL,NULL),('652823','尉犁县','652800',1,NULL,NULL,NULL,NULL,NULL,NULL),('652824','若羌县','652800',1,NULL,NULL,NULL,NULL,NULL,NULL),('652825','且末县','652800',1,NULL,NULL,NULL,NULL,NULL,NULL),('652826','焉耆回族自治县','652800',1,NULL,NULL,NULL,NULL,NULL,NULL),('652827','和静县','652800',1,NULL,NULL,NULL,NULL,NULL,NULL),('652828','和硕县','652800',1,NULL,NULL,NULL,NULL,NULL,NULL),('652829','博湖县','652800',1,NULL,NULL,NULL,NULL,NULL,NULL),('652900','阿克苏地区','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('652901','阿克苏市','652900',1,NULL,NULL,NULL,NULL,NULL,NULL),('652922','温宿县','652900',1,NULL,NULL,NULL,NULL,NULL,NULL),('652923','库车县','652900',1,NULL,NULL,NULL,NULL,NULL,NULL),('652924','沙雅县','652900',1,NULL,NULL,NULL,NULL,NULL,NULL),('652925','新和县','652900',1,NULL,NULL,NULL,NULL,NULL,NULL),('652926','拜城县','652900',1,NULL,NULL,NULL,NULL,NULL,NULL),('652927','乌什县','652900',1,NULL,NULL,NULL,NULL,NULL,NULL),('652928','阿瓦提县','652900',1,NULL,NULL,NULL,NULL,NULL,NULL),('652929','柯坪县','652900',1,NULL,NULL,NULL,NULL,NULL,NULL),('653000','克孜勒苏柯尔克孜自治州','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('653001','阿图什市','653000',1,NULL,NULL,NULL,NULL,NULL,NULL),('653022','阿克陶县','653000',1,NULL,NULL,NULL,NULL,NULL,NULL),('653023','阿合奇县','653000',1,NULL,NULL,NULL,NULL,NULL,NULL),('653024','乌恰县','653000',1,NULL,NULL,NULL,NULL,NULL,NULL),('653100','喀什地区','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('653101','喀什市','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653121','疏附县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653122','疏勒县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653123','英吉沙县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653124','泽普县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653125','莎车县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653126','叶城县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653127','麦盖提县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653128','岳普湖县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653129','伽师县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653130','巴楚县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653131','塔什库尔干塔吉克自治县','653100',1,NULL,NULL,NULL,NULL,NULL,NULL),('653200','和田地区','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('653201','和田市','653200',1,NULL,NULL,NULL,NULL,NULL,NULL),('653221','和田县','653200',1,NULL,NULL,NULL,NULL,NULL,NULL),('653222','墨玉县','653200',1,NULL,NULL,NULL,NULL,NULL,NULL),('653223','皮山县','653200',1,NULL,NULL,NULL,NULL,NULL,NULL),('653224','洛浦县','653200',1,NULL,NULL,NULL,NULL,NULL,NULL),('653225','策勒县','653200',1,NULL,NULL,NULL,NULL,NULL,NULL),('653226','于田县','653200',1,NULL,NULL,NULL,NULL,NULL,NULL),('653227','民丰县','653200',1,NULL,NULL,NULL,NULL,NULL,NULL),('654000','伊犁哈萨克自治州','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654002','伊宁市','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654003','奎屯市','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654004','霍尔果斯市','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654021','伊宁县','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654022','察布查尔锡伯自治县','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654023','霍城县','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654024','巩留县','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654025','新源县','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654026','昭苏县','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654027','特克斯县','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654028','尼勒克县','654000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654200','塔城地区','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654201','塔城市','654200',1,NULL,NULL,NULL,NULL,NULL,NULL),('654202','乌苏市','654200',1,NULL,NULL,NULL,NULL,NULL,NULL),('654221','额敏县','654200',1,NULL,NULL,NULL,NULL,NULL,NULL),('654223','沙湾县','654200',1,NULL,NULL,NULL,NULL,NULL,NULL),('654224','托里县','654200',1,NULL,NULL,NULL,NULL,NULL,NULL),('654225','裕民县','654200',1,NULL,NULL,NULL,NULL,NULL,NULL),('654226','和布克赛尔蒙古自治县','654200',1,NULL,NULL,NULL,NULL,NULL,NULL),('654300','阿勒泰地区','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('654301','阿勒泰市','654300',1,NULL,NULL,NULL,NULL,NULL,NULL),('654321','布尔津县','654300',1,NULL,NULL,NULL,NULL,NULL,NULL),('654322','富蕴县','654300',1,NULL,NULL,NULL,NULL,NULL,NULL),('654323','福海县','654300',1,NULL,NULL,NULL,NULL,NULL,NULL),('654324','哈巴河县','654300',1,NULL,NULL,NULL,NULL,NULL,NULL),('654325','青河县','654300',1,NULL,NULL,NULL,NULL,NULL,NULL),('654326','吉木乃县','654300',1,NULL,NULL,NULL,NULL,NULL,NULL),('659000','自治区直辖县级行政区划','650000',1,NULL,NULL,NULL,NULL,NULL,NULL),('659001','石河子市','659000',1,NULL,NULL,NULL,NULL,NULL,NULL),('659002','阿拉尔市','659000',1,NULL,NULL,NULL,NULL,NULL,NULL),('659003','图木舒克市','659000',1,NULL,NULL,NULL,NULL,NULL,NULL),('659004','五家渠市','659000',1,NULL,NULL,NULL,NULL,NULL,NULL),('659006','铁门关市','659000',1,NULL,NULL,NULL,NULL,NULL,NULL),('710000','台湾省',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('810000','香港特别行政区',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),('820000','澳门特别行政区',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL);

#
# Structure for table "tb_goods_category"
#

CREATE TABLE `tb_goods_category` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(20) NOT NULL,
  `desc` varchar(255) DEFAULT NULL,
  `default_image` varchar(255) DEFAULT NULL,
  `sort` smallint(5) unsigned NOT NULL COMMENT '显示顺序',
  `status` tinyint(1) NOT NULL COMMENT '商品类别状态',
  `is_delete` tinyint(1) NOT NULL COMMENT '是否逻辑删除',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `parent_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_category_parent_id_5abc16fa_fk_tb_goods_category_id` (`parent_id`),
  KEY `tb_goods_category_creator_id_dc28d487` (`creator_id`),
  CONSTRAINT `tb_goods_category_parent_id_5abc16fa_fk_tb_goods_category_id` FOREIGN KEY (`parent_id`) REFERENCES `tb_goods_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品类别';

#
# Data for table "tb_goods_category"
#

REPLACE INTO `tb_goods_category` VALUES ('3cc9ced7429f41f380ca7496191b2c8b',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2022-07-31 18:38:59.711317','2022-07-31 18:38:47.138244','测试手机',NULL,'',0,1,0,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL);

#
# Structure for table "tb_goods_brand"
#

CREATE TABLE `tb_goods_brand` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(30) NOT NULL COMMENT '品牌名',
  `desc` longtext NOT NULL COMMENT '品牌描述',
  `default_image` varchar(255) DEFAULT NULL,
  `sort` smallint(5) unsigned NOT NULL,
  `category_id` varchar(100) NOT NULL COMMENT '所属分类',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `tb_goods_brand_category_id_02d8306e_fk_tb_goods_category_id` (`category_id`),
  KEY `tb_goods_brand_creator_id_034490f8` (`creator_id`),
  CONSTRAINT `tb_goods_brand_category_id_02d8306e_fk_tb_goods_category_id` FOREIGN KEY (`category_id`) REFERENCES `tb_goods_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品品牌';

#
# Data for table "tb_goods_brand"
#


#
# Structure for table "tb_goods_coupon"
#

CREATE TABLE `tb_goods_coupon` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(50) NOT NULL,
  `caption` varchar(256) DEFAULT NULL,
  `desc` varchar(150) DEFAULT NULL,
  `sort` int(11) NOT NULL COMMENT '显示顺序',
  `total_num` int(11) NOT NULL COMMENT '优惠券总数量',
  `received_num` int(11) NOT NULL COMMENT '优惠券已领取数量',
  `used_num` int(11) NOT NULL COMMENT '已被使用的数量',
  `is_permanent` tinyint(1) NOT NULL COMMENT '是否无限张数',
  `price` decimal(10,2) NOT NULL,
  `is_condition` tinyint(1) NOT NULL COMMENT '有无门槛',
  `use_min_price` decimal(10,2) NOT NULL,
  `start_time` date DEFAULT NULL COMMENT '优惠券领取开启时间',
  `end_time` date DEFAULT NULL COMMENT '优惠券领取结束时间',
  `valid_begin_date` date DEFAULT NULL,
  `valid_end_date` date DEFAULT NULL,
  `coupon_expiretime` int(11) NOT NULL COMMENT '优惠券有效期限（单位：天）',
  `receive_type` smallint(6) NOT NULL COMMENT '优惠券发送方式',
  `coupon_type` smallint(6) NOT NULL COMMENT '优惠券类型（2）',
  `is_delete` tinyint(1) NOT NULL COMMENT '是否逻辑删除',
  `status` tinyint(1) NOT NULL COMMENT '状态',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `tb_goods_coupon_creator_id_5ede45ac` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品优惠券';

#
# Data for table "tb_goods_coupon"
#


#
# Structure for table "tb_goods_coupon_record"
#

CREATE TABLE `tb_goods_coupon_record` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `number` varchar(64) DEFAULT NULL,
  `status` smallint(6) NOT NULL,
  `used_time` datetime(6) DEFAULT NULL,
  `receive_time` datetime(6) DEFAULT NULL,
  `is_delete` tinyint(1) NOT NULL COMMENT '是否逻辑删除',
  `coupon_id` varchar(100) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `user_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_coupon_record_coupon_id_45c28b4b_fk_tb_goods_coupon_id` (`coupon_id`),
  KEY `tb_goods_coupon_record_user_id_34aaa577_fk_lyadmin_users_id` (`user_id`),
  KEY `tb_goods_coupon_record_creator_id_9fb5ffca` (`creator_id`),
  CONSTRAINT `tb_goods_coupon_record_coupon_id_45c28b4b_fk_tb_goods_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `tb_goods_coupon` (`id`),
  CONSTRAINT `tb_goods_coupon_record_user_id_34aaa577_fk_lyadmin_users_id` FOREIGN KEY (`user_id`) REFERENCES `lyadmin_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户持券表';

#
# Data for table "tb_goods_coupon_record"
#


#
# Structure for table "tb_goods_spec_template"
#

CREATE TABLE `tb_goods_spec_template` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `spec` varchar(100) NOT NULL,
  `option` varchar(255) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `tb_goods_spec_template_creator_id_416c26a4` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品规格模板';

#
# Data for table "tb_goods_spec_template"
#


#
# Structure for table "tb_goods_spu"
#

CREATE TABLE `tb_goods_spu` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(60) NOT NULL,
  `sub_name` varchar(60) DEFAULT NULL,
  `spec_type` int(10) unsigned NOT NULL,
  `default_image` varchar(255) DEFAULT NULL,
  `image_list` varchar(2000) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `sales` int(11) NOT NULL,
  `stock` int(11) NOT NULL,
  `unit` varchar(30) DEFAULT NULL,
  `comments` int(11) DEFAULT NULL,
  `desc_detail` longtext,
  `desc_pack` longtext,
  `desc_service` longtext,
  `is_launched` tinyint(1) NOT NULL,
  `is_tuijian` tinyint(1) NOT NULL,
  `sort` smallint(5) unsigned NOT NULL,
  `is_delete` tinyint(1) NOT NULL COMMENT '是否逻辑删除',
  `brand_id` varchar(100) DEFAULT NULL,
  `category1_id` varchar(100) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `tb_goods_spu_brand_id_1fa4b54f_fk_tb_goods_brand_id` (`brand_id`),
  KEY `tb_goods_spu_category1_id_dec6b204_fk_tb_goods_category_id` (`category1_id`),
  KEY `tb_goods_spu_creator_id_0a937088` (`creator_id`),
  CONSTRAINT `tb_goods_spu_brand_id_1fa4b54f_fk_tb_goods_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `tb_goods_brand` (`id`),
  CONSTRAINT `tb_goods_spu_category1_id_dec6b204_fk_tb_goods_category_id` FOREIGN KEY (`category1_id`) REFERENCES `tb_goods_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品SPU';

#
# Data for table "tb_goods_spu"
#

REPLACE INTO `tb_goods_spu` VALUES ('abe429eb47d84dbd873f1442bcaedd58',NULL,NULL,NULL,'2022-08-01 22:59:57.799272','2022-08-01 22:59:57.693992','测试手机商品多规格','测试手机商品多规格',1,'http://127.0.0.1:8000/media/platform/2022-08-01/20220801225845_971.png','[\'http://127.0.0.1:8000/media/platform/2022-08-01/20220801225848_774.png\', \'http://127.0.0.1:8000/media/platform/2022-08-01/20220801225851_499.png\']',5600.00,0,0,'',0,'<p>测试商品详情</p>','','',1,0,1,0,NULL,'3cc9ced7429f41f380ca7496191b2c8b',NULL);

#
# Structure for table "tb_goods_sku"
#

CREATE TABLE `tb_goods_sku` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(60) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `shop_price` decimal(10,2) DEFAULT NULL,
  `market_price` decimal(10,2) DEFAULT NULL,
  `cost_price` decimal(10,2) DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `unite` varchar(20) DEFAULT NULL,
  `sales` int(11) DEFAULT NULL,
  `default_image` varchar(255) DEFAULT NULL,
  `is_launched` tinyint(1) NOT NULL,
  `is_delete` tinyint(1) NOT NULL COMMENT '是否逻辑删除',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `spu_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_sku_spu_id_4461d223_fk_tb_goods_spu_id` (`spu_id`),
  KEY `tb_goods_sku_creator_id_a17c462b` (`creator_id`),
  CONSTRAINT `tb_goods_sku_spu_id_4461d223_fk_tb_goods_spu_id` FOREIGN KEY (`spu_id`) REFERENCES `tb_goods_spu` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品SKU';

#
# Data for table "tb_goods_sku"
#

REPLACE INTO `tb_goods_sku` VALUES ('2ed520b91652439585d2557b61edc979',NULL,NULL,NULL,'2022-08-01 22:59:57.792253','2022-08-01 22:59:57.792253',NULL,5600.00,0.00,0.00,0.00,999,NULL,0,'http://127.0.0.1:8000/media/platform/2022-08-01/20220801225955_189.png',1,0,NULL,'abe429eb47d84dbd873f1442bcaedd58'),('7e0700d159044728a726723f0f731cce',NULL,NULL,NULL,'2022-08-01 22:59:57.704018','2022-08-01 22:59:57.704018',NULL,5600.00,0.00,0.00,0.00,999,NULL,0,'http://127.0.0.1:8000/media/platform/2022-08-01/20220801225950_577.png',1,0,NULL,'abe429eb47d84dbd873f1442bcaedd58'),('7edb10067931472eaad051d3d5a23194',NULL,NULL,NULL,'2022-08-01 22:59:57.698003','2022-08-01 22:59:57.698003',NULL,5600.00,0.00,0.00,0.00,999,NULL,0,'http://127.0.0.1:8000/media/platform/2022-08-01/20220801225947_460.png',1,0,NULL,'abe429eb47d84dbd873f1442bcaedd58'),('dfa223d5974e404a983bb8e81a05cb25',NULL,NULL,NULL,'2022-08-01 22:59:57.712040','2022-08-01 22:59:57.712040',NULL,5600.00,0.00,0.00,0.00,999,NULL,0,'http://127.0.0.1:8000/media/platform/2022-08-01/20220801225952_984.png',1,0,NULL,'abe429eb47d84dbd873f1442bcaedd58');

#
# Structure for table "tb_goods_sku_image"
#

CREATE TABLE `tb_goods_sku_image` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `image` varchar(255) NOT NULL,
  `sort` smallint(5) unsigned NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `sku_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_sku_image_sku_id_a82c1e92_fk_tb_goods_sku_id` (`sku_id`),
  KEY `tb_goods_sku_image_creator_id_90a1f537` (`creator_id`),
  CONSTRAINT `tb_goods_sku_image_sku_id_a82c1e92_fk_tb_goods_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `tb_goods_sku` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SKU图片';

#
# Data for table "tb_goods_sku_image"
#


#
# Structure for table "tb_goods_spu_specification"
#

CREATE TABLE `tb_goods_spu_specification` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `name` varchar(20) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `spu_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_spu_specification_spu_id_39c06c59_fk_tb_goods_spu_id` (`spu_id`),
  KEY `tb_goods_spu_specification_creator_id_ea64a3a9` (`creator_id`),
  CONSTRAINT `tb_goods_spu_specification_spu_id_39c06c59_fk_tb_goods_spu_id` FOREIGN KEY (`spu_id`) REFERENCES `tb_goods_spu` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品SPU规格';

#
# Data for table "tb_goods_spu_specification"
#

REPLACE INTO `tb_goods_spu_specification` VALUES ('13c72a1b064047e7b04dff5eb75b991a',NULL,NULL,NULL,'2022-08-01 22:59:57.693992','2022-08-01 22:59:57.694995','颜色',NULL,'abe429eb47d84dbd873f1442bcaedd58'),('6497b2b201d041509f598f59172eeba9',NULL,NULL,NULL,'2022-08-01 22:59:57.695999','2022-08-01 22:59:57.695999','内存',NULL,'abe429eb47d84dbd873f1442bcaedd58');

#
# Structure for table "tb_goods_spu_specification_option"
#

CREATE TABLE `tb_goods_spu_specification_option` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `value` varchar(20) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `spec_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_spu_specifi_spec_id_603e43ee_fk_tb_goods_` (`spec_id`),
  KEY `tb_goods_spu_specification_option_creator_id_a4944bc4` (`creator_id`),
  CONSTRAINT `tb_goods_spu_specifi_spec_id_603e43ee_fk_tb_goods_` FOREIGN KEY (`spec_id`) REFERENCES `tb_goods_spu_specification` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='规格选项';

#
# Data for table "tb_goods_spu_specification_option"
#

REPLACE INTO `tb_goods_spu_specification_option` VALUES ('1bc35bc5bc72421ca7b54b2b0a6a504c',NULL,NULL,NULL,'2022-08-01 22:59:57.695999','2022-08-01 22:59:57.695999','白色',NULL,'13c72a1b064047e7b04dff5eb75b991a'),('51901a9e3e784623984e394c74ac7311',NULL,NULL,NULL,'2022-08-01 22:59:57.694995','2022-08-01 22:59:57.694995','金色',NULL,'13c72a1b064047e7b04dff5eb75b991a'),('5d37a947613b47a193f52f101be5a0b0',NULL,NULL,NULL,'2022-08-01 22:59:57.697028','2022-08-01 22:59:57.697028','512G',NULL,'6497b2b201d041509f598f59172eeba9'),('cd9f634da05f4cedb06e320865106db3',NULL,NULL,NULL,'2022-08-01 22:59:57.697028','2022-08-01 22:59:57.697028','128G',NULL,'6497b2b201d041509f598f59172eeba9');

#
# Structure for table "tb_goods_sku_specification"
#

CREATE TABLE `tb_goods_sku_specification` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `option_id` varchar(100) NOT NULL,
  `sku_id` varchar(100) NOT NULL,
  `spec_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_sku_specifi_option_id_dec442f7_fk_tb_goods_` (`option_id`),
  KEY `tb_goods_sku_specification_sku_id_cc4f8bc7_fk_tb_goods_sku_id` (`sku_id`),
  KEY `tb_goods_sku_specifi_spec_id_d53fc09e_fk_tb_goods_` (`spec_id`),
  KEY `tb_goods_sku_specification_creator_id_770697b2` (`creator_id`),
  CONSTRAINT `tb_goods_sku_specifi_option_id_dec442f7_fk_tb_goods_` FOREIGN KEY (`option_id`) REFERENCES `tb_goods_spu_specification_option` (`id`),
  CONSTRAINT `tb_goods_sku_specifi_spec_id_d53fc09e_fk_tb_goods_` FOREIGN KEY (`spec_id`) REFERENCES `tb_goods_spu_specification` (`id`),
  CONSTRAINT `tb_goods_sku_specification_sku_id_cc4f8bc7_fk_tb_goods_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `tb_goods_sku` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SKU规格';

#
# Data for table "tb_goods_sku_specification"
#

REPLACE INTO `tb_goods_sku_specification` VALUES ('08b21322a9c7441789898663f4085fc4',NULL,NULL,NULL,'2022-08-01 22:59:57.704018','2022-08-01 22:59:57.704018',NULL,'cd9f634da05f4cedb06e320865106db3','7edb10067931472eaad051d3d5a23194','6497b2b201d041509f598f59172eeba9'),('31d49079d67b41749b3eec220647ed91',NULL,NULL,NULL,'2022-08-01 22:59:57.701010','2022-08-01 22:59:57.701010',NULL,'51901a9e3e784623984e394c74ac7311','7edb10067931472eaad051d3d5a23194','13c72a1b064047e7b04dff5eb75b991a'),('365d884f1b8c45da9c893c50e03886e2',NULL,NULL,NULL,'2022-08-01 22:59:57.708029','2022-08-01 22:59:57.708029',NULL,'51901a9e3e784623984e394c74ac7311','7e0700d159044728a726723f0f731cce','13c72a1b064047e7b04dff5eb75b991a'),('36cff96281054848a18bcba175d415b5',NULL,NULL,NULL,'2022-08-01 22:59:57.715048','2022-08-01 22:59:57.715048',NULL,'1bc35bc5bc72421ca7b54b2b0a6a504c','dfa223d5974e404a983bb8e81a05cb25','13c72a1b064047e7b04dff5eb75b991a'),('73d01cace09d40888ed33cb8437f83f2',NULL,NULL,NULL,'2022-08-01 22:59:57.791250','2022-08-01 22:59:57.791250',NULL,'cd9f634da05f4cedb06e320865106db3','dfa223d5974e404a983bb8e81a05cb25','6497b2b201d041509f598f59172eeba9'),('8aad53cb2c2e471e8dddf3a9a2eb7697',NULL,NULL,NULL,'2022-08-01 22:59:57.795261','2022-08-01 22:59:57.795261',NULL,'1bc35bc5bc72421ca7b54b2b0a6a504c','2ed520b91652439585d2557b61edc979','13c72a1b064047e7b04dff5eb75b991a'),('99a025b2e5774f4db0d61c1ac02a9a1d',NULL,NULL,NULL,'2022-08-01 22:59:57.711037','2022-08-01 22:59:57.711037',NULL,'5d37a947613b47a193f52f101be5a0b0','7e0700d159044728a726723f0f731cce','6497b2b201d041509f598f59172eeba9'),('f168522e38d5435cbd8bd71b24120d23',NULL,NULL,NULL,'2022-08-01 22:59:57.797266','2022-08-01 22:59:57.797266',NULL,'5d37a947613b47a193f52f101be5a0b0','2ed520b91652439585d2557b61edc979','6497b2b201d041509f598f59172eeba9');

#
# Structure for table "tb_lunbo_manage"
#

CREATE TABLE `tb_lunbo_manage` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `title` varchar(100) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `sort` int(11) NOT NULL COMMENT '显示顺序',
  `image` varchar(255) NOT NULL,
  `link` longtext,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `link_type` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_lunbo_manage_creator_id_61e86919` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='轮播图设置';

#
# Data for table "tb_lunbo_manage"
#

REPLACE INTO `tb_lunbo_manage` VALUES ('e86adc251eb348c1bc0d1534cb130d3e',NULL,NULL,NULL,'2022-06-27 13:56:06.343544','2022-06-27 13:56:06.343544','首页轮播图1',1,1,1,'http://127.0.0.1:8000/media/platform/2021-10-27/20211027110807_498.jpg','http://www.xxx.com',NULL,0);

#
# Structure for table "tb_mall_order_info"
#

CREATE TABLE `tb_mall_order_info` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `order_id` varchar(64) NOT NULL,
  `trade_id` varchar(100) DEFAULT NULL,
  `address_name` varchar(50) DEFAULT NULL,
  `address_mobile` varchar(20) DEFAULT NULL,
  `address_place` varchar(100) DEFAULT NULL,
  `couponrecord_id` varchar(60) DEFAULT NULL,
  `couponrecord_price` decimal(10,2) DEFAULT NULL,
  `total_count` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `total_amount_pay` decimal(10,2) NOT NULL,
  `freight` decimal(10,2) DEFAULT NULL,
  `logistics_id` varchar(100) DEFAULT NULL,
  `send_time` datetime(6) DEFAULT NULL COMMENT '发货时间',
  `logistics_company` varchar(90) DEFAULT NULL,
  `pay_method` smallint(6) NOT NULL,
  `pay_time` varchar(64) DEFAULT NULL COMMENT '支付时间',
  `remark` varchar(100) DEFAULT NULL,
  `cancel_reason` varchar(100) DEFAULT NULL,
  `status` smallint(6) NOT NULL,
  `pay_status` smallint(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL COMMENT '是否逻辑删除',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `user_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`),
  UNIQUE KEY `trade_id` (`trade_id`),
  UNIQUE KEY `couponrecord_id` (`couponrecord_id`),
  KEY `tb_mall_order_info_user_id_814332e5_fk_lyadmin_users_id` (`user_id`),
  KEY `tb_mall_order_info_creator_id_6d97d688` (`creator_id`),
  CONSTRAINT `tb_mall_order_info_user_id_814332e5_fk_lyadmin_users_id` FOREIGN KEY (`user_id`) REFERENCES `lyadmin_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单基本信息';

#
# Data for table "tb_mall_order_info"
#


#
# Structure for table "tb_mall_order_goods"
#

CREATE TABLE `tb_mall_order_goods` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `count` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `comment` longtext,
  `score` smallint(6) NOT NULL,
  `is_anonymous` tinyint(1) NOT NULL,
  `is_commented` tinyint(1) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `order_id` varchar(100) NOT NULL,
  `sku_id` varchar(100) DEFAULT NULL,
  `spu_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_mall_order_goods_order_id_d7ebf6af_fk_tb_mall_order_info_id` (`order_id`),
  KEY `tb_mall_order_goods_sku_id_bc54f8f7_fk_tb_goods_sku_id` (`sku_id`),
  KEY `tb_mall_order_goods_spu_id_4671e639_fk_tb_goods_spu_id` (`spu_id`),
  KEY `tb_mall_order_goods_creator_id_3b1a9dea` (`creator_id`),
  CONSTRAINT `tb_mall_order_goods_order_id_d7ebf6af_fk_tb_mall_order_info_id` FOREIGN KEY (`order_id`) REFERENCES `tb_mall_order_info` (`id`),
  CONSTRAINT `tb_mall_order_goods_sku_id_bc54f8f7_fk_tb_goods_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `tb_goods_sku` (`id`),
  CONSTRAINT `tb_mall_order_goods_spu_id_4671e639_fk_tb_goods_spu_id` FOREIGN KEY (`spu_id`) REFERENCES `tb_goods_spu` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单商品';

#
# Data for table "tb_mall_order_goods"
#


#
# Structure for table "tb_mall_order_refunds"
#

CREATE TABLE `tb_mall_order_refunds` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `order_no` varchar(64) NOT NULL,
  `refund_id` varchar(64) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reason` varchar(64) DEFAULT NULL,
  `status` smallint(6) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `order_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_no` (`order_no`),
  UNIQUE KEY `refund_id` (`refund_id`),
  KEY `tb_mall_order_refunds_order_id_e725cf4c_fk_tb_mall_order_info_id` (`order_id`),
  KEY `tb_mall_order_refunds_creator_id_672686b7` (`creator_id`),
  CONSTRAINT `tb_mall_order_refunds_order_id_e725cf4c_fk_tb_mall_order_info_id` FOREIGN KEY (`order_id`) REFERENCES `tb_mall_order_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商城订单退款';

#
# Data for table "tb_mall_order_refunds"
#


#
# Structure for table "tb_message_template"
#

CREATE TABLE `tb_message_template` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `code` varchar(100) NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` longtext NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `tb_message_template_creator_id_3ec11b83` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息模板';

#
# Data for table "tb_message_template"
#


#
# Structure for table "tb_message"
#

CREATE TABLE `tb_message` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `msg_chanel` int(11) NOT NULL,
  `public` tinyint(1) NOT NULL,
  `msg_title` varchar(100) DEFAULT NULL,
  `msg_content` longtext,
  `to_path` varchar(256) DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `msg_type_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_message_msg_type_id_b4072045_fk_tb_message_template_id` (`msg_type_id`),
  KEY `tb_message_creator_id_3214601d` (`creator_id`),
  CONSTRAINT `tb_message_msg_type_id_b4072045_fk_tb_message_template_id` FOREIGN KEY (`msg_type_id`) REFERENCES `tb_message_template` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息中心';

#
# Data for table "tb_message"
#

REPLACE INTO `tb_message` VALUES ('7210a59d19fe406bbd237510344334bf',NULL,NULL,NULL,'2022-06-27 13:56:06.345538','2022-06-27 13:56:06.345538',2,1,'测试消息','<p>消息内容实体部分</p>','/index/path',1,NULL,NULL);

#
# Structure for table "tb_message_user"
#

CREATE TABLE `tb_message_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `update_datetime` datetime(6) DEFAULT NULL,
  `create_datetime` datetime(6) DEFAULT NULL,
  `read_at` datetime(6) DEFAULT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `messageid_id` varchar(100) NOT NULL,
  `revuserid_id` varchar(100) NOT NULL,
  `senduserid_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_message_user_messageid_id_e64702d8_fk_tb_message_id` (`messageid_id`),
  KEY `tb_message_user_revuserid_id_b63a4813_fk_lyadmin_users_id` (`revuserid_id`),
  KEY `tb_message_user_senduserid_id_cb96b84f_fk_lyadmin_users_id` (`senduserid_id`),
  CONSTRAINT `tb_message_user_messageid_id_e64702d8_fk_tb_message_id` FOREIGN KEY (`messageid_id`) REFERENCES `tb_message` (`id`),
  CONSTRAINT `tb_message_user_revuserid_id_b63a4813_fk_lyadmin_users_id` FOREIGN KEY (`revuserid_id`) REFERENCES `lyadmin_users` (`id`),
  CONSTRAINT `tb_message_user_senduserid_id_cb96b84f_fk_lyadmin_users_id` FOREIGN KEY (`senduserid_id`) REFERENCES `lyadmin_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户消息';

#
# Data for table "tb_message_user"
#


#
# Structure for table "tb_monitor"
#

CREATE TABLE `tb_monitor` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `ip` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `os` varchar(50) DEFAULT NULL,
  `online` tinyint(1) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `days` smallint(6) NOT NULL,
  `interval` smallint(6) NOT NULL,
  `islocal` tinyint(1) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `tb_monitor_creator_id_27f410f2` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='服务监控';

#
# Data for table "tb_monitor"
#


#
# Structure for table "tb_oauth_wx"
#

CREATE TABLE `tb_oauth_wx` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `update_datetime` datetime(6) DEFAULT NULL,
  `create_datetime` datetime(6) DEFAULT NULL,
  `xcx_openid` varchar(100) DEFAULT NULL,
  `gzh_openid` varchar(100) DEFAULT NULL,
  `avatarUrl` varchar(900) DEFAULT NULL,
  `nick` varchar(40) DEFAULT NULL,
  `sex` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `unionId` varchar(255) DEFAULT NULL,
  `session_key` varchar(255) DEFAULT NULL,
  `xcx_access_token` varchar(255) DEFAULT NULL,
  `gzh_access_token` varchar(255) DEFAULT NULL,
  `gzh_refresh_token` varchar(255) DEFAULT NULL,
  `gzh_scope` varchar(255) DEFAULT NULL,
  `mobilePhoneNumber` varchar(30) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `tb_oauth_wx_xcx_openid_86e639c2` (`xcx_openid`),
  KEY `tb_oauth_wx_gzh_openid_534fea1f` (`gzh_openid`),
  CONSTRAINT `tb_oauth_wx_user_id_2a271e12_fk_lyadmin_users_id` FOREIGN KEY (`user_id`) REFERENCES `lyadmin_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信登录用户数据';

#
# Data for table "tb_oauth_wx"
#


#
# Structure for table "tb_other_manage"
#

CREATE TABLE `tb_other_manage` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `status` tinyint(1) NOT NULL,
  `type` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `key` varchar(50) NOT NULL,
  `value` longtext NOT NULL,
  `sort` int(11) NOT NULL COMMENT '显示顺序',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `tb_other_manage_creator_id_125ff1a6` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台其他设置';

#
# Data for table "tb_other_manage"
#

REPLACE INTO `tb_other_manage` VALUES ('34799dd05d094458bd2b200d3f211eda',NULL,NULL,NULL,'2022-06-27 13:56:06.349195','2022-06-27 13:56:06.349195',1,1,'客服电话','customerservicephone','4006668888',1,NULL),('4ef8d8c46f2649438bddaba3628e3271',NULL,NULL,NULL,'2022-06-27 13:56:06.351665','2022-06-27 13:56:06.351665',1,1,'关于我们','aboutus','<p>我是关于我们的简介，请写在这里</p>',2,NULL),('6261abf71d3b4ead9b1213225933b50f',NULL,NULL,NULL,'2022-06-27 13:56:06.353660','2022-06-27 13:56:06.353660',1,3,'公司logo','companylogo','http://127.0.0.1:8000/media/platform/2022-04-07/20220407120605_298.png',2,NULL);

#
# Structure for table "tb_terminalserver"
#

CREATE TABLE `tb_terminalserver` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `host` varchar(100) NOT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `username` varchar(200) NOT NULL,
  `password` varchar(200) DEFAULT NULL,
  `pkey` varchar(255) DEFAULT NULL,
  `pkey_passwd` varchar(255) DEFAULT NULL,
  `type` smallint(6) NOT NULL COMMENT '验证方式',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `port` int(11) NOT NULL COMMENT '端口号',
  PRIMARY KEY (`id`),
  KEY `tb_terminalserver_creator_id_d30e3e38` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='终端服务器列表';

#
# Data for table "tb_terminalserver"
#

REPLACE INTO `tb_terminalserver` VALUES ('99508bdc6e454f50ba414f52089928b6',NULL,'superadmin',NULL,'2022-07-17 23:53:34.766663','2022-07-17 17:36:43.286021','124.222.222.225','测试服务器账号','lyadmintest','lyadmintest0008','','',0,NULL,22);

#
# Structure for table "tb_user_leaving"
#

CREATE TABLE `tb_user_leaving` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `message_type` smallint(6) NOT NULL COMMENT '留言类型: 1(留言),2(投诉),3(询问),4(售后),5(求购)',
  `subject` varchar(100) DEFAULT NULL,
  `message` longtext NOT NULL COMMENT '留言内容',
  `images` varchar(3000) DEFAULT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `user_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_user_leaving_user_id_44ed0394_fk_lyadmin_users_id` (`user_id`),
  KEY `tb_user_leaving_creator_id_13389dc5` (`creator_id`),
  CONSTRAINT `tb_user_leaving_user_id_44ed0394_fk_lyadmin_users_id` FOREIGN KEY (`user_id`) REFERENCES `lyadmin_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户反馈';

#
# Data for table "tb_user_leaving"
#


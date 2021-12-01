# Host: localhost  (Version: 5.7.26)
# Date: 2021-12-01 09:49:04
# Generator: MySQL-Front 5.3  (Build 4.234)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "auth_group"
#

DROP TABLE IF EXISTS `auth_group`;
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

DROP TABLE IF EXISTS `captcha_captchastore`;
CREATE TABLE `captcha_captchastore` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `challenge` varchar(32) NOT NULL,
  `response` varchar(32) NOT NULL,
  `hashkey` varchar(40) NOT NULL,
  `expiration` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hashkey` (`hashkey`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COMMENT='captcha store';

#
# Data for table "captcha_captchastore"
#

INSERT INTO `captcha_captchastore` VALUES (1,'3*4=','12','7a5079adfd6615e732f6910d0b47b4fbbf918082','2021-11-13 10:57:36.320843'),(2,'6-1=','5','a13fa0ce673a2a0a12f9065d2a9102deb2f295b4','2021-11-13 10:57:40.743472'),(3,'8*6=','48','fb8c42fb2f49938417f06a41c9cf0cf573bcb568','2021-11-13 10:57:57.368170'),(4,'8+7=','15','ede654e4afdb3cd98753c3e46c2c125a54ef4e65','2021-11-13 11:03:54.695222'),(5,'7-6=','1','14023675c5b93d60d6342838171b3bc85e69d519','2021-11-13 11:08:14.198404'),(6,'4*2=','8','54504cea1c9221f7ce724250e449a3ccfcc2396f','2021-11-13 11:08:14.979236'),(7,'6-3=','3','d162219c2f1ca062c62b4e625f11116539c19905','2021-11-13 11:08:29.101375'),(8,'6-5=','1','c2ef6b230c83e78a5f1501aa4089b84a36f53b57','2021-11-13 11:33:12.552198'),(9,'5-3=','2','a75b6af14b433145fdb2510ddd78c06f54606f90','2021-11-13 11:33:51.870202'),(10,'9-1=','8','9c0dd719077e0d6528035437e6209cc6d11bfb80','2021-11-13 11:34:00.233721'),(11,'6+1=','7','5baa2b8c31fb3e39409deedf1544c9ff852ac2bf','2021-11-13 11:34:08.660262'),(12,'6*5=','30','7e783b6b6b76dc19bafaf2ab1b3453d3237e0a5a','2021-11-13 11:34:17.946108'),(14,'3*1=','3','a98deba6bb4078c54297e65750ab22c5ea7fa55b','2021-11-13 11:35:44.252810'),(15,'7-5=','2','80e2cacbfbbda2066b8eb782a3164764fd47342e','2021-11-13 11:38:11.555335'),(16,'3+8=','11','8c7c6831176623fa50edbd93d9ed0939780d0463','2021-11-13 11:38:19.319101'),(17,'7+6=','13','40b419f26b104c38eb62b6d7566c51f8f7fc2e0a','2021-11-13 11:39:34.685717'),(18,'3-2=','1','13da9e40bbb5e86f9acb40707f46a4cd424e559f','2021-11-13 11:39:42.188429'),(19,'9-9=','0','3e017458c0dbc712f871ffebcae45588f113aaf4','2021-11-13 11:42:03.839921'),(21,'4-1=','3','206f0ea19e0b13351b9217df3a67210b79a22342','2021-11-13 11:42:27.313644'),(22,'9*9=','81','61cf6d11e19f84212f270fe723d449443e071dcf','2021-11-15 17:07:11.110356'),(27,'10+7=','17','6b1d23819ddcd5ced6252e75f36eed51c21e7305','2021-11-16 13:54:40.970949'),(32,'3+3=','6','87bbade8972477e4266c9f852f4dae4aab816ef1','2021-11-16 17:24:44.998234'),(35,'5-3=','2','4d09676b93105f2d05903f13fb08ff8fcf0b0ab3','2021-11-16 17:27:02.856312'),(36,'2+9=','11','fdfe540413ecb9352d065ea634520826a5d7df77','2021-11-16 17:31:55.186619'),(39,'9-4=','5','824efb08200755d76d996cde5e33ec32e68ba909','2021-11-30 18:03:45.372634');

#
# Structure for table "django_content_type"
#

DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COMMENT='content type';

#
# Data for table "django_content_type"
#

INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','permission'),(3,'auth','group'),(4,'contenttypes','contenttype'),(5,'sessions','session'),(6,'captcha','captchastore'),(7,'mysystem','users'),(8,'mysystem','dept'),(9,'mysystem','dictionary'),(10,'mysystem','menu'),(11,'mysystem','menubutton'),(12,'mysystem','sysdictionarylist'),(13,'mysystem','role'),(14,'mysystem','post'),(15,'mysystem','operationlog'),(16,'mysystem','loginlog'),(17,'mysystem','button'),(18,'lymessages','mymessage'),(19,'lymessages','mymessagetemplate'),(20,'lymessages','mymessageuser'),(21,'address','area'),(22,'oauth','oauthwxuser'),(23,'platformsettings','othermanage'),(24,'platformsettings','lunbotumanage');

#
# Structure for table "auth_permission"
#

DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  KEY `auth_permission_content_type_id_2f476e4b` (`content_type_id`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COMMENT='permission';

#
# Data for table "auth_permission"
#

INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add captcha store',6,'add_captchastore'),(22,'Can change captcha store',6,'change_captchastore'),(23,'Can delete captcha store',6,'delete_captchastore'),(24,'Can view captcha store',6,'view_captchastore'),(25,'Can add 用户表',7,'add_users'),(26,'Can change 用户表',7,'change_users'),(27,'Can delete 用户表',7,'delete_users'),(28,'Can view 用户表',7,'view_users'),(29,'Can add 部门表',8,'add_dept'),(30,'Can change 部门表',8,'change_dept'),(31,'Can delete 部门表',8,'delete_dept'),(32,'Can view 部门表',8,'view_dept'),(33,'Can add 字典表',9,'add_dictionary'),(34,'Can change 字典表',9,'change_dictionary'),(35,'Can delete 字典表',9,'delete_dictionary'),(36,'Can view 字典表',9,'view_dictionary'),(37,'Can add 菜单表',10,'add_menu'),(38,'Can change 菜单表',10,'change_menu'),(39,'Can delete 菜单表',10,'delete_menu'),(40,'Can view 菜单表',10,'view_menu'),(41,'Can add 菜单权限表',11,'add_menubutton'),(42,'Can change 菜单权限表',11,'change_menubutton'),(43,'Can delete 菜单权限表',11,'delete_menubutton'),(44,'Can view 菜单权限表',11,'view_menubutton'),(45,'Can add 字典详细表',12,'add_sysdictionarylist'),(46,'Can change 字典详细表',12,'change_sysdictionarylist'),(47,'Can delete 字典详细表',12,'delete_sysdictionarylist'),(48,'Can view 字典详细表',12,'view_sysdictionarylist'),(49,'Can add 角色表',13,'add_role'),(50,'Can change 角色表',13,'change_role'),(51,'Can delete 角色表',13,'delete_role'),(52,'Can view 角色表',13,'view_role'),(53,'Can add 岗位表',14,'add_post'),(54,'Can change 岗位表',14,'change_post'),(55,'Can delete 岗位表',14,'delete_post'),(56,'Can view 岗位表',14,'view_post'),(57,'Can add 操作日志',15,'add_operationlog'),(58,'Can change 操作日志',15,'change_operationlog'),(59,'Can delete 操作日志',15,'delete_operationlog'),(60,'Can view 操作日志',15,'view_operationlog'),(61,'Can add 登录日志',16,'add_loginlog'),(62,'Can change 登录日志',16,'change_loginlog'),(63,'Can delete 登录日志',16,'delete_loginlog'),(64,'Can view 登录日志',16,'view_loginlog'),(65,'Can add 权限标识表',17,'add_button'),(66,'Can change 权限标识表',17,'change_button'),(67,'Can delete 权限标识表',17,'delete_button'),(68,'Can view 权限标识表',17,'view_button'),(69,'Can add 消息中心',18,'add_mymessage'),(70,'Can change 消息中心',18,'change_mymessage'),(71,'Can delete 消息中心',18,'delete_mymessage'),(72,'Can view 消息中心',18,'view_mymessage'),(73,'Can add 消息模板',19,'add_mymessagetemplate'),(74,'Can change 消息模板',19,'change_mymessagetemplate'),(75,'Can delete 消息模板',19,'delete_mymessagetemplate'),(76,'Can view 消息模板',19,'view_mymessagetemplate'),(77,'Can add 用户消息',20,'add_mymessageuser'),(78,'Can change 用户消息',20,'change_mymessageuser'),(79,'Can delete 用户消息',20,'delete_mymessageuser'),(80,'Can view 用户消息',20,'view_mymessageuser'),(81,'Can add 省市区',21,'add_area'),(82,'Can change 省市区',21,'change_area'),(83,'Can delete 省市区',21,'delete_area'),(84,'Can view 省市区',21,'view_area'),(85,'Can add 微信登录用户数据',22,'add_oauthwxuser'),(86,'Can change 微信登录用户数据',22,'change_oauthwxuser'),(87,'Can delete 微信登录用户数据',22,'delete_oauthwxuser'),(88,'Can view 微信登录用户数据',22,'view_oauthwxuser'),(89,'Can add 平台其他设置',23,'add_othermanage'),(90,'Can change 平台其他设置',23,'change_othermanage'),(91,'Can delete 平台其他设置',23,'delete_othermanage'),(92,'Can view 平台其他设置',23,'view_othermanage'),(93,'Can add 轮播图设置',24,'add_lunbotumanage'),(94,'Can change 轮播图设置',24,'change_lunbotumanage'),(95,'Can delete 轮播图设置',24,'delete_lunbotumanage'),(96,'Can view 轮播图设置',24,'view_lunbotumanage');

#
# Structure for table "auth_group_permissions"
#

DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_group_id_b120cbf9` (`group_id`),
  KEY `auth_group_permissions_permission_id_84c5c92e` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

#
# Data for table "auth_group_permissions"
#


#
# Structure for table "django_migrations"
#

DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4;

#
# Data for table "django_migrations"
#

INSERT INTO `django_migrations` VALUES (1,'address','0001_initial','2021-10-27 13:36:34.520569'),(2,'contenttypes','0001_initial','2021-10-27 13:36:34.547822'),(3,'contenttypes','0002_remove_content_type_name','2021-10-27 13:36:34.580908'),(4,'auth','0001_initial','2021-10-27 13:36:34.691076'),(5,'auth','0002_alter_permission_name_max_length','2021-10-27 13:36:34.709962'),(6,'auth','0003_alter_user_email_max_length','2021-10-27 13:36:34.713839'),(7,'auth','0004_alter_user_username_opts','2021-10-27 13:36:34.718853'),(8,'auth','0005_alter_user_last_login_null','2021-10-27 13:36:34.722827'),(9,'auth','0006_require_contenttypes_0002','2021-10-27 13:36:34.724965'),(10,'auth','0007_alter_validators_add_error_messages','2021-10-27 13:36:34.729593'),(11,'auth','0008_alter_user_username_max_length','2021-10-27 13:36:34.734553'),(12,'auth','0009_alter_user_last_name_max_length','2021-10-27 13:36:34.739265'),(13,'auth','0010_alter_group_name_max_length','2021-10-27 13:36:34.748695'),(14,'auth','0011_update_proxy_permissions','2021-10-27 13:36:34.754595'),(15,'auth','0012_alter_user_first_name_max_length','2021-10-27 13:36:34.759467'),(16,'mysystem','0001_initial','2021-10-27 13:36:35.444413'),(17,'admin','0001_initial','2021-10-27 13:36:35.515401'),(18,'admin','0002_logentry_remove_auto_add','2021-10-27 13:36:35.535572'),(19,'admin','0003_logentry_add_action_flag_choices','2021-10-27 13:36:35.551954'),(20,'captcha','0001_initial','2021-10-27 13:36:35.570003'),(21,'captcha','0002_alter_captchastore_id','2021-10-27 13:36:35.590872'),(22,'lymessages','0001_initial','2021-10-27 13:36:35.656395'),(23,'lymessages','0002_initial','2021-10-27 13:36:35.846328'),(24,'oauth','0001_initial','2021-10-27 13:36:35.918360'),(25,'platformsettings','0001_initial','2021-10-27 13:36:36.010603'),(26,'platformsettings','0002_lunbotumanage','2021-10-27 13:36:36.053621'),(27,'sessions','0001_initial','2021-10-27 13:36:36.073750'),(28,'mysystem','0002_auto_20211110_0850','2021-11-10 08:50:43.117951');

#
# Structure for table "django_session"
#

DROP TABLE IF EXISTS `django_session`;
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

DROP TABLE IF EXISTS `lyadmin_button`;
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

INSERT INTO `lyadmin_button` VALUES ('2d763a6d6dcf409d87056efd06aace0a',NULL,NULL,NULL,'2021-10-27 13:36:42.753623','2021-10-27 13:36:42.753623','修改密码','Changepassword',NULL),('4547b93a-36b9-410d-987c-3c52a9b51156',NULL,NULL,NULL,'2021-10-27 13:36:42.743317','2021-10-27 13:36:42.743317','编辑','Update',NULL),('4a410769-6b0a-4ed3-90f0-b5d89a6f802c',NULL,NULL,NULL,'2021-10-27 13:36:42.744768','2021-10-27 13:36:42.744768','删除','Delete',NULL),('644e9c34-e3d6-4518-b795-a603a6e9a137',NULL,NULL,NULL,'2021-10-27 13:36:42.746390','2021-10-27 13:36:42.747417','单例','Retrieve',NULL),('6e0a41e5308c44a8b0d2785e05b2c07a',NULL,NULL,NULL,'2021-10-27 13:36:42.754759','2021-10-27 13:36:42.754759','禁用','Disable',NULL),('80cb145b-5035-4517-a28a-7d59426f73f8',NULL,NULL,NULL,'2021-10-27 13:36:42.748417','2021-10-27 13:36:42.748417','新增','Create',NULL),('83a9b774-4669-4d2f-b61d-8ee4944c2316',NULL,NULL,NULL,'2021-10-27 13:36:42.751627','2021-10-27 13:36:42.751627','保存','Save',NULL),('ccc3f35f-c80c-4929-b8cc-67531698f397',NULL,NULL,NULL,'2021-10-27 13:36:42.750381','2021-10-27 13:36:42.750381','查询','Search',NULL);

#
# Structure for table "lyadmin_dept"
#

DROP TABLE IF EXISTS `lyadmin_dept`;
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
  `status` int(11) DEFAULT NULL COMMENT '部门状态',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `parent_id` varchar(100) DEFAULT NULL COMMENT '上级部门',
  PRIMARY KEY (`id`),
  KEY `lyadmin_dept_creator_id_bb4dafb6` (`creator_id`),
  KEY `lyadmin_dept_parent_id_c856ab90` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='部门表';

#
# Data for table "lyadmin_dept"
#

INSERT INTO `lyadmin_dept` VALUES ('cae96ade-7483-4827-bb0d-d2bd63ec1cc4',NULL,NULL,NULL,'2021-10-27 13:36:42.736851','2021-10-27 13:36:42.736851','财务部门',1,NULL,NULL,NULL,1,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3'),('d2c03bd9-dad0-4262-88ca-c3681d224fc3',NULL,NULL,NULL,'2021-10-27 13:36:42.739261','2021-10-27 13:36:42.739261','lyadmin团队',1,NULL,NULL,NULL,1,NULL,NULL),('fd8230ca-67bd-4347-8a9b-57eb19be5d9e',NULL,NULL,NULL,'2021-10-27 13:36:42.741323','2021-10-27 13:36:42.741323','研发部门',2,NULL,NULL,NULL,1,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3');

#
# Structure for table "lyadmin_dictionary"
#

DROP TABLE IF EXISTS `lyadmin_dictionary`;
CREATE TABLE `lyadmin_dictionary` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `code` varchar(100) DEFAULT NULL COMMENT '编码',
  `name` varchar(100) DEFAULT NULL COMMENT '名称',
  `status` int(11) NOT NULL COMMENT '状态',
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

DROP TABLE IF EXISTS `lyadmin_dictionary_detail`;
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
  `status` int(11) NOT NULL COMMENT '状态',
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

DROP TABLE IF EXISTS `lyadmin_login_log`;
CREATE TABLE `lyadmin_login_log` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `session_id` varchar(64) DEFAULT NULL COMMENT '会话标识',
  `browser` varchar(64) NOT NULL COMMENT '浏览器',
  `ipaddr` varchar(32) DEFAULT NULL COMMENT 'ip地址',
  `loginLocation` varchar(64) DEFAULT NULL COMMENT '登录位置',
  `msg` longtext COMMENT '操作信息',
  `os` varchar(64) DEFAULT NULL COMMENT '操作系统',
  `status` tinyint(1) NOT NULL COMMENT '登录状态',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `lyadmin_login_log_creator_id_2aae8b60` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='登录日志';

#
# Data for table "lyadmin_login_log"
#


#
# Structure for table "lyadmin_menu"
#

DROP TABLE IF EXISTS `lyadmin_menu`;
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
  `is_link` int(11) NOT NULL COMMENT '是否外链',
  `web_path` varchar(128) DEFAULT NULL COMMENT '路由地址',
  `component` varchar(128) DEFAULT NULL COMMENT '组件地址',
  `component_name` varchar(50) DEFAULT NULL COMMENT '组件名称',
  `status` int(11) NOT NULL COMMENT '菜单状态',
  `isautopm` int(11) NOT NULL COMMENT '自动创建按钮权限',
  `cache` int(11) NOT NULL COMMENT '是否页面缓存',
  `visible` int(11) NOT NULL COMMENT '侧边栏中是否显示',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `parent_id` varchar(100) DEFAULT NULL COMMENT '上级菜单',
  PRIMARY KEY (`id`),
  KEY `lyadmin_menu_creator_id_39b95522` (`creator_id`),
  KEY `lyadmin_menu_parent_id_4a6f3129` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单表';

#
# Data for table "lyadmin_menu"
#

INSERT INTO `lyadmin_menu` VALUES ('151035da-77a3-4a62-b474-fce6824571fb',NULL,NULL,NULL,'2021-10-27 13:36:42.779118','2021-10-27 13:36:42.779118','support','按钮管理',6,0,'buttonManage','system/button','buttonManage',1,0,0,0,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('15c9ebc5-d12f-470a-a560-938a7dc57570',NULL,NULL,NULL,'2021-10-27 13:36:42.774460','2021-10-27 13:36:42.774460','users','角色管理',3,0,'roleManage','system/role','role',1,0,0,1,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('244b28685cd14a39a383189981510d4a',NULL,NULL,NULL,'2021-10-27 13:36:42.760322','2021-10-27 13:36:42.760322','el-icon-user','用户管理',5,0,'userManage',NULL,NULL,1,0,0,1,NULL,NULL),('25735adb-d051-4b7b-bbb7-1154526f3e4c',NULL,NULL,NULL,'2021-10-27 13:36:42.783105','2021-10-27 13:36:42.783105','el-icon-s-custom','个人中心',13,0,'personalCenter',NULL,NULL,1,0,0,1,NULL,NULL),('2e3438c8-3ddc-43ff-b8d8-cca328e4856e',NULL,NULL,NULL,'2021-10-27 13:36:42.758322','2021-10-27 13:36:42.758322','el-icon-user','管理员管理',1,0,'adminManage',NULL,NULL,1,0,0,1,NULL,NULL),('3171db16eda048ae92b16536fc1241b6',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2021-12-01 09:36:17.546148','2021-12-01 09:36:05.392663','','平台公告',5,0,'messagNotice',NULL,NULL,1,1,0,1,'456b688c-8ad5-46de-bc2e-d41d8047bd42','d4e2fe169a8b40f3846421ac04e4fccb'),('4236eb70-1558-43a0-9cf2-037230c547f9',NULL,NULL,NULL,'2021-10-27 13:36:42.767119','2021-10-27 13:36:42.767119','university','部门管理',1,0,'departmentManage','system/dept','dept',1,0,0,1,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('4ba07859-8b73-4524-a1a6-bbff36d98337',NULL,NULL,NULL,'2021-10-27 13:36:42.769766','2021-10-27 13:36:42.769766','gears','操作日志',1,0,'journalManage','system/log/operationLog','operationLog',1,0,0,1,NULL,'c236fb6b-ddaa-4deb-b79b-16e42d9f347f'),('54f769b0-3dff-416c-8102-e55ec44827cc',NULL,NULL,NULL,'2021-10-27 13:36:42.781137','2021-10-27 13:36:42.781137','el-icon-s-tools','系统管理',20,0,'departmentManage',NULL,NULL,1,0,0,1,NULL,NULL),('56c3f341-4f46-4b04-9cfc-c8a14701707e',NULL,NULL,NULL,'2021-10-27 13:36:42.770764','2021-10-27 13:36:42.770764','reorder','菜单管理',2,0,'menuManage','system/menu','menu',1,0,0,1,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('80a340eae92b430abe17635468c2df1d',NULL,'superadmin',NULL,'2021-12-01 09:36:09.486691','2021-10-27 13:36:42.766122','','其他设置',12,0,'platformSettingsother',NULL,NULL,1,0,0,1,NULL,'d4e2fe169a8b40f3846421ac04e4fccb'),('a607e820-36e5-45c0-aabf-85a8e4e2c7ac',NULL,NULL,NULL,'2021-10-27 13:36:42.777201','2021-10-27 13:36:42.777201','user-plus','权限管理',4,0,'authorityManage','system/rolePermission','rolePermission',1,0,0,1,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc'),('ae5629946df4497cbec10419e8375dd9',NULL,NULL,NULL,'2021-10-27 13:36:42.763130','2021-10-27 13:36:42.763130','','轮播图设置',1,0,'carouselSettingsimg',NULL,NULL,1,0,0,1,NULL,'d4e2fe169a8b40f3846421ac04e4fccb'),('c236fb6b-ddaa-4deb-b79b-16e42d9f347f',NULL,NULL,NULL,'2021-10-27 13:36:42.784102','2021-10-27 13:36:42.784102','el-icon-warning','日志管理',999,0,'journalManage',NULL,NULL,1,0,0,1,NULL,NULL),('d4e2fe169a8b40f3846421ac04e4fccb',NULL,NULL,NULL,'2021-10-27 13:36:42.762161','2021-10-27 13:36:42.762161','el-icon-s-platform','平台设置',9,0,'',NULL,NULL,1,0,0,1,NULL,NULL),('e0f53902-e901-490c-83f3-331e60b97fcf',NULL,NULL,NULL,'2021-10-27 13:36:42.773493','2021-10-27 13:36:42.773493','clock-o','按钮配置',2,0,'buttonConfig/:id/:name','system/ menuButton',NULL,1,0,0,0,NULL,'54f769b0-3dff-416c-8102-e55ec44827cc');

#
# Structure for table "lyadmin_menu_button"
#

DROP TABLE IF EXISTS `lyadmin_menu_button`;
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
  `method` int(11) DEFAULT NULL COMMENT '接口请求方法',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  `menu_id` varchar(100) NOT NULL COMMENT '关联菜单',
  PRIMARY KEY (`id`),
  KEY `lyadmin_menu_button_creator_id_e2b5a076` (`creator_id`),
  KEY `lyadmin_menu_button_menu_id_74205633` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

#
# Data for table "lyadmin_menu_button"
#

INSERT INTO `lyadmin_menu_button` VALUES ('0088e172566f4ee388092ec2be3584ee',NULL,NULL,NULL,'2021-10-27 13:36:42.863398','2021-10-27 13:36:42.863398','删除','Delete','/api/platformsettings/lunboimg/{id}/',3,NULL,'ae5629946df4497cbec10419e8375dd9'),('0209de89-6b9f-4d8a-84d3-ccfc3cc8b4da',NULL,NULL,NULL,'2021-10-27 13:36:42.790693','2021-10-27 13:36:42.790693','编辑','Update','/api/system/button/{id}/',2,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('04896a47-0f3a-4e2f-a111-bfe15f9e31c5',NULL,NULL,NULL,'2021-10-27 13:36:42.792191','2021-10-27 13:36:42.792191','编辑','Update','/api/system/menu/{id}/',2,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('0d931efc-2f80-418f-b4a0-5251f0a88f69',NULL,NULL,NULL,'2021-10-27 13:36:42.832844','2021-10-27 13:36:42.832844','新增','Create','/api/system/operation_log/',1,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('10610c56-cec2-4774-9468-e1c763e59e70',NULL,NULL,NULL,'2021-10-27 13:36:42.834135','2021-10-27 13:36:42.834135','新增','Create','/api/system/dept/',1,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('140166e2-471e-455e-9dcd-05cebbbab95d',NULL,NULL,NULL,'2021-10-27 13:36:42.812954','2021-10-27 13:36:42.812954','查询','Search','/api/system/role/',0,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('14e7088f-a39b-47ae-bd67-b9bbcabae96b',NULL,NULL,NULL,'2021-10-27 13:36:42.849839','2021-10-27 13:36:42.849839','单例','Retrieve','/api/users/users/{id}/',0,NULL,'244b28685cd14a39a383189981510d4a'),('1a0c96cf-09a6-43b4-b08a-0c5b6e2f7bb8',NULL,NULL,NULL,'2021-10-27 13:36:42.879885','2021-10-27 13:36:42.879885','保存','Retrieve','/api/system/role/{id}/',2,NULL,'a607e820-36e5-45c0-aabf-85a8e4e2c7ac'),('1b4f27a7-8ab8-4388-ae57-46e29976cf0e',NULL,NULL,NULL,'2021-10-27 13:36:42.835746','2021-10-27 13:36:42.835746','新增','Create','/api/system/button/',1,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('1d4441fdc418499f856c23aa4e1be2c0',NULL,NULL,NULL,'2021-10-27 13:36:42.847845','2021-10-27 13:36:42.847845','单例','Retrieve','/api/platformsettings/other/{id}/',0,NULL,'80a340eae92b430abe17635468c2df1d'),('264cc3d69f7a46d5a117997e9c78506c',NULL,NULL,NULL,'2021-10-27 13:36:42.864297','2021-10-27 13:36:42.864297','删除','Delete','/api/platformsettings/other/{id}/',3,NULL,'80a340eae92b430abe17635468c2df1d'),('2a3d4756-4d51-4129-b3c4-b2c7a00dbb8a',NULL,NULL,NULL,'2021-10-27 13:36:42.837770','2021-10-27 13:36:42.837770','新增','Create','/api/system/role/',1,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('2c53efc8-e6a4-4192-8688-03baed0874a4',NULL,NULL,NULL,'2021-10-27 13:36:42.865904','2021-10-27 13:36:42.865904','删除','Delete','/api/system/user/{id}/',3,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('324776a3-48ec-4bca-bdd9-1838e2b6f7cc',NULL,NULL,NULL,'2021-10-27 13:36:42.815689','2021-10-27 13:36:42.815689','查询','Search','/api/system/user/',0,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('353595a28cb1463b830cfbf79fea60b5',NULL,NULL,NULL,'2021-10-27 13:36:42.880876','2021-10-27 13:36:42.880876','禁用','Disable','/api/users/users/disableuser/{id}/',2,NULL,'244b28685cd14a39a383189981510d4a'),('3688b715-4689-468f-bf3e-6f910259f837',NULL,NULL,NULL,'2021-10-27 13:36:42.816928','2021-10-27 13:36:42.816928','查询','Search','/api/system/user/user_info/',0,NULL,'25735adb-d051-4b7b-bbb7-1154526f3e4c'),('37462e31-3cdf-4576-af10-5958f53b1bef',NULL,NULL,NULL,'2021-10-27 13:36:42.818641','2021-10-27 13:36:42.818641','查询','Search','/api/system/operation_log/',0,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('3e11db64-b8e8-4558-963b-71d063a7db16',NULL,NULL,NULL,'2021-10-27 13:36:42.793858','2021-10-27 13:36:42.793858','编辑','Update','/api/system/dept/{id}/',2,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('3fd6ae6c-fd76-4465-b2b6-db672f4bd79e',NULL,NULL,NULL,'2021-10-27 13:36:42.867901','2021-10-27 13:36:42.867901','删除','Delete','/api/system/role/{id}/',3,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('42ad6e05-7c84-444f-bcae-09de84f4988b',NULL,NULL,NULL,'2021-10-27 13:36:42.820665','2021-10-27 13:36:42.820665','查询','Search','/api/system/menu/',0,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('43696212-ecba-4e66-8678-33c9bc935c76',NULL,NULL,NULL,'2021-10-27 13:36:42.822020','2021-10-27 13:36:42.822020','查询','Search','/api/users/users/',0,NULL,'244b28685cd14a39a383189981510d4a'),('4fe4b7f5-0bc8-4375-9f39-747e06ec285a',NULL,NULL,NULL,'2021-10-27 13:36:42.869954','2021-10-27 13:36:42.869954','删除','Delete','/api/system/menu_button/{id}/',3,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf'),('51085c21-2279-490f-8878-594f059f7616',NULL,NULL,NULL,'2021-10-27 13:36:42.870709','2021-10-27 13:36:42.870709','删除','Delete','/api/system/button/{id}/',3,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('59db5099a03f44c8adb883faa340c15a',NULL,NULL,NULL,'2021-10-27 13:36:42.807842','2021-10-27 13:36:42.807842','查询','Search','/api/platformsettings/lunboimg/',0,NULL,'ae5629946df4497cbec10419e8375dd9'),('5aac29b0-5a32-45fb-81c5-437b48f4a5df',NULL,NULL,NULL,'2021-10-27 13:36:42.823707','2021-10-27 13:36:42.823707','查询','Search','/api/system/menu_button/',0,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf'),('5d77d14e-b199-481f-a97d-6e4c0e84fe71',NULL,NULL,NULL,'2021-10-27 13:36:42.795854','2021-10-27 13:36:42.795854','修改密码','Changepassword','/api/system/user/change_password/{id}/',2,NULL,'25735adb-d051-4b7b-bbb7-1154526f3e4c'),('6208f412-6bca-4d7b-a5a0-0103b7ba6091',NULL,NULL,NULL,'2021-10-27 13:36:42.850916','2021-10-27 13:36:42.850916','单例','Retrieve','/api/system/button/{id}/',0,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('6300774a-d19c-43ad-8102-d7bf341eff33',NULL,NULL,NULL,'2021-10-27 13:36:42.852598','2021-10-27 13:36:42.852598','单例','Retrieve','/api/system/dept/{id}/',0,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('646e9790-24f5-4606-abc4-0b5eede12f66',NULL,NULL,NULL,'2021-10-27 13:36:42.826111','2021-10-27 13:36:42.826111','查询','Search','/api/system/dept/',0,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('6b88361b326a4e55a8a5135c08ba66f1',NULL,'superadmin',NULL,'2021-12-01 09:44:04.286191','2021-12-01 09:36:05.401611','单例','Retrieve','/api/messages/messagenotice/{id}/',0,NULL,'3171db16eda048ae92b16536fc1241b6'),('6e4251a948f348ccaa419a777a118048',NULL,NULL,NULL,'2021-10-27 13:36:42.788697','2021-10-27 13:36:42.788697','编辑','Update','/api/platformsettings/other/{id}/',2,NULL,'80a340eae92b430abe17635468c2df1d'),('77096cd56a6441699345e6e4f22d0ec3',NULL,NULL,NULL,'2021-10-27 13:36:42.830824','2021-10-27 13:36:42.830824','新增','Create','/api/platformsettings/other/',1,NULL,'80a340eae92b430abe17635468c2df1d'),('7aef1da4647844e3944a2745cef1bc6d',NULL,NULL,NULL,'2021-10-27 13:36:42.830073','2021-10-27 13:36:42.830073','新增','Create','/api/platformsettings/lunboimg/',1,NULL,'ae5629946df4497cbec10419e8375dd9'),('80efc041695a42e4a9a04c010c6c7004',NULL,NULL,NULL,'2021-10-27 13:36:42.809961','2021-10-27 13:36:42.809961','查询','Search','/api/platformsettings/other/',0,NULL,'80a340eae92b430abe17635468c2df1d'),('875bdfeb-0c34-441d-8ee3-bb93c21e17dd',NULL,NULL,NULL,'2021-10-27 13:36:42.797849','2021-10-27 13:36:42.797849','编辑','Update','/api/users/users/{id}/',2,NULL,'244b28685cd14a39a383189981510d4a'),('8ae924bd-576c-4ae1-92eb-b0a98148baae',NULL,NULL,NULL,'2021-10-27 13:36:42.872360','2021-10-27 13:36:42.872360','删除','Delete','/api/system/menu/{id}/',3,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('8b7a0e79-a6ef-4946-87c6-8c042b887e1c',NULL,NULL,NULL,'2021-10-27 13:36:42.854278','2021-10-27 13:36:42.854278','单例','Retrieve','/api/system/operation_log/{id}/',0,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('96022ae5-6425-47b9-8f89-01edc33eb2b7',NULL,NULL,NULL,'2021-10-27 13:36:42.855950','2021-10-27 13:36:42.855950','单例','Retrieve','/api/system/role/{id}/',0,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('9e6b2376-1ab0-4966-8d5d-4ad4f911d13c',NULL,NULL,NULL,'2021-10-27 13:36:42.838979','2021-10-27 13:36:42.838979','新增','Create','/api/system/user/',1,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('9fc8436a-1996-478f-a155-5de7939a54dc',NULL,NULL,NULL,'2021-10-27 13:36:42.840630','2021-10-27 13:36:42.840630','新增','Create','/api/users/users/',1,NULL,'244b28685cd14a39a383189981510d4a'),('a3088120763d49ad93498eb515c7c244',NULL,NULL,NULL,'2021-10-27 13:36:42.846848','2021-10-27 13:36:42.846848','单例','Retrieve','/api/platformsettings/lunboimg/{id}/',0,NULL,'ae5629946df4497cbec10419e8375dd9'),('abe5c07f-0cab-4053-ac24-e782792e9d7f',NULL,NULL,NULL,'2021-10-27 13:36:42.842253','2021-10-27 13:36:42.842253','新增','Create','/api/system/menu/',1,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('acfde861-1872-47e2-a1f1-abeda5175b7f',NULL,NULL,NULL,'2021-10-27 13:36:42.874356','2021-10-27 13:36:42.874356','删除','Delete','/api/system/operation_log/{id}/',3,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('af60d628-73b1-4c5d-b34e-7c70ab9bd87e',NULL,NULL,NULL,'2021-10-27 13:36:42.828108','2021-10-27 13:36:42.828108','查询','Search','/api/system/button/',0,NULL,'151035da-77a3-4a62-b474-fce6824571fb'),('b10f7d08-2592-4b54-8557-b5ca864a029a',NULL,NULL,NULL,'2021-10-27 13:36:42.875894','2021-10-27 13:36:42.875894','删除','Delete','/api/system/dept/{id}/',3,NULL,'4236eb70-1558-43a0-9cf2-037230c547f9'),('bb7de9ee-5fd1-46f5-9849-088c522f49c7',NULL,NULL,NULL,'2021-10-27 13:36:42.877919','2021-10-27 13:36:42.877919','删除','Delete','/api/users/users/{id}/',3,NULL,'244b28685cd14a39a383189981510d4a'),('bc114580-e62d-4e08-b707-843759817344',NULL,NULL,NULL,'2021-10-27 13:36:42.799843','2021-10-27 13:36:42.799843','编辑','Update','/api/system/user/{id}/',2,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('bc6104a0-f487-4dfd-a368-fb587d6d57d8',NULL,NULL,NULL,'2021-10-27 13:36:42.801083','2021-10-27 13:36:42.801083','编辑','Update','/api/system/menu_button/{id}/',2,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf'),('c8eee7f68c1845169b8d2af946502077',NULL,'superadmin',NULL,'2021-12-01 09:44:08.416152','2021-12-01 09:36:05.402609','删除','Delete','/api/messages/messagenotice/{id}/',3,NULL,'3171db16eda048ae92b16536fc1241b6'),('ca69833045ed4cf78c8586f7e55ba6db',NULL,'superadmin',NULL,'2021-12-01 09:43:47.988278','2021-12-01 09:36:05.396653','编辑','Update','/api/messages/messagenotice/{id}/',2,NULL,'3171db16eda048ae92b16536fc1241b6'),('d1b3c15f0c664857aeca1d9065d9c499',NULL,'superadmin',NULL,'2021-12-01 09:43:53.786750','2021-12-01 09:36:05.399617','查询','Search','/api/messages/messagenotice/',0,NULL,'3171db16eda048ae92b16536fc1241b6'),('d22c0176-96e0-48b3-b81e-13443f306af5',NULL,NULL,NULL,'2021-10-27 13:36:42.802786','2021-10-27 13:36:42.802786','编辑','Update','/api/system/role/{id}/',2,NULL,'15c9ebc5-d12f-470a-a560-938a7dc57570'),('d2e0608b5b4941ef8c3ff834977caeef',NULL,'superadmin',NULL,'2021-12-01 09:44:01.640263','2021-12-01 09:36:05.400641','新增','Create','/api/messages/messagenotice/',1,NULL,'3171db16eda048ae92b16536fc1241b6'),('dcc58831-08d1-4469-8b01-fca71e0f497f',NULL,NULL,NULL,'2021-10-27 13:36:42.805122','2021-10-27 13:36:42.805122','编辑','Update','/api/system/user/user_info/',2,NULL,'25735adb-d051-4b7b-bbb7-1154526f3e4c'),('e6b93920-2236-46ec-841b-cff6f63ce788',NULL,NULL,NULL,'2021-10-27 13:36:42.807121','2021-10-27 13:36:42.807121','编辑','Update','/api/system/operation_log/{id}/',2,NULL,'4ba07859-8b73-4524-a1a6-bbff36d98337'),('e7fa30290d37447585ea7583d9d01f1b',NULL,NULL,NULL,'2021-10-27 13:36:42.787095','2021-10-27 13:36:42.787095','编辑','Update','/api/platformsettings/lunboimg/{id}/',2,NULL,'ae5629946df4497cbec10419e8375dd9'),('f0e080c0-275d-4085-b56c-735b49510eff',NULL,NULL,NULL,'2021-10-27 13:36:42.857976','2021-10-27 13:36:42.857976','单例','Retrieve','/api/system/user/{id}/',0,NULL,'2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),('fc71b446-fde1-439f-ab41-c38f30230caa',NULL,NULL,NULL,'2021-10-27 13:36:42.844249','2021-10-27 13:36:42.844249','新增','Create','/api/system/menu_button/',1,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf'),('fcbe4cec-cc2d-436d-92ba-023f8c9ad31c',NULL,NULL,NULL,'2021-10-27 13:36:42.859942','2021-10-27 13:36:42.859942','单例','Retrieve','/api/system/menu/{id}/',0,NULL,'56c3f341-4f46-4b04-9cfc-c8a14701707e'),('fe96f32c-6124-4b24-b809-4964186f5163',NULL,NULL,NULL,'2021-10-27 13:36:42.861936','2021-10-27 13:36:42.861936','单例','Retrieve','/api/system/menu_button/{id}/',0,NULL,'e0f53902-e901-490c-83f3-331e60b97fcf');

#
# Structure for table "lyadmin_operation_log"
#

DROP TABLE IF EXISTS `lyadmin_operation_log`;
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


#
# Structure for table "lyadmin_post"
#

DROP TABLE IF EXISTS `lyadmin_post`;
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

DROP TABLE IF EXISTS `lyadmin_role`;
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
  `status` int(11) NOT NULL COMMENT '角色状态',
  `admin` int(11) NOT NULL COMMENT '是否为admin',
  `data_range` int(11) NOT NULL COMMENT '数据权限范围',
  `remark` longtext COMMENT '备注',
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `lyadmin_role_creator_id_858b8a61` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

#
# Data for table "lyadmin_role"
#

INSERT INTO `lyadmin_role` VALUES ('35b58d98-b506-4f93-be79-ed1e109da071',NULL,NULL,NULL,'2021-10-27 13:36:42.894069','2021-10-27 13:36:42.894069','普通用户','public',2,1,0,4,NULL,NULL),('36001d1a-1b3e-4413-bdfe-b3bc04375f46',NULL,NULL,NULL,'2021-10-27 13:36:42.883871','2021-10-27 13:36:42.883871','管理员','admin',1,1,1,3,NULL,NULL);

#
# Structure for table "lyadmin_role_dept"
#

DROP TABLE IF EXISTS `lyadmin_role_dept`;
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

INSERT INTO `lyadmin_role_dept` VALUES (1,'35b58d98-b506-4f93-be79-ed1e109da071','fd8230ca-67bd-4347-8a9b-57eb19be5d9e'),(2,'35b58d98-b506-4f93-be79-ed1e109da071','d2c03bd9-dad0-4262-88ca-c3681d224fc3');

#
# Structure for table "lyadmin_role_menu"
#

DROP TABLE IF EXISTS `lyadmin_role_menu`;
CREATE TABLE `lyadmin_role_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` varchar(100) NOT NULL,
  `menu_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lyadmin_role_menu_role_id_menu_id_ee3d26d9_uniq` (`role_id`,`menu_id`),
  KEY `lyadmin_role_menu_role_id_68ec079a` (`role_id`),
  KEY `lyadmin_role_menu_menu_id_27af6f62` (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;

#
# Data for table "lyadmin_role_menu"
#

INSERT INTO `lyadmin_role_menu` VALUES (1,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a607e820-36e5-45c0-aabf-85a8e4e2c7ac'),(2,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','ae5629946df4497cbec10419e8375dd9'),(3,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2e3438c8-3ddc-43ff-b8d8-cca328e4856e'),(4,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','56c3f341-4f46-4b04-9cfc-c8a14701707e'),(5,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','15c9ebc5-d12f-470a-a560-938a7dc57570'),(6,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','4ba07859-8b73-4524-a1a6-bbff36d98337'),(7,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','d4e2fe169a8b40f3846421ac04e4fccb'),(8,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','c236fb6b-ddaa-4deb-b79b-16e42d9f347f'),(9,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','244b28685cd14a39a383189981510d4a'),(10,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','54f769b0-3dff-416c-8102-e55ec44827cc'),(11,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','4236eb70-1558-43a0-9cf2-037230c547f9'),(12,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','151035da-77a3-4a62-b474-fce6824571fb'),(13,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','e0f53902-e901-490c-83f3-331e60b97fcf'),(14,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','80a340eae92b430abe17635468c2df1d'),(15,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','25735adb-d051-4b7b-bbb7-1154526f3e4c'),(16,'35b58d98-b506-4f93-be79-ed1e109da071','15c9ebc5-d12f-470a-a560-938a7dc57570'),(17,'35b58d98-b506-4f93-be79-ed1e109da071','56c3f341-4f46-4b04-9cfc-c8a14701707e'),(18,'35b58d98-b506-4f93-be79-ed1e109da071','244b28685cd14a39a383189981510d4a'),(19,'35b58d98-b506-4f93-be79-ed1e109da071','54f769b0-3dff-416c-8102-e55ec44827cc'),(20,'35b58d98-b506-4f93-be79-ed1e109da071','4236eb70-1558-43a0-9cf2-037230c547f9');

#
# Structure for table "lyadmin_role_permission"
#

DROP TABLE IF EXISTS `lyadmin_role_permission`;
CREATE TABLE `lyadmin_role_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` varchar(100) NOT NULL,
  `menubutton_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lyadmin_role_permission_role_id_menubutton_id_dfd195d1_uniq` (`role_id`,`menubutton_id`),
  KEY `lyadmin_role_permission_role_id_610a95e1` (`role_id`),
  KEY `lyadmin_role_permission_menubutton_id_539eb394` (`menubutton_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4;

#
# Data for table "lyadmin_role_permission"
#

INSERT INTO `lyadmin_role_permission` VALUES (1,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','51085c21-2279-490f-8878-594f059f7616'),(2,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','5d77d14e-b199-481f-a97d-6e4c0e84fe71'),(3,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','43696212-ecba-4e66-8678-33c9bc935c76'),(4,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3fd6ae6c-fd76-4465-b2b6-db672f4bd79e'),(5,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','875bdfeb-0c34-441d-8ee3-bb93c21e17dd'),(6,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','e7fa30290d37447585ea7583d9d01f1b'),(7,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','0088e172566f4ee388092ec2be3584ee'),(8,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','bc6104a0-f487-4dfd-a368-fb587d6d57d8'),(9,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3688b715-4689-468f-bf3e-6f910259f837'),(10,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6e4251a948f348ccaa419a777a118048'),(11,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','140166e2-471e-455e-9dcd-05cebbbab95d'),(12,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','9fc8436a-1996-478f-a155-5de7939a54dc'),(13,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','bb7de9ee-5fd1-46f5-9849-088c522f49c7'),(14,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','646e9790-24f5-4606-abc4-0b5eede12f66'),(15,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','e6b93920-2236-46ec-841b-cff6f63ce788'),(16,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','dcc58831-08d1-4469-8b01-fca71e0f497f'),(17,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','acfde861-1872-47e2-a1f1-abeda5175b7f'),(18,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','af60d628-73b1-4c5d-b34e-7c70ab9bd87e'),(19,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','fcbe4cec-cc2d-436d-92ba-023f8c9ad31c'),(20,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','1d4441fdc418499f856c23aa4e1be2c0'),(21,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','353595a28cb1463b830cfbf79fea60b5'),(22,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','9e6b2376-1ab0-4966-8d5d-4ad4f911d13c'),(23,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','77096cd56a6441699345e6e4f22d0ec3'),(24,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','0d931efc-2f80-418f-b4a0-5251f0a88f69'),(25,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','96022ae5-6425-47b9-8f89-01edc33eb2b7'),(26,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','14e7088f-a39b-47ae-bd67-b9bbcabae96b'),(27,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','10610c56-cec2-4774-9468-e1c763e59e70'),(28,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','7aef1da4647844e3944a2745cef1bc6d'),(29,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6208f412-6bca-4d7b-a5a0-0103b7ba6091'),(30,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','6300774a-d19c-43ad-8102-d7bf341eff33'),(31,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','8b7a0e79-a6ef-4946-87c6-8c042b887e1c'),(32,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','3e11db64-b8e8-4558-963b-71d063a7db16'),(33,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2c53efc8-e6a4-4192-8688-03baed0874a4'),(34,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','5aac29b0-5a32-45fb-81c5-437b48f4a5df'),(35,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','8ae924bd-576c-4ae1-92eb-b0a98148baae'),(36,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','a3088120763d49ad93498eb515c7c244'),(37,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','0209de89-6b9f-4d8a-84d3-ccfc3cc8b4da'),(38,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','1b4f27a7-8ab8-4388-ae57-46e29976cf0e'),(39,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','80efc041695a42e4a9a04c010c6c7004'),(40,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','37462e31-3cdf-4576-af10-5958f53b1bef'),(41,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','b10f7d08-2592-4b54-8557-b5ca864a029a'),(42,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','04896a47-0f3a-4e2f-a111-bfe15f9e31c5'),(43,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','264cc3d69f7a46d5a117997e9c78506c'),(44,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','42ad6e05-7c84-444f-bcae-09de84f4988b'),(45,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','fc71b446-fde1-439f-ab41-c38f30230caa'),(46,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','4fe4b7f5-0bc8-4375-9f39-747e06ec285a'),(47,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','59db5099a03f44c8adb883faa340c15a'),(48,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','abe5c07f-0cab-4053-ac24-e782792e9d7f'),(49,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','324776a3-48ec-4bca-bdd9-1838e2b6f7cc'),(50,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','bc114580-e62d-4e08-b707-843759817344'),(51,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','2a3d4756-4d51-4129-b3c4-b2c7a00dbb8a'),(52,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','1a0c96cf-09a6-43b4-b08a-0c5b6e2f7bb8'),(53,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','f0e080c0-275d-4085-b56c-735b49510eff'),(54,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','fe96f32c-6124-4b24-b809-4964186f5163'),(55,'36001d1a-1b3e-4413-bdfe-b3bc04375f46','d22c0176-96e0-48b3-b81e-13443f306af5');

#
# Structure for table "lyadmin_users"
#

DROP TABLE IF EXISTS `lyadmin_users`;
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
  `mobile` varchar(11) DEFAULT NULL COMMENT '电话',
  `avatar` varchar(200) DEFAULT NULL COMMENT '头像',
  `name` varchar(40) NOT NULL COMMENT '姓名',
  `nickname` varchar(100) NOT NULL COMMENT '用户昵称',
  `gender` int(11) DEFAULT NULL COMMENT '性别',
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

INSERT INTO `lyadmin_users` VALUES ('pbkdf2_sha256$260000$oivECWOjB0GJyMjPsrqb3t$9FvnYtXtsNWDva2P3A/eIg6cRMLOp7kiIOuwfLKyDAY=',NULL,0,'','',0,1,'2021-10-27 13:36:42.908928','244b28685cd14a39a383189981510d4a',NULL,NULL,NULL,'2021-10-27 16:11:15.297518','2021-10-27 13:36:42.908928','test',NULL,'18888888888',NULL,'测试用户','测试用户',NULL,NULL,''),('pbkdf2_sha256$260000$oE0tnjC7PRIV6aCEah0J1F$scZo6l2/kekoClW8jZ6bM4PmSXevb4qzqHLro8PvzLc=',NULL,1,'','',1,1,'2021-10-27 13:36:42.901886','456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,NULL,NULL,'2021-10-27 13:36:42.901886','2021-10-27 13:36:42.901886','superadmin',NULL,NULL,NULL,'超级管理员','',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3'),('pbkdf2_sha256$260000$DO6dpT8e4Ls0yD51grncC8$KZfswxNJ8MILTWwy+bicRyU7Q3PKC4orn4SJbhIkN4Q=',NULL,0,'','',1,1,'2021-10-27 13:36:42.904112','d1431450-5068-4461-b57e-7862c005a547',NULL,NULL,NULL,'2021-10-27 13:36:42.904112','2021-10-27 13:36:42.904112','admin',NULL,NULL,NULL,'管理员','',NULL,NULL,'d2c03bd9-dad0-4262-88ca-c3681d224fc3');

#
# Structure for table "django_admin_log"
#

DROP TABLE IF EXISTS `django_admin_log`;
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

DROP TABLE IF EXISTS `lyadmin_users_groups`;
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

DROP TABLE IF EXISTS `lyadmin_users_post`;
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

DROP TABLE IF EXISTS `lyadmin_users_role`;
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

INSERT INTO `lyadmin_users_role` VALUES (1,'d1431450-5068-4461-b57e-7862c005a547','36001d1a-1b3e-4413-bdfe-b3bc04375f46');

#
# Structure for table "lyadmin_users_user_permissions"
#

DROP TABLE IF EXISTS `lyadmin_users_user_permissions`;
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
# Structure for table "tb_areas"
#

DROP TABLE IF EXISTS `tb_areas`;
CREATE TABLE `tb_areas` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_areas_parent_id_bae67575_fk_tb_areas_id` (`parent_id`),
  CONSTRAINT `tb_areas_parent_id_bae67575_fk_tb_areas_id` FOREIGN KEY (`parent_id`) REFERENCES `tb_areas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='省市区';

#
# Data for table "tb_areas"
#


#
# Structure for table "tb_lunbo_manage"
#

DROP TABLE IF EXISTS `tb_lunbo_manage`;
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
  `link` varchar(100) NOT NULL,
  `creator_id` varchar(100) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `tb_lunbo_manage_creator_id_61e86919` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='轮播图设置';

#
# Data for table "tb_lunbo_manage"
#

INSERT INTO `tb_lunbo_manage` VALUES ('e86adc251eb348c1bc0d1534cb130d3e',NULL,NULL,NULL,'2021-10-27 13:36:42.911920','2021-10-27 13:36:42.911920','首页轮播图1',1,1,1,'http://127.0.0.1:8000/media/platform/2021-10-27/20211027110807_498.jpg','http://www.xxx.com',NULL);

#
# Structure for table "tb_message_template"
#

DROP TABLE IF EXISTS `tb_message_template`;
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

DROP TABLE IF EXISTS `tb_message`;
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

INSERT INTO `tb_message` VALUES ('7210a59d19fe406bbd237510344334bf',NULL,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL,'2021-12-01 09:45:55.118585','2021-12-01 09:45:55.118585',2,1,'测试消息','<p>消息内容实体部分</p>','/index/path',1,'456b688c-8ad5-46de-bc2e-d41d8047bd42',NULL);

#
# Structure for table "tb_message_user"
#

DROP TABLE IF EXISTS `tb_message_user`;
CREATE TABLE `tb_message_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_datetime` datetime(6) DEFAULT NULL,
  `update_datetime` datetime(6) DEFAULT NULL,
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
# Structure for table "tb_oauth_wx"
#

DROP TABLE IF EXISTS `tb_oauth_wx`;
CREATE TABLE `tb_oauth_wx` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_datetime` datetime(6) DEFAULT NULL,
  `update_datetime` datetime(6) DEFAULT NULL,
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
  `mobilePhoneNumber` varchar(11) NOT NULL,
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

DROP TABLE IF EXISTS `tb_other_manage`;
CREATE TABLE `tb_other_manage` (
  `id` varchar(100) NOT NULL COMMENT 'Id',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `modifier` varchar(100) DEFAULT NULL COMMENT '修改人',
  `dept_belong_id` varchar(100) DEFAULT NULL COMMENT '数据归属部门',
  `update_datetime` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `create_datetime` datetime(6) DEFAULT NULL COMMENT '创建时间',
  `status` tinyint(1) NOT NULL,
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

INSERT INTO `tb_other_manage` VALUES ('34799dd05d094458bd2b200d3f211eda',NULL,NULL,NULL,'2021-10-27 13:36:42.913913','2021-10-27 13:36:42.913913',1,'客服电话','customerservicephone','4006668888',1,NULL),('4ef8d8c46f2649438bddaba3628e3271',NULL,NULL,NULL,'2021-10-27 13:36:42.915639','2021-10-27 13:36:42.915639',1,'关于我们','aboutus','<p>我是关于我们的简介，请写在这里</p>',2,NULL);

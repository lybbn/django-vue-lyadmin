# 初始化
import os

import django

# 在environ字典里设置默认Django环境，'xxxx.settings'指Django项目的配置文件
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'application.settings')
django.setup()

from mysystem.models import Dept, Button, Menu, MenuButton, Role, Users
from apps.platformsettings.models import LunbotuManage,OtherManage,SystemConfig
from apps.lymessages.models import MyMessage


class Initialize:
    def __init__(self, delete=False):
        """
        delete 是否删除已初始化数据
        """
        self.delete = delete
        self.creator_id = "456b688c-8ad5-46de-bc2e-d41d8047bd42"

    def save(self, obj, data: list, name):
        print(f"正在初始化【{name}】")
        if self.delete:
            try:
                obj.objects.filter(id__in=[ele.get('id') for ele in data]).delete()
            except Exception:
                pass
        for ele in data:
            m2m_dict = {}
            new_data = {}
            for key, value in ele.items():
                # 判断传的 value 为 list 的多对多进行抽离，使用set 进行更新
                if isinstance(value, list):
                    m2m_dict[key] = value
                else:
                    new_data[key] = value
            object, _ = obj.objects.get_or_create(id=ele.get("id"), defaults=new_data)
            for key, m2m in m2m_dict.items():
                m2m = list(set(m2m))
                if m2m and len(m2m) > 0 and m2m[0]:
                    exec(f"""
if object.{key}:
    object.{key}.set({m2m})
""")
        print(f"初始化完成【{name}】")

    def init_dept(self):
        """
        初始化部门信息
        """
        self.dept_data = [
            {"id": "cae96ade-7483-4827-bb0d-d2bd63ec1cc4", "name": "财务部门", "sort": 1,
             "parent_id": "d2c03bd9-dad0-4262-88ca-c3681d224fc3"},
            {"id": "d2c03bd9-dad0-4262-88ca-c3681d224fc3", "name": "lyadmin团队", "sort": 1, "parent_id": None},
            {"id": "fd8230ca-67bd-4347-8a9b-57eb19be5d9e", "name": "研发部门", "sort": 2,
             "parent_id": "d2c03bd9-dad0-4262-88ca-c3681d224fc3"},
            #自定义


        ]
        self.save(Dept, self.dept_data, "部门信息")

    def init_button(self):
        """
        初始化权限表标识
        """
        self.button_data = [
            {"id": "4547b93a-36b9-410d-987c-3c52a9b51156", "name": "编辑", "value": "Update", },
            {"id": "4a410769-6b0a-4ed3-90f0-b5d89a6f802c", "name": "删除", "value": "Delete", },
            {"id": "644e9c34-e3d6-4518-b795-a603a6e9a137", "name": "单例", "value": "Retrieve", },
            {"id": "80cb145b-5035-4517-a28a-7d59426f73f8", "name": "新增", "value": "Create", },
            {"id": "ccc3f35f-c80c-4929-b8cc-67531698f397", "name": "查询", "value": "Search", },
            {"id": "83a9b774-4669-4d2f-b61d-8ee4944c2316", "name": "保存", "value": "Save", },
            {"id": "2d763a6d6dcf409d87056efd06aace0a", "name": "修改密码", "value": "Changepassword", },
            {"id": "6e0a41e5308c44a8b0d2785e05b2c07a", "name": "禁用", "value": "Disable", },
            {"id": "f3f365e9bfab44f587cbd91e3691ef0f", "name": "终端", "value": "Terminal", },
            {"id": "c66a0ab23a6044189ae0beb530ac68cf", "name": "发货", "value": "Deliver", },
            {"id": "43d89c33967545a387a3ac27c02460b6", "name": "统计", "value": "Statistics", },
            {"id": "09134d7643504804a6c7cc3d16e06684", "name": "日志", "value": "Logs", },
            {"id": "5bf695439e9d4c4d9601bf4fb558b3a2", "name": "任务列表", "value": "Tasklist", },

        ]
        self.save(Button, self.button_data, "权限表标识")

    def init_menu(self):
        """
        初始化菜单表
        """
        self.menu_data = [
            {'id': '9065cb5445ac42ef93eb9e75e6287792', 'name': 'DashBoard', 'sort': 1, 'web_path': 'analysis','icon': 'DataLine', 'parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e', 'name': '管理员管理', 'sort': 3, 'web_path': 'adminManage','icon': 'avatar', 'parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm':0},
            {'id': '244b28685cd14a39a383189981510d4a', 'name': '用户管理', 'sort': 5, 'web_path': 'userManage','icon': 'user-filled', 'parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'd73f73a399af48cea6a8490ac508d7a0', 'name': '用户管理CRUD', 'sort': 7, 'web_path': 'userManageCrud','icon': 'user-filled', 'parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'name': '平台设置', 'sort': 9, 'web_path': '','icon': 'platform', 'parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'ae5629946df4497cbec10419e8375dd9', 'name': '轮播图设置', 'sort': 1, 'web_path': 'carouselSettingsimg','icon': '', 'parent_id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'component': None,'component_name': None, 'visible': 1, 'isautopm': 0},
            {'id': '3171db16eda048ae92b16536fc1241b6', 'name': '平台公告', 'sort': 5, 'web_path': 'messagNotice','icon': '', 'parent_id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'component': None, 'component_name': None,'visible': 1, 'isautopm': 0},
            {'id': '80a340eae92b430abe17635468c2df1d', 'name': '参数设置', 'sort': 12, 'web_path': 'platformSettingsother','icon': '', 'parent_id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'component': None, 'component_name': None,'visible': 1, 'isautopm': 0},
            {'id': '49160b589f004e44b3920c82583c2581', 'name': '系统配置', 'sort': 15, 'web_path': 'systemConfig','icon': '', 'parent_id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'component': None, 'component_name': None,'visible': 1, 'isautopm': 0},
            {'id': '4236eb70-1558-43a0-9cf2-037230c547f9', 'name': '部门管理', 'sort': 1, 'web_path': 'departmentManage','icon': '', 'parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/dept', 'component_name': 'dept', 'visible': 1,'isautopm':0},
            {'id': '4ba07859-8b73-4524-a1a6-bbff36d98337', 'name': '操作日志', 'sort': 1, 'web_path': 'journalManage','icon': '', 'parent_id': 'c236fb6b-ddaa-4deb-b79b-16e42d9f347f', 'component': 'system/log/operationLog', 'component_name': 'operationLog', 'visible': 1,'isautopm':0},
            {'id': '56c3f341-4f46-4b04-9cfc-c8a14701707e', 'name': '菜单管理', 'sort': 2, 'web_path': 'menuManage','icon': '', 'parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/menu','component_name': 'menu', 'visible': 1,'isautopm':0},
            {'id': 'e0f53902-e901-490c-83f3-331e60b97fcf', 'name': '按钮配置', 'sort': 2,'web_path': 'buttonConfig/:id/:name', 'icon': '','parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/ menuButton', 'component_name': None, 'visible': 0,'isautopm':0},
            {'id': '15c9ebc5-d12f-470a-a560-938a7dc57570', 'name': '角色管理', 'sort': 3,'web_path': 'roleManage', 'icon': '','parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/role', 'component_name': 'role', 'visible': 1,'isautopm':0},
            {'id': 'a607e820-36e5-45c0-aabf-85a8e4e2c7ac', 'name': '权限管理', 'sort': 4,'web_path': 'authorityManage', 'icon': '','parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/rolePermission', 'component_name': 'rolePermission', 'visible': 1,'isautopm':0},
            {'id': '151035da-77a3-4a62-b474-fce6824571fb', 'name': '按钮管理', 'sort': 6,'web_path': 'buttonManage', 'icon': '','parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/button','component_name': 'buttonManage', 'visible': 0,'isautopm':0},
            {'id': '02c24003527546359b5a77ae07adc7d5', 'name': '地区管理', 'sort': 7, 'web_path': 'areaManage','icon': '', 'parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': None,'component_name': None, 'visible': 1, 'isautopm': 0},
            {'id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'name': '系统管理', 'sort': 990,'web_path': '', 'icon': 'tools', 'parent_id': None,'component': None, 'component_name': None, 'visible': 1,'isautopm':0},
            {'id': '25735adb-d051-4b7b-bbb7-1154526f3e4c', 'name': '个人中心', 'sort': 13,'web_path': 'personalCenter', 'icon': 'user', 'parent_id': None,'component': None, 'component_name': None, 'visible': 1,'isautopm':0},
            {'id': 'c236fb6b-ddaa-4deb-b79b-16e42d9f347f', 'name': '日志管理', 'sort': 999,'web_path': 'journalManage', 'icon': 'info-filled', 'parent_id': None,'component': None, 'component_name': None, 'visible': 1,'isautopm':0},
            {'id': '77edf447326b4e0dbc6f9719c1de8a12', 'name': '系统监控', 'sort': 888, 'web_path': '','icon': 'TrendCharts', 'parent_id': None, 'component': None,'component_name': None, 'visible': 1, 'isautopm': 0},
            {'id': 'bcbeeee5c91a4e2ea2c2a31237e33616', 'name': '服务监控', 'sort': 10, 'web_path': 'server','icon': '', 'parent_id': '77edf447326b4e0dbc6f9719c1de8a12', 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': '09a42810d4dd4b2eb939f8eb0b01d9d1', 'name': '计划任务', 'sort': 20, 'web_path': 'crontab', 'icon': '','parent_id': '77edf447326b4e0dbc6f9719c1de8a12', 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': '718daec1b94b456c96d773889648173e', 'name': '终端服务', 'sort': 30, 'web_path': 'terminal', 'icon': '','parent_id': '77edf447326b4e0dbc6f9719c1de8a12', 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'a28f8ca682d04c8fb2953fdeb3d9e2e6', 'name': '商城管理', 'sort': 188, 'web_path': '', 'icon': 'GoodsFilled','parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'd470ab18859a4472b525e605ae96c325', 'name': '商品管理', 'sort': 1, 'web_path': 'goodsManage', 'icon': '','parent_id': 'a28f8ca682d04c8fb2953fdeb3d9e2e6', 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'b999c50996864465b851575e378c5aea', 'name': '商品分类', 'sort': 2, 'web_path': 'goodsType', 'icon': '','parent_id': 'a28f8ca682d04c8fb2953fdeb3d9e2e6', 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'a524f17e9ac74be3baf9d113f014184c', 'name': '订单管理', 'sort': 199, 'web_path': '', 'icon': 'List','parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': '2e07b715d5e24e2ca45997527430e9d3', 'name': '商城订单', 'sort': 1, 'web_path': 'mallOrderManage', 'icon': '','parent_id': 'a524f17e9ac74be3baf9d113f014184c', 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': '2a7c0142f7514dacb7999383e4e67aca', 'name': '财务管理', 'sort': 299, 'web_path': '', 'icon': 'WalletFilled','parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'dc8c173b425048e7a8c9b59513596c7f', 'name': '商品财务流水', 'sort': 1, 'web_path': 'financeStatisticsGoods', 'icon': '','parent_id': '2a7c0142f7514dacb7999383e4e67aca', 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': '3c13161f70f1469a913d539e7616c577', 'name': '意见反馈', 'sort': 8, 'web_path': 'userFeekback', 'icon': '','parent_id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},

        ]
        self.save(Menu, self.menu_data, "菜单表")

    def init_menu_button(self):
        """
        初始化菜单权限表
        """
        self.menu_button_data = [
            {'id': 'e7fa30290d37447585ea7583d9d01f1b', 'menu_id': 'ae5629946df4497cbec10419e8375dd9','name': '编辑', 'value': 'Update', 'api': '/api/platformsettings/lunboimg/{id}/', 'method': 2},
            {'id': '6e4251a948f348ccaa419a777a118048', 'menu_id': '80a340eae92b430abe17635468c2df1d','name': '编辑', 'value': 'Update', 'api': '/api/platformsettings/other/{id}/', 'method': 2},
            {'id': '0209de89-6b9f-4d8a-84d3-ccfc3cc8b4da', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb','name': '编辑', 'value': 'Update', 'api': '/api/system/button/{id}/', 'method': 2},
            {'id': '04896a47-0f3a-4e2f-a111-bfe15f9e31c5', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e','name': '编辑', 'value': 'Update', 'api': '/api/system/menu/{id}/', 'method': 2},
            {'id': '3e11db64-b8e8-4558-963b-71d063a7db16', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9','name': '编辑', 'value': 'Update', 'api': '/api/system/dept/{id}/', 'method': 2},
            {'id': '5d77d14e-b199-481f-a97d-6e4c0e84fe71', 'menu_id': '25735adb-d051-4b7b-bbb7-1154526f3e4c','name': '修改密码', 'value': 'Changepassword', 'api': '/api/system/user/change_password/{id}/', 'method': 2},
            {'id': '875bdfeb-0c34-441d-8ee3-bb93c21e17dd', 'menu_id': '244b28685cd14a39a383189981510d4a','name': '编辑', 'value': 'Update', 'api': '/api/users/users/{id}/', 'method': 2},
            {'id': '875bdfeb0c34441d8ee3bb93c21e17dd', 'menu_id': 'd73f73a399af48cea6a8490ac508d7a0','name': '编辑', 'value': 'Update', 'api': '/api/users/users/{id}/', 'method': 2},
            {'id': 'bc114580-e62d-4e08-b707-843759817344', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e','name': '编辑', 'value': 'Update', 'api': '/api/system/user/{id}/', 'method': 2},
            {'id': 'bc6104a0-f487-4dfd-a368-fb587d6d57d8', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf','name': '编辑', 'value': 'Update', 'api': '/api/system/menu_button/{id}/', 'method': 2},
            {'id': 'd22c0176-96e0-48b3-b81e-13443f306af5', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570','name': '编辑', 'value': 'Update', 'api': '/api/system/role/{id}/', 'method': 2},
            {'id': 'dcc58831-08d1-4469-8b01-fca71e0f497f', 'menu_id': '25735adb-d051-4b7b-bbb7-1154526f3e4c','name': '编辑', 'value': 'Update', 'api': '/api/system/user/user_info/', 'method': 2},
            {'id': 'e6b93920-2236-46ec-841b-cff6f63ce788', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337','name': '编辑', 'value': 'Update', 'api': '/api/system/operation_log/{id}/', 'method': 2},
            {'id': 'ca69833045ed4cf78c8586f7e55ba6db', 'menu_id': '3171db16eda048ae92b16536fc1241b6','name': '编辑', 'value': 'Update', 'api': '/api/messages/messagenotice/{id}/', 'method': 2},
            {'id': 'b4cbe8ed35a04155b14c7809fad6b2ef', 'menu_id': '718daec1b94b456c96d773889648173e','name': '编辑', 'value': 'Update', 'api': '/api/terminal/terminal/{id}/', 'method': 2},
            {'id': 'cf50028007164569a136fbdeaff7619c', 'menu_id': '02c24003527546359b5a77ae07adc7d5','name': '编辑', 'value': 'Update', 'api': '/api/address/area/{id}/', 'method': 2},
            {'id': '4281eaced4e943ababeefb66a6a7f13d', 'menu_id': 'd470ab18859a4472b525e605ae96c325','name': '编辑', 'value': 'Update', 'api': '/api/mall/goodsspu/{id}/', 'method': 2},
            {'id': '716480cd8ac645239405763834326f7e', 'menu_id': 'b999c50996864465b851575e378c5aea','name': '编辑', 'value': 'Update', 'api': '/api/mall/goodstype/{id}/', 'method': 2},
            {'id': '4b73b1669e49495f93de36d63cc2c0d8', 'menu_id': '2e07b715d5e24e2ca45997527430e9d3','name': '编辑', 'value': 'Update', 'api': '/api/mall/goodsorder/{id}/', 'method': 2},
            {'id': 'd419393d77e34f8e9c1eda5893f3bc87', 'menu_id': '49160b589f004e44b3920c82583c2581', 'name': '编辑','value': 'Update', 'api': '/api/platformsettings/sysconfig/{id}/', 'method': 2},
            {'id': '59db5099a03f44c8adb883faa340c15a', 'menu_id': 'ae5629946df4497cbec10419e8375dd9','name': '查询', 'value': 'Search', 'api': '/api/platformsettings/lunboimg/', 'method': 0},
            {'id': '80efc041695a42e4a9a04c010c6c7004', 'menu_id': '80a340eae92b430abe17635468c2df1d','name': '查询', 'value': 'Search', 'api': '/api/platformsettings/other/', 'method': 0},
            {'id': '140166e2-471e-455e-9dcd-05cebbbab95d', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570','name': '查询', 'value': 'Search', 'api': '/api/system/role/', 'method': 0},
            {'id': '324776a3-48ec-4bca-bdd9-1838e2b6f7cc', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e','name': '查询', 'value': 'Search', 'api': '/api/system/user/', 'method': 0},
            {'id': '3688b715-4689-468f-bf3e-6f910259f837', 'menu_id': '25735adb-d051-4b7b-bbb7-1154526f3e4c','name': '查询', 'value': 'Search', 'api': '/api/system/user/user_info/', 'method': 0},
            {'id': '37462e31-3cdf-4576-af10-5958f53b1bef', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337','name': '查询', 'value': 'Search', 'api': '/api/system/operation_log/', 'method': 0},
            {'id': '42ad6e05-7c84-444f-bcae-09de84f4988b', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e','name': '查询', 'value': 'Search', 'api': '/api/system/menu/', 'method': 0},
            {'id': '43696212-ecba-4e66-8678-33c9bc935c76', 'menu_id': '244b28685cd14a39a383189981510d4a','name': '查询', 'value': 'Search', 'api': '/api/users/users/', 'method': 0},
            {'id': '43696212ecba4e66867833c9bc935c76', 'menu_id': 'd73f73a399af48cea6a8490ac508d7a0','name': '查询', 'value': 'Search', 'api': '/api/users/users/', 'method': 0},
            {'id': '5aac29b0-5a32-45fb-81c5-437b48f4a5df', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf','name': '查询', 'value': 'Search', 'api': '/api/system/menu_button/', 'method': 0},
            {'id': '646e9790-24f5-4606-abc4-0b5eede12f66', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9','name': '查询', 'value': 'Search', 'api': '/api/system/dept/', 'method': 0},
            {'id': 'af60d628-73b1-4c5d-b34e-7c70ab9bd87e', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb','name': '查询', 'value': 'Search', 'api': '/api/system/button/', 'method': 0},
            {'id': 'd1b3c15f0c664857aeca1d9065d9c499', 'menu_id': '3171db16eda048ae92b16536fc1241b6','name': '查询', 'value': 'Search', 'api': '/api/messages/messagenotice/', 'method': 0},
            {'id': 'c2490dfba1644cae8f8ff85e2d6f1d3d', 'menu_id': '9065cb5445ac42ef93eb9e75e6287792','name': '查询', 'value': 'Search', 'api': '', 'method': 0},
            {'id': 'a69fb746c0aa4bd0b31b1480c9e4dcc0', 'menu_id': 'bcbeeee5c91a4e2ea2c2a31237e33616','name': '查询', 'value': 'Search', 'api': '/api/monitor/getsysteminfo/', 'method': 0},
            {'id': 'e1ddf86666364a39be76c963c277b009', 'menu_id': '718daec1b94b456c96d773889648173e','name': '查询', 'value': 'Search', 'api': '/api/terminal/terminal/', 'method': 0},
            {'id': '8f465aa674744313890cc8c59d3d0fd2', 'menu_id': '02c24003527546359b5a77ae07adc7d5','name': '查询', 'value': 'Search', 'api': '/api/address/area/area_root/', 'method': 0},
            {'id': '43a779c3e1634e84bb1a32c675b5f744', 'menu_id': 'd470ab18859a4472b525e605ae96c325','name': '查询', 'value': 'Search', 'api': '/api/mall/goodsspu/', 'method': 0},
            {'id': '2c5b748c5dce4f34bd24b1201faf09c2', 'menu_id': 'b999c50996864465b851575e378c5aea','name': '查询', 'value': 'Search', 'api': '/api/mall/goodstype/', 'method': 0},
            {'id': 'f5818e4cd46947daabe046c511dfbd63', 'menu_id': '2e07b715d5e24e2ca45997527430e9d3','name': '查询', 'value': 'Search', 'api': '/api/mall/goodsorder/', 'method': 0},
            {'id': '6a21329f0dcd4781a64fc4f62324e4c0', 'menu_id': 'dc8c173b425048e7a8c9b59513596c7f','name': '查询', 'value': 'Search', 'api': '/api/mall/goodsforderinfo/', 'method': 0},
            {'id': '05932c39ad444ac5aaf880d281620611', 'menu_id': '3c13161f70f1469a913d539e7616c577','name': '查询', 'value': 'Search', 'api': '/api/platformsettings/userfeeckback/', 'method': 0},
            {'id': '4450d80871eb44a1aaa4fbb5429885f0', 'menu_id': '09a42810d4dd4b2eb939f8eb0b01d9d1','name': '查询','value': 'Search', 'api': '/api/crontab/periodictask/', 'method': 0},
            {'id': 'fa7c32c9397c46b8821b62aae5512af0', 'menu_id': '49160b589f004e44b3920c82583c2581', 'name': '查询','value': 'Search', 'api': '/api/platformsettings/sysconfig/', 'method': 0},
            {'id': '7aef1da4647844e3944a2745cef1bc6d', 'menu_id': 'ae5629946df4497cbec10419e8375dd9','name': '新增', 'value': 'Create', 'api': '/api/platformsettings/lunboimg/', 'method': 1},
            {'id': '77096cd56a6441699345e6e4f22d0ec3', 'menu_id': '80a340eae92b430abe17635468c2df1d','name': '新增', 'value': 'Create', 'api': '/api/platformsettings/other/', 'method': 1},
            {'id': '0d931efc-2f80-418f-b4a0-5251f0a88f69', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337','name': '新增', 'value': 'Create', 'api': '/api/system/operation_log/', 'method': 1},
            {'id': '10610c56-cec2-4774-9468-e1c763e59e70', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9','name': '新增', 'value': 'Create', 'api': '/api/system/dept/', 'method': 1},
            {'id': '1b4f27a7-8ab8-4388-ae57-46e29976cf0e', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb','name': '新增', 'value': 'Create', 'api': '/api/system/button/', 'method': 1},
            {'id': '2a3d4756-4d51-4129-b3c4-b2c7a00dbb8a', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570','name': '新增', 'value': 'Create', 'api': '/api/system/role/', 'method': 1},
            {'id': '9e6b2376-1ab0-4966-8d5d-4ad4f911d13c', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e','name': '新增', 'value': 'Create', 'api': '/api/system/user/', 'method': 1},
            {'id': '9fc8436a-1996-478f-a155-5de7939a54dc', 'menu_id': '244b28685cd14a39a383189981510d4a','name': '新增', 'value': 'Create', 'api': '/api/users/users/', 'method': 1},
            {'id': '9fc8436a1996478fa1555de7939a54dc', 'menu_id': 'd73f73a399af48cea6a8490ac508d7a0','name': '新增', 'value': 'Create', 'api': '/api/users/users/', 'method': 1},
            {'id': 'abe5c07f-0cab-4053-ac24-e782792e9d7f', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e','name': '新增', 'value': 'Create', 'api': '/api/system/menu/', 'method': 1},
            {'id': 'fc71b446-fde1-439f-ab41-c38f30230caa', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf','name': '新增', 'value': 'Create', 'api': '/api/system/menu_button/', 'method': 1},
            {'id': 'd2e0608b5b4941ef8c3ff834977caeef', 'menu_id': '3171db16eda048ae92b16536fc1241b6','name': '新增', 'value': 'Create', 'api': '/api/messages/messagenotice/', 'method': 1},
            {'id': '8d65733d401c40f8b27cc6bcfed78bc3', 'menu_id': '718daec1b94b456c96d773889648173e','name': '新增', 'value': 'Create', 'api': '/api/terminal/terminal/', 'method': 1},
            {'id': '8228955d67bc4dc89638b523f58108ee', 'menu_id': '02c24003527546359b5a77ae07adc7d5','name': '新增', 'value': 'Create', 'api': '/api/address/area/', 'method': 1},
            {'id': '220fa39fd56e47e1ab9558c6bd10106e', 'menu_id': 'd470ab18859a4472b525e605ae96c325','name': '新增', 'value': 'Create', 'api': '/api/mall/goodsspu/', 'method': 1},
            {'id': '676e32850165441cad01782e453de925', 'menu_id': 'b999c50996864465b851575e378c5aea','name': '新增', 'value': 'Create', 'api': '/api/mall/goodstype/', 'method': 1},
            {'id': '19d01a929bc9414cac1a8defd48597c9', 'menu_id': '09a42810d4dd4b2eb939f8eb0b01d9d1', 'name': '新增','value': 'Create', 'api': '/api/crontab/periodictask/', 'method': 1},
            {'id': '103d4310b98e4ff1ba71336af8d4c6c2', 'menu_id': '49160b589f004e44b3920c82583c2581', 'name': '新增','value': 'Create', 'api': '/api/platformsettings/sysconfig/', 'method': 1},
            {'id': 'a3088120763d49ad93498eb515c7c244', 'menu_id': 'ae5629946df4497cbec10419e8375dd9','name': '单例', 'value': 'Retrieve', 'api': '/api/platformsettings/lunboimg/{id}/', 'method': 0},
            {'id': '1d4441fdc418499f856c23aa4e1be2c0', 'menu_id': '80a340eae92b430abe17635468c2df1d','name': '单例', 'value': 'Retrieve', 'api': '/api/platformsettings/other/{id}/', 'method': 0},
            {'id': '14e7088f-a39b-47ae-bd67-b9bbcabae96b', 'menu_id': '244b28685cd14a39a383189981510d4a','name': '单例', 'value': 'Retrieve', 'api': '/api/users/users/{id}/', 'method': 0},
            {'id': '14e7088fa39b47aebd67b9bbcabae96b', 'menu_id': 'd73f73a399af48cea6a8490ac508d7a0','name': '单例', 'value': 'Retrieve', 'api': '/api/users/users/{id}/', 'method': 0},
            {'id': '6208f412-6bca-4d7b-a5a0-0103b7ba6091', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb','name': '单例', 'value': 'Retrieve', 'api': '/api/system/button/{id}/', 'method': 0},
            {'id': '6300774a-d19c-43ad-8102-d7bf341eff33', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9','name': '单例', 'value': 'Retrieve', 'api': '/api/system/dept/{id}/', 'method': 0},
            {'id': '8b7a0e79-a6ef-4946-87c6-8c042b887e1c', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337','name': '单例', 'value': 'Retrieve', 'api': '/api/system/operation_log/{id}/', 'method': 0},
            {'id': '96022ae5-6425-47b9-8f89-01edc33eb2b7', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570','name': '单例', 'value': 'Retrieve', 'api': '/api/system/role/{id}/', 'method': 0},
            {'id': 'f0e080c0-275d-4085-b56c-735b49510eff', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e','name': '单例', 'value': 'Retrieve', 'api': '/api/system/user/{id}/', 'method': 0},
            {'id': 'fcbe4cec-cc2d-436d-92ba-023f8c9ad31c', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e','name': '单例', 'value': 'Retrieve', 'api': '/api/system/menu/{id}/', 'method': 0},
            {'id': 'fe96f32c-6124-4b24-b809-4964186f5163', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf','name': '单例', 'value': 'Retrieve', 'api': '/api/system/menu_button/{id}/', 'method': 0},
            {'id': '6b88361b326a4e55a8a5135c08ba66f1', 'menu_id': '3171db16eda048ae92b16536fc1241b6','name': '单例', 'value': 'Retrieve', 'api': '/api/messages/messagenotice/{id}/', 'method': 0},
            {'id': '6d6b6689d1224900b09c8101b3344f42', 'menu_id': 'a607e820-36e5-45c0-aabf-85a8e4e2c7ac','name': '单例', 'value': 'Retrieve', 'api': '/api/system/role_id_to_menu/{id}/', 'method': 0},
            {'id': 'f19826f7df9842089cee94a795681b2e', 'menu_id': '9065cb5445ac42ef93eb9e75e6287792','name': '单例', 'value': 'Retrieve', 'api': '', 'method': 0},
            {'id': 'ea18bb51400b482a8aad5dc18357bcab', 'menu_id': '718daec1b94b456c96d773889648173e','name': '单例', 'value': 'Retrieve', 'api': '/api/terminal/terminal/{id}/', 'method': 0},
            {'id': 'efcbf104971a4266a26d9469e58c1327', 'menu_id': '02c24003527546359b5a77ae07adc7d5','name': '单例', 'value': 'Retrieve', 'api': '/api/address/area/{id}/', 'method': 0},
            {'id': '2235160bd56c423880572f5450b94f16', 'menu_id': 'd470ab18859a4472b525e605ae96c325','name': '单例', 'value': 'Retrieve', 'api': '/api/mall/goodsspu/{id}/', 'method': 0},
            {'id': '118ce77cc07140a08d9a92ab8800f2cf', 'menu_id': 'b999c50996864465b851575e378c5aea','name': '单例', 'value': 'Retrieve', 'api': '/api/mall/goodstype/{id}/', 'method': 0},
            {'id': '3737d4afa1e2437b93e8cdcd7116180a', 'menu_id': '2e07b715d5e24e2ca45997527430e9d3','name': '单例', 'value': 'Retrieve', 'api': '/api/mall/goodsorder/{id}/', 'method': 0},
            {'id': '6e9d454742f74437928959c02be42456', 'menu_id': 'dc8c173b425048e7a8c9b59513596c7f','name': '单例', 'value': 'Retrieve', 'api': '/api/mall/goodsforderinfo/{id}/', 'method': 0},
            {'id': '11d334fcadf1490e85e6a045126dea78', 'menu_id': '3c13161f70f1469a913d539e7616c577','name': '单例', 'value': 'Retrieve', 'api': '/api/platformsettings/userfeeckback/{id}/', 'method': 0},
            {'id': '6e27757847c64e228934b60ae81baedf', 'menu_id': '09a42810d4dd4b2eb939f8eb0b01d9d1', 'name': '单例','value': 'Retrieve', 'api': '/api/crontab/periodictask/{id}/', 'method': 0},
            {'id': '14514da3c11441c2b63f2331e3f897d0', 'menu_id': '49160b589f004e44b3920c82583c2581', 'name': '单例','value': 'Retrieve', 'api': '/api/platformsettings/sysconfig/{id}/', 'method': 0},
            {'id': '0088e172566f4ee388092ec2be3584ee', 'menu_id': 'ae5629946df4497cbec10419e8375dd9','name': '删除', 'value': 'Delete', 'api': '/api/platformsettings/lunboimg/{id}/', 'method': 3},
            {'id': '264cc3d69f7a46d5a117997e9c78506c', 'menu_id': '80a340eae92b430abe17635468c2df1d','name': '删除', 'value': 'Delete', 'api': '/api/platformsettings/other/{id}/', 'method': 3},
            {'id': '2c53efc8-e6a4-4192-8688-03baed0874a4', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e','name': '删除', 'value': 'Delete', 'api': '/api/system/user/{id}/', 'method': 3},
            {'id': '3fd6ae6c-fd76-4465-b2b6-db672f4bd79e', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570','name': '删除', 'value': 'Delete', 'api': '/api/system/role/{id}/', 'method': 3},
            {'id': '4fe4b7f5-0bc8-4375-9f39-747e06ec285a', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf','name': '删除', 'value': 'Delete', 'api': '/api/system/menu_button/{id}/', 'method': 3},
            {'id': '51085c21-2279-490f-8878-594f059f7616', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb','name': '删除', 'value': 'Delete', 'api': '/api/system/button/{id}/', 'method': 3},
            {'id': '8ae924bd-576c-4ae1-92eb-b0a98148baae', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e','name': '删除', 'value': 'Delete', 'api': '/api/system/menu/{id}/', 'method': 3},
            {'id': 'acfde861-1872-47e2-a1f1-abeda5175b7f', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337','name': '删除', 'value': 'Delete', 'api': '/api/system/operation_log/{id}/', 'method': 3},
            {'id': 'b10f7d08-2592-4b54-8557-b5ca864a029a', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9','name': '删除', 'value': 'Delete', 'api': '/api/system/dept/{id}/', 'method': 3},
            {'id': 'bb7de9ee-5fd1-46f5-9849-088c522f49c7', 'menu_id': '244b28685cd14a39a383189981510d4a','name': '删除', 'value': 'Delete', 'api': '/api/users/users/{id}/', 'method': 3},
            {'id': 'bb7de9ee5fd146f59849088c522f49c7', 'menu_id': 'd73f73a399af48cea6a8490ac508d7a0','name': '删除', 'value': 'Delete', 'api': '/api/users/users/{id}/', 'method': 3},
            {'id': 'c8eee7f68c1845169b8d2af946502077', 'menu_id': '3171db16eda048ae92b16536fc1241b6','name': '删除', 'value': 'Delete', 'api': '/api/messages/messagenotice/{id}/', 'method': 3},
            {'id': '281ad1aad421441a965f7bc6b397eb30', 'menu_id': '718daec1b94b456c96d773889648173e','name': '删除', 'value': 'Delete', 'api': '/api/terminal/terminal/{id}/', 'method': 3},
            {'id': 'a20a200c721c489b9925cdd5b5e6708c', 'menu_id': '02c24003527546359b5a77ae07adc7d5','name': '删除', 'value': 'Delete', 'api': '/api/address/area/{id}/', 'method': 3},
            {'id': 'ac302c9907b94ab59ac3c40975add57b', 'menu_id': 'd470ab18859a4472b525e605ae96c325','name': '删除', 'value': 'Delete', 'api': '/api/mall/goodsspu/{id}/', 'method': 3},
            {'id': '98c953b2d74d4d9d83d18433a7fc85ba', 'menu_id': 'b999c50996864465b851575e378c5aea','name': '删除', 'value': 'Delete', 'api': '/api/mall/goodstype/{id}/', 'method': 3},
            {'id': '3cadf44d739b45d4a94ad23939e19716', 'menu_id': '2e07b715d5e24e2ca45997527430e9d3','name': '删除', 'value': 'Delete', 'api': '/api/mall/goodsorder/{id}/', 'method': 3},
            {'id': 'c2cac9993f9142cca5f531565a14f840', 'menu_id': 'dc8c173b425048e7a8c9b59513596c7f','name': '删除', 'value': 'Delete', 'api': '/api/mall/goodsforderinfo/{id}/', 'method': 3},
            {'id': '989ad685ce654dd1b367f41dedfdd0b9', 'menu_id': '3c13161f70f1469a913d539e7616c577','name': '删除', 'value': 'Delete', 'api': '/api/platformsettings/userfeeckback/{id}/', 'method': 3},
            {'id': '576008b6046f4afcb88d8139ff34e228', 'menu_id': '09a42810d4dd4b2eb939f8eb0b01d9d1', 'name': '删除','value': 'Delete', 'api': '/api/crontab/periodictask/{id}/', 'method': 3},
            {'id': '9565c5888bd4414c84ecede7af7d1554', 'menu_id': '49160b589f004e44b3920c82583c2581', 'name': '删除','value': 'Delete', 'api': '/api/platformsettings/sysconfig/{id}/', 'method': 3},
            {'id': '1a0c96cf-09a6-43b4-b08a-0c5b6e2f7bb8', 'menu_id': 'a607e820-36e5-45c0-aabf-85a8e4e2c7ac','name': '保存', 'value': 'Save', 'api': '/api/system/permission/{id}/', 'method': 2},
            {'id': 'f4e0b4aa230b4afba10a7ba58af3c454', 'menu_id': '49160b589f004e44b3920c82583c2581','name': '保存', 'value': 'Save', 'api': '/api/platformsettings/sysconfig/save_content/{id}/', 'method': 2},
            {'id': '353595a28cb1463b830cfbf79fea60b5', 'menu_id': '244b28685cd14a39a383189981510d4a','name': '禁用', 'value': 'Disable', 'api': '/api/users/users/disableuser/{id}/', 'method': 2},
            {'id': '80c8eb6939a245e9890dede241b5d1d6', 'menu_id': 'd73f73a399af48cea6a8490ac508d7a0','name': '禁用', 'value': 'Disable', 'api': '/api/users/users/disableuser/{id}/', 'method': 2},
            {'id': 'a45559c4cc6f48e2b7194c2dc577af3a', 'menu_id': 'd470ab18859a4472b525e605ae96c325','name': '禁用', 'value': 'Disable', 'api': '/api/mall/goodsspu/islaunched/{id}/', 'method': 2},
            {'id': '0ce04d99cbd249a9af88fe1496591a89', 'menu_id': '09a42810d4dd4b2eb939f8eb0b01d9d1', 'name': '禁用','value': 'Disable', 'api': '/api/crontab/periodictask/enabled/{id}/', 'method': 2},
            {'id': '6af0929440a345238c28ee9b1fe341ba', 'menu_id': '718daec1b94b456c96d773889648173e','name': '终端', 'value': 'Terminal', 'api': '/ws/webssh/', 'method': 5},
            {'id': 'bec59f93068a4d7aaaf5b4ccfbc12265', 'menu_id': '2e07b715d5e24e2ca45997527430e9d3','name': '统计', 'value': 'Statistics', 'api': '/api/mall/goodsorder/orderstatistics/', 'method': 0},
            {'id': '53e6d5a4192c4f0f8bdd7f5647124147', 'menu_id': 'dc8c173b425048e7a8c9b59513596c7f','name': '统计', 'value': 'Statistics', 'api': '/api/mall/goodsforderinfo/orderstatistics/', 'method': 0},
            {'id': 'c28461a142d7464f8865752c969d82de', 'menu_id': '2e07b715d5e24e2ca45997527430e9d3','name': '发货', 'value': 'Deliver', 'api': '/api/mall/goodsorder/sendoutgoods/', 'method': 1},
            {'id': '0b5bf0f1caac45beabf54fb5d930187b', 'menu_id': '09a42810d4dd4b2eb939f8eb0b01d9d1','name': '日志', 'value': 'Logs', 'api': '/api/crontab/taskresult/', 'method': 0},
            {'id': 'fa8d945124b74379aba32bcf34ea5383', 'menu_id': '09a42810d4dd4b2eb939f8eb0b01d9d1','name': '任务列表', 'value': 'Search', 'api': '/api/crontab/periodictask/tasklist/', 'method': 0},

        ]
        self.save(MenuButton, self.menu_button_data, "菜单权限表")

    def init_role(self):
        """
        初始化角色表
        """
        data = [
            {"id": "36001d1a-1b3e-4413-bdfe-b3bc04375f46", "name": "管理员", "key": "admin", "sort": 1, "status": 1,
             "admin": 1, "data_range": 3,
             "menu": [ele.get("id") for ele in self.menu_data],
             "permission": [ele.get("id") for ele in self.menu_button_data]
             },
            {"id": "35b58d98-b506-4f93-be79-ed1e109da071", "name": "普通用户", "key": "public", "sort": 2, "status": 1,
             "admin": 0, "data_range": 4,
             "dept": ["d2c03bd9-dad0-4262-88ca-c3681d224fc3", "fd8230ca-67bd-4347-8a9b-57eb19be5d9e"],
             "menu": ["15c9ebc5-d12f-470a-a560-938a7dc57570", "4236eb70-1558-43a0-9cf2-037230c547f9",
                      "54f769b0-3dff-416c-8102-e55ec44827cc", "56c3f341-4f46-4b04-9cfc-c8a14701707e",
                      "244b28685cd14a39a383189981510d4a"],
             "permission": []
             },
            #自定义


        ]
        self.save(Role, data, "角色表")

    def init_users(self):
        """
        初始化用户表
        """
        data = [
            {"id": "456b688c-8ad5-46de-bc2e-d41d8047bd42",
             "password": "pbkdf2_sha256$260000$oE0tnjC7PRIV6aCEah0J1F$scZo6l2/kekoClW8jZ6bM4PmSXevb4qzqHLro8PvzLc=",
             "is_superuser": 1, "is_staff": 1,"identity":0,
             "is_active": 1, "username": "superadmin", "name": "超级管理员",
             "dept_id": "d2c03bd9-dad0-4262-88ca-c3681d224fc3",
             },
            {"id": "d1431450-5068-4461-b57e-7862c005a547",
             "password": "pbkdf2_sha256$260000$DO6dpT8e4Ls0yD51grncC8$KZfswxNJ8MILTWwy+bicRyU7Q3PKC4orn4SJbhIkN4Q=",
             "is_superuser": 0, "is_staff": 1,"identity":1,
             "is_active": 1, "username": "admin", "name": "管理员",
             "dept_id": "d2c03bd9-dad0-4262-88ca-c3681d224fc3",
             "role": ["36001d1a-1b3e-4413-bdfe-b3bc04375f46"],
             },
            {"id": "244b28685cd14a39a383189981510d4a",
             "password": "pbkdf2_sha256$260000$oivECWOjB0GJyMjPsrqb3t$9FvnYtXtsNWDva2P3A/eIg6cRMLOp7kiIOuwfLKyDAY=",
             "is_superuser": 0, "is_staff": 0,"identity":2,
             "is_active": 1, "username": "test", "name": "测试用户","mobile":"18888888888","nickname":"测试用户",
             "dept_id": "",
             "role": [],
             },
        ]
        self.save(Users, data, "用户表")

    def init_platformsettings_lunbo(self):
        """
        初始化轮播图设置
        """
        data = [
            {"id": "e86adc251eb348c1bc0d1534cb130d3e",
             "title": "首页轮播图1",
             "type": 1, "status": 1,
             "sort": 1,
             "image": "http://127.0.0.1:8000/media/platform/2021-10-27/20211027110807_498.jpg",
             "link": "http://www.xxx.com",
             },
        ]
        self.save(LunbotuManage, data, "轮播图设置")

    def init_platformsettings_message(self):
        """
        初始化平台公告
        """
        data = [
            {"id": "7210a59d19fe406bbd237510344334bf",
             "msg_chanel": 2,
             "public": 1,
             "msg_title":"测试消息",
             "msg_content": "<p>消息内容实体部分</p>",
             "to_path": "/index/path",
             "status": 1,
             },
        ]
        self.save(MyMessage, data, "平台公告")

    def init_platformsettings_other(self):
        """
        初始化参数设置
        """
        data = [
            {"id": "34799dd05d094458bd2b200d3f211eda",
             "name": "客服电话",
             "status": 1,
             "sort": 1,
             "key":"customerservicephone",
             "type": 1,
             "value": "4006668888",
             },
            {"id": "4ef8d8c46f2649438bddaba3628e3271",
             "name": "关于我们",
             "status": 1,
             "sort": 2,
             "key":"aboutus",
             "type": 2,
             "value": "<p>我是关于我们的简介，请写在这里</p>",
             },
            {"id": "6261abf71d3b4ead9b1213225933b50f",
             "name": "公司logo",
             "status": 1,
             "sort": 2,
             "type": 3,
             "key": "companylogo",
             "value": "http://127.0.0.1:8000/media/platform/2022-04-07/20220407120605_298.png",
             },

        ]
        self.save(OtherManage, data, "参数设置")

    def init_platformsettings_sysconfig(self):
        """
        初始化系统配置
        """
        data = [
            {"id": "9c3e3670d4ee4898a1374cf780bcdc42",
             "title": "基础配置",
             "status": 1,
             "sort": 0,
             "key":"base",
             "value": None,
             "form_item_type":0,
             "placeholder":None,
             "parent_id":None
             },
            {"id": "0e5ed3b69fd94a6daabff47d08244eb0",
             "title": "客服电话",
             "status": 1,
             "sort": 1,
             "key": "phone",
             "value": "1888888888x",
             "form_item_type": 0,
             "placeholder": "请输入电话号码",
             "parent_id": "9c3e3670d4ee4898a1374cf780bcdc42"
             },
            {"id": "ae2987ded9d04dd7bc6a3aebfaf83f5f",
             "title": "隐私协议",
             "status": 1,
             "sort": 2,
             "key": "privatexy",
             "value": "<p>隐私内容</p>",
             "form_item_type": 14,
             "placeholder": "请输入内容",
             "parent_id": "9c3e3670d4ee4898a1374cf780bcdc42"
             },
            {"id": "bbcabe17837d4233ac2a24a907dd27c3",
             "title": "logo",
             "status": 1,
             "sort": 3,
             "key": "logo",
             "value": "http://127.0.0.1:8000/media/platform/2022-04-07/20220407120605_298.png",
             "form_item_type": 7,
             "placeholder": None,
             "parent_id": "9c3e3670d4ee4898a1374cf780bcdc42"
             },

        ]
        self.save(SystemConfig, data, "系统配置")

    def run(self):
        self.init_dept()
        self.init_button()
        self.init_menu()
        self.init_menu_button()
        self.init_role()
        self.init_users()
        self.init_platformsettings_lunbo()
        self.init_platformsettings_message()
        self.init_platformsettings_other()
        self.init_platformsettings_sysconfig()


def main(is_delete=False):
    Initialize(is_delete).run()
    pass


if __name__ == '__main__':
    main()

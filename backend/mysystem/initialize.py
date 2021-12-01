# 初始化
import os

import django

# 在environ字典里设置默认Django环境，'xxxx.settings'指Django项目的配置文件
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'application.settings')
django.setup()

from mysystem.models import Dept, Button, Menu, MenuButton, Role, Users
from apps.platformsettings.models import LunbotuManage,OtherManage
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

        ]
        self.save(Button, self.button_data, "权限表标识")

    def init_menu(self):
        """
        初始化菜单表
        """
        self.menu_data = [
            {'id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e', 'name': '管理员管理', 'sort': 1, 'web_path': 'adminManage','icon': 'el-icon-user', 'parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm':0},
            {'id': '244b28685cd14a39a383189981510d4a', 'name': '用户管理', 'sort': 5, 'web_path': 'userManage','icon': 'el-icon-user', 'parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'name': '平台设置', 'sort': 9, 'web_path': '','icon': 'el-icon-s-platform', 'parent_id': None, 'component': None, 'component_name': None, 'visible': 1,'isautopm': 0},
            {'id': 'ae5629946df4497cbec10419e8375dd9', 'name': '轮播图设置', 'sort': 1, 'web_path': 'carouselSettingsimg','icon': '', 'parent_id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'component': None,'component_name': None, 'visible': 1, 'isautopm': 0},
            {'id': '3171db16eda048ae92b16536fc1241b6', 'name': '平台公告', 'sort': 5, 'web_path': 'messagNotice','icon': '', 'parent_id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'component': None, 'component_name': None,'visible': 1, 'isautopm': 0},
            {'id': '80a340eae92b430abe17635468c2df1d', 'name': '其他设置', 'sort': 12, 'web_path': 'platformSettingsother','icon': '', 'parent_id': 'd4e2fe169a8b40f3846421ac04e4fccb', 'component': None, 'component_name': None,'visible': 1, 'isautopm': 0},
            {'id': '4236eb70-1558-43a0-9cf2-037230c547f9', 'name': '部门管理', 'sort': 1, 'web_path': 'departmentManage','icon': 'university', 'parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/dept', 'component_name': 'dept', 'visible': 1,'isautopm':0},
            {'id': '4ba07859-8b73-4524-a1a6-bbff36d98337', 'name': '操作日志', 'sort': 1, 'web_path': 'journalManage','icon': 'gears', 'parent_id': 'c236fb6b-ddaa-4deb-b79b-16e42d9f347f', 'component': 'system/log/operationLog', 'component_name': 'operationLog', 'visible': 1,'isautopm':0},
            {'id': '56c3f341-4f46-4b04-9cfc-c8a14701707e', 'name': '菜单管理', 'sort': 2, 'web_path': 'menuManage','icon': 'reorder', 'parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/menu','component_name': 'menu', 'visible': 1,'isautopm':0},
            {'id': 'e0f53902-e901-490c-83f3-331e60b97fcf', 'name': '按钮配置', 'sort': 2,'web_path': 'buttonConfig/:id/:name', 'icon': 'clock-o','parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/ menuButton', 'component_name': None, 'visible': 0,'isautopm':0},
            {'id': '15c9ebc5-d12f-470a-a560-938a7dc57570', 'name': '角色管理', 'sort': 3,'web_path': 'roleManage', 'icon': 'users','parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/role', 'component_name': 'role', 'visible': 1,'isautopm':0},
            {'id': 'a607e820-36e5-45c0-aabf-85a8e4e2c7ac', 'name': '权限管理', 'sort': 4,'web_path': 'authorityManage', 'icon': 'user-plus','parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/rolePermission', 'component_name': 'rolePermission', 'visible': 1,'isautopm':0},
            {'id': '151035da-77a3-4a62-b474-fce6824571fb', 'name': '按钮管理', 'sort': 6,'web_path': 'buttonManage', 'icon': 'support','parent_id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'component': 'system/button','component_name': 'buttonManage', 'visible': 0,'isautopm':0},
            {'id': '54f769b0-3dff-416c-8102-e55ec44827cc', 'name': '系统管理', 'sort': 20,'web_path': 'departmentManage', 'icon': 'el-icon-s-tools', 'parent_id': None,'component': None, 'component_name': None, 'visible': 1,'isautopm':0},
            {'id': '25735adb-d051-4b7b-bbb7-1154526f3e4c', 'name': '个人中心', 'sort': 13,'web_path': 'personalCenter', 'icon': 'el-icon-s-custom', 'parent_id': None,'component': None, 'component_name': None, 'visible': 1,'isautopm':0},
            {'id': 'c236fb6b-ddaa-4deb-b79b-16e42d9f347f', 'name': '日志管理', 'sort': 999,'web_path': 'journalManage', 'icon': 'el-icon-warning', 'parent_id': None,'component': None, 'component_name': None, 'visible': 1,'isautopm':0},
        ]
        self.save(Menu, self.menu_data, "菜单表")

    def init_menu_button(self):
        """
        初始化菜单权限表
        """
        self.menu_button_data = [
            {'id': 'e7fa30290d37447585ea7583d9d01f1b', 'menu_id': 'ae5629946df4497cbec10419e8375dd9',
             'name': '编辑', 'value': 'Update', 'api': '/api/platformsettings/lunboimg/{id}/', 'method': 2},
            {'id': '6e4251a948f348ccaa419a777a118048', 'menu_id': '80a340eae92b430abe17635468c2df1d',
             'name': '编辑', 'value': 'Update', 'api': '/api/platformsettings/other/{id}/', 'method': 2},
            {'id': '0209de89-6b9f-4d8a-84d3-ccfc3cc8b4da', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb',
             'name': '编辑', 'value': 'Update', 'api': '/api/system/button/{id}/', 'method': 2},
            {'id': '04896a47-0f3a-4e2f-a111-bfe15f9e31c5', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e',
             'name': '编辑', 'value': 'Update', 'api': '/api/system/menu/{id}/', 'method': 2},
            {'id': '3e11db64-b8e8-4558-963b-71d063a7db16', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9',
             'name': '编辑', 'value': 'Update', 'api': '/api/system/dept/{id}/', 'method': 2},
            {'id': '5d77d14e-b199-481f-a97d-6e4c0e84fe71', 'menu_id': '25735adb-d051-4b7b-bbb7-1154526f3e4c',
             'name': '修改密码', 'value': 'Changepassword', 'api': '/api/system/user/change_password/{id}/', 'method': 2},
            {'id': '875bdfeb-0c34-441d-8ee3-bb93c21e17dd', 'menu_id': '244b28685cd14a39a383189981510d4a',
             'name': '编辑', 'value': 'Update', 'api': '/api/users/users/{id}/', 'method': 2},
            {'id': 'bc114580-e62d-4e08-b707-843759817344', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e',
             'name': '编辑', 'value': 'Update', 'api': '/api/system/user/{id}/', 'method': 2},
            {'id': 'bc6104a0-f487-4dfd-a368-fb587d6d57d8', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf',
             'name': '编辑', 'value': 'Update', 'api': '/api/system/menu_button/{id}/', 'method': 2},
            {'id': 'd22c0176-96e0-48b3-b81e-13443f306af5', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570',
             'name': '编辑', 'value': 'Update', 'api': '/api/system/role/{id}/', 'method': 2},
            {'id': 'dcc58831-08d1-4469-8b01-fca71e0f497f', 'menu_id': '25735adb-d051-4b7b-bbb7-1154526f3e4c',
             'name': '编辑', 'value': 'Update', 'api': '/api/system/user/user_info/', 'method': 2},
            {'id': 'e6b93920-2236-46ec-841b-cff6f63ce788', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337',
             'name': '编辑', 'value': 'Update', 'api': '/api/system/operation_log/{id}/', 'method': 2},
            {'id': 'ca69833045ed4cf78c8586f7e55ba6db', 'menu_id': '3171db16eda048ae92b16536fc1241b6',
             'name': '编辑', 'value': 'Update', 'api': '/api/messages/messagenotice/{id}/', 'method': 2},
            {'id': '59db5099a03f44c8adb883faa340c15a', 'menu_id': 'ae5629946df4497cbec10419e8375dd9',
             'name': '查询', 'value': 'Search', 'api': '/api/platformsettings/lunboimg/', 'method': 0},
            {'id': '80efc041695a42e4a9a04c010c6c7004', 'menu_id': '80a340eae92b430abe17635468c2df1d',
             'name': '查询', 'value': 'Search', 'api': '/api/platformsettings/other/', 'method': 0},
            {'id': '140166e2-471e-455e-9dcd-05cebbbab95d', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570',
             'name': '查询', 'value': 'Search', 'api': '/api/system/role/', 'method': 0},
            {'id': '324776a3-48ec-4bca-bdd9-1838e2b6f7cc', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e',
             'name': '查询', 'value': 'Search', 'api': '/api/system/user/', 'method': 0},
            {'id': '3688b715-4689-468f-bf3e-6f910259f837', 'menu_id': '25735adb-d051-4b7b-bbb7-1154526f3e4c',
             'name': '查询', 'value': 'Search', 'api': '/api/system/user/user_info/', 'method': 0},
            {'id': '37462e31-3cdf-4576-af10-5958f53b1bef', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337',
             'name': '查询', 'value': 'Search', 'api': '/api/system/operation_log/', 'method': 0},
            {'id': '42ad6e05-7c84-444f-bcae-09de84f4988b', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e',
             'name': '查询', 'value': 'Search', 'api': '/api/system/menu/', 'method': 0},
            {'id': '43696212-ecba-4e66-8678-33c9bc935c76', 'menu_id': '244b28685cd14a39a383189981510d4a',
             'name': '查询', 'value': 'Search', 'api': '/api/users/users/', 'method': 0},
            {'id': '5aac29b0-5a32-45fb-81c5-437b48f4a5df', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf',
             'name': '查询', 'value': 'Search', 'api': '/api/system/menu_button/', 'method': 0},
            {'id': '646e9790-24f5-4606-abc4-0b5eede12f66', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9',
             'name': '查询', 'value': 'Search', 'api': '/api/system/dept/', 'method': 0},
            {'id': 'af60d628-73b1-4c5d-b34e-7c70ab9bd87e', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb',
             'name': '查询', 'value': 'Search', 'api': '/api/system/button/', 'method': 0},
            {'id': 'd1b3c15f0c664857aeca1d9065d9c499', 'menu_id': '3171db16eda048ae92b16536fc1241b6',
             'name': '查询', 'value': 'Search', 'api': '/api/messages/messagenotice/', 'method': 0},
            {'id': '7aef1da4647844e3944a2745cef1bc6d', 'menu_id': 'ae5629946df4497cbec10419e8375dd9',
             'name': '新增', 'value': 'Create', 'api': '/api/platformsettings/lunboimg/', 'method': 1},
            {'id': '77096cd56a6441699345e6e4f22d0ec3', 'menu_id': '80a340eae92b430abe17635468c2df1d',
             'name': '新增', 'value': 'Create', 'api': '/api/platformsettings/other/', 'method': 1},
            {'id': '0d931efc-2f80-418f-b4a0-5251f0a88f69', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337',
             'name': '新增', 'value': 'Create', 'api': '/api/system/operation_log/', 'method': 1},
            {'id': '10610c56-cec2-4774-9468-e1c763e59e70', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9',
             'name': '新增', 'value': 'Create', 'api': '/api/system/dept/', 'method': 1},
            {'id': '1b4f27a7-8ab8-4388-ae57-46e29976cf0e', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb',
             'name': '新增', 'value': 'Create', 'api': '/api/system/button/', 'method': 1},
            {'id': '2a3d4756-4d51-4129-b3c4-b2c7a00dbb8a', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570',
             'name': '新增', 'value': 'Create', 'api': '/api/system/role/', 'method': 1},
            {'id': '9e6b2376-1ab0-4966-8d5d-4ad4f911d13c', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e',
             'name': '新增', 'value': 'Create', 'api': '/api/system/user/', 'method': 1},
            {'id': '9fc8436a-1996-478f-a155-5de7939a54dc', 'menu_id': '244b28685cd14a39a383189981510d4a',
             'name': '新增', 'value': 'Create', 'api': '/api/users/users/', 'method': 1},
            {'id': 'abe5c07f-0cab-4053-ac24-e782792e9d7f', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e',
             'name': '新增', 'value': 'Create', 'api': '/api/system/menu/', 'method': 1},
            {'id': 'fc71b446-fde1-439f-ab41-c38f30230caa', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf',
             'name': '新增', 'value': 'Create', 'api': '/api/system/menu_button/', 'method': 1},
            {'id': 'd2e0608b5b4941ef8c3ff834977caeef', 'menu_id': '3171db16eda048ae92b16536fc1241b6',
             'name': '新增', 'value': 'Create', 'api': '/api/messages/messagenotice/', 'method': 1},
            {'id': 'a3088120763d49ad93498eb515c7c244', 'menu_id': 'ae5629946df4497cbec10419e8375dd9',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/platformsettings/lunboimg/{id}/', 'method': 0},
            {'id': '1d4441fdc418499f856c23aa4e1be2c0', 'menu_id': '80a340eae92b430abe17635468c2df1d',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/platformsettings/other/{id}/', 'method': 0},
            {'id': '14e7088f-a39b-47ae-bd67-b9bbcabae96b', 'menu_id': '244b28685cd14a39a383189981510d4a',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/users/users/{id}/', 'method': 0},
            {'id': '6208f412-6bca-4d7b-a5a0-0103b7ba6091', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/system/button/{id}/', 'method': 0},
            {'id': '6300774a-d19c-43ad-8102-d7bf341eff33', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/system/dept/{id}/', 'method': 0},
            {'id': '8b7a0e79-a6ef-4946-87c6-8c042b887e1c', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/system/operation_log/{id}/', 'method': 0},
            {'id': '96022ae5-6425-47b9-8f89-01edc33eb2b7', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/system/role/{id}/', 'method': 0},
            {'id': 'f0e080c0-275d-4085-b56c-735b49510eff', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/system/user/{id}/', 'method': 0},
            {'id': 'fcbe4cec-cc2d-436d-92ba-023f8c9ad31c', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/system/menu/{id}/', 'method': 0},
            {'id': 'fe96f32c-6124-4b24-b809-4964186f5163', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/system/menu_button/{id}/', 'method': 0},
            {'id': '6b88361b326a4e55a8a5135c08ba66f1', 'menu_id': '3171db16eda048ae92b16536fc1241b6',
             'name': '单例', 'value': 'Retrieve', 'api': '/api/messages/messagenotice/{id}/', 'method': 0},
            {'id': '0088e172566f4ee388092ec2be3584ee', 'menu_id': 'ae5629946df4497cbec10419e8375dd9',
             'name': '删除', 'value': 'Delete', 'api': '/api/platformsettings/lunboimg/{id}/', 'method': 3},
            {'id': '264cc3d69f7a46d5a117997e9c78506c', 'menu_id': '80a340eae92b430abe17635468c2df1d',
             'name': '删除', 'value': 'Delete', 'api': '/api/platformsettings/other/{id}/', 'method': 3},
            {'id': '2c53efc8-e6a4-4192-8688-03baed0874a4', 'menu_id': '2e3438c8-3ddc-43ff-b8d8-cca328e4856e',
             'name': '删除', 'value': 'Delete', 'api': '/api/system/user/{id}/', 'method': 3},
            {'id': '3fd6ae6c-fd76-4465-b2b6-db672f4bd79e', 'menu_id': '15c9ebc5-d12f-470a-a560-938a7dc57570',
             'name': '删除', 'value': 'Delete', 'api': '/api/system/role/{id}/', 'method': 3},
            {'id': '4fe4b7f5-0bc8-4375-9f39-747e06ec285a', 'menu_id': 'e0f53902-e901-490c-83f3-331e60b97fcf',
             'name': '删除', 'value': 'Delete', 'api': '/api/system/menu_button/{id}/', 'method': 3},
            {'id': '51085c21-2279-490f-8878-594f059f7616', 'menu_id': '151035da-77a3-4a62-b474-fce6824571fb',
             'name': '删除', 'value': 'Delete', 'api': '/api/system/button/{id}/', 'method': 3},
            {'id': '8ae924bd-576c-4ae1-92eb-b0a98148baae', 'menu_id': '56c3f341-4f46-4b04-9cfc-c8a14701707e',
             'name': '删除', 'value': 'Delete', 'api': '/api/system/menu/{id}/', 'method': 3},
            {'id': 'acfde861-1872-47e2-a1f1-abeda5175b7f', 'menu_id': '4ba07859-8b73-4524-a1a6-bbff36d98337',
             'name': '删除', 'value': 'Delete', 'api': '/api/system/operation_log/{id}/', 'method': 3},
            {'id': 'b10f7d08-2592-4b54-8557-b5ca864a029a', 'menu_id': '4236eb70-1558-43a0-9cf2-037230c547f9',
             'name': '删除', 'value': 'Delete', 'api': '/api/system/dept/{id}/', 'method': 3},
            {'id': 'bb7de9ee-5fd1-46f5-9849-088c522f49c7', 'menu_id': '244b28685cd14a39a383189981510d4a',
             'name': '删除', 'value': 'Delete', 'api': '/api/users/users/{id}/', 'method': 3},
            {'id': 'c8eee7f68c1845169b8d2af946502077', 'menu_id': '3171db16eda048ae92b16536fc1241b6',
             'name': '删除', 'value': 'Delete', 'api': '/api/messages/messagenotice/{id}/', 'method': 3},
            {'id': '1a0c96cf-09a6-43b4-b08a-0c5b6e2f7bb8', 'menu_id': 'a607e820-36e5-45c0-aabf-85a8e4e2c7ac',
             'name': '保存', 'value': 'Retrieve', 'api': '/api/system/role/{id}/', 'method': 2},
            {'id': '353595a28cb1463b830cfbf79fea60b5', 'menu_id': '244b28685cd14a39a383189981510d4a',
             'name': '禁用', 'value': 'Disable', 'api': '/api/users/users/disableuser/{id}/', 'method': 2},
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
             "is_superuser": 1, "is_staff": 1,
             "is_active": 1, "username": "superadmin", "name": "超级管理员",
             "dept_id": "d2c03bd9-dad0-4262-88ca-c3681d224fc3",
             },
            {"id": "d1431450-5068-4461-b57e-7862c005a547",
             "password": "pbkdf2_sha256$260000$DO6dpT8e4Ls0yD51grncC8$KZfswxNJ8MILTWwy+bicRyU7Q3PKC4orn4SJbhIkN4Q=",
             "is_superuser": 0, "is_staff": 1,
             "is_active": 1, "username": "admin", "name": "管理员",
             "dept_id": "d2c03bd9-dad0-4262-88ca-c3681d224fc3",
             "role": ["36001d1a-1b3e-4413-bdfe-b3bc04375f46"],
             },
            {"id": "244b28685cd14a39a383189981510d4a",
             "password": "pbkdf2_sha256$260000$oivECWOjB0GJyMjPsrqb3t$9FvnYtXtsNWDva2P3A/eIg6cRMLOp7kiIOuwfLKyDAY=",
             "is_superuser": 0, "is_staff": 0,
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
             "sort": 1,
             "msg_title":"测试消息",
             "msg_content": "<p>消息内容实体部分</p>",
             "to_path": "/index/path",
             "status": 1,
             },
        ]
        self.save(MyMessage, data, "平台公告")

    def init_platformsettings_other(self):
        """
        初始化其他设置
        """
        data = [
            {"id": "34799dd05d094458bd2b200d3f211eda",
             "name": "客服电话",
             "status": 1,
             "sort": 1,
             "key":"customerservicephone",
             "value": "4006668888",
             },
            {"id": "4ef8d8c46f2649438bddaba3628e3271",
             "name": "关于我们",
             "status": 1,
             "sort": 2,
             "key":"aboutus",
             "value": "<p>我是关于我们的简介，请写在这里</p>",
             },
        ]
        self.save(OtherManage, data, "其他设置")

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


def main(is_delete=False):
    Initialize(is_delete).run()
    pass


if __name__ == '__main__':
    main()

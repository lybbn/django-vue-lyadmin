export const systemTree = [
	{
		id: "1",
		text: "管理员管理",
		checked: false,
		attributes: {
			icon: "el-icon-s-custom",
			url: "adminManage"
		},
		hasParent: false,
		hasChildren: false,
	},

	{
		id: "10",
		text: "用户管理",
		checked: false,
		attributes: {
			icon: "el-icon-s-custom",
			url: "userManage"
		},
		hasParent: false,
		hasChildren: false,
	},

	{
		id: "13",
		text: "平台设置",
		checked: false,
		attributes: {
			icon: "el-icon-s-platform",
			url: ""
		},
		hasParent: false,
		hasChildren: true,
		children: [
            {
                id: "131",
                text: "轮播图设置",
                checked: false,
                attributes: {
                    icon: "icon-cat-skuQuery",
                    url: "carouselSettingsimg"
                },
                parentId: "13",
                hasParent: false
            },
            {
                id: "133",
                text: "其他设置",
                checked: false,
                attributes: {
                    icon: "icon-cat-skuQuery",
                    url: "platformSettingsother"
                },
                parentId: "13",
                hasParent: false
            },
		]
	},

	{
		id: "19",
		text: "意见反馈",
		checked: false,
		attributes: {
			icon: "el-icon-warning",
			url: "userFeekback"
		},
		hasParent: false,
		hasChildren: false,
	},
	{
		id: "70",
		text: "消息中心",
		checked: false,
		attributes: {
			icon: "el-icon-message-solid",
			url:''
		},
		hasParent: false,
		hasChildren: true,
		children: [
			{
				id: "301",
				text: "消息模板",
				checked: false,
				attributes: {
					icon: "",
					url: "messagTemplate"
				},
				parentId: "70",
				hasParent: false
			},
			{
				id: "302",
				text: "消息公告",
				checked: false,
				attributes: {
					icon: "",
					url: "messagNotice"
				},
				parentId: "70",
				hasParent: false
			}
		]
	},
	{
		id: "80",
		text: "系统管理",
		checked: false,
		attributes: {
			icon: "el-icon-s-tools",
			url: "taskFeedbackManage"
		},
		hasParent: false,
		hasChildren: true,
		children: [
			{
				id: "201",
				text: "部门管理",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "departmentManage"
				},
				parentId: "10",
				hasParent: false
			},
			{
				id: "202",
				text: "菜单管理",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "menuManage"
				},
				parentId: "10",
				hasParent: false
			},
			{
				id: "203",
				text: "角色管理",
				state: null,
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "roleManage"
				},
				parentId: "10",
				hasParent: false
			},
			{
				id: "204",
				text: "权限管理",
				state: null,
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "authorityManage"
				},
				parentId: "10",
				hasParent: false
			},
		],
	},
	{
		id: "99",
		text: "个人中心",
		checked: false,
		attributes: {
			icon: "el-icon-message",
			url: "personalCenter"
		},
		hasParent: false,
		hasChildren: false,
	},
	{
		id: "100",
		text: "操作日志",
		checked: false,
		attributes: {
			icon: "el-icon-document",
			url: "journalManage"
		},
		hasParent: false,
		hasChildren: false,
	},
];

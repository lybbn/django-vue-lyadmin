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
		id: "2",
		text: "用户管理",
		checked: false,
		attributes: {
			icon: "el-icon-user",
			url: "userManage"
		},
		hasParent: false,
		hasChildren: false,
	},

	{
		id: "3",
		text: "代理商管理",
		checked: false,
		attributes: {
			icon: "el-icon-s-flag",
			url: "agentManage"
		},
		hasParent: false,
		hasChildren: true,
		children: [
			{
				id: "31",
				text: "代理商管理",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "agentManage"
				},
				parentId: "3",
				hasParent: false
			},
			{
				id: "32",
				text: "代理商申请",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "agentApply"
				},
				parentId: "3",
				hasParent: false
			},
		]
	},


	{
		id: "4",
		text: "回收员管理",
		checked: false,
		attributes: {
			icon: "el-icon-s-release",
			url: "recyclerManage"
		},
		hasParent: false,
		hasChildren: false,
	},
	{
		id: "5",
		text: "回收员申请",
		checked: false,
		attributes: {
			icon: "el-icon-s-cooperation",
			url: "recyclerApply"
		},
		hasParent: false,
		hasChildren: false,
	},


	{
		id: "6",
		text: "回收类目管理",
		checked: false,
		attributes: {
			icon: "el-icon-tickets",
			url: "recyclCategoryManage"
		},
		hasParent: false,
		hasChildren: true,
		children: [
			{
				id: "61",
				text: "一级分类",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "recyclCategoryParent"
				},
				parentId: "6",
				hasParent: false
			},
			{
				id: "62",
				text: "二级分类",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "recyclCategoryChild"
				},
				parentId: "6",
				hasParent: false
			},
		]
	},
	{
		id: "7",
		text: "商城管理",
		checked: false,
		attributes: {
			icon: "el-icon-shopping-bag-1",
			url: ""
		},
		hasParent: false,
		hasChildren: true,
		children: [
			{
				id: "71",
				text: "商城商品管理",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "shoppingMallGoodsManage"
				},
				parentId: "7",
				hasParent: false
			},
			{
				id: "72",
				text: "分类",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "goodsClass"
				},
				parentId: "7",
				hasParent: false
			},
		]
	},
	{
		id: "8",
		text: "订单管理",
		checked: false,
		attributes: {
			icon: "el-icon-s-order",
			url: ""
		},
		hasParent: false,
		hasChildren: true,
		children: [
			{
				id: "81",
				text: "回收订单管理",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "recoveryOrderManage"
				},
				parentId: "8",
				hasParent: false
			},
			{
				id: "82",
				text: "商城订单管理",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "shoppingMallOrderManage"
				},
				parentId: "8",
				hasParent: false
			},
		]
	},

	{
		id: "9",
		text: "代理区域申请",
		checked: false,
		attributes: {
			icon: "el-icon-school",
			url: "actRegionalAudit"
		},
		hasParent: false,
		hasChildren: false
	},

	{
		id: "10",
		text: "回收站点管理",
		checked: false,
		attributes: {
			icon: "el-icon-map-location",
			url: "recyclSiteManage"
		},
		hasParent: false,
		hasChildren: false
	},
	{
		id: "11",
		text: "申请额度",
		checked: false,
		attributes: {
			icon: "el-icon-s-finance",
			url: ""
		},
		hasParent: false,
		hasChildren: true,
		children: [
			{
				id: "111",
				text: "回收员申请额度",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "applyQuotaRecycl"
				},
				parentId: "11",
				hasParent: false
			},
			{
				id: "112",
				text: "代理商申请额度",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "applyQuotaAgent"
				},
				parentId: "11",
				hasParent: false
			},
		]
	},

	{
		id: "12",
		text: "资讯动态",
		checked: false,
		attributes: {
			icon: "el-icon-news",
			url: "dynamicsInfo"
		},
		hasParent: false,
		hasChildren: false
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
				id: "130",
				text: "平台图片设置",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "platformSettingsImg"
				},
				parentId: "13",
				hasParent: false
			},
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
				id: "132",
				text: "标签设置",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "labelSetting"
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

	// {
	// 	id: "14",
	// 	text: "客服设置",
	// 	checked: false,
	// 	attributes: {
	// 		icon: "el-icon-service",
	// 		url: "customerServiceSettings"
	// 	},
	// 	hasParent: false,
	// 	hasChildren: false,
	// },

	{
		id: "15",
		text: "分销设置",
		checked: false,
		attributes: {
			icon: "el-icon-s-ticket",
			url: "distributionSettings"
		},
		hasParent: false,
		hasChildren: false,
	},
	{
		id: "16",
		text: "财务管理",
		checked: false,
		attributes: {
			icon: "el-icon-s-management",
			url: "distributionSettings"
		},
		hasParent: false,
		hasChildren: true,
		children: [
			{
				id: "161",
				text: "代理商财务统计",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "financeStatisticsAgent"
				},
				parentId: "16",
				hasParent: false
			},
			{
				id: "162",
				text: "回收员财务统计",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "financeStatisticsRecycl"
				},
				parentId: "16",
				hasParent: false
			},
			{
				id: "163",
				text: "用户提现统计",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "withdrawalStatisticsUser"
				},
				parentId: "16",
				hasParent: false
			},
			{
				id: "164",
				text: "用户提现审核",
				checked: false,
				attributes: {
					icon: "icon-cat-skuQuery",
					url: "applyJifenCashOutUser"
				},
				parentId: "16",
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

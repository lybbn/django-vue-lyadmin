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
                    url: "PlatformSettingsother"
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

export const menuicons =[{"value": "AddLocation", "msg": "AddLocation"}, {"value": "Aim", "msg": "Aim"}, {"value": "AlarmClock", "msg": "AlarmClock"}, {"value": "Apple", "msg": "Apple"}, {"value": "ArrowDown", "msg": "ArrowDown"}, {"value": "ArrowDownBold", "msg": "ArrowDownBold"}, {"value": "ArrowLeft", "msg": "ArrowLeft"}, {"value": "ArrowLeftBold", "msg": "ArrowLeftBold"}, {"value": "ArrowRight", "msg": "ArrowRight"}, {"value": "ArrowRightBold", "msg": "ArrowRightBold"}, {"value": "ArrowUp", "msg": "ArrowUp"}, {"value": "ArrowUpBold", "msg": "ArrowUpBold"}, {"value": "Avatar", "msg": "Avatar"}, {"value": "Back", "msg": "Back"}, {"value": "Baseball", "msg": "Baseball"}, {"value": "Basketball", "msg": "Basketball"}, {"value": "Bell", "msg": "Bell"}, {"value": "BellFilled", "msg": "BellFilled"}, {"value": "Bicycle", "msg": "Bicycle"}, {"value": "Bottom", "msg": "Bottom"}, {"value": "BottomLeft", "msg": "BottomLeft"}, {"value": "BottomRight", "msg": "BottomRight"}, {"value": "Bowl", "msg": "Bowl"}, {"value": "Box", "msg": "Box"}, {"value": "Briefcase", "msg": "Briefcase"}, {"value": "Brush", "msg": "Brush"}, {"value": "BrushFilled", "msg": "BrushFilled"}, {"value": "Burger", "msg": "Burger"}, {"value": "Calendar", "msg": "Calendar"}, {"value": "Camera", "msg": "Camera"}, {"value": "CameraFilled", "msg": "CameraFilled"}, {"value": "CaretBottom", "msg": "CaretBottom"}, {"value": "CaretLeft", "msg": "CaretLeft"}, {"value": "CaretRight", "msg": "CaretRight"}, {"value": "CaretTop", "msg": "CaretTop"}, {"value": "Cellphone", "msg": "Cellphone"}, {"value": "ChatDotRound", "msg": "ChatDotRound"}, {"value": "ChatDotSquare", "msg": "ChatDotSquare"}, {"value": "ChatLineRound", "msg": "ChatLineRound"}, {"value": "ChatLineSquare", "msg": "ChatLineSquare"}, {"value": "ChatRound", "msg": "ChatRound"}, {"value": "ChatSquare", "msg": "ChatSquare"}, {"value": "Check", "msg": "Check"}, {"value": "Checked", "msg": "Checked"}, {"value": "Cherry", "msg": "Cherry"}, {"value": "Chicken", "msg": "Chicken"}, {"value": "CircleCheck", "msg": "CircleCheck"}, {"value": "CircleCheckFilled", "msg": "CircleCheckFilled"}, {"value": "CircleClose", "msg": "CircleClose"}, {"value": "CircleCloseFilled", "msg": "CircleCloseFilled"}, {"value": "CirclePlus", "msg": "CirclePlus"}, {"value": "CirclePlusFilled", "msg": "CirclePlusFilled"}, {"value": "Clock", "msg": "Clock"}, {"value": "Close", "msg": "Close"}, {"value": "CloseBold", "msg": "CloseBold"}, {"value": "Cloudy", "msg": "Cloudy"}, {"value": "Coffee", "msg": "Coffee"}, {"value": "CoffeeCup", "msg": "CoffeeCup"}, {"value": "Coin", "msg": "Coin"}, {"value": "ColdDrink", "msg": "ColdDrink"}, {"value": "Collection", "msg": "Collection"}, {"value": "CollectionTag", "msg": "CollectionTag"}, {"value": "Comment", "msg": "Comment"}, {"value": "Compass", "msg": "Compass"}, {"value": "Connection", "msg": "Connection"}, {"value": "Coordinate", "msg": "Coordinate"}, {"value": "CopyDocument", "msg": "CopyDocument"}, {"value": "Cpu", "msg": "Cpu"}, {"value": "CreditCard", "msg": "CreditCard"}, {"value": "Crop", "msg": "Crop"}, {"value": "DArrowLeft", "msg": "DArrowLeft"}, {"value": "DArrowRight", "msg": "DArrowRight"}, {"value": "DCaret", "msg": "DCaret"}, {"value": "DataAnalysis", "msg": "DataAnalysis"}, {"value": "DataBoard", "msg": "DataBoard"}, {"value": "DataLine", "msg": "DataLine"}, {"value": "Delete", "msg": "Delete"}, {"value": "DeleteFilled", "msg": "DeleteFilled"}, {"value": "DeleteLocation", "msg": "DeleteLocation"}, {"value": "Dessert", "msg": "Dessert"}, {"value": "Discount", "msg": "Discount"}, {"value": "Dish", "msg": "Dish"}, {"value": "DishDot", "msg": "DishDot"}, {"value": "Document", "msg": "Document"}, {"value": "DocumentAdd", "msg": "DocumentAdd"}, {"value": "DocumentChecked", "msg": "DocumentChecked"}, {"value": "DocumentCopy", "msg": "DocumentCopy"}, {"value": "DocumentDelete", "msg": "DocumentDelete"}, {"value": "DocumentRemove", "msg": "DocumentRemove"}, {"value": "Download", "msg": "Download"}, {"value": "Drizzling", "msg": "Drizzling"}, {"value": "Edit", "msg": "Edit"}, {"value": "EditPen", "msg": "EditPen"}, {"value": "Eleme", "msg": "Eleme"}, {"value": "ElemeFilled", "msg": "ElemeFilled"}, {"value": "ElementPlus", "msg": "ElementPlus"}, {"value": "Expand", "msg": "Expand"}, {"value": "Failed", "msg": "Failed"}, {"value": "Female", "msg": "Female"}, {"value": "Files", "msg": "Files"}, {"value": "Film", "msg": "Film"}, {"value": "Filter", "msg": "Filter"}, {"value": "Finished", "msg": "Finished"}, {"value": "FirstAidKit", "msg": "FirstAidKit"}, {"value": "Flag", "msg": "Flag"}, {"value": "Fold", "msg": "Fold"}, {"value": "Folder", "msg": "Folder"}, {"value": "FolderAdd", "msg": "FolderAdd"}, {"value": "FolderChecked", "msg": "FolderChecked"}, {"value": "FolderDelete", "msg": "FolderDelete"}, {"value": "FolderOpened", "msg": "FolderOpened"}, {"value": "FolderRemove", "msg": "FolderRemove"}, {"value": "Food", "msg": "Food"}, {"value": "Football", "msg": "Football"}, {"value": "ForkSpoon", "msg": "ForkSpoon"}, {"value": "Fries", "msg": "Fries"}, {"value": "FullScreen", "msg": "FullScreen"}, {"value": "Goblet", "msg": "Goblet"}, {"value": "GobletFull", "msg": "GobletFull"}, {"value": "GobletSquare", "msg": "GobletSquare"}, {"value": "GobletSquareFull", "msg": "GobletSquareFull"}, {"value": "Goods", "msg": "Goods"}, {"value": "GoodsFilled", "msg": "GoodsFilled"}, {"value": "Grape", "msg": "Grape"}, {"value": "Grid", "msg": "Grid"}, {"value": "Guide", "msg": "Guide"}, {"value": "Headset", "msg": "Headset"}, {"value": "Help", "msg": "Help"}, {"value": "HelpFilled", "msg": "HelpFilled"}, {"value": "Hide", "msg": "Hide"}, {"value": "Histogram", "msg": "Histogram"}, {"value": "HomeFilled", "msg": "HomeFilled"}, {"value": "HotWater", "msg": "HotWater"}, {"value": "House", "msg": "House"}, {"value": "IceCream", "msg": "IceCream"}, {"value": "IceCreamRound", "msg": "IceCreamRound"}, {"value": "IceCreamSquare", "msg": "IceCreamSquare"}, {"value": "IceDrink", "msg": "IceDrink"}, {"value": "IceTea", "msg": "IceTea"}, {"value": "InfoFilled", "msg": "InfoFilled"}, {"value": "Iphone", "msg": "Iphone"}, {"value": "Key", "msg": "Key"}, {"value": "KnifeFork", "msg": "KnifeFork"}, {"value": "Lightning", "msg": "Lightning"}, {"value": "Link", "msg": "Link"}, {"value": "List", "msg": "List"}, {"value": "Loading", "msg": "Loading"}, {"value": "Location", "msg": "Location"}, {"value": "LocationFilled", "msg": "LocationFilled"}, {"value": "LocationInformation", "msg": "LocationInformation"}, {"value": "Lock", "msg": "Lock"}, {"value": "Lollipop", "msg": "Lollipop"}, {"value": "MagicStick", "msg": "MagicStick"}, {"value": "Magnet", "msg": "Magnet"}, {"value": "Male", "msg": "Male"}, {"value": "Management", "msg": "Management"}, {"value": "MapLocation", "msg": "MapLocation"}, {"value": "Medal", "msg": "Medal"}, {"value": "Menu", "msg": "Menu"}, {"value": "Message", "msg": "Message"}, {"value": "MessageBox", "msg": "MessageBox"}, {"value": "Mic", "msg": "Mic"}, {"value": "Microphone", "msg": "Microphone"}, {"value": "MilkTea", "msg": "MilkTea"}, {"value": "Minus", "msg": "Minus"}, {"value": "Money", "msg": "Money"}, {"value": "Monitor", "msg": "Monitor"}, {"value": "Moon", "msg": "Moon"}, {"value": "MoonNight", "msg": "MoonNight"}, {"value": "More", "msg": "More"}, {"value": "MoreFilled", "msg": "MoreFilled"}, {"value": "MostlyCloudy", "msg": "MostlyCloudy"}, {"value": "Mouse", "msg": "Mouse"}, {"value": "Mug", "msg": "Mug"}, {"value": "Mute", "msg": "Mute"}, {"value": "MuteNotification", "msg": "MuteNotification"}, {"value": "NoSmoking", "msg": "NoSmoking"}, {"value": "Notebook", "msg": "Notebook"}, {"value": "Notification", "msg": "Notification"}, {"value": "Odometer", "msg": "Odometer"}, {"value": "OfficeBuilding", "msg": "OfficeBuilding"}, {"value": "Open", "msg": "Open"}, {"value": "Operation", "msg": "Operation"}, {"value": "Opportunity", "msg": "Opportunity"}, {"value": "Orange", "msg": "Orange"}, {"value": "Paperclip", "msg": "Paperclip"}, {"value": "PartlyCloudy", "msg": "PartlyCloudy"}, {"value": "Pear", "msg": "Pear"}, {"value": "Phone", "msg": "Phone"}, {"value": "PhoneFilled", "msg": "PhoneFilled"}, {"value": "Picture", "msg": "Picture"}, {"value": "PictureFilled", "msg": "PictureFilled"}, {"value": "PictureRounded", "msg": "PictureRounded"}, {"value": "PieChart", "msg": "PieChart"}, {"value": "Place", "msg": "Place"}, {"value": "Platform", "msg": "Platform"}, {"value": "Plus", "msg": "Plus"}, {"value": "Pointer", "msg": "Pointer"}, {"value": "Position", "msg": "Position"}, {"value": "Postcard", "msg": "Postcard"}, {"value": "Pouring", "msg": "Pouring"}, {"value": "Present", "msg": "Present"}, {"value": "PriceTag", "msg": "PriceTag"}, {"value": "Printer", "msg": "Printer"}, {"value": "Promotion", "msg": "Promotion"}, {"value": "QuestionFilled", "msg": "QuestionFilled"}, {"value": "Rank", "msg": "Rank"}, {"value": "Reading", "msg": "Reading"}, {"value": "ReadingLamp", "msg": "ReadingLamp"}, {"value": "Refresh", "msg": "Refresh"}, {"value": "RefreshLeft", "msg": "RefreshLeft"}, {"value": "RefreshRight", "msg": "RefreshRight"}, {"value": "Refrigerator", "msg": "Refrigerator"}, {"value": "Remove", "msg": "Remove"}, {"value": "RemoveFilled", "msg": "RemoveFilled"}, {"value": "Right", "msg": "Right"}, {"value": "ScaleToOriginal", "msg": "ScaleToOriginal"}, {"value": "School", "msg": "School"}, {"value": "Scissor", "msg": "Scissor"}, {"value": "Search", "msg": "Search"}, {"value": "Select", "msg": "Select"}, {"value": "Sell", "msg": "Sell"}, {"value": "SemiSelect", "msg": "SemiSelect"}, {"value": "Service", "msg": "Service"}, {"value": "SetUp", "msg": "SetUp"}, {"value": "Setting", "msg": "Setting"}, {"value": "Share", "msg": "Share"}, {"value": "Ship", "msg": "Ship"}, {"value": "Shop", "msg": "Shop"}, {"value": "ShoppingBag", "msg": "ShoppingBag"}, {"value": "ShoppingCart", "msg": "ShoppingCart"}, {"value": "ShoppingCartFull", "msg": "ShoppingCartFull"}, {"value": "Smoking", "msg": "Smoking"}, {"value": "Soccer", "msg": "Soccer"}, {"value": "SoldOut", "msg": "SoldOut"}, {"value": "Sort", "msg": "Sort"}, {"value": "SortDown", "msg": "SortDown"}, {"value": "SortUp", "msg": "SortUp"}, {"value": "Stamp", "msg": "Stamp"}, {"value": "Star", "msg": "Star"}, {"value": "StarFilled", "msg": "StarFilled"}, {"value": "Stopwatch", "msg": "Stopwatch"}, {"value": "SuccessFilled", "msg": "SuccessFilled"}, {"value": "Sugar", "msg": "Sugar"}, {"value": "Suitcase", "msg": "Suitcase"}, {"value": "Sunny", "msg": "Sunny"}, {"value": "Sunrise", "msg": "Sunrise"}, {"value": "Sunset", "msg": "Sunset"}, {"value": "Switch", "msg": "Switch"}, {"value": "SwitchButton", "msg": "SwitchButton"}, {"value": "TakeawayBox", "msg": "TakeawayBox"}, {"value": "Ticket", "msg": "Ticket"}, {"value": "Tickets", "msg": "Tickets"}, {"value": "Timer", "msg": "Timer"}, {"value": "ToiletPaper", "msg": "ToiletPaper"}, {"value": "Tools", "msg": "Tools"}, {"value": "Top", "msg": "Top"}, {"value": "TopLeft", "msg": "TopLeft"}, {"value": "TopRight", "msg": "TopRight"}, {"value": "TrendCharts", "msg": "TrendCharts"}, {"value": "Trophy", "msg": "Trophy"}, {"value": "TurnOff", "msg": "TurnOff"}, {"value": "Umbrella", "msg": "Umbrella"}, {"value": "Unlock", "msg": "Unlock"}, {"value": "Upload", "msg": "Upload"}, {"value": "UploadFilled", "msg": "UploadFilled"}, {"value": "User", "msg": "User"}, {"value": "UserFilled", "msg": "UserFilled"}, {"value": "Van", "msg": "Van"}, {"value": "VideoCamera", "msg": "VideoCamera"}, {"value": "VideoCameraFilled", "msg": "VideoCameraFilled"}, {"value": "VideoPause", "msg": "VideoPause"}, {"value": "VideoPlay", "msg": "VideoPlay"}, {"value": "View", "msg": "View"}, {"value": "Wallet", "msg": "Wallet"}, {"value": "WalletFilled", "msg": "WalletFilled"}, {"value": "Warning", "msg": "Warning"}, {"value": "WarningFilled", "msg": "WarningFilled"}, {"value": "Watch", "msg": "Watch"}, {"value": "Watermelon", "msg": "Watermelon"}, {"value": "WindPower", "msg": "WindPower"}, {"value": "ZoomIn", "msg": "ZoomIn"}, {"value": "ZoomOut", "msg": "ZoomOut"}]
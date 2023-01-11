//API DOMAIN
const API_DOMAIN = process.env.NODE_ENV === 'development' ? "127.0.0.1:8000" : "django-vue3-lyadmin.lybbn.cn"
//lyadmin系统配置
module.exports = {

    //API DOMAIN
    API_DOMAIN : API_DOMAIN,

    //接口地址
    API_URL : process.env.NODE_ENV === 'development' ? "http://"+ API_DOMAIN +"/api/" : "https://"+ API_DOMAIN +"/api/",

    //标题
    APP_TITLE : "django-vue-lyadmin后台管理系统",

	//是否开启多标签
	ISMULTITABS: true,

	//语言 简体中文 zh-cn、 英文 en（此功能只是示例）
	LANG: 'zh-cn',

	// elementplus 组件大小： small、default、large
	ELEMENT_SIZE: 'default',

	// elementplus 组件 zIndex
	ELEMENT_ZINDEX: 3000,

	// elementplus button组件 autoInsertSpace 是否自动在两个中文字符之间插入空格
	ELEMENT_BUTTON: false,

	//菜单默认是否折叠
	MENU_IS_COLLAPSE: false,

	//主题颜色
	COLOR: '#409EFF',

    //默认主题 'dark' 暗黑、'light' 正常
	THEME: 'light',

    //登录信息数据存储方式 localStorage、sessionStorage
	STORAGE_METHOD: 'localStorage',

}
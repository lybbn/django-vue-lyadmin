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

	//语言(暂未开发多语言切换)
	LANG: 'zh-cn',

	//主题颜色
	COLOR: '#409EFF',

    //默认主题 'dark' 暗黑、'light' 正常
	THEME: 'light',

    //登录信息数据存储方式 localStorage、sessionStorage
	STORAGE_METHOD: 'localStorage',

}
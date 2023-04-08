import { createI18n } from 'vue-i18n'
import el_zh_cn from 'element-plus/lib/locale/lang/zh-cn'
import el_en from 'element-plus/lib/locale/lang/en'

import zh_cn from './lang/zh-cn.js'
import en from './lang/en.js'

//得到默认使用的语言
const getDefaultLang = () => {
	//用户指定了默认语言时，使用用户指定的
	if (localStorage.getItem('language') != null) {
	  	return localStorage.getItem('language');
	} else {
		//用户未指定时，根据游览器选择:
		if (navigator.language == 'zh-CN') {
		  	return 'zh-cn';
		} else if (navigator.language == 'en') {
		  	return 'en';
		} else {
		  	return 'zh-cn';
		}
	}
}

const messages = {
	'zh-cn': {
		el: el_zh_cn,
		...zh_cn
	},
	'en': {
		el: el_en,
		...en
	}
}

const i18n = createI18n({
	legacy:false,
	locale: getDefaultLang(),
	fallbackLocale: 'zh-cn',// 设置备用语言
	globalInjection: true,
	messages,
})

export default i18n;
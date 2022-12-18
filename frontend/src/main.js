import { createApp } from 'vue'
//引入ElementPlus
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import zhCn from 'element-plus/es/locale/lang/zh-cn'
// 统一导入el-icon图标
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
//引入ElementPlus 结束


import "babel-polyfill";
import 'xe-utils'

//多标签bus通信
import mitt from 'mitt'

//导入自定义css
import './assets/css/common.scss'
//elementplus暗黑主题从（element-plus/theme-chalk/dark/css-vars.css）拷贝
import './assets/css/elementplus-theme-dark-css-vars.css'

import App from './App.vue'
import store from './store'
import axios from 'axios'
import VueAxios from 'vue-axios'

import router from './router'

const app = createApp(App)

app.config.globalProperties.axios = axios

// vue3.x的全局实例，要挂载在config.globalProperties上
app.config.globalProperties.$Bus = new mitt()

//引入状态管理
import {isShowBtn,hasPermission,formatUnitSize} from './utils/util'
app.config.globalProperties.isShowBtn = isShowBtn
app.config.globalProperties.hasPermission = hasPermission
app.config.globalProperties.formatUnitSize = formatUnitSize
// 过滤器
import * as custom from './utils/util'
Object.keys(custom).forEach(key => {
  app.component(key, custom[key])
})

// //进入自定义指令
import directivePlugin from '@/utils/directive.js'

// 注册全局elementplus icon组件
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}
import registerSvgIcon from "./icons"
registerSvgIcon(app)

import draggable from '@/components/vuedraggable/dist/vuedraggable.umd.js'
app.component('draggable', draggable)

import lyContainerWidgets from '@/components/lyform-builder/lyform-design/lycontainers-widget/index'
import lyFieldWidget from '@/components/lyform-builder/lyform-design/lyfield-widget/index'
import lySettingPannel from '@/components/lyform-builder/lysetting-pannel/lywidget-setting/index'

app.use(ElementPlus,{
  size: 'default',  // 默认控件尺寸default(其他large、small)
  zIndex: 3000,  // 弹出组件的zIndex
  locale: zhCn,
})

app.use(lyContainerWidgets)
app.use(lyFieldWidget)
app.use(lySettingPannel)
app.use(store)
app.use(router)
app.use(VueAxios,axios)
app.use(directivePlugin)
app.mount('#app')



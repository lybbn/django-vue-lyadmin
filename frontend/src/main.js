// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)
Vue.prototype.axios = axios
// 引入element UI
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import './assets/css/common.scss'

import "babel-polyfill";
import App from './App';
import 'xe-utils'
// 引入路由
import router from './router';
//富文本编辑器

import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'
import VueQuillEditor from 'vue-quill-editor'
Vue.use(VueQuillEditor)
import Quill from "quill"
import { ImageDrop } from 'quill-image-drop-module'
import ImageResize from 'quill-image-resize-module'
Quill.register('modules/imageDrop', ImageDrop)
Quill.register('modules/imageResize', ImageResize)

// 引入状态管理
import store from './vuex/store';
import {isShowBtn} from './utils/util'
Vue.prototype.isShowBtn = isShowBtn
// 引入icon
import VueClipboard from 'vue-clipboard2'
Vue.use(VueClipboard)
// 过滤器
import * as custom from './utils/util'
Vue.config.productionTip = false;
// 使用element UI
Vue.use(ElementUI);
import '@/utils/directive.js'
Object.keys(custom).forEach(key => {
  Vue.filter(key, custom[key])
})
let to={},from={}
/**
 * 路由拦截
 * 权限验证
 */
router.beforeEach((to, from, next) => {
  if (to.meta.requireAuth) { // 判断该路由是否需要登录权限
    let userId = sessionStorage.getItem('userId') ? sessionStorage.getItem('userId') : false
    if (userId) { // 通过vuex state获取当前的token是否存在
      let menuList = JSON.parse(sessionStorage.getItem('menuList'))
      if(menuList.filter(item=>item.url == to.name).length > 0 || (to.name =='buttonConfig' &&  menuList.filter(item=>item.url=='menuManage').length >0) || (to.name =='buttonManage' &&  menuList.filter(item=>item.url=='menuManage').length >0)) {
        next()
      } else {
        next({
          path: '/login'
        })
      }
    } else {
      // console.info("进入登陆")
        next({
          path: '/login'
        })
    }
  } else {
    next()
  }
})
const $vue=new Vue({
  router,
  store,
  render: h => h(App),
  data: {
    Bus: new Vue()
  }
}).$mount('#app')
export default  $vue

//进入xss
// import xss from 'xss'
// Object.defineProperty(Vue.prototype, '$xss', {
//   value: xss
// })

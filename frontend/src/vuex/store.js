import Vue from 'vue';
import Vuex from 'vuex';

//引入router

import router from '../router'

Vue.use(Vuex);
// Vue.use(router);


// 登录验证
export default new Vuex.Store({
    state: {
        user: false,
        //mutitabs
        tabsPage: sessionStorage.getItem('tabsPage')||[{"title":"管理员管理","name":"adminManage"}],//默认显示的页
        TabsValue: sessionStorage.getItem('TabsValue')||'adminManage',//默认选中显示的标签页
        //控制是否支持多选项卡
        isMultiTabs:true

    },
    mutations: {
        // 登录
        login(state, user) {
            state.user = user;
            sessionStorage.setItem("userInfo", user);
        },
        // 退出
        logout(state, user) {
            state.user = "";
            sessionStorage.setItem("userInfo", "");
        },
        //mutitabs
        editableTabs: (state, obj) => {
          // 浅拷贝 state.tabsPage
          const arr = Array.from(state.tabsPage)
          // 判断数组内是否为空
          if (arr.length !== 0) {
            // 使用 Array.some 去判断是否存在对象信息
            var even = function (obj) {
              return arr.some(item => {
                return item.name === obj.attributes.url
              })
            }
            // even方法 如果对象存在返回true,不存在则返回flase
            // 加！触发 true 代码块
            if (!even(obj)/* 如果不存在将对象push进数组内bing */) {
              // 将tabs所需参数push进arr数组
              arr.push({ title: obj.text, name: obj.attributes.url })
              // 赋值给tabsPage参数
              state.tabsPage = arr
              // 存储sessionStorage -- 解决刷新消失
              window.sessionStorage.setItem('tabsPage', JSON.stringify(arr))
              window.sessionStorage.setItem('TabsValue', obj.attributes.url)
              // 赋值给TabsValue参数
              state.TabsValue = obj.attributes.url
              // 跳转
              router.push({ name: obj.attributes.url })
            } else { // 如果存在 只做跳转选中
              // 赋值给TabsValue参数
              state.TabsValue = obj.attributes.url
              window.sessionStorage.setItem('TabsValue', obj.attributes.url)
              // 跳转
              router.push({ name: obj.attributes.url })
            }
          } else { // 如果为0
            // 将tabs所需参数push进arr数组
            arr.push({
              title: obj.text, name: obj.attributes.url
            })
            // 赋值给tabsPage参数
            state.tabsPage = arr
            // 赋值给TabsValue参数
            state.TabsValue = obj.attributes.url
            // 跳转
            router.push({ name: obj.attributes.url })
          }
        },
        //自定义右键菜单
        //自定义右键菜单
        //切换tab菜单
        switchtab(state,curContextTabName){
          state.TabsValue = curContextTabName
          router.push({ name: curContextTabName });
        },
        // 保存右键点击tab的id
        saveCurContextTabId(state, curContextTabId) {
          state.TabsValue = curContextTabId
        },
        // 关闭所有标签
        closeAllTabs(state) {
          state.tabsPage = [{"title":"管理员管理","name":"adminManage"}];
          router.push({ name: "adminManage"});
        },
        // 关闭其它标签页
        closeOtherTabs(state, par) {
          let tabs = state.tabsPage;
          let length = tabs.length;
          let curContextTabId = state.TabsValue;
          let id; // 右键点击时的tab在整个tabs数组中的id
          tabs.forEach((tab, index) => {
            if (tab.name == curContextTabId) {
                id = index
                return false
            }
          })
          if (par == "left") {
            if (id >= 0) {
                state.tabsPage = state.tabsPage.slice(id, length)
                sessionStorage.setItem('tabsPage', JSON.stringify(state.tabsPage))
            }
          }
          if (par == "right") {
            if (id >= 0) {
                state.tabsPage = state.tabsPage.slice(0, id + 1)
                sessionStorage.setItem('tabsPage', JSON.stringify(state.tabsPage))
            }
          }
          if (par == "other") {
              state.tabsPage = [tabs[id]]
              state.TabsValue = tabs[id].name
              sessionStorage.setItem('tabsPage', JSON.stringify(state.tabsPage))
              sessionStorage.setItem('TabsValue', state.TabsValue)
          }
        },
    },
    actions: {
        // 注册方法
        editableTabs(context, obj) {
            context.commit('editableTabs', obj)
        }
  }
})

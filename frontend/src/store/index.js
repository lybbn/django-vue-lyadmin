import { createStore } from 'vuex'
import router from '../router'

export default createStore({
    state: {
        keepAliveRoute:['server'],//希望缓存的页面name，如['server']
        userId: localStorage.getItem('userId') || '' ,
        logintoken:localStorage.getItem('logintoken')|| '',
        userName:localStorage.getItem('userName')|| '',
        refresh:localStorage.getItem('refresh')|| '',
        //mutitabs
        // tabsPage: sessionStorage.getItem('tabsPage')||[{"title":"管理员管理","name":"adminManage"}],//默认显示的页
        // TabsValue: sessionStorage.getItem('TabsValue')||'adminManage',//默认选中显示的标签页
        tabsPage: localStorage.getItem('tabsPage')||[],//默认显示的页
        TabsValue: localStorage.getItem('TabsValue')||'',//默认选中显示的标签页
        //控制是否支持多选项卡
        isMultiTabs:true,
        //控制主题:light正常模式、dark暗黑模式
        siteTheme:localStorage.getItem('siteTheme')?localStorage.getItem('siteTheme'):"light",
  },
    mutations: {
        setSiteTheme(state, val) {
            state.siteTheme = val;
            localStorage.siteTheme = val;
        },
        // 登录
        setUserId(state, val) {
            state.userId = val;
            localStorage.userId = val;
        },
        setLogintoken(state, val) {
            state.logintoken = val;
            localStorage.logintoken = val;
        },
        setUserName(state, val) {
            state.userName = val;
            localStorage.userName = val;
        },
        setRefresh(state, val) {
            state.refresh = val;
            localStorage.refresh = val;
        },
        // 退出
        logout(state, val) {
            state.userId = ''
            state.logintoken = ''
            state.userName = ''
            state.refresh = ''
            // state.tabsPage = [{"title":"管理员管理","name":"adminManage"}]
            // state.TabsValue = 'adminManage'
            state.tabsPage=[]
            state.TabsValue = ""

        },
        //首次登录第一个标签页获取
        firstTabs(state,datas){
            if(state.tabsPage.length==0){
                state.tabsPage=datas[0]
                localStorage.setItem("tabsPage", JSON.stringify(state.tabsPage))
            }
            if(state.TabsValue=="") {
                state.TabsValue = datas[1]
                localStorage.setItem("TabsValue", state.TabsValue)
            }

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
              // 存储localStorage -- 解决刷新消失
              localStorage.setItem('tabsPage', JSON.stringify(arr))
              localStorage.setItem('TabsValue', obj.attributes.url)
              // 赋值给TabsValue参数
              state.TabsValue = obj.attributes.url
              // 跳转
              router.push({ name: obj.attributes.url })
            } else { // 如果存在 只做跳转选中
              // 赋值给TabsValue参数
              state.TabsValue = obj.attributes.url
              localStorage.setItem('TabsValue', obj.attributes.url)
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
         //切换tab菜单(没有标签则重新创建)
        switchtab(state,curContextTabName){
            state.TabsValue = curContextTabName
            localStorage.setItem('TabsValue', curContextTabName)
            var arr = state.tabsPage
            if (Object.prototype.toString.call(arr) === '[object String]') {
                // 字符串需要转换
                arr = JSON.parse(arr);
            }
            if(!arr.some(item => item.name === curContextTabName)){
                var menuList = JSON.parse(localStorage.getItem('menuList'))
                var curContextTabObj = menuList.filter(item=>item.url === curContextTabName)
                if(curContextTabObj.length>0){
                    // 将tabs所需参数push进arr数组
                    arr.push({ title: curContextTabObj[0].moduleName, name: curContextTabName })
                    // 赋值给tabsPage参数
                    state.tabsPage = arr
                    // 存储localStorage -- 解决刷新消失
                    localStorage.setItem('tabsPage', JSON.stringify(arr))
                }
            }
            router.push({ name: curContextTabName });
        },
        //切换tab菜单(没有标签则重新创建)-只切换标签，不发送路由
        switchtabNoRoute(state,curContextTabName){
            if(state.TabsValue != curContextTabName){
                state.TabsValue = curContextTabName
                var arr = state.tabsPage
                if (Object.prototype.toString.call(arr) === '[object String]') {
                    // 字符串需要转换
                    arr = JSON.parse(arr);
                }
                if(!arr.some(item => item.name === curContextTabName)){
                    var menuList = localStorage.getItem('menuList')
                    if(menuList){
                        menuList = JSON.parse(localStorage.getItem('menuList'))
                        if(menuList.length>0){
                            var curContextTabObj = menuList.filter(item=>item.url === curContextTabName)
                            if(curContextTabObj.length>0){
                                // 将tabs所需参数push进arr数组
                                arr.push({ title: curContextTabObj[0].moduleName, name: curContextTabName })
                                // 赋值给tabsPage参数
                                state.tabsPage = arr
                                localStorage.setItem('TabsValue', curContextTabName)
                                // 存储localStorage -- 解决刷新消失
                                localStorage.setItem('tabsPage', JSON.stringify(arr))
                            }
                        }
                    }
                }
            }
        },
        //自定义右键菜单
        // 保存右键点击tab的id
        saveCurContextTabId(state, curContextTabId) {
          state.TabsValue = curContextTabId
        },
        // 关闭所有标签(只保留第一个标签页)
        closeAllTabs(state) {
            // let indextabarr = [{"title":"管理员管理","name":"adminManage"}]
            // state.tabsPage = indextabarr;
            // localStorage.setItem('tabsPage', JSON.stringify(indextabarr))
            // localStorage.setItem('TabsValue', "adminManage")
            // router.push({ name: "adminManage"});
            let tempstate = state.tabsPage
            state.tabsPage = [tempstate[0]]
            localStorage.setItem('tabsPage', JSON.stringify(state.tabsPage))
            localStorage.setItem('TabsValue', state.tabsPage[0].name)
            router.push({ name: state.tabsPage[0].name})
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
                localStorage.setItem('tabsPage', JSON.stringify(state.tabsPage))
            }
          }
          if (par == "right") {
            if (id >= 0) {
                state.tabsPage = state.tabsPage.slice(0, id + 1)
                localStorage.setItem('tabsPage', JSON.stringify(state.tabsPage))
            }
          }
          if (par == "other") {
              state.tabsPage = [tabs[id]]
              state.TabsValue = tabs[id].name
              localStorage.setItem('tabsPage', JSON.stringify(state.tabsPage))
              localStorage.setItem('TabsValue', state.TabsValue)
          }
        },
  },
    getters:{
       // 登录
      getUserId(state) {
          if(!state.userId){
            state.userId = localStorage.getItem('userId')
          }
          return state.userId
        },
      getLogintoken(state) {
          if(!state.logintoken){
            state.logintoken = localStorage.getItem('logintoken')
          }
          return state.logintoken
        },
      getUserName(state) {
          if(!state.userName){
            state.userName = localStorage.getItem('userName')
          }
          return state.userName
        },
      getRefresh(state) {
          if(!state.refresh){
            state.refresh = localStorage.getItem('refresh')
          }
          return state.refresh
        },
  },
    actions: {
     // 注册方法
      editableTabs(context, obj) {
          context.commit('editableTabs', obj)
      }
  },
    modules: {
  }
})

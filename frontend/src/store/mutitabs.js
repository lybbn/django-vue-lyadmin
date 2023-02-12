import { defineStore } from 'pinia'
import router from "../router";
import config from "@/config"
import {setStorage,getStorage} from '@/utils/util'

export const useMutitabsStore = defineStore('mutitabs', {
    state:() => {
        return {
            userId: getStorage('userId') || '' ,
            logintoken:getStorage('logintoken')|| '',
            userName:getStorage('userName')|| '',
            refresh:getStorage('refresh')|| '',
            //mutitabs
            // tabsPage: sessionStorage.getItem('tabsPage')||[{"title":"管理员管理","name":"adminManage"}],//默认显示的页
            // TabsValue: sessionStorage.getItem('TabsValue')||'adminManage',//默认选中显示的标签页
            tabsPage: getStorage('tabsPage')||[],//默认显示的页
            TabsValue: getStorage('TabsValue')||'',//默认选中显示的标签页
            //控制是否支持多选项卡
            isMultiTabs:config.ISMULTITABS,
            isFullscreen:false,//是否全屏
        }
    },
    getters:{
        // 登录
        getUserId(state) {
              if(!state.userId){
                  state.userId = getStorage('userId')
              }
              return state.userId
        },
        getLogintoken(state) {
              if(!state.logintoken){
                  state.logintoken = getStorage('logintoken')
              }
              return state.logintoken
        },
        getUserName(state) {
              if(!state.userName){
                    state.userName = getStorage('userName')
              }
            return state.userName
        },
        getRefresh(state) {
              if(!state.refresh){
                    state.refresh = getStorage('refresh')
              }
              return state.refresh
        },
    },
    actions: {
        // 登录
        setUserId(val) {
            this.userId = val;
            setStorage('userId',val)
        },
        setLogintoken(val) {
            this.logintoken = val;
            setStorage('logintoken',val)
        },
        setUserName(val) {
            this.userName = val;
            setStorage('userName',val)
        },
        setRefresh(val) {
            this.refresh = val;
            setStorage('refresh',val)
        },
        // 退出
        logout(val) {
            this.userId = ''
            this.logintoken = ''
            this.userName = ''
            this.refresh = ''
            // state.tabsPage = [{"title":"管理员管理","name":"adminManage"}]
            // state.TabsValue = 'adminManage'
            this.tabsPage=[]
            this.TabsValue = ""
            localStorage.clear()
            sessionStorage.clear()
        },
        //首次登录第一个标签页获取
        firstTabs(datas){
            if(this.tabsPage.length==0){
                this.tabsPage=datas[0]
                setStorage("tabsPage", JSON.stringify(this.tabsPage))
            }
            if(this.TabsValue=="") {
                this.TabsValue = datas[1]
                setStorage("TabsValue", this.TabsValue)
            }

        },
        //mutitabs
        editableTabs(obj){
          // 浅拷贝 state.tabsPage
          const arr = Array.from(this.tabsPage)
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
              this.tabsPage = arr
              // 存储localStorage -- 解决刷新消失
              setStorage('tabsPage', JSON.stringify(arr))
              setStorage('TabsValue', obj.attributes.url)
              // 赋值给TabsValue参数
              this.TabsValue = obj.attributes.url
              // 跳转
              router.push({ name: obj.attributes.url })
            } else { // 如果存在 只做跳转选中
              // 赋值给TabsValue参数
              this.TabsValue = obj.attributes.url
              setStorage('TabsValue', obj.attributes.url)
              // 跳转
              router.push({ name: obj.attributes.url })
            }
          } else { // 如果为0
            // 将tabs所需参数push进arr数组
            arr.push({
              title: obj.text, name: obj.attributes.url
            })
            // 赋值给tabsPage参数
            this.tabsPage = arr
            // 赋值给TabsValue参数
            this.TabsValue = obj.attributes.url
            // 跳转
            router.push({ name: obj.attributes.url })
          }
        },
         //切换tab菜单(没有标签则重新创建)
        switchtab(curContextTabName){
            this.TabsValue = curContextTabName
            setStorage('TabsValue', curContextTabName)
            var arr = this.tabsPage
            if (Object.prototype.toString.call(arr) === '[object String]') {
                // 字符串需要转换
                arr = JSON.parse(arr);
            }
            if(!arr.some(item => item.name === curContextTabName)){
                var menuList = JSON.parse(getStorage('menuList'))
                var curContextTabObj = menuList.filter(item=>item.url === curContextTabName)
                if(curContextTabObj.length>0){
                    // 将tabs所需参数push进arr数组
                    arr.push({ title: curContextTabObj[0].moduleName, name: curContextTabName })
                    // 赋值给tabsPage参数
                    this.tabsPage = arr
                    // 存储localStorage -- 解决刷新消失
                    setStorage('tabsPage', JSON.stringify(arr))
                }
            }
            router.push({ name: curContextTabName });
        },
        //切换tab菜单(没有标签则重新创建)-只切换标签，不发送路由
        switchtabNoRoute(curContextTabName){
            if(this.TabsValue != curContextTabName){
                this.TabsValue = curContextTabName
                var arr = this.tabsPage
                if (Object.prototype.toString.call(arr) === '[object String]') {
                    // 字符串需要转换
                    arr = JSON.parse(arr);
                }
                if(!arr.some(item => item.name === curContextTabName)){
                    var menuList = getStorage('menuList')
                    if(menuList){
                        menuList = JSON.parse(getStorage('menuList'))
                        if(menuList.length>0){
                            var curContextTabObj = menuList.filter(item=>item.url === curContextTabName)
                            if(curContextTabObj.length>0){
                                // 将tabs所需参数push进arr数组
                                arr.push({ title: curContextTabObj[0].moduleName, name: curContextTabName })
                                // 赋值给tabsPage参数
                                this.tabsPage = arr
                                setStorage('TabsValue', curContextTabName)
                                // 存储localStorage -- 解决刷新消失
                                setStorage('tabsPage', JSON.stringify(arr))
                            }
                        }
                    }
                }
            }
        },
        //自定义右键菜单
        // 保存右键点击tab的id
        saveCurContextTabId(curContextTabId) {
          this.TabsValue = curContextTabId
        },
        // 关闭所有标签(只保留第一个标签页)
        closeAllTabs(state) {
            // let indextabarr = [{"title":"管理员管理","name":"adminManage"}]
            // state.tabsPage = indextabarr;
            // localStorage.setItem('tabsPage', JSON.stringify(indextabarr))
            // localStorage.setItem('TabsValue', "adminManage")
            // router.push({ name: "adminManage"});
            let tempstate = this.tabsPage
            this.tabsPage = [tempstate[0]]
            setStorage('tabsPage', JSON.stringify(this.tabsPage))
            setStorage('TabsValue', this.tabsPage[0].name)
            router.push({ name: this.tabsPage[0].name})
        },
        // 关闭其它标签页
        closeOtherTabs(par) {
          let tabs = this.tabsPage;
          let length = tabs.length;
          let curContextTabId = this.TabsValue;
          let id; // 右键点击时的tab在整个tabs数组中的id
          tabs.forEach((tab, index) => {
            if (tab.name == curContextTabId) {
                id = index
                return false
            }
          })
          if (par == "left") {
            if (id >= 0) {
                this.tabsPage = this.tabsPage.slice(id, length)
                setStorage('tabsPage', JSON.stringify(this.tabsPage))
                this.checkTbasRouter()
            }
          }
          if (par == "right") {
            if (id >= 0) {
                this.tabsPage = this.tabsPage.slice(0, id + 1)
                setStorage('tabsPage', JSON.stringify(this.tabsPage))
                this.checkTbasRouter()
            }
          }
          if (par == "other") {
              this.tabsPage = [tabs[id]]
              this.TabsValue = tabs[id].name
              setStorage('tabsPage', JSON.stringify(this.tabsPage))
              setStorage('TabsValue', this.TabsValue)
              this.checkTbasRouter()
          }
        },
        //解决标签与路由不一致问题（检查标签栏当前选择与当前路由不同则路由跳转至改标签栏）
        checkTbasRouter(){
            if(router.currentRoute.value.name != this.TabsValue){
                router.push({ name: this.TabsValue})
            }
        }
    },
})
<template>
  <div class="myeltas1">
    <el-tabs class="myeltas2"
      v-model="editableTabsValue"
      type="card"
      closable
      @tab-remove="removeTab"
      @tab-click="tabClick($event)"
      @contextmenu.prevent.native="openContextMenu($event)">
      <template v-for="(item,index) in editableTabs" :key="index">
        <el-tab-pane :label="item.title" :name="item.name" v-if="index<100"></el-tab-pane>
      </template>
    </el-tabs>
    <transition name="el-zoom-in-top">
        <ul v-show="contextMenuVisible" :style="{left:left+'px',top:top+'px'}" class="contextmenu" id="lycontextmenu">
            <li @click="reloadPage"><el-icon><Refresh /></el-icon><span class="contextmenu-text">刷新</span></li>
            <li @click="closeAllTabs"><el-icon><CircleCloseFilled /></el-icon><span class="contextmenu-text">关闭所有</span></li>
            <li @click="closeOtherTabs('left')"><el-icon><Back /></el-icon><span class="contextmenu-text">关闭左边</span></li>
            <li @click="closeOtherTabs('right')"><el-icon><Right /></el-icon><span class="contextmenu-text">关闭右边</span></li>
            <li @click="closeOtherTabs('other')"><el-icon><Delete /></el-icon><span class="contextmenu-text">关闭其他</span></li>
            <li @click="maximize"><el-icon><FullScreen /></el-icon><span class="contextmenu-text">最大化</span></li>
            <li @click="openWindow"><el-icon><CopyDocument /></el-icon><span class="contextmenu-text">新窗口打开</span></li>
            <li @click="closeContextMenu()"><el-icon><Close /></el-icon><span class="contextmenu-text">取消操作</span></li>
        </ul>
    </transition>
      <router-view v-slot="{Component,route}">
<!--              <component :is="Component" v-if="!route.meta.isActive" :key="route.path"></component>-->
<!--          <transition name="lyfadein" mode="out-in">-->
          <keep-alive :include="keepAliveRoutes" :exclude="excludes">
              <component :is="Component" :key="route.name" v-if="!isRourterAlive" ref="lyComponent"></component>
          </keep-alive>
<!--          </transition>-->
      </router-view>
      <div class="lymain-maximize-exit" @click="exitMaximize"><el-icon><close /></el-icon></div>
  </div>
</template>

<script>
    import {useKeepAliveStore} from "@/store/keepAlive";
    import {useMutitabsStore} from "@/store/mutitabs";
    import {useSiteThemeStore} from "@/store/siteTheme";
    import {setStorage,getStorage} from '@/utils/util'

    export default {
        name: "mutitabs",
        components: {},
        setup() {
            const keepAliveStore = useKeepAliveStore()
            const mutitabsstore = useMutitabsStore()
            const siteThemeStore = useSiteThemeStore()
            return { keepAliveStore,mutitabsstore,siteThemeStore}
        },
        data() {
            return {
                //右键自定义菜单
                contextMenuVisible:false,
                left:0,
                top:0,
                //刷新当前页
                isRourterAlive:false,
                excludes:"",
            };
        },
        mounted() {
            document.addEventListener("click", (e) => {
              let that = this
              if (e.target.className !="myeltas2") {
                that.contextMenuVisible = false; //点击其他区域关闭右键菜单
              }
            });
            //刷新加载localStorage存着地址
            let lytabsPage = getStorage("tabsPage")
            if (lytabsPage) {
                var TabsValue = getStorage("TabsValue");
                if (lytabsPage === "[]"||lytabsPage==""||lytabsPage==null || TabsValue === 'login') {
                    this.relogin()//重新登录
                }
                this.mutitabsstore.tabsPage = JSON.parse(lytabsPage);
                const currentRouteName = this.$route.name
                const currentRouteQuery = this.$route.query
                if(currentRouteName == 'login' || currentRouteName == 'root'){
                    this.mutitabsstore.TabsValue = TabsValue;
                    this.$router.push({ name: TabsValue })
                }else{
                    this.mutitabsstore.switchtabNoRoute(currentRouteName,currentRouteQuery)
                }
            }else{
                this.relogin()//重新登录
            }
        },
        computed: {
            // 监听vuex保存的数据
            editableTabs: {
                get() {
                    return this.mutitabsstore.tabsPage;
                },
                set(val) {
                    this.mutitabsstore.tabsPage = val;
                },
            },
            editableTabsValue: {
                get() {
                    return this.mutitabsstore.TabsValue;
                },
                set(val) {
                    this.mutitabsstore.TabsValue = val;
                },
            },
            keepAliveRoutes(){
                return this.keepAliveStore.keepAliveRoute
            }
        },
        methods: {
            //退出最大化
			exitMaximize(){
				document.getElementById('app').classList.remove('lymain-maximize')
                if(this.$refs.lyComponent.setFull){
                    this.$refs.lyComponent.setFull()
                }
			},
            relogin(){
                this.mutitabsstore.logout('false')
                this.siteThemeStore.setSiteTheme('light')
                sessionStorage.clear()
                localStorage.clear()
                this.$message.warning('请重新登录!')
                this.$router.push({path: '/login'})
            },
            removeTab(targetName) {
                let tabs = this.editableTabs;
                let activeName = this.editableTabsValue;
                //只有一个标签不允许关闭
                if(tabs.length === 1){
                    return
                }
                if (activeName === targetName) {
                    tabs.forEach((tab, index) => {
                        if (tab.name === targetName) {
                            let nextTab = tabs[index + 1] || tabs[index - 1];
                            // console.log(nextTab);
                            if (nextTab) {
                                activeName = nextTab.name;
                            }
                        }
                });
                }
                this.editableTabsValue = activeName;
                this.editableTabs = tabs.filter((tab) => tab.name !== targetName);
                this.mutitabsstore.tabsPage = this.editableTabs;
                setStorage("tabsPage",JSON.stringify(this.editableTabs));
                //解决刷新消失
                setStorage("TabsValue", activeName);
                var thetabsPage = getStorage("tabsPage")
                // 删除时跳转不在停留被删除页
                if (thetabsPage === "[]"||thetabsPage==""||thetabsPage==null) {
                    this.relogin()
                } else {
                    this.$router.push({ name: activeName });
                }
            },
            tabClick(event) {
                //关闭自定义菜单
                this.closeContextMenu()
                //写一个点击tabs跳转
                this.mutitabsstore.switchtab(event.props.name)
            },
            //自定义菜单
            openContextMenu(e) {
                var obj =  e.srcElement ? e.srcElement : e.target;
                if (obj.id) {
                    let currentContextTabId = obj.id.split("-")[1];
                    this.contextMenuVisible = true;
                    this.mutitabsstore.saveCurContextTabId(currentContextTabId);
                    this.left = e.clientX + 1;
                    this.top = e.clientY + 1;
                    //右键菜单边缘化位置处理（防止在最边缘右键右健菜单消失部分）
                    this.$nextTick(() => {
                        let ct = document.getElementById("lycontextmenu");
                        if(document.body.offsetWidth - e.clientX < ct.offsetWidth){
                            this.left = document.body.offsetWidth - ct.offsetWidth - 1;
                            this.top = e.clientY + 1;
                        }
                    })
                }
            },
            reloadPage(){
                this.contextMenuVisible = false
                const currentRoute = this.$router.currentRoute.value;
                currentRoute.matched.forEach((r)=> {
                    if (r.path === currentRoute.fullPath) {
                        //获取到当前页面的name
                        const comName = r.components.default.name!= undefined?r.components.default.name:r.components.default.__name;
                        if (comName != undefined) {
                            this.excludes = comName
                            this.isRourterAlive = true
                        }
                    }
                })
                this.$nextTick(() => {
                    this.isRourterAlive = false
                    this.excludes = ""
                })
            },
            //标签页最大化
            maximize(){
				var TabsValue = this.mutitabsstore.TabsValue
				this.contextMenuVisible = false
				//判断是否当前路由，否的话跳转
				if(this.$route.name != TabsValue){
					this.$router.push({
						name: TabsValue,
					})
				}
				document.getElementById('app').classList.add('lymain-maximize')
                if(this.$refs.lyComponent.setFull){
                    this.$refs.lyComponent.setFull()
                }
			},
            //新窗口打开
			openWindow(){
				let currentPath = this.mutitabsstore.TabsValue
                let routeData = this.$router.resolve({path:currentPath})
                window.open(routeData.href,'_blank')
				this.contextMenuVisible = false
			},
            // 关闭所有标签页
            closeAllTabs() {
                this.mutitabsstore.closeAllTabs()
                this.contextMenuVisible = false;
            },
            // 关闭其它标签页
            closeOtherTabs(par) {
                this.mutitabsstore.closeOtherTabs(par);
                this.contextMenuVisible = false;
            },
            // 关闭contextMenu
            closeContextMenu() {
                this.contextMenuVisible = false;
            },
        },
    };
</script>
<style>
    .myeltas2 .el-tabs__nav .el-tabs__item.is-active {
        color: var(--el-color-primary);
        /*background-color: var(--l-changetab-bg);*/
        background-color: var(--l-main-sidebar-menu-active-bg)!important;
        border-bottom: none;
        /*border-bottom-color: var(--l-changetab-border);*/
        /*box-shadow: 0 0 5px #cccccc;*/
        box-shadow: 0 0 3px rgba(0, 0, 0, .12);
    }
    .myeltas2 .el-tabs__nav-wrap{
        background: var(--l-changetab-bg);
        border-color: transparent;
        /*box-shadow: 0 0 3px #cccccc;*/
        box-shadow: 0 0 3px rgba(0, 0, 0, .12);
    }
    /*去除顶部线*/
    .myeltas2 .el-tabs__header {
        /*border: none;*/
        margin: 0;
        border-bottom :none;
    }
    .myeltas2 .el-tabs__nav{
        /*background-color: lightgrey;*/
        background-color: var(--l-changetab-bg);
        /*border: none !important;*/
        border-radius:0 !important;
    }
    /*字体大小*/
    .myeltas2  .el-tabs__item{
        font-size: 13px;
        color: #808695;
        height: 30px;
        line-height: 30px;
        padding: 0 15px;
    }
    /*标签左右箭头*/
    .myeltas2 .el-tabs__nav-next, .el-tabs__nav-prev {
        line-height: 35px;
        font-size: 17px;
    }
    /*自定义右键菜单*/
    .contextmenu {
        width: 130px;
        margin: 0;
        border: 1px solid #ccc;
        background: var(--l-changetab-right-menu);
        z-index: 3000;
        position: absolute;
        list-style-type: none;
        padding: 5px 0;
        border-radius: 4px;
        font-size: 14px;
        box-shadow: 1px 1px 3px 0 #cccccc;
    }
    .contextmenu li {
        margin: 0;
        padding: 9px 16px;
        display: flex;
        align-items: center;
    }
    .contextmenu li:hover {
        background: var(--l-changetab-right-menu-hover-bg);
        cursor: pointer;
        color: var(--el-color-primary);
    }
    .contextmenu-text{
        margin-left: 5px;
    }
    .lyfadein-enter-from {
        transform: translateX(-0.5%);
    }

    .lyfadein-leave-from {
        transform: translateX(0);
    }
    .lyfadein-leave-to {
        transform: translateX(0.5%);
        opacity: 0.1;
    }

    .lyfadein-enter-active{
        transition: all 0.4s;
    }
    .lyfadein-leave-active{
        transition: all 0.3s;
    }

    .lyfadein-enter-to {
        transform: translateX(0);
    }

</style>
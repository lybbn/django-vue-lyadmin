<template>
  <div class="myeltas1">
    <el-tabs class="myeltas2"
      v-model="editableTabsValue"
      type="card"
      closable
      @tab-remove="removeTab"
      @tab-click="tabClick($event)"
      @contextmenu.prevent.native="openContextMenu($event)">
      <el-tab-pane
        :key="item.name"
        v-for="item in editableTabs"
        :label="item.title"
        :name="item.name"></el-tab-pane>
    </el-tabs>
    <ul
    v-show="contextMenuVisible"
    :style="{left:left+'px',top:top+'px'}"
    class="contextmenu">
        <li @click="reloadPage"><el-icon><Refresh /></el-icon><span class="contextmenu-text">刷新</span></li>
        <li @click="closeAllTabs"><el-icon><CircleCloseFilled /></el-icon><span class="contextmenu-text">关闭所有</span></li>
        <li @click="closeOtherTabs('left')"><el-icon><Back /></el-icon><span class="contextmenu-text">关闭左边</span></li>
        <li @click="closeOtherTabs('right')"><el-icon><Right /></el-icon><span class="contextmenu-text">关闭右边</span></li>
        <li @click="closeOtherTabs('other')"><el-icon><Delete /></el-icon><span class="contextmenu-text">关闭其他</span></li>
        <li @click="closeContextMenu()"><el-icon><Close /></el-icon><span class="contextmenu-text">取消操作</span></li>
    </ul>
      <router-view v-slot="{Component,route}">
<!--              <component :is="Component" v-if="!route.meta.isActive" :key="route.path"></component>-->
          <transition name="lyfadein" mode="out-in">
              <keep-alive :include="keepAliveRoutes" :exclude="excludes">
                    <component :is="Component" :key="route.name" v-if="!isRourterAlive"></component>
              </keep-alive>
          </transition>
      </router-view>
  </div>
</template>

<script>
export default {
    name: "mutitabs",
    components: {},
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
          if (e.target.className !="myeltas1") {
            that.contextMenuVisible = false; //点击其他区域关闭右键菜单
          }
        });
        //刷新加载localStorage存着地址
        let lytabsPage = localStorage.getItem("tabsPage")
        if (lytabsPage) {
            this.$store.state.tabsPage = JSON.parse(lytabsPage);
            var TabsValue = localStorage.getItem("TabsValue");
            this.$store.state.TabsValue = TabsValue;
            if (lytabsPage === "[]"||lytabsPage==""||lytabsPage==null || TabsValue === 'login') {
                this.relogin()//重新登录
            } else {
                this.$router.push({ name: TabsValue });
            }
        }else{
            this.relogin()//重新登录
        }
    },
    computed: {
        // 监听vuex保存的数据
        editableTabs: {
            get() {
                return this.$store.state.tabsPage;
            },
            set(val) {
                this.$store.state.tabsPage = val;
            },
        },
        editableTabsValue: {
            get() {
                return this.$store.state.TabsValue;
            },
            set(val) {
                this.$store.state.TabsValue = val;
            },
        },
        keepAliveRoutes(){
            return this.$store.state.keepAliveRoute
        }
    },
    methods: {
        relogin(){
            this.$store.commit('logout', 'false')
            this.$store.commit("setSiteTheme",'light')
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
            this.$store.state.tabsPage = this.editableTabs;
            window.localStorage.setItem("tabsPage",JSON.stringify(this.editableTabs));
            //解决刷新消失
            window.localStorage.setItem("TabsValue", activeName);
            var thetabsPage = localStorage.getItem("tabsPage")
            // 删除时跳转不在停留被删除页
            if (thetabsPage === "[]"||thetabsPage==""||thetabsPage==null) {
                this.$router.push({ name: "login"});
            } else {
                this.$router.push({ name: activeName });
            }
        },
        tabClick(event) {
            //关闭自定义菜单
            this.closeContextMenu()
            //写一个点击tabs跳转
            this.$store.commit("switchtab",event.props.name)
        },
        //自定义菜单
        openContextMenu(e) {
            var obj =  e.srcElement ? e.srcElement : e.target;
            if (obj.id) {
                let currentContextTabId = obj.id.split("-")[1];
                this.contextMenuVisible = true;
                this.$store.commit("saveCurContextTabId", currentContextTabId);
                this.left = e.clientX;
                this.top = e.clientY + 13;
            }
        },
        reloadPage(){
            this.contextMenuVisible = false
            const currentRoute = this.$router.currentRoute.value;
            currentRoute.matched.forEach((r)=> {
                if (r.path === currentRoute.fullPath) {
                    //获取到当前页面的name
                    const comName = r.components.default.name;
                    if (comName != undefined) {
                        this.excludes = comName
                        this.isRourterAlive = true
                    }
                }
            })
            // this.isRourterAlive = true
            // this.contextMenuVisible = false
            this.$nextTick(() => {
                this.isRourterAlive = false
                this.excludes = ""
            })
        },
        // 关闭所有标签页
        closeAllTabs() {
            this.$store.commit("closeAllTabs");
            this.contextMenuVisible = false;
        },
        // 关闭其它标签页
        closeOtherTabs(par) {
            this.$store.commit("closeOtherTabs", par);
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
        color: #46a0fc;
        background-color: var(--l-changetab-bg);
        border-bottom-color: var(--l-changetab-border);
        box-shadow: 0 0 5px #cccccc;
    }
    .myeltas2 .el-tabs__nav-wrap{
        background: var(--l-changetab-bg);
        border-color: transparent;
        box-shadow: 0 0 3px #cccccc;
    }
    /*去除顶部线*/
    .myeltas2 .el-tabs__header {
        /*border: none;*/
        margin: 0 0 2px;
        border-bottom :none;
    }
    .myeltas2 .el-tabs__nav{
        /*background-color: lightgrey;*/
        background-color: var(--l-changetab-bg);
        border: none;
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
        width: 110px;
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
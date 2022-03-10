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
        <li @click="closeAllTabs">关闭所有</li>
        <li @click="closeOtherTabs('left')">关闭左边</li>
        <li @click="closeOtherTabs('right')">关闭右边</li>
        <li @click="closeOtherTabs('other')">关闭其他</li>
        <li @click="closeContextMenu()">取消操作</li>
      </ul>
    <keep-alive>
      <router-view v-if="$route.meta.isActive"></router-view>
    </keep-alive>
      <router-view v-if="!$route.meta.isActive"></router-view>
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
    };
  },
  mounted() {
    //刷新加载sessionStorage存着地址
    if (sessionStorage.getItem("tabsPage")) {
      this.$store.state.tabsPage = JSON.parse(
        sessionStorage.getItem("tabsPage")
      );
      var TabsValue = sessionStorage.getItem("TabsValue");
      this.$store.state.TabsValue = TabsValue;
      if (sessionStorage.getItem("tabsPage") === "[]") {
        this.$router.push({ name: "adminManage"});//默认首页
      } else {
        this.$router.push({ name: TabsValue });
      }
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
  },
  methods: {
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
      window.sessionStorage.tabsPage = JSON.stringify(this.editableTabs);
      //解决刷新消失
      window.sessionStorage.setItem("TabsValue", activeName);
      // 删除时跳转不在停留被删除页
      if (sessionStorage.getItem("tabsPage") === "[]") {
        this.$router.push({ name: "adminManage"});
      } else {
        this.$router.push({ name: activeName });
      }
    },
    tabClick(event) {
        //关闭自定义菜单
        this.closeContextMenu()
        //写一个点击tabs跳转
        this.$store.commit("switchtab",event.name)
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
    background-color: #fff;
    border-bottom-color: #fff;
    box-shadow: 0 0 10px #cccccc;
  }
  /*去除顶部线*/
  .myeltas2 .el-tabs__header {
    /*border: none;*/
    margin: 0 0 8px;
  }
  .myeltas2 .el-tabs__nav{
    /*background-color: lightgrey;*/
    background-color: white;
    border: none;
  }
  /*字体大小*/
  .myeltas2  .el-tabs__item{
    font-size: 13px;
    color: #808695;
    height: 30px;
    line-height: 30px;
    padding: 0 15px;
  }
  /*自定义右键菜单*/
  .contextmenu {
    width: 100px;
    margin: 0;
    border: 1px solid #ccc;
    background: #fff;
    z-index: 3000;
    position: absolute;
    list-style-type: none;
    padding: 5px 0;
    border-radius: 4px;
    font-size: 14px;
    color: #333;
    box-shadow: 2px 2px 3px 0 rgba(0, 0, 0, 0.2);
  }
  .contextmenu li {
    margin: 0;
    padding: 7px 16px;
  }
  .contextmenu li:hover {
    background: #f2f2f2;
    cursor: pointer;
  }

</style>
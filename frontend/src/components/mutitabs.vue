<template>
  <div class="myeltas1">
    <el-tabs class="myeltas2"
      v-model="editableTabsValue"
      type="card"
      closable
      @tab-remove="removeTab"
      @tab-click="tabClick($event)">
      <el-tab-pane
        :key="item.name"
        v-for="item in editableTabs"
        :label="item.title"
        :name="item.name"></el-tab-pane>
    </el-tabs>
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
    return {};
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
      //写一个点击tabs跳转
      this.$router.push({ name: event.name });
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
    border: none;
    margin: 0 0 5px;
  }
  .myeltas2 .el-tabs__nav{
    /*background-color: lightgrey;*/
    background-color: white;
  }


</style>
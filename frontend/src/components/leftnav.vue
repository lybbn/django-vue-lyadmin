/**
* 左边菜单
*/
<template>
<!--  background-color="#304156"-->
<!--    active-background-color="#304156"-->
  <div>
    <el-menu
      :default-active="$route.meta.index"
      :collapse="collapsed"
      collapse-transition
      router
      unique-opened
      class="el-menu-vertical-demo"
      background-color="var(--l-header-bg)"
      active-background-color="var(--l-header-bg)"
      text-color="#ffffff"
      active-text-color="#247af3">
      <div v-if="menuTitle" class="menu-nav-title">
        {{menuTitle}}
      </div>
      <div v-for="menu in allmenu" :key="menu.id">
        <el-sub-menu v-if="menu.hasChildren" :index="'/'+menu.attributes.url" :key="menu.id">
          <template #title >
            <el-icon v-if="menu.attributes.icon!=''">
                <component :is="menu.attributes.icon" />
            </el-icon>
            <span>{{menu.text}}</span>
          </template>
          <el-menu-item-group  v-if="menu.hasChildren">
            <div v-for="chmenu in menu.children">
              <el-menu-item
                v-if="!chmenu.hasChildren"
                :index="'/'+chmenu.attributes.url"
                :key="chmenu.id"
                @click="handleOpen2(chmenu)">
                <el-icon>
                  <component :is="chmenu.attributes.icon?chmenu.attributes.icon:'Menu'" />
                </el-icon>
                {{chmenu.text}}
              </el-menu-item>
              <el-sub-menu v-else :index="'/'+chmenu.attributes.url">
                <template #title>
                  <el-icon v-if="chmenu.attributes.icon!=''">
                    <component :is="chmenu.attributes.icon" />
                  </el-icon>
                  <span>{{chmenu.text}}</span>
                </template>
                <el-menu-item
                  v-for="cchmenu in chmenu.children"
                  :index="'/'+cchmenu.attributes.url"
                  :key="cchmenu.id"
                  @click="handleOpen2(cchmenu)">
                  <el-icon v-if="cchmenu.attributes.icon!=''">
                    <component :is="cchmenu.attributes.icon" />
                  </el-icon>
                  {{cchmenu.text}}
                </el-menu-item>
              </el-sub-menu>
            </div>
          </el-menu-item-group>
        </el-sub-menu>
        <el-menu-item  v-else :index="'/'+menu.attributes.url" :key="menu.id" @click="handleOpen2(menu)">
          <el-icon v-if="menu.attributes.icon!=''">
            <component :is="menu.attributes.icon" />
          </el-icon>
          <template #title>{{menu.text}}</template>
        </el-menu-item>
      </div>
    </el-menu>
  </div>
</template>
<script>
import {systemTree} from "@/utils/menuTree.js"
import {routerTree} from "@/router/index.js"
import { uniqueId } from 'lodash'
import {apiSystemWebRouter} from '@/api/api'
import XEUtils from 'xe-utils'
import { mapActions } from "vuex";
import store from "../store";
export default {
  name: "leftnav",
  data() {
    return {
      collapsed: false,
      allmenu: [],
      menuTitle:'',
    };
  },
  watch: {
    $route(to, from) {
      if(store.getters.getLogintoken) {
        // this.$forceUpdate()
        this.getMenu()
      }
    }
  },
  created() {
    let userId = store.getters.getUserId
    let params = {
      userId: userId
    };
    this.getMenu()
    this.$Bus.on("toggle", value => {
      this.collapsed = !value;
    });
  },
  methods: {
    getMenu() {
      this.menuTitle=''
      this.allmenu=[]

      //动态加载菜单
      this.allmenu = JSON.parse(localStorage.getItem('allmenu'))
      //加载menutree文件的静态菜单，启用动态后这一段要注释掉
      //this.allmenu = systemTree
      // this.$forceUpdate()
    },
    supplementPath (menu) {
      return menu.map(e => ({
        ...e,
        path: e.path || uniqueId('ly-menu-empty-'),
        ...e.children ? {
          children: this.supplementPath(e.children)
        } : {}
      }))
    },
    // 调用 注册vuex内注册的editableTabs方法
    ...mapActions({
      handleOpen2: "editableTabs",
    }),
  }
};
</script>
<style lang="scss" scoped>
.el-menu.el-menu--horizontal{
  border-bottom: 0;
}
.menu-nav-title{
  height: 56px;
  line-height: 56px;
  padding-left: 20px;
  font-size: 20px;
  font-weight: bold;
  background: #eff6ff;
  color: #247af3;
  border-bottom: 1px solid #c9e0ff;
}
.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 100%;
  min-height: 400px;
}
.el-menu-vertical-demo{
  i{
    margin-right: 5px;
    font-size: 18px;
  }
}

.el-menu-vertical-demo:not(.el-menu--collapse) {
  border: none;
  text-align: left;
}

::v-deep(.el-menu-item-group__title) {
  padding: 0px !important;
}
.el-menu-item.is-active {
  position: relative;
  background-color: rgb(48, 54, 62) !important;
  &:before{
    width: 2px;
    height: 100%;
    position: absolute;
    left: 0;
    top: 0;
    background: var(--l-main-sidebar-menu-hover-bg);
    display: block;
  }
}
.el-menu-bg {
  background-color: #1f2d3d !important;
}

.el-menu {
  border: none;
  overflow: hidden;

}

.logobox {
  height: 40px;
  line-height: 40px;
  color: #9d9d9d;
  font-size: 20px;
  text-align: center;
  padding: 10px 0px;
}

.logoimg {
  /*height: 40px;*/
}
.router-link-active{
  color: #ffd04b;
}
.aside span{
  display: none;
}
.el-menu--collapse{
    ::v-deep(.el-sub-menu__icon-arrow){
      display: none !important;
    }
}
.el-sub-menu{
  /*width: 180px;*/
  width:100%
}
</style>

/**
* 左边菜单
*/
<template>
<!--  background-color="#304156"-->
<!--    active-background-color="#304156"-->
  <el-menu
    :default-active="$route.meta.index"
    :collapse="collapsed"
    collapse-transition
    router
    unique-opened
    class="el-menu-vertical-demo"
    background-color="#3C444D"
    active-background-color="#3C444D"
    text-color="#ffffff"
    active-text-color="#247af3">
    <div v-if="menuTitle" class="menu-nav-title">
      {{menuTitle}}
    </div>
    <div v-for="menu in allmenu">
      <el-submenu v-if="menu.hasChildren" :index="menu.text" :key="menu.id">
        <template slot="title" >
          <i class="iconfont" :class="menu.attributes.icon?menu.attributes.icon:'el-icon-menu'"></i>
          <span slot="title">{{menu.text}}</span>
        </template>
        <el-menu-item-group  v-if="menu.hasChildren">
          <el-menu-item
            v-for="chmenu in menu.children"
            :index="'/'+chmenu.attributes.url"
            :key="chmenu.id"
            @click="handleOpen2(chmenu)"
          >
            <i class="iconfont" :class="chmenu.attributes.icon?chmenu.attributes.icon:'el-icon-menu'"></i>
            <span slot="title">{{chmenu.text}}</span>
          </el-menu-item>
        </el-menu-item-group>
      </el-submenu>
      <el-menu-item  v-else :index="'/'+menu.attributes.url" :key="menu.id" @click="handleOpen2(menu)">
        <i class="iconfont" :class="menu.attributes.icon?menu.attributes.icon:'el-icon-menu'"></i>
        <span slot="title">{{menu.text}}</span>
      </el-menu-item>
    </div>
  </el-menu>
</template>
<script>
import {systemTree} from "@/utils/menuTree.js"
import {routerTree} from "@/router/index.js"
import { uniqueId } from 'lodash'
import {apiSystemWebRouter} from '@/api/api'
import XEUtils from 'xe-utils'
import { mapActions } from "vuex";
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
      if(sessionStorage.getItem('logintoken')) {
        this.$forceUpdate()
        this.getMenu()
      }
    }
  },
  created() {
    let userId = sessionStorage.getItem("userId")
    let params = {
      userId: userId
    };
    this.getMenu()
    this.$root.Bus.$on("toggle", value => {
      this.collapsed = !value;
    });
  },
  methods: {
    getMenu() {
      this.menuTitle=''
      this.allmenu=[]

      // apiSystemWebRouter().then(res=>{
      //   if(res.code == 2000) {
      //     let menuTree = []
      //     if(res.data.data.length > 0) {
      //       let childrenList = res.data.data.filter(item=> item.parent)
      //       let parentList = res.data.data.filter(item=> !item.parent)
      //       if(parentList.length >0) {
      //         parentList.forEach(item=>{
      //           let menuTreeChildren=[]
      //           let children = childrenList.filter(itema=>itema.parent == item.id)
      //           children.forEach(itemb=>{
      //             menuTreeChildren.push(({
      //               text:itemb.name,
      //               id:itemb.id,
      //               attributes:{
      //                 url:itemb.web_path,
      //                 icon:itemb.icon
      //               },
      //               hasChildren: false,
      //               hasParent:true
      //             }))
      //           })
      //           menuTree.push({
      //             text:item.name,
      //             id:item.id,
      //             attributes:{
      //               url:item.web_path,
      //               icon:item.icon
      //             },
      //             hasChildren: children.length >0,
      //             hasParent:false,
      //             children:menuTreeChildren,
      //           })
      //           item.children=[...children]
      //         })
      //       }
      //     }
      //     this.allmenu =  menuTree
      //     // this.allmenu =  systemTree
      //     //console.log(this.allmenu,'this.allmenu')
      //     sessionStorage.setItem('allmenu', JSON.stringify(this.allmenu))
      //     this.$forceUpdate()
      //   } else {
      //     this.$message.warning(res.msg)
      //   }
      // })

      //动态加载菜单
      this.allmenu = JSON.parse(sessionStorage.getItem('allmenu'))
      //加载menutree文件的静态菜单，启用动态后这一段要注释掉
      //this.allmenu = systemTree
      this.$forceUpdate()
    },
    supplementPath (menu) {
      return menu.map(e => ({
        ...e,
        path: e.path || uniqueId('d2-menu-empty-'),
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
<style lang="scss">
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

.el-menu-item-group__title {
  padding: 0px;
}
.el-menu-item.is-active {
  /*background: #3C444D !important;*/
  position: relative;
  border-left: 2px solid rgb(36, 122, 243);
  background-color: rgb(48, 54, 62) !important;
  &:before{
    width: 2px;
    height: 100%;
    position: absolute;
    left: 0;
    top: 0;
    background: #247af3;
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
  height: 40px;
}
.router-link-active{
  color: #ffd04b;
}
.aside .el-submenu__icon-arrow,.aside span{
  display: none;
}
.el-submenu{
  /*width: 180px;*/
  width:100%
}
</style>

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
      text-color="#ffffff"
      active-text-color="var(--el-color-primary)">
      <div v-if="menuTitle" class="menu-nav-title">
        {{menuTitle}}
      </div>
      <div v-for="menu in allmenu" :key="menu.id">
        <el-sub-menu v-if="menu.hasChildren" :index="menu.attributes.url?'/'+menu.attributes.url:menu.id" :key="menu.id">
          <template #title >
            <el-icon>
              <component :is="menu.attributes.icon?menu.attributes.icon:'Menu'" />
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
                <template #title >
                  <span>{{chmenu.text}}</span>
                </template>
              </el-menu-item>
              <el-sub-menu v-else :index="chmenu.attributes.url?'/'+chmenu.attributes.url:chmenu.id">
                <template #title>
                  <el-icon>
                    <component :is="chmenu.attributes.icon?chmenu.attributes.icon:'Menu'" />
                  </el-icon>
                  <span>{{chmenu.text}}</span>
                </template>
                <el-menu-item
                  v-for="cchmenu in chmenu.children"
                  :index="cchmenu.attributes.url?'/'+cchmenu.attributes.url:cchmenu.id"
                  :key="cchmenu.id"
                  @click="handleOpen2(cchmenu)">
                  <el-icon>
                    <component :is="cchmenu.attributes.icon?cchmenu.attributes.icon:'Menu'" />
                  </el-icon>
                  <template #title>
                    <span>{{cchmenu.text}}</span>
                  </template>
                </el-menu-item>
              </el-sub-menu>
            </div>
          </el-menu-item-group>
        </el-sub-menu>
        <el-menu-item  v-else :index="'/'+menu.attributes.url" :key="menu.id" @click="handleOpen2(menu)">
          <el-icon>
            <component :is="menu.attributes.icon?menu.attributes.icon:'Menu'" />
          </el-icon>
          <template #title>
            <span>{{menu.text}}</span>
          </template>
        </el-menu-item>
      </div>
    </el-menu>
  </div>
</template>
<script setup>
    import {ref, onMounted,watch,getCurrentInstance} from 'vue'
    import XEUtils from 'xe-utils'
    import {useMutitabsStore} from "@/store/mutitabs";
    import { useRouter,useRoute,onBeforeRouteUpdate } from 'vue-router';
    import {setStorage,getStorage} from '@/utils/util'

    let bus = getCurrentInstance().appContext.config.globalProperties.$Bus; // 声明$Bus
    const mutitabsStore = useMutitabsStore()
    let collapsed = ref(false)
    let allmenu = ref([])
    let menuTitle = ref("")

    function handleOpen2(obj){
        mutitabsStore.editableTabs(obj)
    }

    function getMenu() {
        menuTitle.value=''
        allmenu.value=[]

        //动态加载菜单
        allmenu.value = JSON.parse(getStorage('allmenu'))
    }

    onMounted(()=>{
        let userId = mutitabsStore.userId
        let params = {
            userId: userId
        };
        getMenu()
        bus.on("toggle", value => {
            collapsed.value = !value;
        });
        bus.on("routeReload", value => {
            getMenu()
        });
    })
    onBeforeRouteUpdate(to=>{
        // if(mutitabsStore.logintoken) {
        //     getMenu()
        // }
        mutitabsStore.switchtabNoRoute(to.name,to.query)
    })
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
  color: var(--el-color-primary);
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
  /*background-color: rgb(48, 54, 62) !important;*/
  background-color: var(--l-main-sidebar-menu-active-bg) !important;
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

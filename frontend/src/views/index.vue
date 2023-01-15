<template>
  <el-container class="index-con">
    <el-header class="index-header lyadmin-header">
      <navcon></navcon>
    </el-header>
    <el-container class="main-con">
      <el-aside :class="showclass" class="lyadmin-side">
        <el-scrollbar>
          <leftnav ></leftnav>
        </el-scrollbar>
      </el-aside>
      <el-main class="index-main" v-if="isMultiTabs">
        <mutitabs></mutitabs>
      </el-main>
      <el-main class="index-main" v-else>
        <keep-alive>
          <router-view v-if="$route.meta.isActive"></router-view>
        </keep-alive>
        <router-view v-if="!$route.meta.isActive"></router-view>
      </el-main>
    </el-container>
  </el-container>
</template>
<script setup>
    import {ref, onMounted,getCurrentInstance,computed} from 'vue'
    import navcon from '../components/navcon.vue'
    import leftnav from '../components/leftnav.vue'
    import Mutitabs from "../components/mutitabs";
    import {useMutitabsStore} from "@/store/mutitabs";
    import {useSiteThemeStore} from "@/store/siteTheme";

    let bus = getCurrentInstance().appContext.config.globalProperties.$Bus; // 声明$Bus
    let showclass = ref("asideshow")
    let showtype = ref(false)
    const mutitabsStore =  useMutitabsStore()
    let isMultiTabs = mutitabsStore.isMultiTabs

    const siteThemeStore = useSiteThemeStore()

    const asideshowWidth = computed(()=>{
        return siteThemeStore.menuWidth +'px'
    })

    onMounted(()=>{
        bus.on('toggle', value => {
            //console.log('value')
            if (value) {
                showclass.value = 'asideshow'
            } else {
                setTimeout(() => {
                    showclass.value = 'aside'
              }, 300)
            }
        })
    })
</script>
<style scoped>
  .main-con{
    width:100%;
    height: 100%;
    /*overflow-y: auto;*/
  }
  .hg100{
    height: 100vh !important;
    overflow-y: hidden !important;
  }
  .index-con {
    height: 100%;
    width: 100%;
    box-sizing: border-box;
    overflow-y: hidden;
  }

  .aside {
    width: 64px !important;
    background-color: var(--l-header-bg);
    margin: 0px;
    box-shadow: 0 0 5px #cccccc;
    height: calc(100vh - 60px);
  }

  .asideshow {
    width: v-bind(asideshowWidth);
    /*height: calc(100vh - 60px);*/
    background-color: var(--l-header-bg);
    margin: 0px;
    box-shadow: 0 0 5px #cccccc;
  }
  .index-main {
    display: block;
    -webkit-box-flex: 1;
    -ms-flex: 1;
    flex: 1;
    -ms-flex-preferred-size: auto;
    flex-basis: auto;
    overflow: auto;
    padding: 8px 10px 0 10px;
    width: 100%;
  }
  .index-header{
    padding: 0px;
    width: 100%;
    box-shadow: 0px 4px 12px 0px rgba(0, 0, 0, 0.08);
  }
  .el-main.noPadding{
    padding: 0px !important;
    border-left: 2px solid #333;
  }

</style>
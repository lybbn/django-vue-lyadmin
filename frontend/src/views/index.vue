<template>
  <el-container class="index-con">
    <el-header class="index-header">
      <navcon></navcon>
    </el-header>
    <div class="main-con" style="width:100%">
      <div style="display: flex; flex-direction: row;">
        <el-aside :class="showclass">
          <leftnav ></leftnav>
        </el-aside>
        <div class="container-outer 100vh">
          <el-main class="index-main">
            <keep-alive>
              <router-view v-if="$route.meta.isActive"></router-view>
            </keep-alive>
            <router-view v-if="!$route.meta.isActive"></router-view>
          </el-main>
        </div>
      </div>
    </div>
  </el-container>
</template>
<script>
  // import {systemVersionNewest,tmallShopGetProductList} from '@/api/api'
  import navcon from '../components/navcon.vue'
  import leftnav from '../components/leftnav.vue'
  import router from "../router";
  export default {
    name: 'index',
    data() {
      return {
        showclass: 'asideshow',
        showtype: false,
      }
    },
    components: {
      navcon,
      leftnav
    },
    methods:{

    },
    created() {
      this.$root.Bus.$on('toggle', value => {
        //console.log('value')
        if (value) {
          this.showclass = 'asideshow'
        } else {
          setTimeout(() => {
            this.showclass = 'aside'
          }, 300)
        }
      })
    }
  }
</script>
<style lang="scss" scoped>
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
    background-color: #304156;
    margin: 0px;
    border-right: 1px solid #eeeeee;
    height: calc(100vh - 60px);
  }

  .asideshow {
    width: 185px !important;
    height: calc(100vh - 60px);
    background-color: #304156;
    margin: 0px;
    border-right: 1px solid #eeeeee;
  }

  .index-main {
    display: block;
    -webkit-box-flex: 1;
    -ms-flex: 1;
    flex: 1;
    -ms-flex-preferred-size: auto;
    flex-basis: auto;
    overflow: auto;
    padding: 20px 20px 0 20px;
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

  .container-outer{
    width: 100%;
    height: calc(100vh - 60px);
    overflow-y: auto;
  }

</style>
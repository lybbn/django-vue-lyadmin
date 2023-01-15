<template>
  <el-menu class="el-menu-demo" mode="horizontal"  background-color="var(--l-header-bg)"  text-color="#ffffff" active-text-color="#ffffff" :ellipsis="false">
      <div  :style="collapsed ? collapsedWidth : 'width:90px;margin-left:0'" class="divleft">
          <p class="login-inner" @click.stop="" style="text-align: center;" :style="collapsed ? loginInnerWidth : 'width:90px'">
             <img class="logoimg" src="../assets/logo.png" alt=""  :style="collapsed ? 'width:40px' : 'width:24px;height:24px;margin-left:0'">
          </p>
        <img class="showimg" :src="collapsed?imgsq:imgshow" @click.stop="toggle(collapsed)">
      </div>
<!--      <span class="site-title">Django-Vue-Lyadmin后台管理系统</span>-->
<!--      <el-row class="buttonimg" type="info">-->
<!--      </el-row>-->
      <el-row  class="ly-header-right">
            <span style="margin-right: 20px;" @click="handleFullScreen" v-if="!isFullscreen">
                <el-tooltip
                    class="box-item"
                    effect="dark"
                    content="全屏"
                    placement="bottom">
                    <el-icon style="font-size: 16px;color: white;"><full-screen /></el-icon>
                </el-tooltip>
            </span>
            <span style="margin-right: 20px;" @click="handleFullScreen" v-if="isFullscreen">
                <el-tooltip
                    class="box-item"
                    effect="dark"
                    content="退出全屏"
                    placement="bottom">
                    <el-icon style="font-size: 16px;color: white;"><Minus /></el-icon>
                </el-tooltip>
            </span>
            <span style="margin-right: 20px;"  @click="setSiteTheme">
                <el-tooltip
                    class="box-item"
                    effect="dark"
                    content="暗黑模式"
                    placement="bottom">
                    <el-icon style="font-size: 16px;color: white;" v-if="siteThemeStore.siteTheme == 'light'"><Sunny /></el-icon>
                    <el-icon style="font-size: 16px;color: white;" v-if="siteThemeStore.siteTheme == 'dark'"><Moon /></el-icon>
                </el-tooltip>
            </span>
            <span style="margin-right: 20px;">
                <el-color-picker v-model="colorPrimary" :predefine="colorList" size="small" @change="setColorPrimary"></el-color-picker>
            </span>
          <span>
              <el-dropdown trigger="hover" class="right-dropdown-center">
                <span class="el-dropdown-link">
                  你好,{{userName}}
                  <el-icon class="el-icon--right">
                    <arrow-down />
                  </el-icon>
                </span>
                <template #dropdown>
                  <el-dropdown-menu>
                      <div v-show="hasPermission('personalCenter','Search')">
                          <el-dropdown-item @click="jumpto" ><el-icon><User /></el-icon>个人中心</el-dropdown-item>
                      </div>
                      <el-dropdown-item @click="exit"><el-icon><Close /></el-icon>退出登录</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
          </span>

      </el-row>
  </el-menu>
</template>
<script setup>
    import {ref, onMounted,onBeforeUnmount,getCurrentInstance,nextTick,computed} from 'vue'
    import { ElMessage , ElMessageBox } from 'element-plus'
    import screenfull from 'screenfull'
    import {useMutitabsStore} from "@/store/mutitabs";
    import {useSiteThemeStore} from "@/store/siteTheme";
    import {useRouter} from 'vue-router'

    const router = useRouter()
    let bus = getCurrentInstance().appContext.config.globalProperties.$Bus; // 声明$Bus
    const mutitabsStore = useMutitabsStore()
    const siteThemeStore = useSiteThemeStore()

    let collapsed = ref(true)
    let imgshow = require('../assets/img/show.png')
    let imgsq = require('../assets/img/sq.png')
    let userName = ref("")
    let mobileWidth = ref(992)
    let isFullscreen = ref(mutitabsStore.isFullscreen)

    let colorList = ref(['#409EFF', '#009688', '#536dfe', '#ff5c93', '#c62f2f', '#fd726d'])
    let colorPrimary = ref(siteThemeStore.colorPrimary || '#409EFF')
    
    function setColorPrimary() {
        siteThemeStore.setColorPrimary(colorPrimary.value)
    }

    let collapsedWidth=computed(()=>{
        return 'width:'+ (siteThemeStore.menuWidth+25)+'px'
    })
    let loginInnerWidth=computed(()=>{
        return 'width:'+ (siteThemeStore.menuWidth+15)+'px'
    })

    //路由跳转
    function jumpto(){
        mutitabsStore.switchtab('personalCenter')
    }
    // 退出登录
    function exit(e) {
        ElMessageBox.confirm('退出登录, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
            mutitabsStore.logout('false')
            sessionStorage.clear()
            localStorage.clear()
            siteThemeStore.$reset()
            ElMessage.success('已退出登录!')
            // window.location.pathname = '/login'
            router.replace({path: '/login'}).then(()=>{
                window.location.reload()
            })
      })
      .catch(() => {
      })
    }
    // 切换显示
    function toggle(showtype) {
        collapsed.value = !showtype
        bus.emit('toggle', collapsed.value)
    }
    //全屏显示
    function handleFullScreen(){
        if (!screenfull.isEnabled) {
            ElMessage.warning('您的浏览器不支持全屏!')
            return false
        }else{
            screenfull.toggle()
            isFullscreen.value = !screenfull.isFullscreen
        }

    }
    //设置主题
    function setSiteTheme(){
        if(siteThemeStore.siteTheme=='light'){
            siteThemeStore.setSiteTheme('dark')
        }else{
            siteThemeStore.setSiteTheme('light')
        }
    }
        //解决table 表格缩放错位问题
    function handleResize() {
        collapsed.value = isMobile()
        toggle(collapsed.value)
    }
    function isMobile() {
        let htmlWidth = document.documentElement.clientWidth || document.body.clientWidth;
        if(htmlWidth>mobileWidth.value){
            return false
        }
        return true
    }

    onMounted(()=>{
        userName.value = mutitabsStore.userName
        window.addEventListener('resize', handleResize);
        nextTick(()=>{
              handleResize
        })
    })

    onBeforeUnmount(()=>{
        window.removeEventListener("resize", handleResize);
    })


</script>
<style lang="scss" scoped>
    .divleft{
        display: flex;
        align-items: center;
    }
    .site-title{
        color: #ffffff;
        font-size: 20px;
    }
    .right-dropdown-center{
        color: #ffffff;
        display: flex;
        align-items: center;
    }
    ::v-deep(.el-dropdown--default){
        height: 18px !important;
    }
    ::v-deep(.el-dropdown){
        line-height: unset !important;
    }
    ::v-deep(.el-icon--right) {
        margin-left:0 !important;
    }
    .ly-header-right{
        display: flex;
        align-items: center;
        cursor: pointer;
        justify-content: center;
        padding-right: 15px;
        background-color: var(--l-header-bg) !important;
    }
    .ly-header-right:hover{
        background: var(--l-header-bg) !important;
    }
  .el-menu-vertical-demo:not(.el-menu--collapse) {
    border: none;
  }

  .is-console{
    float: right;
    margin: 14px;
  }

  .buttonimg {
    height: 60px;
    background-color: transparent;
    border: none;
    position: relative;
    float: left;
    cursor:pointer;
  }

  .showimg {
    width: 26px;
    height: 26px;
    cursor: pointer;
    /*position: absolute;*/
    /*top: 17px;*/
    /*left: 0;*/
  }

  .showimg:active {
    border: none;
  }

  .logobox {
    height: 40px;
    line-height: 40px;
    color: #9d9d9d;
    /*color: #FFFFFF;*/
    font-size: 20px;
    text-align: center;
    /*margin-left: 20px;*/
    display: inline-block;
    outline: none;
    float: left;
  }
  .logoimg {
    height: 40px;
    cursor: pointer;
  }
  .el-menu-demo{
      height: 60px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      .el-menu-item.is-active {
          position: relative;
          background-color:var(--l-header-bg) !important;
        }
      li{
          height: 100%;
          &.logo-outer{
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: none !important;
                margin: 0;
                padding: 0;
                .login-inner{
                    flex:1;
                    display: flex;
                    align-items: center;
                    justify-content: center;

                }
          }
      }
  }
    .el-menu.el-menu--horizontal{
        border-bottom: 0;
  }
</style>
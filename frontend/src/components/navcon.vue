/**
* 头部菜单
*/
<template>
  <el-menu class="el-menu-demo" mode="horizontal"  background-color="var(--l-header-bg)"  text-color="#ffffff" active-text-color="#ffffff" :ellipsis="false">
      <el-menu-item  :style="collapsed ? 'width:210px' : 'width:90px;margin-left:0'" class="logo-outer">
          <p class="login-inner"  @click.stop="">
             <img class="logoimg" src="../assets/logo.png" alt=""  :style="collapsed ? 'width:40px' : 'width:24px;height:24px;margin-left:0'">
          </p>
        <img class="showimg" :src="collapsed?imgsq:imgshow" @click.stop="toggle(collapsed)">
      </el-menu-item>
<!--      <span class="site-title">Django-Vue-Lyadmin后台管理系统</span>-->
<!--      <el-row class="buttonimg" type="info">-->
<!--      </el-row>-->
      <el-row  class="ly-header-right">
            <span style="margin-right: 20px;" @click="fullScreen" v-if="!isFullscreen">
                <el-tooltip
                    class="box-item"
                    effect="dark"
                    content="全屏"
                    placement="bottom">
                    <el-icon style="font-size: 16px;color: white;"><full-screen /></el-icon>
                </el-tooltip>
            </span>
            <span style="margin-right: 20px;" @click="fullScreen" v-if="isFullscreen">
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
                    <el-icon style="font-size: 16px;color: white;" v-if="this.$store.state.siteTheme == 'light'"><Sunny /></el-icon>
                    <el-icon style="font-size: 16px;color: white;" v-if="this.$store.state.siteTheme == 'dark'"><Moon /></el-icon>
                </el-tooltip>
            </span>
<!--            <el-sub-menu index="1-1-1-1" class="submenu" style="width:auto;">-->
<!--                <template #title class="el-title">你好,{{userName}}</template>-->
<!--                <el-menu-item @click="exit">退出</el-menu-item>-->
<!--            </el-sub-menu>-->
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
<script>
  import screenfull from 'screenfull'
  import store from '../store'
  export default {
    name: 'navcon',
    data() {
      return {
        collapsed: true,
        imgshow: require('../assets/img/show.png'),
        imgsq: require('../assets/img/sq.png'),
        userName: '',
        mobileWidth:992,
        isFullscreen:false,

      }
    },
    // 创建完毕状态(里面是操作)
    created() {
      this.userName=store.getters.getUserName
    },
    mounted() {
        window.addEventListener('resize', this.handleResize);
        this.handleResize()
        this.init()
    },

    unmounted() {
         window.removeEventListener("resize", this.handleResize);
         // 最后注销监听事件
        if (screenfull.isEnabled) {
            screenfull.off('change', this.change);
        }
    },
    methods: {
        //路由跳转
        jumpto(){
            this.$store.commit("switchtab",'personalCenter')
        },
        // 退出登录
        exit(e) {
            this.$confirm('退出登录, 是否继续?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
        }).then(() => {
            this.$store.commit('logout', 'false')
            this.$store.commit("setSiteTheme",'light')
            this.$router.push({path: '/login'})
            sessionStorage.clear()
            localStorage.clear()
            this.$message.success('已退出登录!')
          })
          .catch(() => {
          })
        },
        // 切换显示
        toggle(showtype) {
            this.collapsed = !showtype
            this.$Bus.emit('toggle', !showtype)
        },
        init() {
            if(screenfull.isEnabled) { // 判断是否支持全屏
                screenfull.on('change', this.change); // 开启监听change事件
            }
        },
        // 更改当前屏幕的状态
        change() {
            this.isFullscreen = screenfull.isFullscreen; // 更新全屏状态
        },
        //全屏显示
        fullScreen () {
            if (!screenfull.isEnabled) {
              this.$message({
                message: '您的浏览器不支持全屏',
                type: 'warning'
              })
              return false
            }
            screenfull.toggle()
        },
        //设置主题
        setSiteTheme(){
            if(this.$store.state.siteTheme=='light'){
                this.$store.commit("setSiteTheme",'dark')
            }else{
                this.$store.commit("setSiteTheme",'light')
            }
        },
        //解决table 表格缩放错位问题
        handleResize() {
            this.collapsed = this.isMobile()
            this.toggle(this.collapsed)
        },
        isMobile() {
            let htmlWidth = document.documentElement.clientWidth || document.body.clientWidth;
            if(htmlWidth>this.mobileWidth){
                return false
            }
            return true
        },
    }
  }
</script>
<style lang="scss" scoped>
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
    ::v-deep(.el-sub-menu__title){
        height: 100%;
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
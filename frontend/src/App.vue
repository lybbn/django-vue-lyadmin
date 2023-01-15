<template>
    <el-config-provider :locale="locale" :size="siteThemeStore.elementSize" :zIndex="siteThemeStore.elementzIndex">
        <router-view></router-view>
    </el-config-provider>
</template>
<script setup>
    import {ref, onMounted,watch,computed } from 'vue'
    import {useSiteThemeStore} from "@/store/siteTheme";
    import { useI18n } from "vue-i18n";
    const i18n = useI18n();

    const siteThemeStore = useSiteThemeStore()

    const colorPrimary = siteThemeStore.colorPrimary
    const menuHeaderColor = siteThemeStore.menuHeaderColor

    onMounted(()=>{

        siteThemeStore.setColorPrimary(colorPrimary)

        if (siteThemeStore.siteTheme === 'dark') {
            document.documentElement.classList.add('dark')
        } else {
            document.documentElement.classList.remove('dark')
            siteThemeStore.setMenuHeaderColor(menuHeaderColor)
        }
    })

    const locale = computed(()=>{
        return i18n.messages.value[i18n.locale.value].el
    })
</script>
<style lang="scss">
  #app {
    /*font-family: Avenir, Helvetica, Arial, sans-serif;*/
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    /*text-align: center;*/
    /*color: #2c3e50;*/
    height: 100%;
  }
  /*页面最大化*/
  .lyadmin.lymain-maximize {
      .lymain-maximize-exit {display: block;}
      .myeltas2,.lyadmin-header,.lyadmin-side {display: none;}
   }
  .lymain-maximize-exit {display: none;position: fixed;z-index: 3000;top:-20px;left:50%;margin-left: -20px;border-radius: 50%;width: 40px;height: 40px;cursor: pointer;background: rgba(0,0,0,0.2);text-align: center;}
  .lymain-maximize-exit i {font-size: 14px;margin-top: 22px;color: #fff;}
  .lymain-maximize-exit:hover {background: rgba(0,0,0,0.4);}

  // 移动端样式覆盖
  @media (max-width: 992px){
    .el-form-item {display: block;}
    .el-form-item__label {display: block;text-align: left;padding: 0 0 10px;}
    .el-dialog {width: 90%!important;}
    .el-dialog.is-fullscreen {width: 100%!important;}
    .el-drawer.rtl {width: 90%!important;}
    .el-form-item__content {margin-left: 0px!important;}

    .lyPagination-page {
        .el-pagination__total,
        .el-pagination__jump,
        .el-pagination__sizes {display: none!important;}
    }
  }
</style>

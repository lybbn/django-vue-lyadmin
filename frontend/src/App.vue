<template>
  <router-view/>
</template>
<script setup>
    import {ref, onMounted,watch } from 'vue'
    import {useSiteThemeStore} from "@/store/siteTheme";

    const siteThemeStore = useSiteThemeStore()

    onMounted(()=>{
        if (siteThemeStore.siteTheme === 'dark') {
            document.documentElement.classList.add('dark')
        } else {
            document.documentElement.classList.remove('dark')
        }
    })

    //防止页面刷新丢失主题
    watch(()=>siteThemeStore.siteTheme, (n,o) => {
        if (n === 'dark') {
            document.documentElement.classList.add('dark')
        } else {
            document.documentElement.classList.remove('dark')
        }
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
</style>

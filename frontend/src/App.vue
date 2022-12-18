<template>
  <div id="app">
    <router-view/>
  </div>
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
</style>

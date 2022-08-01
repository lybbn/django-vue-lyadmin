<template>
  <div id="app">
    <router-view/>
  </div>
</template>
<script>
  export default {
    data(){
      return{
        theSiteTheme:"",
      }
    },
    mounted() {
      this.theSiteTheme = this.$store.state.siteTheme;
    },
    computed: {
      listentheme() {
        return this.$store.state.siteTheme;
      }
     },
    watch: {
      //防止页面刷新丢失主题
      theSiteTheme: function (value, oldvalue) {
        if (value === 'dark') {
          document.documentElement.classList.add('dark')
        } else {
          document.documentElement.classList.remove('dark')
        }
      },
      listentheme: function (value, oldvalue) {
        if (value === 'dark') {
          document.documentElement.classList.add('dark')
        } else {
          document.documentElement.classList.remove('dark')
        }
      },
    },
  }
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

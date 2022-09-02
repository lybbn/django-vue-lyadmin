<template>
    <div class="page">
    <p class="page_title">404 找不到页面</p>
        <div class="page_btn">
            <el-button @click="backhome">
                点击返回
            </el-button>
            <el-button @click="exit">
                退出登录
            </el-button>
        </div>
  </div>
</template>

<script>
    export default {
        name: "404",
        methods:{
            backhome(){
                this.$router.replace('/')
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
        },
    }
</script>

<style lang="scss" scoped>
.page {
    background: #303131;
    background-blend-mode: multiply,multiply;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    .page_title {
        font-size: 20px;
        color: #FFF;
        margin-bottom: 20px;
        .page_btn{
            display: flex;
        }
    }
}
</style>
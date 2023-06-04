<template>
    <div class="page">
    <p class="page_title">404</p>
        <div class="page_btn">
            <el-button @click="backhome">
                返回首页
            </el-button>
            <el-button @click="exit">
                退出登录
            </el-button>
        </div>
  </div>
</template>

<script>
    import {useMutitabsStore} from "@/store/mutitabs";
    import {setStorage,getStorage} from '@/utils/util'

    export default {
        name: "404",
        setup(){
            const mutitabsstore = useMutitabsStore()
            return { mutitabsstore}
        },
        methods:{
            backhome(){
                // this.$router.replace('/')
                let allmenu = getStorage('allmenu')
                if(allmenu){
                    allmenu = JSON.parse(allmenu)
                    if(allmenu.length>0){
                        let tabsPage = allmenu[0].attributes.url
                        this.mutitabsstore.switchtab(tabsPage)
                    }
                }
            },
            // 退出登录
            exit(e) {
                this.$confirm('退出登录, 是否继续?', '提示', {
                  confirmButtonText: '确定',
                  cancelButtonText: '取消',
                  type: 'warning'
            }).then(() => {
                this.mutitabsstore.logout('false')
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
        font-size: 160px;
        color: #FFF;
        margin-bottom: 20px;
        .page_btn{
            display: flex;
        }
    }
}
</style>
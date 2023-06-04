<template>
    <div class="lycontainer" >
        <ly-xterm :wsuri="wsuri"></ly-xterm>
    </div>
</template>

<script>
    import LyXterm from "@/components/terminal/xterm.vue";
    import {domain,url} from '@/api/url'
    export default{
        name: "lyterminal",
        components: {LyXterm},
        data(){
            return{
                wsuri:(window.location.protocol === 'http:' ? 'ws://' : 'wss://') + domain+"/ws/webssh/",
            }
        },
        created() {
            let url = window.location.href
            let getqyinfo = url.split('?')[1]
            let getqys = new URLSearchParams('?'+getqyinfo)
            let id = getqys.get('id')
            let host = getqys.get('host')
            document.title =host+"在线终端WEBSSH"
            this.wsuri = this.wsuri +"?id="+id
        },
    }
</script>
<style lang="scss" scoped>
    .lycontainer{
        background: black;
        height: 100% ;
        width: 100%;
        /*background: black;*/
        /*padding: 10px;*/
        overflow: hidden;
    }
</style>
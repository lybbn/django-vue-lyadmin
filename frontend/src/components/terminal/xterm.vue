<template>
    <div class="xtermbox">
        <div ref="lyxterm" class="lyxterm"></div>
    </div>
</template>

<script>
    import "xterm/css/xterm.css"
    import "xterm/lib/xterm.js";
    import { getJWTAuthorization } from '@/api/request'
    import { Terminal } from 'xterm'
    import { FitAddon } from "xterm-addon-fit"
    import { AttachAddon } from 'xterm-addon-attach'
    export default {
        name: "LyXterm",
        props:{
            fontSize:{
                type:Number,
                default:15
            },
            wsuri: {
                type: String,
                default: ''
            },
        },
        data(){
            return{
                term: null,
                lyws: null,
                cols: 50,
                rows: 50,
            }
        },
        mounted() {
            this.initXterm()
            this.initSocket()
            window.addEventListener('resize', this.listenResize);
        },
        unmounted() {
            this.lyws && this.lyws.close()
            // this.term && this.term.dispose()
            window.removeEventListener("resize", this.listenResize);
        },
        methods:{
            //Xterm主题
            initXterm() {
                let init_width = 9;
                let init_height = 22;
                const _width = window.innerWidth
                const _height = window.innerHeight
                this.cols = Math.floor(_width / init_width)
                this.rows = Math.floor(_height / init_height)
                this.term = new Terminal({
                    cols: this.cols,
                    rows: this.rows,
                    rendererType: "canvas", //渲染类型
                    fontSize: this.fontSize,
                    scrollback: 500,//终端中的回滚量
                    convertEol: true, //启用时，光标将设置为下一行的开头
                    cursorBlink: true, //光标闪烁
                    disableStdin: false, //是否应禁用输入。
                    cursorStyle: "block", //光标样式
                    theme: {
                        foreground: "yellow", //字体
                        background: "black", //背景色#060101
                        cursor: "yellow" //设置光标
                    },
                })
                this.term.open(this.$refs.lyxterm)
            },
            //websocket初始化
            initSocket () {
                this.term.fitAddon = new FitAddon()
                this.term.loadAddon(this.term.fitAddon)
                this.lyws = new WebSocket(this.wsuri,['JWTLYADMIN',getJWTAuthorization()])
                const attachAddon = new AttachAddon(this.lyws)
                this.term.loadAddon(attachAddon)
                // 链接成功后
                this.term.fitAddon.fit()
                this.term.focus();
                //websocket关闭之后操作
                this.lyws.onclose = () => {
                    this.term.fitAddon.fit()
                    console.log("close socket");
                    this.term.write('\r\n连接已被关闭...\r\n')
                };
                //websocket链接成功之后操作
                this.lyws.onopen = () => {
                    this.term.fitAddon.fit()
                    this.term.write("Welcome To Django-Vue3-Lyadmin WebSSH ☺\r\n")
                    this.termResize({cols:this.cols,rows:this.rows})
                };

                //websocket错误信息
                this.lyws.onerror = () => {
                    console.log("websocket 链接错误");
                    this.term.fitAddon.fit()
                    this.lyws.close()
                    this.lyws =null
                };
                let that = this
                this.term.onData(function (data){
                    if(!that.lyws || that.lyws.readyState == 3 || that.lyws.readyState == 2){
                        that.term.write('\r\n连接丢失,正在尝试重新连接!\r\n')
                        that.reconnect()
                    }
                })
                this.term.onResize(({ cols, rows }) => {
                    this.term.fitAddon.fit()
                    this.termResize({cols:cols,rows:rows})
                })
                // window.onresize = function () {
                //     that.term.fitAddon.fit()
                //     if(that.term){
                //         that.term.focus()
                //     }
                // }
            },
            termResize(size){
                if(this.lyws){
                    size['resize'] = 1;
                    this.lyws.send(JSON.stringify(size));
                }
            },
            listenResize(){
                if(this.term){
                    this.term.fitAddon.fit()
                    this.term.focus()
                }
            },
            reconnect(){
                if(!this.lyws || this.lyws.readyState == 3 || this.lyws.readyState == 2){
                    this.initSocket()
                }
            },
        },
    }
</script>

<style lang="scss" scoped>
    .xtermbox {
        width: 100%;
        height: 100%;
        background: black;
        .lyxterm{
            width: 100%;
            height: 100%;
        }
    }
    .xterm {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
    }
</style>
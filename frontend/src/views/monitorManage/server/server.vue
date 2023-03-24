<template>
    <div class="lycontainer" :class="{'ly-is-full':isFull}" :style="{height:tableHeight}">
        <el-scrollbar v-loading="showloading" element-loading-text="Loading..." element-loading-background="rgba(122, 122, 122, 0.9)">
            <div style="margin-bottom: 12px">
                <el-row :gutter="20">
                    <el-col :span="24">
                        <div class="lycard">
                            <div class="lycard-left">
                                <span :class="iconClass" class="lyiconfont">系统：</span>
                                <span>{{monitorData.system}}</span>
                                <span style="margin-left: 20px">已不间断运行: {{monitorData.time}}</span>
                                <span style="margin-left: 20px">自动刷新(秒)：</span>
                                <el-input-number v-model="refreshInterval" size="small" :min="3" @change="restartIntervalMonitor"/>
<!--                                <span style="margin-left: 20px"><el-button type="primary" size="small" icon="Refresh" circle @click="getData" /></span>-->
                                <el-button style="margin-left: 20px" type="primary" v-show="timer" :text="true" link @click="getData"><span style="font-size: 13px"  @click="clearIntervalMonitor">停止</span></el-button>
                                <el-button style="margin-left: 20px" type="primary" v-show="!timer" :text="true" link @click="getData"><span style="font-size: 13px"  @click="restartIntervalMonitor">开始</span></el-button>
                                <el-button type="primary" :text="true" link @click="getData"><span style="font-size: 13px">手动刷新</span></el-button>
                            </div>
                            <div class="lycard-center">

                            </div>
                            <div class="lycard-right">
                                <div @click="setFull">
                                    <el-tooltip content="全屏" placement="bottom">
                                        <el-icon ><full-screen /></el-icon>
                                    </el-tooltip>
                                </div>
                            </div>
                        </div>
                    </el-col>
                </el-row>
            </div>
            <div>
                <ly-statuscard  v-model="monitorData"></ly-statuscard>
            </div>
            <div>
                <ly-monitor-echartcard :loading="showloading" :rows="3" v-model="monitorData" ref="lyechartpic"></ly-monitor-echartcard>
            </div>
            <div style="height: 20px">
            </div>
        </el-scrollbar>
    </div>
</template>

<script>
    import LyStatuscard from "../../../components/monitor/statusCard";
    import {monitorGetSystemInfo} from '@/api/api'
    import LyMonitorEchartcard from "../../../components/monitor/echartCard";
    export default {
        name: "server",
        components: {LyMonitorEchartcard, LyStatuscard},
        created() {
            this.getData()
        },
        mounted() {
            if(!this.isRunning){
                this.intervalMonitor()
                this.isRunning = true
                // setTimeout(() => {
                //     this.showloading = false
                // }, 1000)

            }
            // 监听页面宽度变化搜索框的高度
            window.addEventListener('resize', this.listenResize);
            this.listenResize()
        },
        activated() {
            if(!this.isRunning){
                this.intervalMonitor()
                this.isRunning = true
            }
            // 监听页面宽度变化搜索框的高度
            window.addEventListener('resize', this.listenResize);
            this.listenResize()
        },
        deactivated() {
            this.isRunning = false
            this.clearIntervalMonitor()
            // 页面销毁，去掉监听事件
			window.removeEventListener("resize", this.listenResize);
        },
        unmounted() {
            this.clearIntervalMonitor()
            // 页面销毁，去掉监听事件
			window.removeEventListener("resize", this.listenResize);
        },
        data(){
            return{
                isFull:false,
                isRunning:false,
                showloading:false,//页面初始是否加载loading
                tableHeight:'500px',
                monitorData:{
                    cpu: [0, 0, [0, 0, 0, 0], "", 0, 1],
                    disk: [{path: "", size: ["0GB", "0GB", "0GB", 0], inodes: false}],
                    is_windows: true,
                    load_average: {one: 0, five: 0, fifteen: 0, max: 0, limit: 0, safe:0, percent: 0},
                    mem: {percent: 0, total: 0, free: 0, used: 0},
                    system: "",
                    time: "0天",
                    network:{
                        up:0,
                        down:0,
                        downTotal:0,
                        upTotal:0,
                        network:{

                        }
                    }
                },
                refreshInterval:3,
                iconClass:'',
                timer:null,//定时器
            }
        },
        watch:{
            'isFull':function (nval) {
                this.listenResize()
            },
        },
        methods:{
            setFull(){
                this.isFull=!this.isFull
            },
            //获取列表
            getData(){
                monitorGetSystemInfo(this.formInline).then(res => {
                    if(res.code ==2000) {
                        this.monitorData = res.data
                        let tempsystem = res.data.system.split(" ")[0].toLowerCase()
                        this.iconClass = 'ico-'+tempsystem
                    }
                })
            },
            intervalMonitor(){
                let that = this
                this.timer = setInterval(() => {
                    that.getData()
                },that.refreshInterval*1000);
            },
            restartIntervalMonitor(){
                this.clearIntervalMonitor()
                this.intervalMonitor()
            },
            clearIntervalMonitor(){
                clearInterval(this.timer)
                this.timer = null
            },
            handleResize() {
                if(this.$refs.lyechartpic){
                    this.$refs.lyechartpic.handleResize();
                }
            },
            // 计算搜索栏的高度
            listenResize() {
				this.$nextTick(() => {
				    this.getTheTableHeight()
				})
			},
            getTheTableHeight(){
                if(this.isFull){
                    this.tableHeight =(window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight) +'px'
                }else{
                    this.tableHeight =(window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight) - 100 +'px'
                }
                this.handleResize()

            },
        },
    }
</script>

<style lang="scss" scoped>
    .lycontainer{
        width: 100%;
        /*height: calc(100vh - 130px); //动态计算长度值*/
        /*overflow-x: hidden;*/
        /*overflow-y:auto;*/
    }
    .echarts-inner{
        margin-top: 1px;
    }
    ::v-deep(.el-scrollbar__bar.is-horizontal) {
        display: none;
    }
    .lycard{
        background: var(--el-bg-color);
        box-shadow: var(--el-box-shadow-light);
        height: 30px;
        border: 1px solid var(--el-border-color-light);
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 15px 10px 15px;
        font-size: 13px;
    }
    .lycard-left{
        display: flex;
        align-items: center;
    }
    .lycard-right{
        display: flex;
        align-items: center;
    }
    .lyiconfont{
        width: 40px;
        display: flex;
        align-items: center;
    }
     /*系统图标*/
    .ico-linux {
        background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAATCAYAAAB2pebxAAAAAXNSR0IArs4c6QAAAdVJREFUOE+VlOFx4jAQhXclN5AWSAmmhKQEUgGWhgpCCaQCjxYqgBJICaGEcwnnAhhpM88jMcYxkzvP8AetPu++fc9MD57NZvMUY9wRkSOiLqX0djgcLnPl/AjinAsZUEo6a+1r27bd9M4sBF2klM6q+kRE+H0S0YqZtyGEj3+FLFJKK1WtcUFVhZmPRHQRkdf/gRxVtWfmzwxbQRtr7bJt234Mmh1nvV7XxphzvtCN9bHWPk91mYU45zD/QlUHEVNK6KBW1cDMPoQgv3bSNM2uqiqZvtE5dyaiOndzG+lHJ03TvBDRy36/304FxBkzAyQi4sv5D4hz7mit3c75AZecc3+ICNtbFvPdQaAF6ubWWN6aR0K3t26mEKy1mxtlBBmczMyXEMIS/08hf+FOEXl7FAfv/Vf2TSciz3cQ771TVYxTZ3vfrRHF3vt3VUUo8fRlS1zSyswdcpF1OY6FG40C6yNLxcm9iJwYazPG1ONgwaEFWgDZxbux6Ln7nnEIN45dWFJMRKeUEr4h8Ae+Kze9MvQd2RrGyYntEbiqqmD1Psb4NYjGPDhTVRfoLsbocwRWKaUtvHLbDsgoRgHmxqqttehigFyv14W1NuAbw8wfxphTSfM3C/IiRW5CAokAAAAASUVORK5CYII=");
        background-repeat: no-repeat;
        padding-left: 30px;
        background-size: contain;
        height: 20px;
    }

    .ico-windows {
        background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAALJJREFUOE/lU9EJwjAUvINmgKyQFbpCV3AFV3AFXaDQrNARdARncAU3yMlBCxZMW/BLfJCf5HIveXdH7Ki+72MIIZVSkqREsgWQvDjfNwhAbJpmBj0AdJKO3q/14TAM94ltASJ5keRO3dojTaBPgD8juFaGNAJ4TpJV58ic87lyepMUNwk2VLBZDt/I+CMEtrItu6jJiba3s1BX4S1MyUEqpbQk/Xer4OSdVsO0I81Yi/MLrIlzp0RBFLwAAAAASUVORK5CYII=");
        background-repeat: no-repeat;
        padding-left: 30px;
        background-size: contain;
        height: 20px;
    }

    .ico-centos {
        background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAPCAYAAADUFP50AAAAAXNSR0IArs4c6QAAAWdJREFUOE99ksGNwkAMRe2YSEic0gKUQAtQAhSAyERUsC3sVhBlQBQAJZAWKIG0kAM3wuDVH00iNsDOKYr9/vz5NtOHs9lskjzP6091/lQwxpyIqLbWLt/1vAXX6/U0iiID4PF42N1ud+7DHWiMUWY+q2pFRAsisqEZAkciSohoZq31zDN4YuZSVad9kJkzgKoKcN4HD8w8hnqAfTBwEW5bwE37Zn9jmqYzZkYYbSPg6n6/13EcewdBjFR1vt1uSzbGFFB0znUBiEglIiWEbrfbjIjgxB8RgRBxmqbf7c8oiry96/V6HA6H5JxLmqapR6ORaWuqCpHSW12tVuPBYHAJVn0Q+AYUxzG+a1WFM9w4yfO86lLNsuwLDU9BeOvMDGsYh68VRfHTT/XCzJhdG0Q3x5AsAjPW2snLHKEaZrlwzvlwRASJA0JIycscn1cKKyci/k1N0yz3+z226c/5b8lhucbM3i35L4czsXOxTF0MAAAAAElFTkSuQmCC");
        background-repeat: no-repeat;
        padding-left: 30px;
        background-size: contain;
        height: 20px;
    }

    .ico-ubuntu {
        background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAAXNSR0IArs4c6QAAAUVJREFUOE+VksFtAjEQRWfMFQ6bEqAEKAFKgANnGMsVpIVQggeJArIlZEsgJWRLCA1gT/SRkVh2IyU+7crz/eb/GaY/HhGJRCRmtjoejw0P6UIIVUrpjYim5V6J6L1816q66Qm99+Kca1JKZyKqUGxmB2ae4yEz8z0iRGaGlkBozAzFxMzr8n9h5mmPKCLfoDDzZ4xx8Wjj7rE85Hm73VaTyWRtZhciAq26Xq+z0+nUPvv33p9LFzWLCEyjFbRxMDNR1dlQaPv9fumcm+ac238JSwaAtIzoc86SUmqccx8lyY2q1s9UEfkqI9LOOB48XFT15S5EDuPxGP5Bo5zzoiPc7XZzUOG1iG6FCARJ55zRVRtj7BJRFEK4bcvjAhBRbWYtM78S0c3G4MpBCPpoNMICYP1AwibhNKq6+lU4EAzGtiQiD+IPImyt7qiNvV0AAAAASUVORK5CYII=");
        background-repeat: no-repeat;
        padding-left: 30px;
        background-size: contain;
        height: 20px;
    }

    .ico-debian {
        background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAQCAYAAAAmlE46AAAAAXNSR0IArs4c6QAAAV5JREFUOE99UsuRgkAQfc0c8UIKuyGwIWgIevAsTRnBEgJGYE1jeeTgpkAIawhrClz0CGz1FGONlDpVHKaZ9+nXTZgcZl4S0fcwDB8AzgBaImqiKGr2+/3FP6cQx8wWABPRue/7Rv8RUQpASfQTEcld3QOZ+QRA1Qpr7e6JE0c6DMOuqqrCAdUegNIYswjthOD1ep3MZrNfImqttV80Fv76vl8cDgftyZ3NZpNGUcQAGmOM9tfmea6KSxFZ0KjGevEgJYvjOK2qyvUZkhljrFNUFgBJ2JfWrLUy7XN0cRKRTw9E+DDLslIDmAKzLJsTUSIiP86qXibAuYJCq9vtNum6zl6v17yu65Z8CH4+XmUMolX2UWlpjCk0pPscmVlTXYWp+mTVTdd1l+PxeN+aEKjDVe+raV+v7m4B/HDfLcCU4L5yY69lOM936g9L/iqoZwQPQG9bt+Z2u5019leq/xQlshES047zAAAAAElFTkSuQmCC");
        background-repeat: no-repeat;
        padding-left: 30px;
        background-size: contain;
        height: 20px;
    }

    .ico-fedora {
        background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAAXNSR0IArs4c6QAAARtJREFUOE+Fks1thDAQhWfkK5dNCbslZEtYSsgeuHtcQlpIB4gRcgHJmVMoIbTAjWu4cMR2NAgiLzLJSEiWzTdvfh5CFEVRnLIseweAZwA4rU8jAHTDMNybppHzErgdtNY3RPyME0XnBfDe53Vdd7/gETTPc26tbeVHIpKkN6XUpSzLflEkorBX8t5f5U4pVYUQpOztG5n5CbXWb4j4ugeZGY0xXyEE6fchnHP3o8clKxF9R0OK4RYTZY6I2FdVdV0Vzwl43IPMzGZfGhFVMop4yklF2Rsz538o9ilQEv/X40cSRMROekytSbJO03SJQXGHDGZ0zpkQwlkpJfZ7iHmejbWWY7CVvlZDvADAIbRYbrdkUd3MvSklTf4DoYOi1ZiPQGwAAAAASUVORK5CYII=");
        background-repeat: no-repeat;
        padding-left: 30px;
        background-size: contain;
        height: 20px;
    }
</style>
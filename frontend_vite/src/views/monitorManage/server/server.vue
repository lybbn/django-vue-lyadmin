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
    import LyStatuscard from "@/components/monitor/statusCard.vue";
    import {monitorGetSystemInfo} from '@/api/api'
    import LyMonitorEchartcard from "@/components/monitor/echartCard.vue";
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
        background-image: url("data:image/png;base64,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");
        background-repeat: no-repeat;
        padding-left: 30px;
        background-size: contain;
        height: 20px;
    }

    .ico-ubuntu {
        background-image: url("data:image/png;base64,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");
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
<template>
    <el-row :gutter="20">
        <el-col :span="24" >
            <div  class="space-inner">
                <el-tabs type="border-card" class="lycard" v-model="activeName" @tab-change="handleTabChage">
                    <el-skeleton :rows="rows" :animated="animated" :count="count" :loading="loading" style="padding: 20px;width: auto;overflow: hidden;">
                        <template #default>
                            <el-tab-pane label="流量趋势" name="tab1">
                                <div class="lymonitor-info">
                                    <div class="lymonitor-info-item"><p><span class="lyico-up"></span>上行</p><a>{{network.up+'KB'}}</a></div>
                                    <div class="lymonitor-info-item"><p><span class="lyico-down"></span>下行</p><a>{{network.down+'KB'}}</a></div>
                                    <div class="lymonitor-info-item"><p>总发送</p><a>{{formatUnitSize(network.upTotal)}}</a></div>
                                    <div class="lymonitor-info-item"><p>总接收</p><a>{{formatUnitSize(network.downTotal)}}</a></div>
                                    <el-select v-model="networkValue"  placeholder="Select" size="large" @change="networkSelectChange">
                                        <el-option
                                          v-for="item in networkOptions"
                                          :key="item.value"
                                          :label="item.label"
                                          :value="item.value"
                                        />
                                    </el-select>
                                </div>
                                <LyLineEchart ref="lyecharts1" v-show="activeName == 'tab1'" v-model="network"></LyLineEchart>
                            </el-tab-pane>
                        </template>
                    </el-skeleton>
                </el-tabs>
            </div>
        </el-col>
    </el-row>
</template>

<script>

    import LyLineEchart from "./lyLineEchart";
    export default {
        name: "LyMonitorEchartcard",
        components: {LyLineEchart},
        data(){
            return{
                activeName:"tab1",
                dataList:{
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
                network:{
                    down: 0,
                    downPackets: 0,
                    downTotal: 0,
                    up: 0,
                    upPackets: 0,
                    upTotal: 0,
                },
                networkValue:'all',//默认值
                networkOptions:[
                    {
                    value: 'all',
                    label: '全部',
                    },
                ],
            }
        },
        created() {
            this.dataList = this.modelValue
        },
        props:{
            loading: {
                type: Boolean,
                default: false
            },
            count:{
                type:Number,
                default:1,
            },
            rows:{
                type:Number,
                default:4,
            },
            animated:{
                type:Boolean,
                default:true,
            },
            modelValue: {
            },
            height:{
                type:Number,
                default:400,
            }
        },
        watch:{
            modelValue: function(nval){
                this.dataList = nval;
                var tempnetwork = this.dataList.network.network
                var tempoptions = [
                    {
                    value: 'all',
                    label: '全部',
                    },
                ]
                for (let i = 0; i<Object.keys(tempnetwork).length;i++) {
                    tempoptions.push({
                        value:i,
                        label:Object.keys(tempnetwork)[i],
                    })
                }
                this.networkOptions = tempoptions
                if(this.networkValue == 'all'){
                    this.network = this.dataList.network
                }else{
                    this.network = Object.values(this.dataList.network.network)[this.networkValue]
                }
            },
            dataList: function(nval) {
                this.$emit('update:modelValue', nval);
            },
        },
        methods:{
            handleTabChage(e){
            },
            networkSelectChange(){
                if(this.networkValue == 'all'){
                    this.network = this.dataList.network
                }else{
                    this.network = Object.values(this.dataList.network.network)[this.networkValue]
                }
            },
            handleResize() {
                this.$nextTick(() => {
                    if(this.$refs.lyecharts1){
                        this.$refs.lyecharts1.handleResize()
                    }
                })
            }
        },
    }
</script>

<style scoped>
    .space-inner{
    }
    .lycard{
        background: var(--el-bg-color);
        box-shadow: var(--el-box-shadow-light);
        border: 1px solid var(--el-border-color-light);
    }
    .lymonitor-info{
        display: flex;
        width: 100%;
        text-align: center;
        align-items: center;
        justify-content: center;
        column-gap: 5%;
        font-size: 13px;
        line-height: 20px;
    }
    .lymonitor-info .lyico-up {
        width: 12px;
        height: 12px;
        border-radius: 100%;
        background-color: #4c8ff1;
        display: inline-block;
        margin-right: 3px;

    }
    .lymonitor-info .lyico-down {
        width: 12px;
        height: 12px;
        border-radius: 100%;
        background-color: #1cd798;
        display: inline-block;
        margin-right: 3px;
    }
    /*.lymonitor-info-item{*/
    /*    flex: 1;*/
    /*}*/
</style>
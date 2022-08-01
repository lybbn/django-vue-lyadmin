<template>
    <div class="lycontainer">
        <el-scrollbar>
            <div>
                <ly-growcard :loading="showloading" :rows="2" v-model="growData"></ly-growcard>
            </div>
            <div class="echarts-inner">
                <ly-echartcard :loading="showloading" :rows="3" v-model="growData"></ly-echartcard>
            </div>
        </el-scrollbar>
    </div>
</template>

<script>
    import LyGrowcard from "../../components/analysis/growCard";
    import LyEchartcard from "../../components/analysis/echartCard";
    export default {
        name: "analysis",
        components: {LyEchartcard, LyGrowcard},
        data(){
            return{
                showloading:true,
                growData:[
                    {id:1,title:"访问数",nums:650309,totalnums:896556,icon:{
                            type:"View",
                            background:"#67c23a",
                        },
                        time:{
                            name:"日",
                            type:"success"
                        }},
                    {id:2,title:"订单数",nums:250108,totalnums:365899,icon:{
                            type:"GoodsFilled",
                            background:"#e6a23c",
                        },
                        time:{
                            name:"月",
                            type:"warning"
                        }},
                    {id:3,title:"下载数",nums:356897,totalnums:568952,icon:{
                            type:"Download",
                            background:"#409eff",
                        },
                        time:{
                            name:"周",
                            type:""
                        }},
                    {id:4,title:"成交数",nums:156889,totalnums:956889,icon:{
                            type:"WalletFilled",
                            background:"#f56c6c",
                        },
                        time:{
                            name:"年",
                            type:"danger"
                        }},
                ],
                echartsData:[

                ]
            }
        },
        created() {
            setTimeout(() => {
                this.showloading = false
            }, 1500)
        },
    }
</script>
<style lang="scss" scoped>
    .lycontainer{
        width: 100%;
        height: calc(100vh - 130px); //动态计算长度值
        /*overflow-x: hidden;*/
        /*overflow-y:auto;*/
    }
    .echarts-inner{
        margin-top: 1px;
    }
    ::v-deep(.el-scrollbar__bar.is-horizontal) {
        display: none;
    }
</style>
<template>
    <el-row :gutter="20">
        <el-col :span="24" >
            <div  class="space-inner">
                <el-tabs type="border-card" class="lycard" v-model="activeName" @tab-change="handleTabChage">
                    <el-skeleton :rows="rows" :animated="animated" :count="count" :loading="loading" style="padding: 20px;width: auto;overflow: hidden;">
                        <template #default>
                            <el-tab-pane label="订单分析" name="tab1">
                                <ly-line-echart ref="lyecharts1" v-if="activeName == 'tab1'"></ly-line-echart>
                            </el-tab-pane>
                            <el-tab-pane label="访问量" name="tab2" >
                                <ly-bar-echart ref="lyecharts2" v-if="activeName == 'tab2'"></ly-bar-echart>
                            </el-tab-pane>
                        </template>
                    </el-skeleton>
                </el-tabs>
            </div>
        </el-col>
    </el-row>
</template>

<script>
    import LyBarEchart from "@/components/analysis/barEchart.vue";
    import LyLineEchart from "@/components/analysis/lineEchart.vue";
    export default {
        name: "LyEchartcard",
        components: {LyLineEchart, LyBarEchart},
        data(){
            return{
                activeName:"tab1",
                dataList:"",
            }
        },
        created() {
            this.dataList = this.modelValue
        },
        props:{
            loading: {
                type: Boolean,
                default: true
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
              type: Array,
              default: []
            },
            height:{
                type:Number,
                default:300,
            }
        },
        watch:{
            modelValue: function(nval){
                this.dataList = nval;
            },
            dataList: function(nval) {
                this.$emit('update:modelValue', nval);
            },
        },
        methods:{
            handleTabChage(e){
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
</style>
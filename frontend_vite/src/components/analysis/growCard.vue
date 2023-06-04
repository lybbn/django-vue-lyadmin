<template>
    <el-row :gutter="20">
        <el-col :span="6" :xs="{span: 24}" :sm="{span: 24}" :md="{span: 6}" v-for="item in dataList">
            <div :style="{height:height}" class="space-inner">
                <div class="lycard">
                    <div class="space-header">
                        <div class="space-header-title">{{item.title}}</div>
                        <div class="space-header-extend-right">
                            <el-tag :type="item.time.type">
                                {{item.time.name}}
                            </el-tag>
                        </div>
                    </div>
                    <el-skeleton :rows="rows" :animated="animated" :count="count" :loading="loading" style="padding: 20px;width: auto;overflow: hidden;">
                        <template #default>
                            <div class="space-main">
                                <div class="space-main-up">
                                    <span style="font-size: 24px;">{{ item.nums }}</span>
                                    <div class="space-main-icon">
                                        <el-avatar :size="50" :icon="item.icon.type" :style="{background:item.icon.background?item.icon.background:null}" />
                                    </div>
                                </div>
                                <div class="space-main-down">
                                    <span style="font-size: 14px;margin-left: 5px">{{ "总"+item.title }}</span>
                                    <div>{{ item.totalnums }}</div>
                                </div>
                            </div>
                        </template>
                    </el-skeleton>
                </div>
            </div>
        </el-col>
    </el-row>

</template>

<script>
    export default {
        name: "LyGrowcard",
        data(){
            return{
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
            direction:{
                type:String,
                default:"horizontal",
            },
            alignment:{
                type:String,
                default:"flex-start",
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
                default:200,
            }
        },
        watch:{
            modelValue: function(nval){
                this.dataList = nval;
            },
            dataList: function(nval) {
                this.$emit('update:modelValue', nval);
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
    .space-header{
        border-bottom: 1px solid var(--el-color-info-light-7);
        font-size: 14px;
        padding: 2px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .space-header-title{
        padding: 8px 0;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
        margin-left: 10px;
    }
    .space-header-extend-right{
        padding: 8px 0;
        margin-right: 10px;
    }
    .space-main{
        padding: 20px;
    }
    .space-main-icon{
    }
    .space-main-up{
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .space-main-down{
        margin-top: 15px;
        display: flex;
        justify-content: space-between;
    }
    ::v-deep(.el-col) {
        margin-bottom: 11px;
    }
</style>
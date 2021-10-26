<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="回收员姓名：">
                    <el-input size="small" v-model.trim="formInline.name" maxlength="60"  clearable placeholder="回收员姓名" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <!--                <el-form-item label="创建时间：">-->
                <!--                    <el-date-picker-->
                <!--                            style="width:100% !important;"-->
                <!--                            v-model="timers"-->
                <!--                            size="small"-->
                <!--                            type="datetimerange"-->
                <!--                            @change="timeChange"-->
                <!--                            range-separator="至"-->
                <!--                            start-placeholder="开始日期"-->
                <!--                            end-placeholder="结束日期">-->
                <!--                    </el-date-picker>-->
                <!--                </el-form-item>-->
                <!--                v-show="isShowBtn('financeStatisticsRecycl','分销设置','Create')"-->
<!--                <el-form-item label=""><el-button size="small" @click="addModule" type="primary">新增</el-button></el-form-item>&lt;!&ndash;超管有此权限&ndash;&gt;-->
                <el-form-item label=""><el-button size="small" @click="exportData" type="primary" v-show="isShowBtn('financeStatisticsRecycl','回收员财务统计','Export')">导出</el-button></el-form-item>
            </el-form>
        </div>
        <el-table size="small" height="calc(100vh - 160px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
            <el-table-column min-width="150" prop="name" label="回收员姓名"></el-table-column>
            <el-table-column min-width="150" prop="balance" label="余额"></el-table-column>
            <el-table-column min-width="150" prop="totalamount" label="总金额"></el-table-column>
            <el-table-column min-width="100" label="状态">
                <template slot-scope="scope">
                    <el-tag v-if="scope.row.is_active">正常</el-tag>
                    <el-tag v-else type="danger">禁用</el-tag>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
            <el-table-column label="操作" fixed="right" width="180">
                <template slot-scope="scope">
                    <!--                        v-show="isShowBtn('financeStatisticsRecycl','分销设置','Update')"-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('financeStatisticsRecycl','回收员财务统计','Retrieve')">详情</span>
                </template>
            </el-table-column>
        </el-table>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module ref="addModuleFlag" @refreshData="search"></add-module>
    </div>
</template>
<script>
    import addModule from "./components/addModule";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {retrieveFinancestatisticsgetuserFinancial,retrieveFinancestatisticsExport} from '@/api/api'
    export default {
        components:{
            Pagination,
            addModule
        },
        name:'financeStatisticsRecycl',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    name:'',
                    type:1,
                    page: 1,
                    limit: 10,
                },
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                statusList:[
                    {id:1,name:'是'},
                    {id:0,name:'否'}
                ],
                tableData:[]
            }
        },
        methods:{
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增','2')
            },
            handleEdit(row,flag) {
                let vm = this
                if(flag=='detail') {
                    vm.$refs.addModuleFlag.addModuleFn(row,'详情','2')
                }
            },

            callFather(parm) {
                this.formInline.page = parm.page
                this.formInline.limit = parm.limit
                this.getData()
            },
            search() {
                this.formInline.page = 1
                this.formInline.limit = 10
                this.getData()
            },
            //获取列表
            async getData(){
                this.loadingPage = true
                 retrieveFinancestatisticsgetuserFinancial(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                 })
            },
            /**
             * 从URL里下载文件
            */
            // 下载文件
            downloadFile(url) {
                var iframe =document.createElement("iframe")
                iframe.style.display ="none";
                iframe.src = url;
                document.body.appendChild(iframe);
            },
            exportData() {
                var params = {
                    type:1,
                    page: 1,
                    limit: 9999,
                }
                retrieveFinancestatisticsExport(params).then(res => {
                     if(res.code ==2000) {
                         this.downloadFile(res.data.data)
                         //this.$message.warning(res.data.data)
                     }
                 })
            }
        },
        created() {
            this.getData()
        },
    }
</script>


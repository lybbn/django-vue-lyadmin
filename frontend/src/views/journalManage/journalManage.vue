<template>
    <div>

        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="关键词：">
                    <el-input size="small" v-model.trim="formInline.search" maxlength="60" clearable placeholder="关键词" @change="search"></el-input>
                </el-form-item>
                <el-form-item label="请求模块：">
                    <el-input size="small" v-model.trim="formInline.request_modular" maxlength="60" clearable placeholder="请求模块" @change="search"></el-input>
                </el-form-item>
                <el-form-item label="请求地址：">
                    <el-input size="small" v-model.trim="formInline.request_path" maxlength="60" clearable placeholder="请求地址" @change="search"></el-input>
                </el-form-item>
                <el-form-item label="请求方法：">
                    <el-input size="small" v-model.trim="formInline.request_method" maxlength="30" clearable placeholder="请求方法" @change="search" style="width:130px"></el-input>
                </el-form-item>
                <el-form-item label="IP地址：">
                    <el-input size="small" v-model.trim="formInline.request_ip" maxlength="60" clearable placeholder="IP地址" @change="search"></el-input>
                </el-form-item>
                <el-form-item label=""><el-button size="small" @click="deleteAlllogs" type="danger" v-show="isShowBtn('journalManage','操作日志','Delete')">全部清空</el-button></el-form-item>
            </el-form>
        </div>
        <el-table  size="small" height="calc(100vh - 260px)" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
            <el-table-column min-width="90" prop="request_modular" label="请求模块" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="120" prop="request_path" label="请求地址" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="70" prop="request_method" label="请求方法" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="80" prop="request_ip" label="IP地址" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="120" prop="request_browser" label="请求浏览器" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="200" prop="request_body" label="请求数据" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="60" prop="response_code" label="响应码" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="200" prop="json_result" label="返回信息" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="120" prop="modifier_name" label="操作人"></el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
            <el-table-column label="操作" fixed="right" width="120">
                <template slot-scope="scope">
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('journalManage','操作日志','Retrieve')">详情</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('journalManage','操作日志','Delete')">删除</span>
                </template>
            </el-table-column>
        </el-table>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <journal-manage-detail ref="journalManageDetailFlag"></journal-manage-detail>
    </div>
</template>

<script>
    import {systemOperationlog,systemOperationlogDelete,systemOperationlogDeletealllogsDelete} from '@/api/api'
    import Pagination from "@/components/Pagination";
    import journalManageDetail from "./journalManageDetail";
    export default {
        name: "journalManage",
        components:{
            Pagination,
            journalManageDetail
        },
        data() {
            return {
                loadingPage:false,
                formInline:{
                    page: 1,
                    limit: 10
                },
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                tableData:[]
            }
        },
        created() {
            this.getData()
        },
        //解决table 表格缩放错位问题
        handleResize() {
            this.$nextTick(()=> {
                this.$refs.tableref.doLayout();
            });
        },
        mounted() {
            //解决table 表格缩放错位问题
            window.addEventListener('resize', this.handleResize);
        },
        destroyed() {
            //解决table 表格缩放错位问题
             window.removeEventListener("resize", this.handleResize);
        },
        methods:{
            deleteAlllogs(){
                let vm = this
                vm.$confirm('是否确认清空全部日志数据', "警告", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning"
                }).then(function() {
                    return systemOperationlogDeletealllogsDelete().then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
            handleEdit(row,flag) {
                if(flag=='detail') {
                   this.$refs.journalManageDetailFlag.journalManageDetailFn(row)
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        systemOperationlogDelete({id:row.id}).then(res=>{
                            if(res.code == 2000) {
                                vm.$message.success(res.msg)
                                vm.search()
                            } else {
                                vm.$message.warning(res.msg)
                            }
                        })
                    }).catch(()=>{

                    })
                }
            },
            callFather(parm) {
                this.formInline.page = parm.page
                this.formInline.limit = parm.limit
                this.getData()
            },
            search() {
                this.formInline.page = 1
                this.getData()
            },
            getData() {
                this.loadingPage = true
                systemOperationlog(this.formInline).then(res => {
                    this.loadingPage = false
                    if(res.code ==2000) {
                        this.tableData = res.data.data
                        this.pageparm.page = res.data.page;
                        this.pageparm.limit = res.data.limit;
                        this.pageparm.total = res.data.total;
                    }
                })
            },
        }
    }
</script>

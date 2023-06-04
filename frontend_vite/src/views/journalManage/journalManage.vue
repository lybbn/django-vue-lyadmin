<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="关键词：">
                    <el-input size="default" v-model.trim="formInline.search" maxlength="60" style="width:160px;" clearable placeholder="关键词" @change="search"></el-input>
                </el-form-item>
                <el-form-item label="请求模块：">
                    <el-input size="default" v-model.trim="formInline.request_modular" maxlength="60" style="width:100px;" clearable placeholder="请求模块" @change="search"></el-input>
                </el-form-item>
                <el-form-item label="请求地址：">
                    <el-input size="default" v-model.trim="formInline.request_path" maxlength="60" style="width:150px;" clearable placeholder="请求地址" @change="search"></el-input>
                </el-form-item>
                <el-form-item label="请求方法：" v-if="showOtherSearch">
                    <el-input size="default" v-model.trim="formInline.request_method" maxlength="30" style="width:100px;" clearable placeholder="请求方法" @change="search"></el-input>
                </el-form-item>
                <el-form-item label="IP地址：" v-if="showOtherSearch">
                    <el-input size="default" v-model.trim="formInline.request_ip" maxlength="60" style="width:150px;" clearable placeholder="IP地址" @change="search"></el-input>
                </el-form-item>
                <el-form-item label="创建时间：" v-if="showOtherSearch">
                    <el-date-picker
                            style="width:350px"
                            v-model="timers"
                            type="datetimerange"
                            @change="timeChange"
                            range-separator="至"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                    </el-date-picker>
                </el-form-item>
                <el-form-item label=""><el-button  @click="search" type="primary" icon="Search" v-show="isShowBtn('journalManage','操作日志','Search')">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="deleteAlllogs" type="danger" v-show="isShowBtn('journalManage','操作日志','Delete')">全部清空</el-button></el-form-item>
                <el-form-item label="" @click="clickMore" v-if="!showOtherSearch">
                    <span class="lysearchmore">展开
                        <el-icon><ArrowDown /></el-icon>
                    </span>
                </el-form-item>
                <el-form-item label="" @click="clickMore" v-if="showOtherSearch">
                    <span class="lysearchmore">收起
                        <el-icon><ArrowUp /></el-icon>
                    </span>
                </el-form-item>
            </el-form>
        </div>
        <el-table  :height="'calc('+(tableHeight)+'px)'"  border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号">
                <template #default="scope">
                    <span v-text="getIndex(scope.$index)"></span>
                </template>
            </el-table-column>
            <el-table-column min-width="100" prop="request_modular" label="请求模块" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="120" prop="request_path" label="请求地址" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="100" prop="request_method" label="请求方法" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="90" prop="request_ip" label="IP地址" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="120" prop="request_browser" label="请求浏览器" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="200" prop="request_body" label="请求数据" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="70" prop="response_code" label="响应码" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="200" prop="json_result" label="返回信息" show-overflow-tooltip></el-table-column>
            <el-table-column min-width="120" prop="creator_name" label="操作人"></el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="创建时间" show-overflow-tooltip></el-table-column>
            <el-table-column label="操作" fixed="right" width="120">
                <template #header>
                    <div style="display: flex;justify-content: space-between;align-items: center;">
                        <div>操作</div>
                        <div @click="setFull">
                            <el-tooltip content="全屏" placement="bottom">
                                <el-icon ><full-screen /></el-icon>
                            </el-tooltip>
                        </div>
                    </div>
                </template>
                <template #default="scope">
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
    import Pagination from "@/components/Pagination.vue";
    import journalManageDetail from "./journalManageDetail.vue";
    import {dateFormats,getTableHeight} from "@/utils/util";
    export default {
        name: "journalManage",
        components:{
            Pagination,
            journalManageDetail
        },
        data() {
            return {
                isFull:false,
                tableHeight:500,
                loadingPage:false,
                showOtherSearch:false,//隐藏过长的搜索条件
                formInline:{
                    page: 1,
                    limit: 10
                },
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                timers:[],
                tableData:[]
            }
        },
        created() {
            this.getData()
        },
        methods:{
            setFull(){
                this.isFull=!this.isFull
                window.dispatchEvent(new Event('resize'))
            },
            // 表格序列号
            getIndex($index) {
                // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
            clickMore(){
                this.showOtherSearch = !this.showOtherSearch
                window.dispatchEvent(new Event('resize'))
            },
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
                let vm = this
                if(flag=='detail') {
                   this.$refs.journalManageDetailFlag.journalManageDetailFn(row)
                }
                else if(flag=='delete') {
                    vm.$confirm('您确定要删除选中的数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        systemOperationlogDelete({id:row.id}).then(res=>{
                            if(res.code == 2000) {
                                vm.$message.success(res.msg)
                                vm.getData()
                            } else {
                                vm.$message.warning(res.msg)
                            }
                        })
                    }).catch(()=>{

                    })
                }
                else if(flag=="reset"){
                    this.formInline = {
                        page:1,
                        limit: 10
                    }
                    this.pageparm={
                        page: 1,
                        limit: 10,
                        total: 0
                    }
                    this.timers = []
                    this.getData()
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
            timeChange(val){
                if (val) {
                    this.formInline.beginAt=dateFormats(val[0],'yyyy-MM-dd hh:mm:ss');
                    this.formInline.endAt=dateFormats(val[1],'yyyy-MM-dd hh:mm:ss');
                } else {
                    this.formInline.beginAt = null
                    this.formInline.endAt = null
                }
                this.search()
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
            // 计算搜索栏的高度
            listenResize() {
				this.$nextTick(() => {
				    this.getTheTableHeight()
				})
			},
            getTheTableHeight(){
                let tabSelectHeight = this.$refs.tableSelect?this.$refs.tableSelect.offsetHeight:0
                tabSelectHeight = this.isFull?tabSelectHeight - 110:tabSelectHeight
                this.tableHeight =  getTableHeight(tabSelectHeight)
            }
        },
        mounted() {
            // 监听页面宽度变化搜索框的高度
            window.addEventListener('resize', this.listenResize);
            this.$nextTick(() => {
              this.getTheTableHeight()
            })
        },
        unmounted() {
              // 页面销毁，去掉监听事件
            window.removeEventListener("resize", this.listenResize);
        },
    }
</script>

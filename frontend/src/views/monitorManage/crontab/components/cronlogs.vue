<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" top="20px" width="70%" :before-close="handleClose">
            <div class="tableSelect" ref="tableSelect">
                <el-form :inline="true" :model="formInline" label-position="left">
                    <el-form-item label="任务名称：">
                        <el-input size="default" v-model.trim="formInline.periodic_task_name" maxlength="60"  clearable placeholder="任务名称" @change="search" style="width:200px"></el-input>
                    </el-form-item>
                    <el-form-item label=""><el-button  @click="search" type="primary" icon="Search">查询</el-button></el-form-item>
                    <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">查看所有</el-button></el-form-item>
                </el-form>
            </div>
            <div class="table">
                <el-table  :height="500" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%">
                    <el-table-column type="index" width="60" align="center" label="序号">
                        <template #default="scope">
                            <span v-text="getIndex(scope.$index)"></span>
                        </template>
                    </el-table-column>
                    <el-table-column min-width="160" prop="task_id" label="任务ID" show-overflow-tooltip></el-table-column>
                    <el-table-column min-width="160" prop="periodic_task_name" label="任务名称" show-overflow-tooltip></el-table-column>
                    <el-table-column min-width="160" prop="task_name" label="执行方法" show-overflow-tooltip></el-table-column>
                    <el-table-column min-width="110" prop="status" label="执行状态"></el-table-column>
                    <el-table-column min-width="190" prop="result" label="执行结果" show-overflow-tooltip></el-table-column>
                    <el-table-column min-width="170" prop="date_created" label="创建时间"></el-table-column>
                    <el-table-column min-width="170" prop="date_done" label="完成时间"></el-table-column>
<!--                    <el-table-column label="操作" fixed="right" width="180">-->
<!--                        <template #header>-->
<!--                            <div style="display: flex;justify-content: space-between;align-items: center;">-->
<!--                                <div>操作</div>-->
<!--                                <div @click="setFull">-->
<!--                                    <el-tooltip content="全屏" placement="bottom">-->
<!--                                        <el-icon ><full-screen /></el-icon>-->
<!--                                    </el-tooltip>-->
<!--                                </div>-->
<!--                            </div>-->
<!--                        </template>-->
<!--                        <template #default="scope">-->
<!--                            <span class="table-operate-btn" @click="handleEdit(scope.row,'disable')" v-show="hasPermission(this.$options.name,'Disable')">-->
<!--                                <span v-if="scope.row.enabled">暂停</span>-->
<!--                                <span v-else>开启</span>-->
<!--                            </span>-->
<!--                            <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="hasPermission(this.$options.name,'Update')">编辑</span>-->
<!--                            <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="hasPermission(this.$options.name,'Delete')">删除</span>-->
<!--                            <span class="table-operate-btn" @click="handleEdit(scope.row,'logs')" v-show="hasPermission(this.$options.name,'Logs')">日志</span>-->
<!--                        </template>-->
<!--                    </el-table-column>-->
                </el-table>
            </div>
            <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
<!--            <template v-slot:footer>-->
<!--                <el-button @click="handleClose">关闭</el-button>-->
<!--            </template>-->
        </ly-dialog>
    </div>
</template>

<script>
    import Pagination from "@/components/Pagination";
    import {crontabTaskresult} from '@/api/api'
    import LyDialog from "@/components/dialog/dialog";
    export default {
        name: "cronlogs",
        components: {LyDialog,Pagination},
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingPage:false,
                loadingTitle:'',
                formInline:{
                    page: 1,
                    limit: 10,
                },
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                tableData:[],
            }
        },
        methods:{
            // 表格序列号
            getIndex($index) {
                // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.loadingPage=false
                this.loadingTitle=''
                this.formInline={
                    page: 1,
                    limit: 10,
                }
                this.pageparm={
                    page: 1,
                    limit: 10,
                    total: 0
                }
                this.tableData=[]
                // this.$emit('refreshData')
            },
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                if(item){
                    this.formInline.periodic_task_name = item
                }
                this.getData()
            },
            callFather(parm) {
                this.formInline.page = parm.page
                this.formInline.limit = parm.limit
                this.getData()
            },
            handleEdit(row,flag) {
                if(flag=="reset"){
                    this.formInline = {
                        page:1,
                        limit: 10
                    }
                    this.pageparm={
                        page: 1,
                        limit: 10,
                        total: 0
                    }
                    this.getData()
                }
            },
            search() {
                this.formInline.page = 1
                this.formInline.limit = 10
                this.getData()
            },
            //获取列表
            async getData() {
                this.loadingPage = true
                crontabTaskresult(this.formInline).then(res => {
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

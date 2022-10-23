<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="任务名称：">
                    <el-input size="default" v-model.trim="formInline.name" maxlength="60"  clearable placeholder="任务名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="" v-show="hasPermission(this.$options.name,'Search')"><el-button  @click="search" type="primary" icon="Search">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
                <el-form-item label="" v-show="hasPermission(this.$options.name,'Create')"><el-button type="primary" icon="Plus" @click="addAdmin">新增</el-button></el-form-item>
            </el-form>
        </div>
        <div class="table">
            <el-table  :height="'calc('+(tableHeight)+'px)'" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%">
                <el-table-column type="index" width="60" align="center" label="序号">
                    <template #default="scope">
                        <span v-text="getIndex(scope.$index)"></span>
                    </template>
                </el-table-column>
<!--                <el-table-column min-width="70" prop="avatar" label="用户头像">-->
<!--                    <template #default="scope">-->
<!--                        <img  :src="scope.row.avatar ? scope.row.avatar : defaultImg" style="width: 30px;height: 30px" :onerror="defaultImg" >-->
<!--                    </template>-->
<!--                </el-table-column>-->
                <el-table-column min-width="160" prop="name" label="任务名称" show-overflow-tooltip></el-table-column>
                <el-table-column min-width="160" prop="task" label="celery任务" show-overflow-tooltip></el-table-column>
                <el-table-column min-width="110" prop="crontab" label="cron表达式"></el-table-column>
                <el-table-column min-width="130" prop="description" label="备注" show-overflow-tooltip></el-table-column>
                <el-table-column min-width="100" label="状态">
                    <template #default="scope">
                        <el-tag v-if="scope.row.enabled">正常</el-tag>
                        <el-tag v-else type="danger">暂停</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="150" prop="date_changed" label="创建时间"></el-table-column>
                <el-table-column label="操作" fixed="right" width="180">
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
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'disable')" v-show="hasPermission(this.$options.name,'Disable')">
                            <span v-if="scope.row.enabled">暂停</span>
                            <span v-else>开启</span>
                        </span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="hasPermission(this.$options.name,'Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="hasPermission(this.$options.name,'Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <crontab-module  ref="moduleCrontabFlag" @refreshData="getData"></crontab-module>
    </div>
</template>

<script>
    import Pagination from "@/components/Pagination";
    import {dateFormats,getTableHeight,hasPermission} from "@/utils/util";
    import {crontabPeriodictask,crontabPeriodictaskDelete,crontabPeriodictaskEnabled} from '@/api/api'
    import {} from '@/utils/util';
    import CrontabModule from "./components/crontabModule";
    export default {
        name: "crontab",
        components: {CrontabModule, Pagination},
        data(){
            return{
                isFull:false,
                tableHeight:500,
                loadingPage:false,
                formInline:{
                    page: 1,
                    limit: 10,
                },
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                timers:[],
                tableData:[],
            }
        },
        methods:{
            // 表格序列号
            getIndex($index) {
                // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
            setFull(){
                this.isFull=!this.isFull
            },
            changeStatus(row) {
                // console.log(row,'row----')
            },
            addAdmin() {
                this.$refs.moduleCrontabFlag.addModuleFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.moduleCrontabFlag.addModuleFn(row,'编辑')
                }
                else if(flag=='disable'){
                    let params = {
                        id:row.id,
                        enabled : !row.enabled
                    }
                    crontabPeriodictaskEnabled(params).then(res=>{
                        if(res.code == 2000) {
                            this.$message.success(res.msg)
                            this.getData()
                        } else {
                            this.$message.warning(res.msg)
                        }
                    })
                }
                else if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        crontabPeriodictaskDelete({id:row.id}).then(res=>{
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
                    this.getData()
                }
            },
            /**
             * 从URL里下载文件
            */
            // 下载文件
            downloadFileURL(url) {
                var iframe =document.createElement("iframe")
                iframe.style.display ="none";
                iframe.src = url;
                document.body.appendChild(iframe);
            },
            exportDataBackend() {
                // var params = {
                //     page: 1,
                //     limit: 9999,
                // }
                // UsersUsersExportexecl(params).then(res => {
                //      if(res.code ==2000) {
                //          this.downloadFileURL(res.data.data)
                //          //this.$message.warning(res.data.data)
                //      }
                //  })
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
            async getData() {
                this.loadingPage = true
                crontabPeriodictask(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                 })
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
            // 计算搜索栏的高度
            listenResize() {
				this.$nextTick(() => {
				    this.getTheTableHeight()
				})
			},
            getTheTableHeight(){
               this.tableHeight =  getTableHeight(this.$refs.tableSelect.offsetHeight)
            }

        },
        created() {
            this.getData()
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

<style lang="scss" scoped>
    .lycontainer{
        background: var(--el-bg-color);
        padding: 10px;
        height: calc(100vh - 220px) ;
        /*background: black;*/
        /*padding: 10px;*/
    }
    ::v-deep(.el-tabs__header){
        margin: 0 0 1px;
    }
</style>
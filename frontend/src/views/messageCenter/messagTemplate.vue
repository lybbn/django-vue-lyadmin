<template>
    <div>
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="标题：">
                    <el-input size="default" v-model.trim="formInline.title" maxlength="60"  clearable placeholder="消息标题" @change="search" style="width:200px"></el-input>
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
                <!--                v-show="isShowBtn('withdrawalStatisticsUser','分销设置','Create')"-->
                <el-form-item label=""><el-button size="default" @click="addModule" type="primary">新增</el-button></el-form-item>
            </el-form>
        </div>
        <el-table  :height="'calc('+(tableHeight)+'px)'" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
            <el-table-column min-width="90" prop="code" label="模板code"></el-table-column>
            <el-table-column min-width="120" prop="title" label="模板title"></el-table-column>
<!--            <el-table-column min-width="120" prop="image" label="封面图">-->
<!--                <template #default="scope">-->
<!--                    <el-image  :src=scope.row.image :preview-src-list="[scope.row.image]" style="width: 60px;height: 60px"></el-image>-->
<!--                </template>-->
<!--            </el-table-column>-->
            <el-table-column min-width="180" prop="content" show-overflow-tooltip label="内容"></el-table-column>
<!--            <el-table-column min-width="80" prop="sort" label="排序"></el-table-column>-->
<!--            <el-table-column min-width="90" label="状态">-->
<!--                <template #default="scope">-->
<!--                    <el-tag v-if="scope.row.status">正常</el-tag>-->
<!--                    <el-tag v-else type="danger">禁用</el-tag>-->
<!--                </template>-->
<!--            </el-table-column>-->
            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
            <el-table-column label="操作" fixed="right" width="180">
                <template #default="scope">
                    <!--                        v-show="isShowBtn('dynamicsInfo','资讯动态','Update')"-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('messagTemplate','消息模板','Update')">编辑</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('messagTemplate','消息模板','Delete')">删除</span>
                </template>
            </el-table-column>
        </el-table>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module ref="addModuleFlag" @refreshData="search"></add-module>
    </div>
</template>
<script>
    import addModule from "./components/addModuleTemplate";
    import Pagination from "@/components/Pagination";
    import {dateFormats,getTableHeight} from "@/utils/util";
    import {messagesMessagetemplate,messagesMessagetemplateDelete} from '@/api/api'
    export default {
        components:{
            Pagination,
            addModule
        },
        name:'messagTemplate',
        data() {
            return {
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
                statusList:[
                    {id:1,name:'是'},
                    {id:0,name:'否'}
                ],
                tableData:[]
            }
        },
        methods:{
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增')
            },
            changeStatus(row) {
                // console.log(row,'row----')
            },
            handleEdit(row,flag) {
                let vm = this
                if(flag=='edit') {
                    vm.$refs.addModuleFlag.addModuleFn(row,'编辑')
                }
                if(flag=='delete') {
                    vm.$confirm('您确定要删除选中的内容？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        messagesMessagetemplateDelete({id:row.id}).then(res=>{
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
                this.formInline.limit = 10
                this.getData()
            },
            //获取列表
            async getData(){
                this.loadingPage = true
                 messagesMessagetemplate(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                 })
            },
            //解决table 表格缩放错位问题
            handleResize() {
                this.$nextTick(()=> {
                    this.$refs.tableref.doLayout();
                });
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
        created() {
            this.getData()
        },
        mounted() {
            //解决table 表格缩放错位问题
            window.addEventListener('resize', this.handleResize);
            // 监听页面宽度变化搜索框的高度
            window.addEventListener('resize', this.listenResize);
            this.$nextTick(() => {
              this.getTheTableHeight()
            })
        },
        unmounted() {
            //解决table 表格缩放错位问题
             window.removeEventListener("resize", this.handleResize);
              // 页面销毁，去掉监听事件
            window.removeEventListener("resize", this.listenResize);
        },
    }
</script>

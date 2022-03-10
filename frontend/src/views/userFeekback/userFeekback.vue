<template>
    <div>
<!--        <div class="tableSelect">-->
<!--            <el-form :inline="true" :model="formInline" label-position="left">-->
<!--                <el-form-item label="用户：">-->
<!--                    <el-input size="small" v-model.trim="formInline.user" maxlength="60"  clearable placeholder="用户名称" @change="search" style="width:200px"></el-input>-->
<!--&lt;!&ndash;                </el-form-item>&ndash;&gt;-->
<!--&lt;!&ndash;                                <el-form-item label="创建时间：">&ndash;&gt;-->
<!--&lt;!&ndash;                                    <el-date-picker&ndash;&gt;-->
<!--&lt;!&ndash;                                            style="width:100% !important;"&ndash;&gt;-->
<!--&lt;!&ndash;                                            v-model="timers"&ndash;&gt;-->
<!--&lt;!&ndash;                                            size="small"&ndash;&gt;-->
<!--&lt;!&ndash;                                            type="datetimerange"&ndash;&gt;-->
<!--&lt;!&ndash;                                            @change="timeChange"&ndash;&gt;-->
<!--&lt;!&ndash;                                            range-separator="至"&ndash;&gt;-->
<!--&lt;!&ndash;                                            start-placeholder="开始日期"&ndash;&gt;-->
<!--&lt;!&ndash;                                            end-placeholder="结束日期">&ndash;&gt;-->
<!--&lt;!&ndash;                                    </el-date-picker>&ndash;&gt;-->
<!--                  </el-form-item>-->
<!--&lt;!&ndash;                <el-form-item label=""><el-button size="small" @click="addAdmin" type="primary" v-show="isShowBtn('goodsClass','分类管理','Create')">新增</el-button></el-form-item>&ndash;&gt;-->
<!--&lt;!&ndash;                <el-form-item label=""><el-button size="small" @click="handleDelete" type="danger" :disabled="multiple" v-show="isShowBtn('goodsClass','分类管理','Delete')">删除</el-button></el-form-item>&ndash;&gt;-->
<!--            </el-form>-->
<!--        </div>-->

        <div class="table">
            <el-table size="small" height="calc(100vh - 280px)" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%" tooltip-effect="dark" @selection-change="handleSelectionChange">
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
<!--                <el-table-column type="selection" width="55" align="center"></el-table-column>-->
                <el-table-column min-width="100" prop="user" label="用户"></el-table-column>
                <el-table-column min-width="200" prop="message" label="反馈内容"></el-table-column>
<!--                <el-table-column min-width="100" label="状态">-->
<!--                    <template slot-scope="scope">-->
<!--                        <el-tag v-if="scope.row.status">正常</el-tag>-->
<!--                        <el-tag v-else type="danger">禁用</el-tag>-->
<!--                    </template>-->
<!--                </el-table-column>-->
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" fixed="right" width="100">
                    <template slot-scope="scope">
<!--                        v-show="isShowBtn('goodClass','分类','Delete')"-->
<!--                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('userFeekback','意见反馈','Update')">编辑</span>-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('userFeekback','意见反馈','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
    </div>
</template>
<script>
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {retrieveUserfeeckback,retrieveUserfeeckbackDelete} from '@/api/api'
    export default {
        components:{
            Pagination,
        },
        name:'userFeekback',
        data() {
            return {
                loadingPage:false,
                // 选项框选中数组
                ids: [],
                // 选项框非单个禁用
                single: true,
                // 非多个禁用
                multiple: true,
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
                    {id:1,name:'正常'},
                    {id:0,name:'禁用'}
                ],
                timers:[],
                tableData:[]
            }
        },
        methods:{
            //多选项框被选中数据
            handleSelectionChange(selection) {
                this.ids = selection.map(item => item.id);
                this.single = selection.length !== 1;
                this.multiple = !selection.length;
            },
            /** 批量删除按钮操作 */
            handleDelete(row) {
                const ids = this.ids;
                let vm = this
                vm.$confirm('是否确认删除选中的数据项?', "警告", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning"
                }).then(function() {
                    return retrieveUserfeeckbackDelete({id:ids}).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
            // addAdmin() {
            //     this.$refs.addGoodClassModuleFlag.addGoodClassModuleFn(null,'新增')
            // },
            handleEdit(row,flag) {
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的分类？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        retrieveUserfeeckbackDelete({id:row.id}).then(res=>{
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
            async getData() {
                this.loadingPage = true
                retrieveUserfeeckback(this.formInline).then(res => {
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
        },
        created() {
            this.getData()
        },
        timers(val){
            if (val) {
                this.formInline.beginAt=dateFormats(val[0],'yyyy-MM-dd hh:mm:ss');
                this.formInline.endAt=dateFormats(val[1],'yyyy-MM-dd hh:mm:ss');
            } else {
                this.formInline.beginAt = ''
                this.formInline.endAt = ''
            }
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
    }
</script>

<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="申请人：">
                    <el-input size="small" v-model.trim="formInline.user" maxlength="60"  clearable placeholder="申请人" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="额度：">
                    <el-input size="small" v-model.trim="formInline.money" maxlength="60"  clearable placeholder="额度" @change="search" style="width:200px"></el-input>
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
                <!--                v-show="isShowBtn('recyclerManage','回收员管理','Create')"-->
            </el-form>
        </div>

        <div class="table">
            <el-table size="small" height="calc(100vh - 260px)" border :data="tableData" v-loading="loadingPage" style="width: 100%" @selection-change="handleSelectionChange">
                <el-table-column type="selection" width="55"></el-table-column>
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
                <el-table-column min-width="120" prop="money" label="额度"></el-table-column>
                <el-table-column min-width="120" prop="info.name" label="申请人"></el-table-column>
                <el-table-column min-width="150" prop="info.agent" label="代理商"></el-table-column>
                <el-table-column min-width="150" prop="identity" label="身份">
                    <template slot-scope="scope">回收员</template>
                </el-table-column>
<!--                <el-table-column min-width="100" label="状态">-->
<!--                    <template slot-scope="scope">-->
<!--                         <el-tag v-if="scope.row.is_active">正常</el-tag>-->
<!--                         <el-tag v-else type="danger">禁用</el-tag>-->
<!--                    </template>-->
<!--                </el-table-column>-->
                <el-table-column min-width="100" label="状态" prop="audit_status">
<!--                <el-switch-->
<!--                    v-model="formData.is_active"-->
<!--                    active-color="#13ce66"-->
<!--                    inactive-color="#ff4949" disabled>-->
<!--                </el-switch>-->
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.audit_status==10">审核中</el-tag>
                         <el-tag v-else-if="scope.row.audit_status==20" type="success">已通过</el-tag>
                        <el-tag v-else-if="scope.row.audit_status==30" type="danger">已驳回</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" fixed="right" width="180">
                    <template slot-scope="scope">
                        <!--                        v-show="isShowBtn('recyclerManage','回收员申请额度','Update')"-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'audit')" v-show="isShowBtn('applyQuotaRecycl','回收员申请额度','Audit')" v-if="scope.row.audit_status==10">审核</span><!--超管有此权限-->
<!--                        <span class="table-operate-btn" @click="handleEdit(scope.row,'recharge')" v-show="isShowBtn('applyQuotaRecycl','回收员申请额度','Delete')">充值</span>&lt;!&ndash;代理有此权限&ndash;&gt;-->
<!--                        <span class="table-operate-btn" @click="handleEdit(scope.row,'refuse')" v-show="isShowBtn('applyQuotaRecycl','回收员申请额度','Delete')">拒绝</span>&lt;!&ndash;代理有此权限&ndash;&gt;-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('applyQuotaRecycl','回收员申请额度','Delete')">删除</span><!--超管有此权限-->
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <audit-module ref="auditModuleFlag" @refreshData="search"></audit-module>
        <add-module ref="addModuleFlag" @refreshData="search"></add-module>
    </div>
</template>
<script>
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {retrieveRecyclerapplyquotaaudit,retrieveRecyclerapplyquotaauditDelete} from '@/api/api'
    import auditModule from "./components/auditModule";
    import addModule from "./components/addModule";
    export default {
        components:{
            Pagination,
            auditModule,
            addModule
        },
        name:'applyQuotaRecycl',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    search:'',
                    status:'',
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
                tableData:[],
                selectData:[]
            }
        },
        methods:{
            handleSelectionChange(e) {
              this.selectData=e
            },
            changeStatus(row) {
                console.log(row,'row----')
            },
            handleEdit(row,flag) {
                if(flag=='audit') {
                    this.$refs.auditModuleFlag.auditModuleFn(row)
                }
                if(flag=='recharge') {
                    this.$refs.addModuleFlag.addModuleFn(row,'充值')
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除该申请记录？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        retrieveRecyclerapplyquotaauditDelete({id:row.id}).then(res=>{
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
                if(flag=='refuse') {
                    let vm = this
                    vm.$confirm('您确定要拒绝该申请记录？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        apiSystemUserDelte({id:row.id}).then(res=>{
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
                 retrieveRecyclerapplyquotaaudit(this.formInline).then(res => {
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
    }
</script>



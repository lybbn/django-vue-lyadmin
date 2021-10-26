<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="代理商名称：">
                    <el-input size="small" v-model.trim="formInline.name" maxlength="60"  clearable placeholder="代理商名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
<!--                <el-form-item label="代理区域：">-->
<!--                    <el-select size="small" v-model="formInline.is_active" placeholder="请选择" clearable style="width: 120px" @change="search">-->
<!--                        <el-option-->
<!--                                v-for="item in statusList"-->
<!--                                :key="item.id"-->
<!--                                :label="item.name"-->
<!--                                :value="item.id">-->
<!--                        </el-option>-->
<!--                    </el-select>-->
<!--                </el-form-item>-->
                <el-form-item label="手机号：">
                    <el-input size="small" v-model.trim="formInline.contact" maxlength="60"  clearable placeholder="手机号" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="证件号：">
                    <el-input size="small" v-model.trim="formInline.idcard" maxlength="60"  clearable placeholder="证件号" @change="search" style="width:200px"></el-input>
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
<!--                <el-form-item label=""><el-button size="small" @click="addAdmin" type="primary" v-show="isShowBtn('agentApply','代理商申请','Create')">新增</el-button></el-form-item>-->
            </el-form>
        </div>
        <el-table size="small" height="calc(100vh - 260px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
            <el-table-column min-width="120" prop="images3" label="头像">
                <template slot-scope="scope">
                    <el-image  :src=scope.row.images3 :preview-src-list="[scope.row.images3]" style="width: 30px;height:30px"></el-image>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="name" label="代理商名称"></el-table-column>
            <el-table-column min-width="150" prop="contact" label="手机号"></el-table-column>
            <el-table-column min-width="150" prop="idcard" label="身份证号"></el-table-column>
            <el-table-column min-width="150" prop="area" label="代理区域"></el-table-column>
            <el-table-column min-width="100" label="状态">
                <template slot-scope="scope">
                         <el-tag v-if="scope.row.audit_status==10">审核中</el-tag>
                         <el-tag v-else-if="scope.row.audit_status==20" type="success">已通过</el-tag>
                        <el-tag v-else-if="scope.row.audit_status==30" type="danger">已驳回</el-tag>

<!--                        <el-switch-->
<!--                                v-model="scope.row.is_active"-->
<!--                                active-color="#13ce66"-->
<!--                                inactive-color="#ff4949"-->
<!--                                @change="changeStatus(scope.row)">-->
<!--                        </el-switch>-->
                    </template>
            </el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
            <el-table-column label="操作" fixed="right" width="180">
                <template slot-scope="scope">
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'审核')" v-show="isShowBtn('agentApply','代理商申请','Audit')" v-if="scope.row.audit_status==10">审核</span><!--超管有这个权限-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('agentApply','代理商申请','Retrieve')">详情</span><!--超管,代理商都有有这个权限-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('agentManage','代理商管理','Delete')">删除</span><!--超管有这个权限-->
                </template>
            </el-table-column>
        </el-table>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module ref="addModuleFlag" @refreshData="search"></add-module>
        <fund-details ref="fundDetailsFlag"></fund-details>
        <audit-agent ref="auditAgentFlag" @refreshData="search"></audit-agent>
    </div>
</template>
<script>
    import addModule from "./components/addModuleApplay";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {retrieveAgentaudit,retrieveAgentauditDelete} from '@/api/api'
    import fundDetails from "./components/fundDetails";
    import auditAgent from "./components/auditAgent";
    export default {
        components:{
            fundDetails,
            Pagination,
            addModule,
            auditAgent
        },
        name:'agentApply',
        data() {
            return {
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
                    {id:1,name:'正常'},
                    {id:0,name:'禁用'}
                ],
                timers:[],
                tableData:[]
            }
        },
        methods:{
            changeStatus(row) {
                console.log(row,'row----')
            },
            addAdmin() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='detail') {
                    this.$refs.addModuleFlag.addModuleFn(row,'详情')
                }
                if(flag=='审核') {
                    this.$refs.auditAgentFlag.auditAgentFn(row)
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        retrieveAgentauditDelete({id:row.id}).then(res=>{
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
                retrieveAgentaudit(this.formInline).then(res => {
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

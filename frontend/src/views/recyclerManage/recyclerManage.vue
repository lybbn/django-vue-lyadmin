<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="回收员：">
                    <el-input size="small" v-model.trim="formInline.name" maxlength="60"  clearable placeholder="回收员" @change="search" style="width:200px"></el-input>
                </el-form-item>
<!--                <el-form-item label="代理商位置：">-->
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
                    <el-input size="small" v-model.trim="formInline.mobile" maxlength="60"  clearable placeholder="手机号" @change="search" style="width:200px"></el-input>
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
<!--                v-show="isShowBtn('recyclerManage','回收员管理','Create')"-->
<!--                <el-form-item label=""><el-button size="small" @click="addModule" type="primary">新增</el-button></el-form-item>-->
            </el-form>
        </div>

        <div class="table">
            <el-table size="small" height="calc(100vh - 260px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
                <el-table-column min-width="70" prop="avatar" label="用户头像">
                    <template slot-scope="scope">
                        <img  :src=scope.row.avatar style="width: 30px;height: 30px">
                    </template>
                </el-table-column>
                <el-table-column min-width="100" prop="name" label="回收员"></el-table-column>
                <el-table-column min-width="100" prop="mobile" label="手机号"></el-table-column>
                <el-table-column min-width="160" prop="info.idcard" label="身份证件号"></el-table-column>
                <el-table-column min-width="130" prop="balance" label="资金"></el-table-column>
                <el-table-column min-width="150" prop="info.agentaddress" label="代理商位置"></el-table-column>
                <el-table-column min-width="100" prop="info.agentname" label="代理商"></el-table-column>
                <el-table-column min-width="80" label="状态">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.is_active">正常</el-tag>
                        <el-tag v-else type="danger">禁用</el-tag>

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
<!--                        v-show="isShowBtn('recyclerManage','回收员管理','Update')"-->
<!--                        <span class="table-operate-btn" @click="handleEdit(scope.row,'audit')">审核</span>&lt;!&ndash;超管有此权限&ndash;&gt;-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'recharge')" v-show="isShowBtn('recyclerManage','回收员管理','Recharge')">充值</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('recyclerManage','回收员管理','Retrieve')">详情</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('recyclerManage','回收员管理','Delete')">删除</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'disable')" v-show="isShowBtn('recyclerManage','回收员管理','Disable')">
                        <span v-if="scope.row.is_active">禁用</span>
                            <span v-else>启用</span>
                        </span><!--超管有此权限-->
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module ref="addModuleFlag" @refreshData="search"></add-module>
        <recharge-module ref="rechargeFlag" @refreshData="search"></recharge-module>
        <audit-module ref="auditModuleFlag" @refreshData="search"></audit-module>
    </div>
</template>
<script>
    import addModule from "./components/addModule";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {retrieveRecyclerusers,retrieveRecyclerusersDelete,retrieveUsersdisableEdit} from '@/api/api'
    import RechargeModule from "./components/rechargeModule";
    import auditModule from "./components/auditModule";
    export default {
        components:{
            RechargeModule,
            Pagination,
            addModule,
            auditModule
        },
        name:'recyclerManage',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    name:'',
                    mobile:'',
                    idcard:'',
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
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='detail') {
                    this.$refs.addModuleFlag.addModuleFn(row,'详情')
                }
                if(flag=='recharge') {
                    this.$refs.rechargeFlag.rechargeFn(row)
                }
                if(flag=='disable'){
                let vm = this
                retrieveUsersdisableEdit({id:row.id}).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除该数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        retrieveRecyclerusersDelete({id:row.id}).then(res=>{
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
                 retrieveRecyclerusers(this.formInline).then(res => {
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


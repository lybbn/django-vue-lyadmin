<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="用户昵称：">
                    <el-input size="small" v-model.trim="formInline.nickname" maxlength="60"  clearable placeholder="用户昵称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="手机号：">
                    <el-input size="small" v-model.trim="formInline.mobile" maxlength="60"  clearable placeholder="手机号" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="身份：">
                    <el-select size="small" v-model="formInline.identity" placeholder="请选择" clearable style="width: 120px" @change="search">
                        <el-option
                                v-for="item in identityList"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="创建时间：">
                    <el-date-picker
                            style="width:100% !important;"
                            v-model="timers"
                            size="small"
                            type="datetimerange"
                            @change="timeChange"
                            range-separator="至"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                    </el-date-picker>
                </el-form-item>
<!--                <el-form-item label=""><el-button size="small" @click="addAdmin" type="primary" v-show="isShowBtn('userManage','用户管理','Create')">新增</el-button></el-form-item>-->
            </el-form>
        </div>

        <div class="table">
            <el-table size="small" height="calc(100vh - 260px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
                <el-table-column min-width="70" prop="avatar" label="用户头像">
                    <template slot-scope="scope">
                        <img  :src="scope.row.avatar" style="width: 30px;height: 30px" :onerror="defaultImg">
                    </template>
                </el-table-column>
                <el-table-column min-width="110" prop="nickname" label="用户昵称"></el-table-column>
                <el-table-column min-width="100" prop="mobile" label="手机号"></el-table-column>
                <el-table-column min-width="80" prop="integral" label="积分"></el-table-column>
                <el-table-column min-width="150" prop="identity" label="身份">
                    <template slot-scope="scope">
                        <span v-for='(item,index) in scope.row.identity' :key="index">
                            <label v-if="item==0">{{(index>0 && index < scope.row.identity.length?'、':'') +"普通用户"}}</label>
                            <label v-if="item==1">{{(index>0 && index < scope.row.identity.length?'、':'') +"回收员"}}</label>
                            <label v-if="item==2">{{(index>0 && index < scope.row.identity.length?'、':'') +"回收站点"}}</label>
                            <label v-if="item==3">{{(index>0 && index < scope.row.identity.length?'、':'') +"代理商"}}</label>
                        </span>
                    </template>
                </el-table-column>
                <el-table-column min-width="100" label="状态">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.is_active">正常</el-tag>
                        <el-tag v-else type="danger">禁用</el-tag>
<!--                        <el-switch-->
<!--                            v-model="scope.row.is_active"-->
<!--                            active-color="#13ce66"-->
<!--                            inactive-color="#ff4949"-->
<!--                            @change="changeStatus(scope.row)">-->
<!--                        </el-switch>-->
                    </template>
                </el-table-column>
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" fixed="right" width="180">
                    <template slot-scope="scope">
<!--                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('userManage','用户管理','Update')">详情</span>-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('userManage','用户管理','Retrieve')">详情</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('userManage','用户管理','Delete')">删除</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'disable')" v-show="isShowBtn('userManage','用户管理','Update')">
                            <span v-if="scope.row.is_active">禁用</span>
                            <span v-else>启用</span>
                        </span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-user ref="addUserFlag" @refreshData="search"></add-user>
    </div>
</template>
<script>
    import addUser from "./components/addUser";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {retrieveUsers,retrieveUsersDelete,retrieveUsersdisableEdit} from '@/api/api'
    export default {
        components:{
            Pagination,
            addUser
        },
        name:'userManage',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    page: 1,
                    limit: 10,
                },
                defaultImg:'this.src="'+require('../../assets/img/avatar.jpg')+'"',
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                statusList:[
                    {id:1,name:'正常'},
                    {id:0,name:'禁用'}
                ],
                identityList:[
                    {id:0,name:'普通用户'},
                    {id:1,name:'回收员'},
                    {id:2,name:'回收站点'},
                    {id:3,name:'代理商'},
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
                this.$refs.addUserFlag.addUserFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addUserFlag.addUserFn(row,'详情')
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
                    vm.$confirm('您确定要删除选中的数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        retrieveUsersDelete({id:row.id}).then(res=>{
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
                retrieveUsers(this.formInline).then(res => {
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

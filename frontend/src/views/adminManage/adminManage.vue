<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="管理员名称：">
                    <el-input size="small" v-model.trim="formInline.name" maxlength="60"  clearable placeholder="管理员名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="管理员账号：">
                    <el-input size="small" v-model.trim="formInline.username" maxlength="60"  clearable placeholder="管理员账号" @change="search" style="width:200px"></el-input>
                </el-form-item>
<!--                <el-form-item label="权限字符：">-->
<!--                    <el-input size="small" v-model.trim="formInline.name" maxlength="60" placeholder="权限字符" @change="search" style="width:200px"></el-input>-->
<!--                </el-form-item>-->
                <el-form-item label="状态：">
                    <el-select size="small" v-model="formInline.is_active" placeholder="请选择" clearable style="width: 120px" @change="search">
                        <el-option
                                v-for="item in statusList"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                        </el-option>
                    </el-select>
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
                <el-form-item label=""><el-button size="small" @click="addAdmin" type="primary" v-show="isShowBtn('adminManage','管理员管理','Create')">新增</el-button></el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table size="small" height="calc(100vh - 260px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
                <!--<el-table-column min-width="150" prop="id" label="管理员编号" show-overflow-tooltip></el-table-column>-->
                <el-table-column min-width="120" prop="name" label="管理员名称"></el-table-column>
                <el-table-column min-width="150" prop="username" label="管理员账号"></el-table-column>
                <el-table-column min-width="100" prop="rolekey" label="权限字符">
                    <template slot-scope="scope">
                        <span v-for='(item,index) in scope.row.rolekey' :key="index">
                                {{(index>0 && index < scope.row.rolekey.length?'、':'') + item.key}}
                        </span>
                    </template>
                </el-table-column>
                <!--<el-table-column min-width="100" prop="name" label="显示排序"></el-table-column>-->
                <el-table-column min-width="100" label="状态">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.is_active">正常</el-tag>
                        <el-tag v-else type="danger">禁用</el-tag>

                    </template>
                </el-table-column>
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作"  width="100">
                    <template slot-scope="scope">
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('adminManage','管理员管理','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('adminManage','管理员管理','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-admin ref="addAdminFlag" @refreshData="search"></add-admin>
    </div>
</template>
<script>
    import addAdmin from "./components/addAdmin";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {apiSystemUser,apiSystemUserDelte} from '@/api/api'
    export default {
        components:{
            Pagination,
            addAdmin
        },
        name:'adminManage',
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
                tableData:[]
            }
        },
        methods:{
            addAdmin() {
                this.$refs.addAdminFlag.addAdminFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addAdminFlag.addAdminFn(row,'编辑')
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的管理员？',{
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
                 apiSystemUser(this.formInline).then(res => {
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

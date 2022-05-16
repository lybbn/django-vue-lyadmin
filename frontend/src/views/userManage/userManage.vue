<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="用户名称：">
                    <el-input size="small" v-model.trim="formInline.username" maxlength="60"  clearable placeholder="用户名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="手机号：">
                    <el-input size="small" v-model.trim="formInline.mobile" maxlength="60"  clearable placeholder="手机号" @change="search" style="width:200px"></el-input>
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
                <el-form-item label=""><el-button size="small" @click="addAdmin" type="primary" v-show="isShowBtn('userManage','用户管理','Create')">新增</el-button></el-form-item>
                <el-form-item label=""><el-button size="small" @click="exportDataBackend" type="primary">导出</el-button></el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table size="small" height="calc(100vh - 280px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
                <el-table-column min-width="70" prop="avatar" label="用户头像">
                    <template slot-scope="scope">
                        <img  :src="scope.row.avatar ? scope.row.avatar : defaultImg" style="width: 30px;height: 30px" :onerror="defaultImg">
                    </template>
                </el-table-column>
                <el-table-column min-width="110" prop="username" label="用户名"></el-table-column>
                <el-table-column min-width="110" prop="nickname" label="用户昵称"></el-table-column>
                <el-table-column min-width="100" prop="mobile" label="手机号"></el-table-column>
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
                <el-table-column label="操作" width="180">
                    <template slot-scope="scope">
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('userManage','用户管理','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('userManage','用户管理','Retrieve')">详情</span>
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
        <user-detail ref="userDetailFlag"></user-detail>
    </div>
</template>
<script>
    import addUser from "./components/addUser";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {UsersUsers,UsersUsersDelete,UsersUsersdisableEdit,UsersUsersExportexecl} from '@/api/api'
    import UserDetail from "./components/userDetail";
    export default {
        components:{
            UserDetail,
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
                defaultImg:"this.src='"+require('../../assets/img/avatar.jpg')+"'",
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
                    {id:1,name:'会员'},
                ],
                timers:[],
                tableData:[]
            }
        },
        methods:{
            changeStatus(row) {
                // console.log(row,'row----')
            },
            addAdmin() {
                this.$refs.addUserFlag.addUserFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addUserFlag.addUserFn(row,'编辑')
                }
                if(flag=='detail') {
                    this.$refs.userDetailFlag.addUserFn(row,'详情')
                }
                if(flag=='disable'){
                    let vm = this
                    UsersUsersdisableEdit({id:row.id}).then(res=>{
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
                        UsersUsersDelete({id:row.id}).then(res=>{
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
            /**
             * 从URL里下载文件,参数files为el-upload上传的文件file
            */
            downloadFile(files) {
                //url转blob
                fetch(files.url)
                .then(response => response.blob())
                .then(blob => {
                    // 处理blob
                    let url = window.URL.createObjectURL(new Blob([blob]))
                    let link = document.createElement('a')
                    link.style.display = 'none'
                    link.href = url
                    // link.download = url.split('/')[url.split('/').length -1] //  // 下载文件的名字
                    if(typeof files.name == "undefined"){
                        link.download = url.split('/')[url.split('/').length -1]
                    }else{
                        link.download = files.name
                    }
                    document.body.appendChild(link)
                    link.click()
                    document.body.removeChild(link) // 下载完成移除元素
                    window.URL.revokeObjectURL(url) // 释放掉blob对象

                })

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
                var params = {
                    page: 1,
                    limit: 9999,
                }
                UsersUsersExportexecl(params).then(res => {
                     if(res.code ==2000) {
                         this.downloadFileURL(res.data.data)
                         //this.$message.warning(res.data.data)
                     }
                 })
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
                UsersUsers(this.formInline).then(res => {
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

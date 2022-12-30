<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="用户昵称：">
                    <el-input size="default" v-model.trim="formInline.nickname" maxlength="60"  clearable placeholder="用户昵称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="手机号：">
                    <el-input size="default" v-model.trim="formInline.mobile" maxlength="60"  clearable placeholder="手机号" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="创建时间：">
                    <el-date-picker
                            style="width:350px"
                            v-model="timers"
                            type="datetimerange"
                            @change="timeChange"
                            range-separator="至"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                    </el-date-picker>
                </el-form-item>
                <el-form-item label=""><el-button  @click="search" type="primary" icon="Search" v-show="isShowBtn('userManage','用户管理','Search')">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="addAdmin" type="primary" icon="Plus" v-show="isShowBtn('userManage','用户管理','Create')">新增</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="exportDataBackend" type="primary">导出</el-button></el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table  :height="'calc('+(tableHeight)+'px)'" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%">
                <el-table-column type="index" width="60" align="center" label="序号">
                    <template #default="scope">
                        <span v-text="getIndex(scope.$index)"></span>
                    </template>
                </el-table-column>
                <el-table-column min-width="70" prop="avatar" label="用户头像">
                    <template #default="scope">
                        <img  :src="scope.row.avatar ? scope.row.avatar : defaultImg" style="width: 30px;height: 30px" :onerror="defaultImg" >
                    </template>
                </el-table-column>
                <el-table-column min-width="110" prop="username" label="用户名"></el-table-column>
                <el-table-column min-width="110" prop="nickname" label="用户昵称"></el-table-column>
                <el-table-column min-width="100" prop="mobile" label="手机号"></el-table-column>
                <el-table-column min-width="100" label="状态">
                    <template #default="scope">
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
        <add-user ref="addUserFlag" @refreshData="getData"></add-user>
        <user-detail ref="userDetailFlag"></user-detail>
    </div>
</template>
<script>
    import addUser from "./components/addUser";
    import Pagination from "@/components/Pagination";
    import {dateFormats,getTableHeight} from "@/utils/util";
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
                isFull:false,
                tableHeight:500,
                loadingPage:false,
                formInline:{
                    page: 1,
                    limit: 10,
                },
                defaultImg:require('../../assets/img/avatar.jpg'),
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
            // 表格序列号
            getIndex($index) {
                // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
            setFull(){
                this.isFull=!this.isFull
                window.dispatchEvent(new Event('resize'))
            },
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
                else if(flag=='detail') {
                    this.$refs.userDetailFlag.addUserFn(row,'详情')
                }
                else if(flag=='disable'){
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
                else if(flag=='delete') {
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

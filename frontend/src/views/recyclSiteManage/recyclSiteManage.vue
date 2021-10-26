<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="站点名称：">
                    <el-input size="small" v-model.trim="formInline.sitename" maxlength="60"  clearable placeholder="站点名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="站点位置：">
                    <el-select size="small" v-model="formInline.is_active" placeholder="请选择" clearable style="width: 120px" @change="search">
                        <el-option
                                v-for="item in statusList"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="站点员：">
                    <el-input size="small" v-model.trim="formInline.user" maxlength="60"  clearable placeholder="站点员" @change="search" style="width:200px"></el-input>
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
                <!--                v-show="isShowBtn('recyclerManage','回收站点管理','Create')"-->
                <el-form-item label=""><el-button size="small" @click="addModule" type="primary" v-show="isShowBtn('recyclSiteManage','回收站点管理','Create')">新增</el-button></el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table size="small" height="calc(100vh - 260px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
                <el-table-column min-width="120" prop="sitename" label="站点名称"></el-table-column>
                <el-table-column min-width="70" prop="avatar" label="头像">
                    <template slot-scope="scope">
                        <img  :src=scope.row.info.avatar style="width: 30px;height: 30px">
                    </template>
                </el-table-column>
                <el-table-column min-width="100" prop="info.name" label="站点员"></el-table-column>
                <el-table-column min-width="130" prop="info.mobile" label="手机号"></el-table-column>
                <el-table-column min-width="200" prop="info.areas" label="站点位置" show-overflow-tooltip></el-table-column>

                <el-table-column min-width="100" label="状态">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.status">正常</el-tag>
                        <el-tag v-else type="danger">禁用</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" fixed="right" width="180">
                    <template slot-scope="scope">
                        <!--                        v-show="isShowBtn('recyclSiteManage','回收站点管理','Update')"-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'btnOff')" v-show="isShowBtn('recyclSiteManage','回收站点管理','Disable')">
                            <span v-if="scope.row.status">冻结</span>
                            <span v-else>解冻</span>
                        </span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('recyclSiteManage','回收站点管理','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('recyclSiteManage','回收站点管理','Retrieve')">详情</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('recyclSiteManage','回收站点管理','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
<!--        <audit-module ref="auditModuleFlag" @refreshData="search"></audit-module>-->
        <add-module ref="addModuleFlag" @refreshData="search"></add-module>
    </div>
</template>
<script>
    import addModule from "./components/addModuleNew";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {retrieveRecyclingsite,retrieveRecyclingsiteDelete,retrieveSiteDisablesiter} from '@/api/api'
    export default {
        components:{
            Pagination,
            addModule
        },
        name:'recyclSiteManage',
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
                    {id:1,name:'是'},
                    {id:0,name:'否'}
                ],
                timers:[],
                tableData:[]
            }
        },
        methods:{
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增')
            },
            changeStatus(row) {
                console.log(row,'row----')
            },
            handleEdit(row,flag) {
                let vm = this
                if(flag=='edit') {
                    vm.$refs.addModuleFlag.addModuleFn(row,'编辑')
                }
                if(flag=='detail') {
                    vm.$refs.addModuleFlag.addModuleFn(row,'详情')
                }
                if(flag=='btnOff') {
                    vm.$confirm('您确定要冻结该站点？',{
                        closeOnClickModal:false
                    }).then(obj=>{
                        retrieveSiteDisablesiter({id:row.id}).then(res=>{
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
                if(flag=='delete') {
                    vm.$confirm('您确定要删除选中的站点？',{
                        closeOnClickModal:false
                    }).then(obj=>{
                        retrieveRecyclingsiteDelete({id:row.id}).then(res=>{
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
                 retrieveRecyclingsite(this.formInline).then(res => {
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




<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="用户昵称：">
                    <el-input v-model.trim="formInline.nickname" maxlength="60"  clearable placeholder="用户昵称" @change="search" style="width:200px"></el-input>
<!--                </el-form-item>-->
<!--                                <el-form-item label="创建时间：">-->
<!--                                    <el-date-picker-->
<!--                                            style="width:350px"-->
<!--                                            v-model="timers"-->
<!--                                            size="small"-->
<!--                                            type="datetimerange"-->
<!--                                            @change="timeChange"-->
<!--                                            range-separator="至"-->
<!--                                            start-placeholder="开始日期"-->
<!--                                            end-placeholder="结束日期">-->
<!--                                    </el-date-picker>-->
                  </el-form-item>
                <el-form-item label="手机号：">
                    <el-input  v-model.trim="formInline.mobile" maxlength="60"  clearable placeholder="手机号" @change="search" style="width:200px"></el-input>
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
                <el-form-item label=""><el-button  @click="search" type="primary" icon="Search" v-show="isShowBtn('userFeekback','意见反馈','Search')">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleDelete" type="danger" :disabled="multiple" v-show="isShowBtn('userFeekback','意见反馈','Delete')">删除</el-button></el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table :height="tableHeight"  border :data="tableData" v-loading="loadingPage" ref="tableref" style="width: 100%" tooltip-effect="dark" @selection-change="handleSelectionChange">
                <el-table-column type="selection" width="60" align="center"></el-table-column>
                <el-table-column type="index" width="60" align="center" label="序号">
                    <template #default="scope">
                        <span v-text="getIndex(scope.$index)"></span>
                    </template>
                </el-table-column>
<!--                <el-table-column type="selection" width="55" align="center"></el-table-column>-->
                <el-table-column min-width="70" prop="avatar" label="用户头像">
                    <template #default="scope">
                        <img  :src="scope.row.avatar ? scope.row.avatar : defaultImg" style="width: 30px;height: 30px" :onerror="defaultImg">
                    </template>
                </el-table-column>
                <el-table-column min-width="100" prop="nickname" label="用户"></el-table-column>
                <el-table-column min-width="100" prop="mobile" label="手机号"></el-table-column>
                <el-table-column min-width="200" prop="message" label="反馈内容" show-overflow-tooltip=""></el-table-column>
<!--                <el-table-column min-width="100" label="状态">-->
<!--                    <template slot-scope="scope">-->
<!--                        <el-tag v-if="scope.row.status">正常</el-tag>-->
<!--                        <el-tag v-else type="danger">禁用</el-tag>-->
<!--                    </template>-->
<!--                </el-table-column>-->
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" width="100">
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
<!--                        v-show="isShowBtn('goodClass','分类','Delete')"-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('userFeekback','意见反馈','Retrieve')">详情</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('userFeekback','意见反馈','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module ref="addModuleFlag"></add-module>
    </div>
</template>
<script>
    import Pagination from "@/components/Pagination.vue";
    import {dateFormats} from "@/utils/util";
    import {PlatformsettingsUserfeeckback,PlatformsettingsUserfeeckbackDelete} from '@/api/api'
    import AddModule from "./components/addModule.vue";
    import { lyMixins } from "@/mixins/mixins"
    import avatarimg from "@/assets/img/avatar.jpg";
    export default {
        mixins: [lyMixins],
        components:{
            AddModule,
            Pagination,
        },
        name:'userFeekback',
        data() {
            return {
                isFull:false,
                loadingPage:false,
                // 选项框选中数组
                ids: [],
                // 选项框非单个禁用
                single: true,
                // 非多个禁用
                multiple: true,
                defaultImg:avatarimg,
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
            setFull(){
                this.isFull=!this.isFull
                window.dispatchEvent(new Event('resize'))
            },
            // 表格序列号
            getIndex($index) {
                // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
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
                    return PlatformsettingsUserfeeckbackDelete({id:ids}).then(res=>{
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
                if(flag=='detail') {
                    this.$refs.addModuleFlag.addModuleFn(row,'详情')
                }
                else if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的分类？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        PlatformsettingsUserfeeckbackDelete({id:row.id}).then(res=>{
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
                    this.timers = []
                    this.getData()
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
                PlatformsettingsUserfeeckback(this.formInline).then(res => {
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

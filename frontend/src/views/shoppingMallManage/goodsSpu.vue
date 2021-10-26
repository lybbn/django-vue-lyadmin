<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="SPU名称：">
                    <el-input size="small" v-model.trim="formInline.name" maxlength="60"  clearable placeholder="SPU名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
<!--                                <el-form-item label="创建时间：">-->
<!--                                    <el-date-picker-->
<!--                                            style="width:100% !important;"-->
<!--                                            v-model="timers"-->
<!--                                            size="small"-->
<!--                                            type="datetimerange"-->
<!--                                            @change="timeChange"-->
<!--                                            range-separator="至"-->
<!--                                            start-placeholder="开始日期"-->
<!--                                            end-placeholder="结束日期">-->
<!--                                    </el-date-picker>-->
<!--                                </el-form-item>-->
<!--                <el-form-item label=""><el-button size="small" @click="addAdmin" type="primary" v-show="isShowBtn('goodsSpu','商品SPU','Create')">新增</el-button></el-form-item>-->
<!--                <el-form-item label=""><el-button size="small" @click="handleDelete" type="danger" :disabled="multiple" v-show="isShowBtn('goodsSpu','商品SPU','Delete')">删除</el-button></el-form-item>-->
            </el-form>
        </div>

        <div class="table">
            <el-table size="small" height="calc(100vh - 260px)" border :data="tableData" v-loading="loadingPage" style="width: 100%" tooltip-effect="dark" @selection-change="handleSelectionChange">
<!--                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>-->
                <el-table-column type="selection" width="55" align="center"></el-table-column>
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
<!--                <el-table-column min-width="120" prop="sort" label="排序"></el-table-column>-->
                <el-table-column min-width="150" prop="name" label="SPU名称"></el-table-column>
                <el-table-column min-width="150" prop="category1_name" label="分类名称"></el-table-column>
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
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('goodsSpu','商品SPU','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('goodsSpu','商品SPU','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <addModule ref="addModuleFlag" @refreshData="search"></addModule>
    </div>
</template>
<script>
    import addModule from "./components/addModuleSpu";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {mallGoodspu,mallGoodspuDelete} from '@/api/api'
    export default {
        components:{
            Pagination,
            addModule
        },
        name:'goodsSpu',
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
                    return mallGoodspuDelete({id:ids}).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
            addAdmin() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addModuleFlag.addModuleFn(row,'编辑')
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的分类？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        mallGoodspuDelete({id:row.id}).then(res=>{
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
                mallGoodspu(this.formInline).then(res => {
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

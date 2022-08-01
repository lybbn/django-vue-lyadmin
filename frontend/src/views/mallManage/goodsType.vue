<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="分类名称：">
                    <el-input v-model.trim="formInline.search" maxlength="60"  clearable placeholder="分类名称" @change="search" style="width:200px"></el-input>
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
                <el-form-item label=""><el-button @click="search" type="primary" icon="Search" v-show="isShowBtn('goodsType','商品分类','Search')">查询</el-button></el-form-item>
                <el-form-item label=""><el-button @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
                <el-form-item label=""><el-button @click="addModule" type="primary" v-show="isShowBtn('goodsType','商品分类','Create')">新增</el-button></el-form-item>
                <el-form-item label=""><el-button @click="handleDelete" type="danger" :disabled="multiple" v-show="isShowBtn('goodsType','商品分类','Delete')">删除</el-button></el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table :height="tableHeight" border :data="tableData" v-loading="loadingPage" style="width: 100%" ref="tableref"
                      @selection-change="handleSelectionChange" row-key="id" :tree-props="{children: 'children', hasChildren: 'hasChildren'}">
<!--                <el-table-column type="selection" width="55"></el-table-column>-->
                <el-table-column type="selection" width="60" align="center"></el-table-column>
                <el-table-column type="index" width="60" align="center" label="序号">
                    <template #default="scope">
                        <span v-text="getIndex(scope.$index)"></span>
                    </template>
                </el-table-column>
                <el-table-column min-width="100" prop="name" label="分类名称"></el-table-column>
                <el-table-column min-width="60" sortable prop="sort" label="排序"></el-table-column>
                <el-table-column min-width="80" prop="default_image" label="图标">
                    <template #default="scope">
                        <el-image  :src="scope.row.default_image" style="width: 30px;height:30px" :preview-src-list="[scope.row.default_image]" v-if="scope.row.default_image"></el-image>
                    </template>
                </el-table-column>
<!--                <el-table-column min-width="100" label="状态" prop="status">-->
<!--                    <template slot-scope="scope">-->
<!--                        <el-tag v-if="scope.row.status" size="small">正常</el-tag>-->
<!--                        <el-tag v-else type="danger" size="small">禁用</el-tag>-->
<!--                    </template>-->
<!--                </el-table-column>-->
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作"  width="180">
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
<!--                        <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('viptypeManage','会员卡管理','Retrieve')">详情</span>-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('goodsType','商品分类','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('goodsType','商品分类','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module-goods-type ref="addModuleFlag" @refreshData="search"></add-module-goods-type>
    </div>
</template>
<script>
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {mallGoodstype,mallGoodstypeDelete} from '@/api/api'
    import XEUtils from "xe-utils";
    import AddModuleGoodsType from "./components/addModuleGoodsType";
    import { lyMixins } from "@/mixins/mixins"
    export default {
        mixins: [lyMixins],
        components:{
            AddModuleGoodsType,
            Pagination,
        },
        name:'goodsType',
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
                formInline:{
                    search:'',
                    page: 1,
                    limit: 100,
                },
                pageparm: {
                    page: 1,
                    limit: 100,
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
            setFull(){
                this.isFull=!this.isFull
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
                    return mallGoodstypeDelete({id:ids}).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
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
                else if(flag=='edit') {
                    this.$refs.addModuleFlag.addModuleFn(row,'编辑')
                }
                else if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        mallGoodstypeDelete({id:row.id}).then(res=>{
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

            callFather(parm) {
                this.formInline.page = parm.page
                this.formInline.limit = parm.limit
                this.getData()
            },
            search() {
                this.formInline.page = 1
                this.formInline.limit = 100
                this.getData()
            },
            //获取列表
            async getData(){
                this.loadingPage = true
                 mallGoodstype(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         // // 将列表数据转换为树形数据
                         // this.tableData = XEUtils.toArrayTree(res.data.data, { parentKey: 'parent', strict: false })
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




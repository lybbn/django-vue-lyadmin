<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="商品名称：">
                    <el-input v-model.trim="formInline.search" maxlength="60"  clearable placeholder="商品名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="商品分类：">
                    <el-select v-model="formInline.category1" placeholder="请选择" filterable clearable @change="search">
                        <el-option
                                v-for="item in categoryList"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="状态：">
                    <el-select v-model="formInline.is_launched" placeholder="请选择" clearable style="width: 120px" @change="search">
                        <el-option
                                v-for="item in islaunchedList"
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
                <!--                </el-form-item> v-show="isShowBtn('shoppingMallGoodsManage','用户管理','Create')"-->
                <el-form-item label=""><el-button  @click="search" type="primary" icon="Search" v-show="isShowBtn('goodsManage','商品管理','Search')">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="addModule" type="primary" v-show="isShowBtn('goodsManage','商品管理','Create')">新增</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleDelete" type="danger" :disabled="multiple" v-show="isShowBtn('goodsManage','商品管理','Delete')">删除</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleDisable" type="info" :disabled="multiple" v-show="isShowBtn('goodsManage','商品管理','Disable')">批量下架</el-button></el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table :height="tableHeight" border :data="tableData" v-loading="loadingPage" ref="tableref" style="width: 100%" @selection-change="handleSelectionChange">
                <el-table-column type="selection" width="60" align="center"></el-table-column>
                <el-table-column type="index" width="60" align="center" label="序号">
                    <template #default="scope">
                        <span v-text="getIndex(scope.$index)"></span>
                    </template>
                </el-table-column>
                <el-table-column min-width="80" prop="default_image" label="主图">
                    <template #default="scope">
                        <el-image  :src=scope.row.default_image :preview-src-list="[scope.row.default_image]" :preview-teleported="true" style="width: 40px;height: 40px"></el-image>
                    </template>
                </el-table-column>
                <el-table-column min-width="120" prop="name" label="商品名称" show-overflow-tooltip></el-table-column>
                <el-table-column min-width="80" prop="category1_name" label="所属分类"></el-table-column>
                <el-table-column min-width="80" prop="price" label="售价"></el-table-column>
                <el-table-column min-width="60" prop="stock" label="库存"></el-table-column>
                <el-table-column min-width="60" prop="is_tuijian" label="是否推荐">
                    <template #default="scope">
                         <span v-if="scope.row.is_tuijian">是</span>
                         <span v-else >否</span>
                    </template>
                </el-table-column>
                <el-table-column min-width="60" sortable prop="sort" label="排序"></el-table-column>
                <el-table-column min-width="60" label="状态">
                    <template #default="scope">
                         <el-tag v-if="scope.row.is_launched">上架</el-tag>
                         <el-tag v-else type="danger">下架</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" fixed="right" width="150">
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
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'status')" v-show="isShowBtn('goodsManage','商品管理','Disable')">
                            <span v-if="scope.row.is_launched">下架</span>
                            <span v-else>上架</span>
                        </span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('goodsManage','商品管理','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('goodsManage','商品管理','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module-goods-manage ref="addModuleFlag" @refreshData="search"></add-module-goods-manage>

    </div>
</template>
<script>
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {mallGoodsspu,mallGoodsspuDelete,mallGoodsspuIslaunched,mallGoodstype} from '@/api/api'
    import AddModuleGoodsManage from "./components/addModuleGoodsManage";
    import { lyMixins } from "@/mixins/mixins"
    export default {
        mixins: [lyMixins],
        components:{
            AddModuleGoodsManage,
            Pagination,
        },
        name:'goodsManage',
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
                islaunchedList:[
                    {id:1,name:'上架'},
                    {id:0,name:'下架'}
                ],
                timers:[],
                tableData:[],
                categoryList:[]
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
                    return mallGoodsspuDelete({id:ids}).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
             /** 批量下架按钮操作 */
            handleDisable(row) {
                const ids = this.ids;
                let vm = this
                vm.$confirm('是否确认下架/上架选中的数据项?', "警告", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning"
                }).then(function() {
                    return mallGoodsspuIslaunched({id:ids}).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增',this.categoryList)
            },
            handleEdit(row,flag) {
                if(flag=='status'){
                    let vm = this
                    var titext = ""
                    if(row.is_launched){
                        titext = "您确定要下架操作吗？"
                    }else{
                        titext = "您确定要上架操作吗？"
                    }
                    vm.$confirm(titext,{
                        closeOnClickModal:false
                    }).then(res=>{
                        mallGoodsspuIslaunched({id:row.id}).then(res=>{
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
                else if(flag=='edit') {
                    this.$refs.addModuleFlag.addModuleFn(row,'编辑',this.categoryList)
                }
                else if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        mallGoodsspuDelete({id:row.id}).then(res=>{
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
                this.formInline.limit = 10
                this.getData()
            },
            //获取列表
            async getData() {
                this.loadingPage = true
                mallGoodsspu(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                 })
            },
            //获取商品分类列表
            getMallGoodscategoryList(){
                let param = {
                    page: 1,
                    limit: 9999,
                }
                mallGoodstype(param).then(res => {
                    if(res.code ==2000) {
                        this.categoryList = res.data.data
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
            this.getMallGoodscategoryList()
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


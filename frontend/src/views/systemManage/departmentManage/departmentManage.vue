<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="关键词：">
                    <el-input size="default" v-model.trim="formInline.search" maxlength="60" placeholder="关键词" clearable @change="getData" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="状态：">
                    <el-select v-model="formInline.status" placeholder="请选择" clearable @change="getData" size="default" style="width:100px">
                        <el-option
                            v-for="item in statusList"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label=""><el-button  @click="getData" type="primary" icon="Search" v-show="isShowBtn('departmentManage','部门管理','Search')">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
                <el-form-item label="">
                    <el-button icon="Plus" type="primary" @click="addDepart" v-show="isShowBtn('departmentManage','部门管理','Create')">新增</el-button>
                </el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table
                :max-height="tableHeight"
                border
                row-key="id"
                :data="tableData"
                ref="tableref"
                v-loading="loadingPage"
                style="width: 100%"
                :tree-props="{children: 'children', hasChildren: 'hasChildren'}">
                <el-table-column type="index" width="70" label="序号">
                    <template #default="scope">
                        <span v-text="getIndex(scope.$index)"></span>
                    </template>
                </el-table-column>
                <el-table-column min-width="180" prop="name" label="部门名称"></el-table-column>
                <el-table-column min-width="100" prop="namer" label="负责人"></el-table-column>
                <el-table-column min-width="120" prop="mobile" label="联系电话"></el-table-column>
                <el-table-column min-width="120" prop="email" label="邮箱"></el-table-column>
                <el-table-column min-width="90"  label="状态">
                    <template #default="scope">
                        <el-tag v-if="scope.row.status==1" type="">启用</el-tag>
                        <el-tag v-else type="danger">禁用</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="80" prop="sort" label="排序"></el-table-column>
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
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('departmentManage','部门管理','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('departmentManage','部门管理','Retrieve')">详情</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('departmentManage','部门管理','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>

        <add-department ref="addDepartmentFlag"  @refreshData="getData"></add-department>
    </div>
</template>
<script>
    import AddDepartment from "./components/addDepartment";
    import {apiSystemDept,apiSystemDeptDelete} from '@/api/api'
    import {dateFormats,getTableHeight} from "@/utils/util";
    import XEUtils from 'xe-utils'
    export default {
        components:{
            AddDepartment,
        },
        name:'departmentManage',
        data() {
            return {
                isFull:false,
                tableHeight:260,
                loadingPage:false,
                formInline:{
                    search:'',
                    name:'',
                    status:'',
                    page:1,
                    limit:9999
                },
                pageparm:{
                    page: 1,
                    limit: 10,
                    total: 0
                },
                tableData:[],
                statusList:[
                    {id:1,name:'启用'},
                    {id:0,name:'禁用'},
                ]
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
            },
            addDepart() {
                this.$refs.addDepartmentFlag.addDepartmentFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addDepartmentFlag.addDepartmentFn(row,'编辑')
                }
                else if(flag == 'detail') {
                    this.$refs.addDepartmentFlag.addDepartmentFn(row,'详情')
                }
                else if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的部门？',{
                        closeOnClickModal:false
                    }).then(()=>{
                        apiSystemDeptDelete({id:row.id}).then(res=>{
                            if(res.code == 2000) {
                                vm.$message.success(res.msg)
                                vm.getData()
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
                        limit: 9999
                    }
                    this.pageparm={
                        page: 1,
                        limit: 10,
                        total: 0
                    }
                    this.getData()
                }
            },
            //获取列表
            async getData(){
                this.loadingPage = true
                apiSystemDept(this.formInline).then(async res => {
                     this.loadingPage = false
                     if(res.code == 2000) {
                         // let childrenList = res.data.data.filter(item=> item.parent)
                         // console.log(childrenList)
                         // let parentList = res.data.data.filter(item=> !item.parent)
                         // console.log(parentList)
                         //    if(parentList.length >0) {
                         //        parentList.forEach(item=>{
                         //            let children = childrenList.filter(itema=>itema.parent == item.id)
                         //            item.children=[...children]
                         //            console.log(children)
                         //        })
                         //    }
                         // this.tableData = parentList
                         // 将列表数据转换为树形数据
                         this.tableData = XEUtils.toArrayTree(res.data.data, { parentKey: 'parent', strict: false })
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     } else {
                         this.$message.warning(res.msg)
                     }
                 })
            },
            // 计算搜索栏的高度
            listenResize() {
				this.$nextTick(() => {
				    this.getTheTableHeight()
				})
			},
            getTheTableHeight(){
                this.tableHeight =  getTableHeight(this.$refs.tableSelect.offsetHeight-70)

            },
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
<style lang="scss" scoped>
    .tableNav{
        overflow: hidden;
        margin-bottom: 20px;
    }
    /*::v-deep(.el-table__placeholder){*/
    /*    display: unset;*/
    /*}*/
</style>
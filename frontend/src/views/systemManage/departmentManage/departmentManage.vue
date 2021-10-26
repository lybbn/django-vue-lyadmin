<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="关键词：">
                    <el-input size="small" v-model.trim="formInline.search" maxlength="60" placeholder="关键词" clearable @change="getData" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="部门名称：">
                    <el-input size="small" v-model.trim="formInline.name" maxlength="60" placeholder="部门名称" clearable @change="getData" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="状态：">
                    <el-select v-model="formInline.status" placeholder="请选择" clearable @change="getData">
                        <el-option
                            v-for="item in statusList"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="">
                    <el-button size="small" type="primary" @click="addDepart" v-show="isShowBtn('departmentManage','部门管理','Create')">新增</el-button>
                </el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table
                size="small"
                height="calc(100vh - 300px)"
                border
                row-key="id"
                :data="tableData"
                v-loading="loadingPage"
                style="width: 100%"
                :tree-props="{children: 'children', hasChildren: 'hasChildren'}">
                <el-table-column type="index" width="55" align="center" label="序号"></el-table-column>
                <el-table-column min-width="180" prop="name" label="部门名称"></el-table-column>
                <el-table-column min-width="100" prop="namer" label="负责人"></el-table-column>
                <el-table-column min-width="120" prop="mobile" label="联系电话"></el-table-column>
                <el-table-column min-width="120" prop="email" label="邮箱"></el-table-column>
                <el-table-column min-width="90"  label="状态">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.status==1" type="primary">启用</el-tag>
                        <el-tag v-else>禁用</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="80" prop="sort" label="排序"></el-table-column>
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" fixed="right" width="180">
                    <template slot-scope="scope">
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
    import addDepartment from "./components/addDepartment";
    import {apiSystemDept,apiSystemDeptDelete} from '@/api/api'
    import XEUtils from 'xe-utils'
    export default {
        components:{
            addDepartment,
        },
        name:'departmentManage',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    search:'',
                    name:'',
                    status:''
                },
                tableData:[],
                statusList:[
                    {id:1,name:'启用'},
                    {id:0,name:'禁用'},
                ]
            }
        },
        methods:{
            addDepart() {
                this.$refs.addDepartmentFlag.addDepartmentFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addDepartmentFlag.addDepartmentFn(row,'编辑')
                }
                if(flag == 'detail') {
                    this.$refs.addDepartmentFlag.addDepartmentFn(row,'详情')
                }
                if(flag=='delete') {
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
                     } else {
                         this.$message.warning(res.msg)
                     }
                 })
            }
        },
        created() {
            this.getData()
        }
    }
</script>
<style lang="scss">
    .tableNav{
        overflow: hidden;
        margin-bottom: 20px;
    }
</style>


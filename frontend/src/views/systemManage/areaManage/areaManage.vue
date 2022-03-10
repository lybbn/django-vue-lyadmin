<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="一级地区名称：">
                    <el-input size="small" v-model.trim="formInline.search" maxlength="60" placeholder="一级地区名称" clearable @change="getRootData" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="状态：">
                    <el-select v-model="formInline.status" placeholder="请选择" clearable @change="getRootData" size="small">
                        <el-option
                            v-for="item in statusList"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
<!--                <el-form-item label="">-->
<!--                    <el-button size="small" type="primary" @click="addDepart" v-show="isShowBtn('areaManage','地区管理','Create')">新增</el-button>-->
<!--                </el-form-item>-->
            </el-form>
        </div>

        <div class="table">
            <el-table
                size="small"
                height="calc(100vh - 210px)"
                border
                row-key="id"
                :data="tableData"
                v-loading="loadingPage"
                style="width: 100%"
                lazy
                :load="loadChild"
                :tree-props="{children: 'children', hasChildren: 'hasChildren'}">
                <el-table-column type="index" width="55" align="center" label="序号"></el-table-column>
                <el-table-column min-width="180" prop="name" label="地区名称"></el-table-column>
                <el-table-column min-width="100" prop="id" label="地区编码"></el-table-column>
                <el-table-column min-width="90"  label="状态">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.status==1" type="primary">启用</el-tag>
                        <el-tag v-else type="danger">禁用</el-tag>
                    </template>
                </el-table-column>
<!--                <el-table-column label="操作"  width="180">-->
<!--&lt;!&ndash;                    <template slot-scope="scope">&ndash;&gt;-->
<!--&lt;!&ndash;                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('areaManage','地区管理','Update')">编辑</span>&ndash;&gt;-->
<!--&lt;!&ndash;                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('areaManage','地区管理','Delete')">删除</span>&ndash;&gt;-->
<!--&lt;!&ndash;                    </template>&ndash;&gt;-->
<!--                </el-table-column>-->
            </el-table>
        </div>

        <add-area ref="addDepartmentFlag"  @refreshData="getData"></add-area>
    </div>
</template>
<script>
    import {addressAreaRoot,addressArea,addressAreaDelete} from '@/api/api'
    import XEUtils from 'xe-utils'
    import AddArea from "./components/addArea";
    export default {
        components:{
            AddArea,
        },
        name:'areaManage',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    page:1,
                    limit:99999
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
                    vm.$confirm('您确定要删除选中的数据？',{
                        closeOnClickModal:false
                    }).then(()=>{
                        addressAreaDelete({id:row.id}).then(res=>{
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
            loadChild(tree, treeNode, resolve){
                var params = {
                    parent:tree.id,
                    page:1,
                    limit:99999
                }
                addressArea(params).then(async res => {
                     if(res.code == 2000) {
                         // 将列表数据转换为树形数据
                         res.data.data.map(value => {
                          value.hasChildren = value.child_count !== 0
                         })
                         resolve(res.data.data)
                     }else {
                         this.$message.warning(res.msg)
                     }
                })
            },
            //获取列表
            async getData(){
                this.loadingPage = true
                addressArea(this.formInline).then(async res => {
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
                        // this.tableData = XEUtils.toArrayTree(res.data.data, { parentKey: 'parent', strict: false })
                         res.data.data.map(value => {
                          value.hasChildren = value.child_count !== 0
                        })
                        this.tableData = res.data.data
                     } else {
                         this.$message.warning(res.msg)
                     }
                 })
            },
            //获取根列表
            async getRootData(){
                this.loadingPage = true
                addressAreaRoot(this.formInline).then(async res => {
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
                        res.data.data.map(value => {
                          value.hasChildren = value.child_count !== 0
                        })
                        this.tableData = res.data.data
                     } else {
                         this.$message.warning(res.msg)
                     }
                 })
            }
        },
        created() {
            this.getRootData()
        },
    }
</script>
<style lang="scss">
    .tableNav{
        overflow: hidden;
        margin-bottom: 20px;
    }
</style>


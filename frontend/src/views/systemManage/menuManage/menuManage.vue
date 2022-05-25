<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="关键词：">
                    <el-input size="small" clearable  v-model.trim="formInline.search" maxlength="60" placeholder="关键词" @change="getData" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="菜单名称：">
                    <el-input size="small" clearable v-model.trim="formInline.name" maxlength="60" placeholder="菜单名称" @change="getData" style="width:200px"></el-input>
                </el-form-item>
<!--                <el-form-item label="缓存：">-->
<!--                    <el-select size="small" v-model="formInline.cache" clearable placeholder="请选择" @change="getData">-->
<!--                        <el-option-->
<!--                                v-for="item in statusList1"-->
<!--                                :key="item.id"-->
<!--                                :label="item.name"-->
<!--                                :value="item.id">-->
<!--                        </el-option>-->
<!--                    </el-select>-->
<!--                </el-form-item>-->
                <el-form-item label="侧边可见：">
                    <el-select size="small" v-model="formInline.visible" clearable placeholder="请选择" @change="getData">
                        <el-option
                            v-for="item in statusList1"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="状态：">
                    <el-select size="small" v-model="formInline.status" clearable placeholder="请选择" @change="getData">
                        <el-option
                            v-for="item in statusList"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="">
                    <el-button size="small" type="primary" @click="addMenu">新增</el-button>
                </el-form-item>
            </el-form>
        </div>

        <el-table
                size="small"
                height="calc(100vh - 210px)"
                border
                row-key="id"
                :data="tableData"
                v-loading="loadingPage"
                style="width: 100%"
                :tree-props="{children: 'children', hasChildren: 'hasChildren'}">
            <el-table-column type="index" width="55" align="center" label="序号"></el-table-column>
            <el-table-column min-width="150" prop="name" label="菜单名称"></el-table-column>
            <el-table-column min-width="80" prop="icon" label="图标">
                <template slot-scope="scope"><i :class="scope.row.icon" style="font-size: 20px"></i></template>
            </el-table-column>
            <el-table-column min-width="100" prop="sort" label="排序"></el-table-column>
            <el-table-column min-width="180" prop="web_path" label="路由地址" show-overflow-tooltip=""></el-table-column>
            <el-table-column min-width="200" label="权限">
                <template slot-scope="scope">
                    <span v-for="(item,index) in scope.row.menuPermission" :key="index">{{item + (index < scope.row.menuPermission.length ? '/' : '')}}</span>
                </template>
            </el-table-column>
            <el-table-column min-width="120" label="侧边可见">
                <template slot-scope="scope">
                    <el-tag v-if="scope.row.visible==1">是</el-tag>
                    <el-tag v-else type="danger">否</el-tag>
                </template>
            </el-table-column>
            <el-table-column min-width="120" label="状态">
                <template slot-scope="scope">
                    <el-tag v-if="scope.row.status==1" type="primary">启用</el-tag>
                    <el-tag v-else type="danger">禁用</el-tag>
                </template>
            </el-table-column>
            <el-table-column label="操作" width="200">
                <template slot-scope="scope">
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('menuManage','菜单管理','Update')">编辑</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('menuManage','菜单管理','Retrieve')">详情</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('menuManage','菜单管理','Delete')">删除</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'buttonConfig')" v-show="isShowBtn('menuManage','菜单管理','Retrieve') && (scope.row.menuPermission || scope.row.isautopm==1)">按钮配置</span>
                </template>
            </el-table-column>
        </el-table>
        <add-menu ref="addMenuFlag"  @refreshData="getData"></add-menu>
    </div>
</template>
<script>
    import addMenu from "./components/addMenu";
    import {dateFormats} from "@/utils/util";
    import {apiSystemMenu,apiSystemMenuDelete} from '@/api/api'
    import XEUtils from "xe-utils";
    export default {
        components:{
            addMenu,
        },
        name:'menuManage',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    search:'',
                    name:'',
                    status:'',
                    cache:'',
                    visible:'',
                    page:1,
                    limit:9999
                },
                timers:[],
                tableData:[],
                statusList:[
                    {id:1,name:'启用'},
                    {id:0,name:'禁用'},
                ],
                statusList1:[
                    {id:1,name:'是'},
                    {id:0,name:'否'},
                ]
            }
        },
        methods:{
            addMenu() {
                this.$refs.addMenuFlag.addMenuFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addMenuFlag.addMenuFn(row,'编辑')
                }
                if(flag == 'detail') {
                    this.$refs.addMenuFlag.addMenuFn(row,'详情')
                }
                if(flag == 'buttonConfig') {
                    this.$router.push({name:'buttonConfig',params:{id:row.id,name:row.name}})
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的菜单？',{
                        closeOnClickModal:false
                    }).then(()=>{
                        apiSystemMenuDelete({id:row.id}).then(res=>{
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
                apiSystemMenu(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         // let childrenList = res.data.data.filter(item=> item.parent)
                         // let parentList = res.data.data.filter(item=> !item.parent)
                         // if(parentList.length >0) {
                         //     parentList.forEach(item=>{
                         //         let children = childrenList.filter(itema=>itema.parent == item.id)
                         //         item.children=[...children]
                         //     })
                         // }
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
        },
    }
</script>
<style lang="scss">
    .tableNav{
        overflow: hidden;
        margin-bottom: 20px;
    }
</style>



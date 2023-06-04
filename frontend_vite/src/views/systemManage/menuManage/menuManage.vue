<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="关键词：">
                    <el-input size="default" clearable  v-model.trim="formInline.search"  maxlength="60" placeholder="关键词" @change="getData" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="侧边可见：">
                    <el-select size="default" v-model="formInline.visible" clearable placeholder="请选择" @change="getData">
                        <el-option
                            v-for="item in statusList1"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="状态：">
                    <el-select size="default" v-model="formInline.status" clearable placeholder="请选择" @change="getData">
                        <el-option
                            v-for="item in statusList"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label=""><el-button  @click="getData" type="primary" icon="Search" v-show="isShowBtn('menuManage','菜单管理','Search')">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
                <el-form-item label="">
                    <el-button type="primary" @click="addMenu" icon="Plus" v-show="isShowBtn('menuManage','菜单管理','Create')">新增</el-button>
                </el-form-item>
            </el-form>
        </div>

        <el-table
                :max-height="tableHeight"
                border
                row-key="id"
                :data="tableData"
                ref="tableref"
                v-loading="loadingPage"
                style="width: 100%;"
                :tree-props="{children: 'children', hasChildren: 'hasChildren'}">
            <el-table-column type="index" width="70"  label="序号" style="display: unset;">
                <template #default="scope">
                    <span v-text="getIndex(scope.$index)"></span>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="name" label="菜单名称"></el-table-column>
            <el-table-column min-width="80" prop="icon" label="图标">
                <template #default="scope">
                    <el-icon :size="16" v-if="scope.row.icon">
                      <component :is="scope.row.icon" />
                    </el-icon>
                </template>
            </el-table-column>
            <el-table-column min-width="70" prop="sort" label="排序"></el-table-column>
            <el-table-column min-width="160" prop="web_path" label="路由地址" show-overflow-tooltip=""></el-table-column>
            <el-table-column min-width="300" label="权限">
                <template #default="scope">
                    <span v-for="(item,index) in scope.row.menuPermission" :key="index">{{item + (index < scope.row.menuPermission.length ? '/' : '')}}</span>
                </template>
            </el-table-column>
            <el-table-column min-width="100" label="侧边可见">
                <template #default="scope">
                    <el-tag v-if="scope.row.visible==1">是</el-tag>
                    <el-tag v-else type="danger">否</el-tag>
                </template>
            </el-table-column>
            <el-table-column min-width="90" label="状态">
                <template #default="scope">
                    <el-tag v-if="scope.row.status==1" type="">启用</el-tag>
                    <el-tag v-else type="danger">禁用</el-tag>
                </template>
            </el-table-column>
            <el-table-column label="操作" fixed="right" width="200">
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
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('menuManage','菜单管理','Update')">编辑</span>
<!--                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('menuManage','菜单管理','Retrieve')">详情</span>-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('menuManage','菜单管理','Delete')">删除</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'buttonConfig')" v-show="isShowBtn('menuManage','菜单管理','Retrieve') && (scope.row.menuPermission || scope.row.isautopm==1)">按钮配置</span>
                </template>
            </el-table-column>
        </el-table>
        <add-menu ref="addMenuFlag"  @refreshData="refreshData"></add-menu>
    </div>
</template>
<script>
    import addMenu from "./components/addMenu.vue";
    import {dateFormats,getTableHeight,setStorage} from "@/utils/util";
    import {apiSystemMenu,apiSystemMenuDelete,apiSystemWebRouter} from '@/api/api'
    import XEUtils from "xe-utils";
    export default {
        components:{
            addMenu,
        },
        name:'menuManage',
        data() {
            return {
                isFull:false,
                tableHeight:260,
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
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
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
            // 表格序列号
            getIndex($index) {
                // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
            setFull(){
                this.isFull=!this.isFull
            },
            addMenu() {
                this.$refs.addMenuFlag.addMenuFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addMenuFlag.addMenuFn(row,'编辑')
                }
                else if(flag == 'detail') {
                    this.$refs.addMenuFlag.addMenuFn(row,'详情')
                }
                else if(flag == 'buttonConfig') {
                    this.$router.push({name:'buttonConfig',params:{id:row.id,name:row.name}})
                }
                else if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的菜单？',{
                        closeOnClickModal:false
                    }).then(()=>{
                        apiSystemMenuDelete({id:row.id}).then(res=>{
                            if(res.code == 2000) {
                                vm.$message.success(res.msg)
                                vm.refreshData()
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
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;

                     } else {
                         this.$message.warning(res.msg)
                     }
                 })
            },
            refreshData(){
                this.getData()
                this.getMenu()
            },
            // 重新获取左侧菜单信息
            getMenu() {
                apiSystemWebRouter().then(res=>{
                    if(res.code == 2000) {
                        let menuTree = []
                        if(res.data.data.length > 0) {
                            let childrenList = res.data.data.filter(item=> item.parent && item.visible == 1)
                            let parentList = res.data.data.filter(item=> !item.parent && item.visible == 1)
                            if(parentList.length >0) {
                                parentList.forEach(item=>{
                                    let menuTreeChildren=[]
                                    let children = childrenList.filter(itema=>itema.parent == item.id)
                                    let children2 = childrenList.filter((item)=>{
                                        return children.every((item1)=>{
                                            return item.path != item1.path;
                                        })
                                    })
                                    children.forEach(itemb=>{
                                        let cmenuTreeChildren=[]
                                        let cchildren = children2.filter(itemc=>itemc.parent == itemb.id)
                                        cchildren.forEach(itemd=>{
                                            cmenuTreeChildren.push(({
                                                text:itemd.name,
                                                id:itemd.id,
                                                attributes:{
                                                    url:itemd.web_path,
                                                    icon:itemd.icon
                                                },
                                                hasChildren: false,
                                                hasParent:true
                                            }))
                                        })
                                        let chasChildren = false
                                        if(cmenuTreeChildren.length>0){
                                            chasChildren = true
                                        }
                                        menuTreeChildren.push(({
                                            text:itemb.name,
                                            id:itemb.id,
                                            attributes:{
                                                url:itemb.web_path,
                                                icon:itemb.icon
                                            },
                                            children:cmenuTreeChildren,
                                            hasChildren: chasChildren,
                                            hasParent:true,
                                        }))
                                    })
                                    menuTree.push({
                                        text:item.name,
                                        id:item.id,
                                        attributes:{
                                            url:children.length >0 ? children[0].web_path :item.web_path,
                                            icon:item.icon
                                        },
                                        hasChildren: children.length >0,
                                        hasParent:false,
                                        children:menuTreeChildren,
                                    })
                                    item.children=[...children]
                                })
                            }

                            // 操作权限管控
                            let menuList=[]
                            res.data.data.forEach(item=>{
                                //console.log(item,'item---- 菜单权限---')
                                menuList.push({
                                    url:item.web_path,
                                    moduleName:item.name,
                                    menuPermission:item.menuPermission
                                })
                            })
                            setStorage('menuList', JSON.stringify(menuList))
                        }
                        setStorage('allmenu', JSON.stringify(menuTree))
                        this.$Bus.emit('routeReload', true)
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
                this.tableHeight =  getTableHeight(this.$refs.tableSelect.offsetHeight-50)

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
<style lang="scss" scoped>
    .tableNav{
        overflow: hidden;
        margin-bottom: 20px;
    }
    /*::v-deep(.el-table__placeholder){*/
    /*    display: unset;*/
    /*}*/
</style>
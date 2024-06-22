<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="关键词：">
                    <el-input size="default" v-model.trim="formInline.search" maxlength="60" placeholder="关键词" clearable @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="状态：">
                    <el-select v-model="formInline.status" placeholder="请选择" size="default" clearable @change="search" style="width:120px">
                        <el-option
                                v-for="item in statusList"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-button  @click="search" type="primary" icon="Search" v-show="isShowBtn('roleManage','角色管理','Search')">查询</el-button>
                <el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button>
                <el-button size="default" type="primary" @click="addRole(null,'新增')" icon="Plus" v-show="isShowBtn('roleManage','角色管理','Create')">新增</el-button>
            </el-form>
        </div>

        <div class="table">
            <el-table  :height="'calc('+(tableHeight)+'px)'" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%">
                <el-table-column width="80" type="index" align="center" label="序号">
                    <template #default="scope">
                        <span v-text="getIndex(scope.$index)"></span>
                    </template>
                </el-table-column>
                <el-table-column min-width="120" prop="name" label="角色名称"></el-table-column>
                <el-table-column min-width="120" prop="key" label="权限字符"></el-table-column>
                <!-- <el-table-column min-width="120" label="是否管理员">
                    <template #default="scope">
                        <el-tag v-if="scope.row.admin==1" type="">是</el-tag>
                        <el-tag v-else type="danger">否</el-tag>
                    </template>
                </el-table-column> -->
                <el-table-column min-width="120" label="状态">
                    <template #default="scope">
                        <el-tag v-if="scope.row.status==1">启用</el-tag>
                        <el-tag v-else type="danger">禁用</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="120" prop="sort" label="排序"></el-table-column>
                <el-table-column label="操作" fixed="right" width="280">
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
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('roleManage','角色管理','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('roleManage','角色管理','Retrieve')">详情</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('roleManage','角色管理','Delete')">删除</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'authority')" v-show="isShowBtn('roleManage','角色管理','Retrieve')">权限管理</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-role ref="addRoleFlag"  @refreshData="search"></add-role>
    </div>
</template>
<script>
    import addRole from "./components/addRole.vue";
    import Pagination from "@/components/Pagination.vue";
    import {dateFormats,getTableHeight} from "@/utils/util";
    import {apiSystemRole,apiSystemRoleDelete} from '@/api/api'

    export default {
        components:{
            Pagination,
            addRole,
        },
        name:'roleManage',
        data() {
            return {
                isFull:false,
                tableHeight:500,
                loadingPage:false,
                formInline:{
                    page: 1,
                    limit: 10,
                    search:'',
                    name:'',
                    status:'',
                },
                pageparm: {
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
            addRole() {
                this.$refs.addRoleFlag.addRoleFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addRoleFlag.addRoleFn(row,'编辑')
                }
                else if(flag == 'detail') {
                    this.$refs.addRoleFlag.addRoleFn(row,'详情')
                }
                else if(flag == 'authority') {
                    // this.$router.push({name:'authorityManage',params:{id:row.id}})//已失效
                    this.$router.push({name:'authorityManage',state:{id:row.id}})
                   // this.$router.push({name:'authorityManage',query:{id:row.id}})
                }
                else if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的角色？',{
                        closeOnClickModal:false
                    }).then(()=>{
                        apiSystemRoleDelete({id:row.id}).then(res=>{
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
            async getData(){
                 this.loadingPage = true
                 apiSystemRole(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data;
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
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
               this.tableHeight =  getTableHeight(this.$refs.tableSelect.offsetHeight)
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
<style lang="scss">
    .tableNav{
        overflow: hidden;
        margin-bottom: 20px;
    }
</style>




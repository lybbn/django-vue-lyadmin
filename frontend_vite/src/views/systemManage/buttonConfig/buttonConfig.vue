<template>
    <div>
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 16px;margin-top: 10px;">
            <el-breadcrumb-item :to="{ path: '/menuManage' }">菜单管理</el-breadcrumb-item>
            <el-breadcrumb-item v-if="$route.query.name">{{$route.query.name}}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-table
            height="calc(100vh - 150px)"
            border
            row-key="id"
            :data="tableData"
            ref="tableref"
            v-loading="loadingPage"
            style="width: 100%">
            <el-table-column type="index" width="55" align="center" label="序号"></el-table-column>
            <el-table-column min-width="150" prop="name" label="名称"></el-table-column>
            <el-table-column min-width="150" label="请求方式">
                <template #default="scope">
                    <span>{{methodsList.filter(item=>item.id == scope.row.method)[0].name}}</span>
                </template>
            </el-table-column>
            <el-table-column min-width="200" prop="api" label="接口地址"></el-table-column>
            <el-table-column label="操作" fixed="right" width="140">
                <template #header>
                    <el-button type="primary" size="default" @click="handleEdit(null,'新增',$route.query.id)">新增</el-button>
                </template>
                <template #default="scope">
<!--                    <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('buttonConfig','按钮配置','Update')">编辑</span>-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'编辑')">编辑</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')">删除</span>
                </template>
            </el-table-column>
        </el-table>
        <add-button ref="addButtonFlag" @refreshData="getData"></add-button>
    </div>
</template>

<script>
    import AddButton from "./components/addButton.vue";
    import {systemMenuButton,systemMenuButtonDelete} from '@/api/api'
    export default {
        name: "buttonConfig",
        components:{
            AddButton
        },
        data() {
            return {
                tableData:[],
                loadingPage:false,
                formInline:{
                    page:1,
                    limit:999,
                    menu:''
                },
                methodsList:[
                    {id:0,name:'GET'},
                    {id:1,name:'POST'},
                    {id:2,name:'PUT'},
                    {id:3,name:'DELETE'},
                    {id:4,name:'OPTIONS'},
                    {id:5,name:'WS'},
                ],
            }
        },
        created() {
            this.formInline.menu=this.$route.query.id
            this.getData()
        },
        //解决table 表格缩放错位问题
        handleResize() {
            this.$nextTick(()=> {
                this.$refs.tableref.doLayout();
            });
        },
        mounted() {
            //解决table 表格缩放错位问题
            window.addEventListener('resize', this.handleResize);
        },
        unmounted() {
            //解决table 表格缩放错位问题
             window.removeEventListener("resize", this.handleResize);
        },
        methods: {
            handleEdit(row, flag, menu) {
                if (flag == '编辑' || flag=='新增') {
                    this.$refs.addButtonFlag.addButtonFn(row, flag, menu)
                }
                if (flag == 'delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的按钮？', {
                        closeOnClickModal: false
                    }).then(() => {
                        systemMenuButtonDelete({id: row.id}).then(res => {
                            if (res.code == 2000) {
                                vm.$message.success(res.msg)
                                vm.getData()
                            } else {
                                vm.$message.warning(res.msg)
                            }
                        })

                    }).catch(() => {

                    })
                }
            },
            getData() {
                this.loadingPage = true
                systemMenuButton(this.formInline).then(res => {
                    this.loadingPage = false
                    if (res.code == 2000) {
                        this.tableData = res.data.data
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            },
        }
    }
</script>

<style scoped>

</style>

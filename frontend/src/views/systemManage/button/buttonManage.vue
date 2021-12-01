<template>
    <div>
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 20px">
            <el-breadcrumb-item :to="{ path: '/menuManage' }">菜单管理</el-breadcrumb-item>
            <el-breadcrumb-item >按钮管理</el-breadcrumb-item>
        </el-breadcrumb>

        <el-table
            size="small"
            height="calc(100vh - 140px)"
            border
            row-key="id"
            :data="tableData"
            ref="tableref"
            v-loading="loadingPage"
            style="width: 100%">
            <el-table-column type="index" width="55" align="center" label="序号"></el-table-column>
            <el-table-column min-width="150" prop="name" label="名称"></el-table-column>
            <el-table-column min-width="150" prop="value" label="key值"></el-table-column>
            <el-table-column min-width="150" prop="update_datetime" label="更新时间"></el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
            <el-table-column label="操作" fixed="right" width="140">
                <template slot="header">
                    <el-button type="primary" size="small" @click="handleEdit(null,'新增')" >新增</el-button>
                </template>
                <template slot-scope="scope">
<!--                    <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('button','按钮管理','Update')">编辑</span>-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'编辑')" >编辑</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" >删除</span>
                </template>
            </el-table-column>
        </el-table>
        <add-button ref="addButtonFlag" @refreshData="getData"></add-button>
    </div>
</template>

<script>
    import addButton from "./components/addButton";
    import {systemButton,systemButtonDelete} from '@/api/api'
    export default {
        name: "buttonManage",
        components:{
            addButton
        },
        data() {
            return {
                tableData:[],
                loadingPage:false,
                formInline:{
                    page:1,
                    limit:999,
                },
            }
        },
        created() {
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
        destroyed() {
            //解决table 表格缩放错位问题
             window.removeEventListener("resize", this.handleResize);
        },
        methods: {
            handleEdit(row, flag, menu) {
                if (flag == '编辑' || flag=='新增') {
                    this.$refs.addButtonFlag.addButtonFn(row, flag)
                }
                if (flag == 'delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的按钮？', {
                        closeOnClickModal: false
                    }).then(() => {
                        systemButtonDelete({id: row.id}).then(res => {
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
                systemButton(this.formInline).then(res => {
                    this.loadingPage = false
                    if (res.code == 2000) {
                        this.tableData = res.data.data
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            }
        }
    }
</script>

<style scoped>

</style>

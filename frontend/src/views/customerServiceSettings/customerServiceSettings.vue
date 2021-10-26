<template>
    <div>
        <el-table size="small" height="calc(100vh - 160px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
            <el-table-column min-width="150" prop="username" label="联系方式"></el-table-column>
            <el-table-column min-width="100" label="状态">
                <template slot-scope="scope">
                    <el-tag v-if="scope.row.is_active">正常</el-tag>
                    <el-tag v-else type="danger">禁用</el-tag>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
            <el-table-column label="操作" fixed="right" width="180">
                <template slot="header">
                    <el-button size="small" @click="addModule" type="primary">新增</el-button>
                </template>
                <template slot-scope="scope">
                    <!--                        v-show="isShowBtn('dynamicsInfo','资讯动态','Update')"-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" >详情</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('dynamicsInfo','资讯动态','Delete')">删除</span>
                </template>
            </el-table-column>
        </el-table>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module ref="addModuleFlag" @refreshData="search"></add-module>
    </div>
</template>
<script>
    import addModule from "./components/addModule";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {apiSystemUser,apiSystemUserDelte} from '@/api/api'
    export default {
        components:{
            Pagination,
            addModule
        },
        name:'customerServiceSettings',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    search:'',
                    status:'',
                    page: 1,
                    limit: 10,
                },
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                statusList:[
                    {id:1,name:'是'},
                    {id:0,name:'否'}
                ],
                tableData:[{name:'好友分享ssss'}]
            }
        },
        methods:{
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增')
            },
            changeStatus(row) {
                console.log(row,'row----')
            },
            handleEdit(row,flag) {
                let vm = this
                if(flag=='detail') {
                    vm.$refs.addModuleFlag.addModuleFn(row,'编辑')
                }
                if(flag=='delete') {
                    vm.$confirm('您确定要删除选中的内容？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        apiSystemUserDelte({id:row.id}).then(res=>{
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
                /*this.loadingPage = true
                 apiSystemUser(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                 })*/
            },
        },
        created() {
            this.getData()
        },
    }
</script>

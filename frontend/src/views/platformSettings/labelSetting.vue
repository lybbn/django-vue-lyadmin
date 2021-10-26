<template>
    <div>
        <el-tabs v-model="formInline.type" @tab-click="getData">
            <el-tab-pane label="评价标签" name="1"></el-tab-pane>
            <el-tab-pane label="留言标签" name="2"></el-tab-pane>
            <el-tab-pane label="取消原因" name="3"></el-tab-pane>
        </el-tabs>
        <el-table size="small" height="calc(100vh - 160px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
            <el-table-column min-width="150" prop="content" label="评价标签" v-if="formInline.type==1"></el-table-column>
            <el-table-column min-width="150" prop="content" label="留言标签" v-if="formInline.type==2"></el-table-column>
            <el-table-column min-width="150" prop="content" label="取消原因" v-if="formInline.type==3"></el-table-column>
            <el-table-column min-width="100" prop="sort" label="排序"></el-table-column>
            <el-table-column min-width="100" label="状态">
                <template slot-scope="scope">
                    <el-tag v-if="scope.row.status">正常</el-tag>
                    <el-tag v-else type="danger">禁用</el-tag>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
            <el-table-column label="操作" fixed="right" width="180">
                <template slot="header">
                    <el-button size="small" @click="addModule" type="primary" v-show="isShowBtn('labelSetting','标签设置','Create')">新增</el-button>
                </template>
                <template slot-scope="scope">
                    <!--                        v-show="isShowBtn('dynamicsInfo','资讯动态','Update')"-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('labelSetting','标签设置','Update')">编辑</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('labelSetting','标签设置','Delete')">删除</span>
                </template>
            </el-table-column>
        </el-table>
        <add-module-label ref="addModuleFlag" @refreshData="getData"></add-module-label>
    </div>
</template>
<script>
    import addModuleLabel from "./components/addModuleLabel";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {retrieveLabel,retrieveLabelDelete} from '@/api/api'
    export default {
        components:{
            Pagination,
            addModuleLabel
        },
        name:'labelSetting',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    search:'',
                    status:'',
                    type:'1',// type标签类型: 1(评价标签),2(留言标签),3(取消原因)
                },
                statusList:[
                    {id:1,name:'是'},
                    {id:0,name:'否'}
                ],
                tableData:[]
            }
        },
        methods:{
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增',this.formInline.type)
            },
            changeStatus(row) {
                console.log(row,'row----')
            },
            handleEdit(row,flag) {
                let vm = this
                if(flag=='edit') {
                    vm.$refs.addModuleFlag.addModuleFn(row,'编辑',this.formInline.type)
                }
                if(flag=='delete') {
                    vm.$confirm('您确定要删除选中的标签？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        retrieveLabelDelete({id:row.id}).then(res=>{
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
                 retrieveLabel(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                        /* this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;*/
                     }
                 })
            },
        },
        created() {
            this.getData()
        },
    }
</script>




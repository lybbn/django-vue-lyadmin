<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="">
                    <el-button size="small" type="primary" @click="addModule" v-show="isShowBtn('platformSettingsother','其他设置','Create')">新增</el-button>
                </el-form-item>
                <el-form-item label="">
                    <el-button size="small" @click="handleDelete" type="danger" :disabled="multiple" v-show="isShowBtn('platformSettingsother','其他设置','Delete')">删除</el-button>
                </el-form-item>
            </el-form>
        </div>
        <div class="table">
            <el-table size="small" height="calc(100vh - 280px)" border :data="tableData" v-loading="loadingPage" style="width: 100%" tooltip-effect="dark" @selection-change="handleSelectionChange">
<!--                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>-->
                <el-table-column type="selection" width="55" align="center"></el-table-column>
                <!--<el-table-column min-width="120" prop="name" label="图片">-->
                    <!--<template slot-scope="scope">-->
                        <!--<el-image  fit="fill" :src="scope.row.image" style="width: 60px;height: 60px" :preview-src-list="[scope.row.image]" v-if="scope.row.image"></el-image>-->
                    <!--</template>-->
                <!--</el-table-column>-->
                <el-table-column min-width="120" prop="name" label="名称"></el-table-column>
                <el-table-column min-width="140" prop="key" label="键名"></el-table-column>
                <el-table-column min-width="180" prop="value" label="键值" show-overflow-tooltip></el-table-column>
                <el-table-column min-width="60" prop="sort" label="排序"></el-table-column>
                <el-table-column min-width="80" label="状态">
                    <template slot-scope="scope">
                         <el-tag v-if="scope.row.status">正常</el-tag>
                         <el-tag v-else type="danger">禁用</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" width="180">
                    <template slot-scope="scope">
                        <!--                        v-show="isShowBtn('recyclCategoryParent','一级分类','Update')"-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('platformSettingsother','其他设置','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('platformSettingsother','其他设置','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module ref="addModuleFlag" @refreshData="search"></add-module>
    </div>
</template>
<script>
    import addModule from "./components/addModuleOther";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {platformsettingsOther,platformsettingsOtherDelete} from '@/api/api'
    export default {
        components:{
            Pagination,
            addModule,
        },
        name:'platformSettingsother',
        data() {
            return {
                loadingPage:false,
                // 选项框选中数组
                ids: [],
                // 选项框非单个禁用
                single: true,
                // 非多个禁用
                multiple: true,
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
                    {id:1,name:'正常'},
                    {id:0,name:'禁用'}
                ],
                timers:[],
                tableData:[]
            }
        },
        methods:{
            //多选项框被选中数据
            handleSelectionChange(selection) {
                this.ids = selection.map(item => item.id);
                this.single = selection.length !== 1;
                this.multiple = !selection.length;
            },
            /** 批量删除按钮操作 */
            handleDelete(row) {
                const ids = this.ids;
                let vm = this
                vm.$confirm('是否确认删除选中的数据项?', "警告", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning"
                }).then(function() {
                    return platformsettingsOtherDelete({id:ids}).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
            changeStatus(row) {
                // console.log(row,'row----')
            },
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.addModuleFlag.addModuleFn(row,'编辑')
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('确定删除该数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        platformsettingsOtherDelete({id:row.id}).then(res=>{
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
                this.loadingPage = true
                platformsettingsOther(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                 })
            },

            timeChange(val){
                if (val) {
                    this.formInline.beginAt=dateFormats(val[0],'yyyy-MM-dd hh:mm:ss');
                    this.formInline.endAt=dateFormats(val[1],'yyyy-MM-dd hh:mm:ss');
                } else {
                    this.formInline.beginAt = null
                    this.formInline.endAt = null
                }
                this.search()
            },
        },
        created() {
            this.getData()
        },
        timers(val){
            if (val) {
                this.formInline.beginAt=dateFormats(val[0],'yyyy-MM-dd hh:mm:ss');
                this.formInline.endAt=dateFormats(val[1],'yyyy-MM-dd hh:mm:ss');
            } else {
                this.formInline.beginAt = ''
                this.formInline.endAt = ''
            }
            this.getData()
        },
    }
</script>



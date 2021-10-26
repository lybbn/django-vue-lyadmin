<template>
    <el-dialog
        title="选择回收员"
        :visible.sync="dialogVisible"
        width="800px"
        center
        top="3%"
        :destroy-on-close="true"
        :close-on-click-modal="false"
        :before-close="handleClose"
        append-to-body>
        <el-form :inline="true" :model="formInline">
            <el-form-item label="回收员：">
                <el-input v-model.trim="formInline.name" style="width: 240px" @change="search" clearable placeholder="回收员名称"></el-input>
            </el-form-item>
        </el-form>

        <el-table size="small" height="70vh" border :data="tableList" v-loading="loadingPage" style="width: 100%" @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column width="100" prop="name" label="头像">
                <template slot-scope="scope">
                    <img :src="scope.row.avatar" style="width: 30px;height: 30px">
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="name" label="回收员名称"></el-table-column>
            <el-table-column min-width="150" prop="mobile" label="联系方式"></el-table-column>
        </el-table>

        <span slot="footer">
            <el-button @click="handleClose">关闭</el-button>
            <el-button @click="addData" :loading="loadingPage" type="primary" :disabled="selectList.length<1">添加</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {retrieveAssignrecycler,retrieveRecyclerusers} from '@/api/api'
    export default {
        name: "recyclerList",
        data() {
            return {
                dialogVisible:false,
                loadingPage:false,
                rorderid:'',
                formInline:{
                    name:'',
                },
                tableList:[],
                selectList:[]
            }
        },
        methods:{
            handleSelectionChange(e) {
              this.selectList= e
                console.log(e)
            },
            handleClose() {
                this.dialogVisible=false
                this.$emit('refreshData')
            },
            recyclerListFn(item) {
                this.dialogVisible=true
                this.rorderid=item ? item.id : ''
                this.formInline={
                    name:''
                }
                this.getData()
            },
            search() {
                // this.formInline.page = 1
                // this.formInline.limit = 10
                this.getData()
            },
            addData() {
                //console.log(this.formInline,'formData')
                // this.loadingPage=true
                if(this.selectList.length>1){
                    vm.$message.warning("只能单人选择")
                    return
                }
                var params = {
                    id:this.rorderid,
                    userid:this.selectList[0].id
                }
                var vm = this
                retrieveAssignrecycler(params).then(res => {
                     if(res.code == 2000) {
                        vm.$message.success(res.msg)
                         this.handleClose()
                        } else {
                        vm.$message.warning(res.msg)
                      }
                 })

            },
            //获取列表
            getData(){
                this.loadingPage = true
                 retrieveRecyclerusers(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableList = res.data.data
                     }
                 })
            },

        }
    }
</script>



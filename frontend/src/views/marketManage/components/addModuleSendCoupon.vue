<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="52%"
            center
            top="2%"
            v-dialog-drag
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
<!--            <el-form-item label="名称：" prop="name">-->
<!--                <el-input v-model="formData.name" style="width: 300px"  :disabled="loadingTitle=='详情'"></el-input>-->
<!--            </el-form-item>-->
            <div class="tableSelect">
                <el-form :inline="true" :model="formInline" label-position="left">
                    <el-form-item label="昵称/手机号：">
                        <el-input size="small" v-model.trim="formInline.name_mobile" maxlength="60"  clearable placeholder="昵称/手机号" @change="search" style="width:200px"></el-input>
                    </el-form-item>
                    <el-form-item >
                        <el-button size="small" type="primary" @click="handleSearch" >查询</el-button>
                    </el-form-item>
                    <el-form-item >
                        <el-button size="small" type="primary" @click="handleSearch" >立即发送</el-button>
                    </el-form-item>
                </el-form>
            </div>
            <div class="table">
            <el-table size="small" height="calc(100vh - 460px)" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%" @selection-change="handleSelectionChange">
                <el-table-column type="selection" width="55" align="center"></el-table-column>
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
                <el-table-column min-width="70" prop="avatar" label="用户头像">
                    <template slot-scope="scope">
                        <img  :src="scope.row.avatar ? scope.row.avatar : defaultImg" style="width: 30px;height: 30px" :onerror="defaultImg">
                    </template>
                </el-table-column>
<!--                <el-table-column min-width="110" prop="username" label="用户名"></el-table-column>-->
                <el-table-column min-width="110" prop="nickname" label="昵称"></el-table-column>
                <el-table-column min-width="100" prop="mobile" label="手机号"></el-table-column>
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" width="100">
                    <template slot-scope="scope">
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'sendcoupon')">发送</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
<!--            <el-form-item label="排序：" prop="sort">-->
<!--                <el-input-number v-model="formData.sort"  :min="1" :max="9999"></el-input-number>-->
<!--            </el-form-item>-->
<!--            <el-form-item label="状态：" prop="status" :disabled="loadingTitle=='详情'">-->
<!--                <el-switch-->
<!--                    v-model="formData.status"-->
<!--                    active-color="#13ce66"-->
<!--                    inactive-color="#ff4949">-->
<!--                </el-switch>-->
<!--            </el-form-item>-->
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave" :disabled="loadingTitle=='详情'">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {UsersUsers} from "@/api/api";
    export default {
        name: "addModuleSendCoupon",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingPage:false,
                loadingTitle:'',
                defaultImg:"this.src='"+require('../../../assets/img/avatar.jpg')+"'",
                // 选项框选中数组
                ids: [],
                // 选项框非单个禁用
                single: true,
                // 非多个禁用
                multiple: true,
                multipleSelection:[],
                formInline:{
                    identity:3,
                    audit_status:20,
                    page: 1,
                    limit: 9999,
                },
                formData:{
                    id:'',
                    userid:'',
                },
                rules:{
                    // name: [
                    //     {required: true, message: '请输入名称',trigger: 'blur'}
                    // ],
                },
                tableData:[]
            }
        },
        methods:{
            handleSelectionChange(e) {
                //console.log(e,'e---')
                this.multipleSelection=e
            },
            handleChange(){
                this.getProvince()
            },
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.$emit('refreshData')
            },
            handleSearch() {
                this.search()
            },
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                this.formData.id=item.id
                this.getData()
            },
            search() {
                this.getData()
            },
            //获取列表
            async getData(){
                let vm = this
                this.loadingPage = true
                 UsersUsers(this.formInline).then(res => {
                     vm.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                 })
            },
            submitData() {
                let vm = this
                this.loadingSave=true
                if(this.multipleSelection.length < 1) {
                    this.loadingSave=false
                    this.$message.warning("至少选择一个")
                }
                // jianzhuProgramSetassign(this.formData).then(res=>{
                //     vm.loadingSave=false
                //     if(res.code ==2000) {
                //         this.$message.success(res.msg)
                //         this.multipleSelection=[]
                //         this.dialogVisible=false
                //         this.handleClose()
                //         this.$emit('refreshData')
                //     } else {
                //         this.$message.warning(res.msg)
                //     }
                // })



                // this.$refs['rulesForm'].validate(obj=>{
                //     if(obj) {
                //         this.loadingSave=true
                //         let param = {
                //             ...this.formData
                //         }
                //         if(this.formData.id){
                //             jianzhuServicetypeEdit(param).then(res=>{
                //                 this.loadingSave=false
                //                 if(res.code ==2000) {
                //                     this.$message.success(res.msg)
                //                     this.handleClose()
                //                     this.$emit('refreshData')
                //                 } else {
                //                     this.$message.warning(res.msg)
                //                 }
                //             })
                //         }
                //         // else{
                //         //     jianzhuServicetypeAdd(param).then(res=>{
                //         //         this.loadingSave=false
                //         //         if(res.code ==2000) {
                //         //             this.$message.success(res.msg)
                //         //             this.handleClose()
                //         //             this.$emit('refreshData')
                //         //         } else {
                //         //             this.$message.warning(res.msg)
                //         //         }
                //         //     })
                //         // }
                //     }
                // })
            }
        }
    }
</script>


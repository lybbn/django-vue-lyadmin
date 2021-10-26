<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="560px"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item :label="loadingTitle=='充值' ? '充值金额：' : '申请额度：'" prop="money">
                <el-input v-model.trim="formData.money" style="width: 300px" v-limitPositiveNumberFixed2 :disabled="loadingTitle=='详情'"></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave" :disabled="loadingTitle=='详情'">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {retrieveQuotaauditagentapplymoneyAdd} from "@/api/api";
    export default {
        name: "addModule",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    money:'',
                },
                rules:{
                    money: [
                        {required: true, message: '请输入金额',trigger: 'blur'}
                    ]
                }
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.$emit('refreshData')
            },
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                this.formData=item ? item : {
                    money:'',
                }
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        if(this.formData.id){
                            // apiSystemUserEdit(param).then(res=>{
                            //     this.loadingSave=false
                            //     if(res.code ==2000) {
                            //         this.$message.success(res.msg)
                            //         this.handleClose()
                            //         this.$emit('refreshData')
                            //     } else {
                            //         this.$message.warning(res.msg)
                            //     }
                            // })
                        }else{
                            retrieveQuotaauditagentapplymoneyAdd(param).then(res=>{
                                this.loadingSave=false
                                if(res.code ==2000) {
                                    this.$message.success(res.msg)
                                    this.handleClose()
                                    this.$emit('refreshData')
                                } else {
                                    this.$message.warning(res.msg)
                                }
                            })
                        }
                    }
                })
            }
        }
    }
</script>


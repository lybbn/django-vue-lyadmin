<template>
    <el-dialog
            title="充值"
            :visible.sync="dialogVisible"
            width="560px"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="true" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item label="充值金额：" prop="money">
                <el-input v-model="formData.money" style="width: 300px" v-limitPositiveNumberFixed2></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {retrieveRecyclerecharge} from "@/api/api";
    export default {
        name: "rechargeModule",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                formData:{
                    id:'',
                    money:''
                },
                rules:{
                    money: [
                        {required: true, message: '请输入充值金额',trigger: 'blur'}
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
            rechargeFn(item) {
                this.dialogVisible=true
                this.formData.id = item.id
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        retrieveRecyclerecharge(this.formData).then(res=>{
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
                })
            },

        }
    }
</script>

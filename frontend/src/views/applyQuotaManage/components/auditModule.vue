<template>
    <el-dialog
            title="审核"
            :visible.sync="dialogVisible"
            width="560px"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="true" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item label="审核：" prop="action">
                <el-select size="small" v-model="formData.action" placeholder="请选择" clearable style="width: 300px">
                    <el-option
                            v-for="item in statusList"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="驳回原因：" prop="remark">
                <el-input size="small" type="textarea" v-model.trim="formData.remark" maxlength="200" show-word-limit clearable placeholder="驳回原因" style="width:300px"></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {retrieveQuotaauditrecyclerpassdeny} from "@/api/api";
    export default {
        name: "auditModule",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                formData:{
                    id:'',
                    action:'',
                    remark:'',
                },
                rules:{
                    action: [
                        {required: true, message: '请选择审核结果',trigger: 'blur'}
                    ]
                },
                statusList:[
                    {id:'pass',name:'通过'},
                    {id:'deny',name:'驳回'},
                ]
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.$emit('refreshData')
            },
            auditModuleFn(item) {
                this.dialogVisible=true
                this.formData.id = item.id
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        retrieveQuotaauditrecyclerpassdeny(this.formData).then(res=>{
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


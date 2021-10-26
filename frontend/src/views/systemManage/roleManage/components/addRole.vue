<template>
    <el-dialog
            :title="dialogTitle"
            :visible.sync="dialogVisible"
            width="600px"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="true" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item label="角色名称：" prop="name">
                <el-input v-model.trim="formData.name" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="权限字符：" prop="key">
                <el-input v-model.trim="formData.key" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="是否管理员：" prop="admin">
                <el-radio-group v-model="formData.admin" style="width: 300px">
                    <el-radio :label="1">是</el-radio>
                    <el-radio :label="0">否</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="状态：" prop="status">
                <el-radio-group v-model="formData.status" style="width: 300px">
                    <el-radio :label="1">启用</el-radio>
                    <el-radio :label="0">禁用</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="排序：" prop="sort">
                <el-input-number v-model="formData.sort"  :min="1" :max="9999"></el-input-number>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {apiSystemRoleEdit,apiSystemRoleAdd} from '@/api/api'
    export default {
        name: "addRole",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                dialogTitle:'',
                formData:{
                    admin:'',
                    key:'',
                    name:'',
                    status:1,
                    sort:'',
                    id:null
                },
                rules:{
                    name: [
                        {required: true, message: '请输入角色名称',trigger: 'blur'}
                    ],
                    admin: [
                        {required: true, message: '请选择是否管理员',trigger: 'blur'}
                    ],
                    key: [
                        {required: true, message: '请输入权限字符',trigger: 'blur'}
                    ],
                    status: [
                        {required: true, message: '请选择状态',trigger: 'blur'}
                    ],
                    sort: [
                        {required: true, message: '请输入排序',trigger: 'blur'}
                    ],
                },
            }
        },
        methods:{

            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
            },

            addRoleFn(item,flag) {
                this.dialogVisible=true
                this.dialogTitle=flag
                this.formData=item?item:{
                    admin:'',
                    key:'',
                    name:'',
                    status:1,
                    sort:''}
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        if(this.dialogTitle=="新增"){
                            apiSystemRoleAdd(this.formData).then(res=>{
                                this.loadingSave=false
                                if(res.code ==2000) {
                                    this.$message.success(res.msg)
                                    this.handleClose()
                                    this.$emit('refreshData')
                                } else {
                                    this.$message.warning(res.msg)
                                }
                            })
                        }else{
                            apiSystemRoleEdit(this.formData).then(res=>{
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


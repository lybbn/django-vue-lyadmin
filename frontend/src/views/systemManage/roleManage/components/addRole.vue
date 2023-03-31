<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="dialogTitle" width="660px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto">
                <el-form-item label="角色名称：" prop="name">
                    <el-input v-model.trim="formData.name" style="width: 100%"></el-input>
                </el-form-item>
                <el-form-item label="权限字符：" prop="key">
                    <el-input v-model.trim="formData.key" style="width: 100%"></el-input>
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
                    <el-input-number v-model="formData.sort"  :min="0" :max="9999"></el-input-number>
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
                <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>
            </template>
        </ly-dialog>
    </div>
</template>

<script>
    import {apiSystemRoleEdit,apiSystemRoleAdd} from '@/api/api'
    import LyDialog from "@/components/dialog/dialog";
    import {deepClone} from "@/utils/util";
    export default {
        components: {LyDialog},
        emits: ['refreshData'],
        name: "addRole",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                dialogTitle:'',
                formData:{
                    admin:1,
                    key:'',
                    name:'',
                    status:1,
                    sort:0,
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
                this.formData={
                    admin:1,
                    key:'',
                    name:'',
                    status:1,
                    sort:0,
                }
            },

            addRoleFn(item,flag) {
                this.dialogVisible=true
                this.dialogTitle=flag
                if(item){
                    this.formData=deepClone(item)
                }
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


<template>
    <div v-dialogDrag>
    <el-dialog
            :title="dialogTitle"
            v-model="dialogVisible"
            width="560px"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="true" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item label="名称：" prop="name">
                <el-input  v-model.trim="formData.name" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="key值：" prop="value">
                <el-input  v-model.trim="formData.value" style="width: 300px"></el-input>
            </el-form-item>
        </el-form>
        <template #footer>
            <el-button @click="handleClose" :loading="loadingSave">关闭</el-button>
            <el-button type="primary" @click="submitData"  :loading="loadingSave">保存</el-button>
        </template>
    </el-dialog>
    </div>
</template>

<script>
    import {systemButtonAdd,systemButtonEdit} from '@/api/api'
    import {deepClone} from "@/utils/util"
    export default {
        emits: ['refreshData'],
        name: "addButton",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                dialogTitle:'',
                formData:{
                    name: '',
                    value:'',
                },
                rules:{
                    name: [
                        {required: true, message: '请输入名称',trigger: 'blur'}
                    ],
                    value: [
                        {required: true, message: '请输入key值',trigger: 'blur'}
                    ],
                },

                buttonList:[],
            }
        },
        methods:{
            getName(e) {
                this.formData.value=e
                this.formData.name=this.buttonList.filter(item=>item.value==e)[0].name
            },
            handleClose() {
                this.formData={
                    name: '',
                    value:'',
                },
                this.dialogVisible=false
            },
            addButtonFn(item,flag,menu) {
                this.dialogVisible=true
                this.dialogTitle=flag
                if(item){
                    this.formData= deepClone(item)
                }
            },
            submitData() {
                // console.log(this.formData,'this.formData------')
                let param = {
                    ...this.formData
                }
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        if(this.dialogTitle=="新增"){
                            systemButtonAdd(param).then(res=>{
                                this.loadingSave=false
                                if(res.code ==2000) {
                                    this.$message.success(res.msg)
                                    this.dialogVisible=false
                                    this.$emit('refreshData')
                                } else {
                                    this.$message.warning(res.msg)
                                }
                            })
                        }else{
                            systemButtonEdit(param).then(res=>{
                                this.loadingSave=false
                                if(res.code ==2000) {
                                    this.$message.success(res.msg)
                                    this.dialogVisible=false
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

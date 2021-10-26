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
            <el-form-item label="标签信息：" prop="content" v-if="formData.type==1">
                <el-input type="textarea" v-model.trim="formData.content" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="留言标签：" prop="content" v-if="formData.type==2">
                <el-input type="textarea" v-model.trim="formData.content" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="取消原因：" prop="content" v-if="formData.type==3">
                <el-input type="textarea" v-model.trim="formData.content" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="排序：" prop="sort">
                <el-input-number v-model="formData.sort"  :min="1" :max="9999"></el-input-number>
            </el-form-item>
            <el-form-item label="状态" prop="status">
                <el-switch
                    v-model="formData.status"
                    active-color="#13ce66"
                    inactive-color="#ff4949">
                </el-switch>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {retrieveLabelAdd,retrieveLabelEdit} from "@/api/api";
    export default {
        name: "addModuleLabel",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                peopleList:[],
                formData:{
                    content:'',
                    type:'',
                    status:true,
                    sort:'',
                },
                rules:{
                    content: [
                        {required: true, message: '请输入内容',trigger: 'blur'}
                    ]
                },
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.$emit('refreshData')
            },
            addModuleFn(item,flag,activeName) {
                this.loadingTitle=flag
                this.dialogVisible=true
                this.formData=item ? item : {
                    content:'',
                    type:activeName,
                    status:true,
                    sort:'',
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
                            retrieveLabelEdit(param).then(res=>{
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
                            retrieveLabelAdd(param).then(res=>{
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
            },

        }
    }
</script>



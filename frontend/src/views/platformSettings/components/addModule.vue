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
            <el-form-item :label="(activeName==3 || activeName==4) ? '跳转链接：' :'图片：'" prop="img">
                <el-upload
                        class="avatar-uploader"
                        action=""
                        :show-file-list="false"
                        :http-request="imgUploadRequest"
                        :on-success="imgUploadSuccess"
                        :before-upload="imgBeforeUpload">
                    <img v-if="formData.image" :src="formData.image" class="avatar">
                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
            </el-form-item>
            <el-form-item label="位置：" prop="name" v-if="activeName==1">
                <el-input type="text" v-model.trim="formData.name" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="名称：" prop="name" v-if="activeName==2">
                <el-input v-model.trim="formData.name" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="排序：" prop="sort">
                <el-input-number v-model="formData.sort"  :min="1" :max="9999"></el-input-number>
            </el-form-item>
            <el-form-item label="状态：" prop="status">
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
    import {retrievePlatformimgAdd,retrievePlatformimgEdit,retrieveRecyclingcategoryAdd,retrieveRecyclingcategoryEdit,retrieveUploadPlatformImg} from "@/api/api";
    export default {
        name: "addModule",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                activeName:'',
                peopleList:[],
                formData:{
                    name:'',
                    image:'',
                    status:true,
                    sort:''
                },
                rules:{
                    image: [
                        {required: true, message: '请上传图片',trigger: 'blur'}
                    ],
                    name: [
                        {required: true, message: '请输入内容',trigger: 'blur'}
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
            addModuleFn(item,flag,activeName) {
                console.log(activeName,'activeName---')
                this.loadingTitle=flag
                this.dialogVisible=true
                this.activeName=activeName
                this.formData=item ? item : {
                    name:'',
                    image:'',
                    status:true,
                    sort:''
                }
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        if(this.activeName == 1){
                            if(this.formData.id){
                                retrievePlatformimgEdit(param).then(res=>{
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
                                retrievePlatformimgAdd(param).then(res=>{
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
                        }else if (this.activeName == 2){
                            if(this.formData.id){
                                retrieveRecyclingcategoryEdit(param).then(res=>{
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
                                retrieveRecyclingcategoryAdd(param).then(res=>{
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

                    }
                })
            },
            imgBeforeUpload(file) {
                const isJPG = file.type === 'image/jpeg' || file.type === 'image/png';
                if (!isJPG) {
                    this.$message.error('图片只能是 JPG/PNG 格式!');
                    return false
                }
                return isJPG;
            },
            async imgUploadRequest(param) {
                var vm = this
                let res= await retrieveUploadPlatformImg(param)
                console.log(res)
                if(res.code == 2000) {
                    vm.formData.image = res.data.data[0]
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess(res) {
                if (res) {
                    this.formData.img = res.url
                }
            }
        }
    }
</script>


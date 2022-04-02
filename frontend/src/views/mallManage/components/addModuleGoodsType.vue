<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="560px"
            center
            v-dialogDrag
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item label="分类名称：" prop="name">
                <el-input v-model.trim="formData.name" style="width: 300px"  :disabled="loadingTitle=='详情'"></el-input>
            </el-form-item>
            <el-form-item label="排序：" prop="sort">
                <el-input-number v-model="formData.sort" :min="0" :max="999999"></el-input-number>
            </el-form-item>
            <el-form-item label="分类图标：" prop="default_image">
                <el-upload
                        class="avatar-uploader"
                        action=""
                        :show-file-list="false"
                        :http-request="imgUploadRequest"
                        :on-success="imgUploadSuccess"
                        :before-upload="imgBeforeUpload">
                    <img v-if="formData.default_image" :src="formData.default_image" class="avatar">
                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
            </el-form-item>
<!--            <el-form-item label="状态：" prop="status" :disabled="loadingTitle=='详情'" >-->
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
    import {mallGoodstypeAdd,mallGoodstypeEdit,platformsettingsUploadPlatformImg} from "@/api/api";
    export default {
        name: "addModuleGoodsType",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    name:"",
                    sort:0,
                    parent:"",
                    default_image:"",
                },
                rules:{
                    name: [
                        {required: true, message: '请输入橱窗名称',trigger: 'blur'}
                    ],
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
                    name:"",
                    parent:"",
                    default_image:"",
                    sort:0,
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
                            mallGoodstypeEdit(param).then(res=>{
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
                            mallGoodstypeAdd(param).then(res=>{
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
                let obj= await platformsettingsUploadPlatformImg(param)
                if(obj.code == 2000) {
                    let res=''
                    if (obj.data.data[0].indexOf("://")>=0){
                        res = obj.data.data[0]

                    }else{
                        res = url.split('/api')[0]+obj.data.data[0]
                    }
                    vm.formData.default_image = res
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess(res) {
                // if (res) {
                //     this.formData.image = res.url
                // }
            }
        }
    }
</script>


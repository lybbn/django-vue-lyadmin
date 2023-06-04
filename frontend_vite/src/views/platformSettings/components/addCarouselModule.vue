<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="560px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto">
                <el-form-item :label="(formData.type==1) ? '图片：' :'图片：'" prop="image">
                    <el-upload
                            class="avatar-uploader"
                            action=""
                            :show-file-list="false"
                            :http-request="imgUploadRequest"
                            :on-success="imgUploadSuccess"
                            :before-upload="imgBeforeUpload">
                        <img v-if="formData.image" :src="formData.image" class="avatar" />
                        <el-icon v-else class="avatar-uploader-icon" size="medium"><Plus /></el-icon>
                    </el-upload>
                </el-form-item>
                <el-form-item label="标题：" prop="title">
                    <el-input type="text" v-model.trim="formData.title"></el-input>
                </el-form-item>
                <el-form-item label="跳转链接：" prop="link" v-if="formData.type==1 || formData.type==2">
                    <el-input v-model.trim="formData.link"></el-input>
                </el-form-item>
                <el-form-item label="排序：" prop="sort">
                    <el-input-number v-model="formData.sort"  :min="0" :max="9999"></el-input-number>
                </el-form-item>
                <el-form-item label="状态：" prop="status">
                    <el-switch
                            v-model="formData.status"
                            active-color="#13ce66"
                            inactive-color="#ff4949">
                    </el-switch>
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
    import {platformsettingsLunboimgAdd,platformsettingsLunboimgEdit,platformsettingsUploadPlatformImg} from "@/api/api";
    import {url} from '@/api/url'
    import LyDialog from "@/components/dialog/dialog.vue";
    export default {
        components: {LyDialog},
        emits: ['refreshData'],
        name: "addModule",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                peopleList:[],
                formData:{
                    title:'',
                    link:'',
                    image:'',
                    type:'',
                    sort:0,
                    status:true
                },
                rules:{
                    image: [
                        {required: true, message: '请上传图片',trigger: 'blur'}
                    ],
                    link: [
                        {required: true, message: '请输入链接',trigger: 'blur'}
                    ],
                    title: [
                        {required: true, message: '请输入标题',trigger: 'blur'}
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
                this.loadingTitle=flag
                this.dialogVisible=true

                this.formData=item ? item : {
                    title:'',
                    link:'',
                    image:'',
                    type:activeName,
                    sort:0,
                    status:true
                }
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        // let newimage = ""
                        // if (this.formData.image.indexOf("://")>=0){
                        //     newimage = this.formData.image.substring(this.formData.image.indexOf("/",8))
                        // }else{
                        //     newimage = this.formData.image
                        // }
                        // this.formData.image = newimage
                        let param = {
                            ...this.formData
                        }
                        if(this.formData.id){
                            platformsettingsLunboimgEdit(param).then(res=>{
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
                            platformsettingsLunboimgAdd(param).then(res=>{
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
                    vm.formData.image = res
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
<style scoped>
    .avatar-uploader .el-upload {
      border: 1px dashed #d9d9d9;
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
    }
    .avatar-uploader .el-upload:hover {
      border-color: #409EFF;
    }
    .avatar-uploader-icon {
      font-size: 28px;
      color: #8c939d;
      width: 128px;
      height: 128px;
      line-height: 128px;
      text-align: center;
    }
    .avatar {
      width: 128px;
      height: 128px;
      display: block;
    }
</style>


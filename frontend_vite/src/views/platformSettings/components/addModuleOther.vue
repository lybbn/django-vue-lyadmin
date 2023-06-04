<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="660px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto">
                <el-form-item label="名称：" prop="name">
                    <el-input v-model.trim="formData.name"></el-input>
                </el-form-item>
                <el-form-item label="键名：" prop="key" v-show="loadingTitle=='新增'">
                    <el-input v-model.trim="formData.key" :disabled="loadingTitle=='编辑'"></el-input>
                    <span style="color: red;font-size: 10px;margin-left: 8px">提示：该项添加后不能修改</span>
                </el-form-item>
                <el-form-item label="类型：" v-show="loadingTitle=='新增'">
                    <el-radio-group v-model="formData.type" :disabled="loadingTitle=='编辑'">
                        <el-radio :label="1">正常值</el-radio>
                        <el-radio :label="2">富文本</el-radio>
                        <el-radio :label="3">图片</el-radio>
                        <el-radio :label="4">视频</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="" v-if="formData.type==2">
                    <TEditor v-model="formData.value"></TEditor>
                </el-form-item>
                <el-form-item label="" v-if="formData.type==3">
                    <el-upload
                            class="avatar-uploader"
                            action=""
                            :show-file-list="false"
                            ref="uploadDefaultImage"
                            :http-request="imgUploadRequest"
                            :on-success="imgUploadSuccess"
                            :before-upload="imgBeforeUpload">
                        <img v-if="formData.value" :src="formData.value" class="avatar">
                        <el-icon v-else class="avatar-uploader-icon" size="medium"><Plus /></el-icon>
                    </el-upload>
                </el-form-item>
                <el-form-item v-if="formData.type==4">
                    <el-upload
                        class="avatar-uploader"
                        ref="lyvideoupload"
                        :limit="1"
                        action="#"
                        :show-file-list="false"
                        accept=".flv,.mp4"
                        :http-request="videoUploadRequest">
                        <video v-if="formData.value"  class="avatar"  width="100%" :autoplay="false" height="500" :src="formData.value"  controls></video>
                        <el-icon v-else class="avatar-uploader-icon" size="medium"><Plus /></el-icon>
<!--                        <template #file="{ file }">-->
<!--                            <video  class="el-upload-list__item-thumbnail"  width="100%" :autoplay="false" height="500" :src="file.url"  controls></video>-->
<!--                            <span class="el-upload-list__item-actions">-->
<!--                                <span class="el-upload-list__item-preview" @click="showvideohandle(file.url)">-->
<!--                                    <el-icon><zoom-in /></el-icon>-->
<!--                                </span>-->
<!--                                <span v-if="!videoDisabled" class="el-upload-list__item-delete" @click="imghandleRemove(file)">-->
<!--                                  <el-icon><Delete /></el-icon>-->
<!--                                </span>-->
<!--                          </span>-->
<!--                        </template>-->
                    </el-upload>
                    <el-input v-model="formData.value" style="margin-top: 10px"></el-input>
                </el-form-item>
                <el-form-item label="键值：" prop="value" v-if="formData.type==1">
                    <el-input v-model.trim="formData.value"></el-input>
                </el-form-item>
                <el-form-item label="排序：" prop="sort">
                    <el-input-number v-model="formData.sort"  :min="0" :max="9999"></el-input-number>
                </el-form-item>
                <el-form-item label="状态：" prop="status" v-if="false">
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
    import {platformsettingsOtherAdd,platformsettingsOtherEdit,platformsettingsUploadPlatformImg} from "@/api/api";
    import TEditor from '@/components/TEditor.vue'
    import LyDialog from "@/components/dialog/dialog.vue";
    export default {
        components: {LyDialog, TEditor },
        emits: ['refreshData'],
        name: "addModuleOther",
        data() {
            return {
                videoDisabled:false,
                isClear: false,
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    name:'',
                    key:'',
                    value:'',
                    sort:0,
                    type:1,
                    status:true,
                },
                rules:{
                    name: [
                        {required: true, message: '请输入名称',trigger: 'blur'}
                    ],
                    key: [
                        {required: true, message: '请输入键名',trigger: 'blur'}
                    ],
                    value: [
                        {required: true, message: '请输入键值',trigger: 'blur'}
                    ],
                },
            }
        },
        mounted() {
            window.addEventListener("focusin", this.onFocusIn,true);
        },
        unmounted() {
            window.removeEventListener("focusin", this.onFocusIn);
        },
        methods:{
            onFocusIn(e){
                e.stopImmediatePropagation()//阻止当前和后面的一系列事件
            },
            showvideohandle(url) {
              this.$alert(
                `<video width="320" height="240" controls>
                              <source src="${url}"  type="video/mp4">
                              您的浏览器不支持 HTML5 video 标签。
                            </video>`,
                "视频预览",
                {
                  dangerouslyUseHTMLString: true
                }
              );
            },
            //多图上传方法
            imghandleRemove(file) {
                console.log(file)
                let fileList = this.$refs.lyvideoupload.uploadFiles;
                let index = fileList.findIndex( fileItem => {return fileItem.uid === file.uid});
                fileList.splice(index, 1);
            },
            async videoUploadRequest(param) {
                var vm = this
                let obj= await platformsettingsUploadPlatformImg(param)
                if(obj.code == 2000) {
                    let res=''
                    if (obj.data.data[0].indexOf("://")>=0){
                        res = obj.data.data[0]

                    }else{
                        res = url.split('/api')[0]+obj.data.data[0]
                    }
                    vm.formData.value = res
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.formData={
                    name:'',
                    key:'',
                    value:'',
                    sort:0,
                    type:1,
                    status:true,
                },
                this.$emit('refreshData')
            },
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                if(item){
                    this.formData = item
                }
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        param.type = parseInt(this.formData.type)
                        if(this.formData.id){
                            platformsettingsOtherEdit(param).then(res=>{
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
                            platformsettingsOtherAdd(param).then(res=>{
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
                    vm.formData.value = res
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess() {
                this.$refs.uploadDefaultImage.clearFiles()
            }
        },
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
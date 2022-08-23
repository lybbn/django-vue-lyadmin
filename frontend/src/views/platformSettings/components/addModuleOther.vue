<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="660px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto">
                <el-form-item label="名称：" prop="name">
                    <el-input v-model.trim="formData.name"></el-input>
                </el-form-item>
                <el-form-item label="排序：" prop="sort">
                    <el-input-number v-model="formData.sort"  :min="0" :max="9999"></el-input-number>
                </el-form-item>
                <el-form-item label="键名：" prop="key">
                    <el-input v-model.trim="formData.key" :disabled="loadingTitle=='编辑'"></el-input>
                    <span style="color: red;font-size: 10px;margin-left: 8px">提示：该项添加后不能修改</span>
                </el-form-item>
                <el-form-item label="类型：">
                    <el-radio-group v-model="type" :disabled="loadingTitle=='编辑'">
                        <el-radio label="1">正常值</el-radio>
                        <el-radio label="2">富文本</el-radio>
                        <el-radio label="3">图片</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="" v-if="type==2">
                    <TEditor v-model="formData.value"></TEditor>
                </el-form-item>
                <el-form-item label="" v-if="type==3">
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
                <el-form-item label="键值：" prop="value" v-if="type==1">
                    <el-input v-model.trim="formData.value"></el-input>
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
    import {platformsettingsOtherAdd,platformsettingsOtherEdit,platformsettingsUploadPlatformImg} from "@/api/api";
    import TEditor from '@/components/TEditor'
    import LyDialog from "../../../components/dialog/dialog";
    export default {
        components: {LyDialog, TEditor },
        emits: ['refreshData'],
        name: "addModuleOther",
        data() {
            return {
                type:'1',
                isClear: false,
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    name:'',
                    key:'',
                    value:'',
                    sort:0,
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
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.$emit('refreshData')
            },
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                this.formData=item ? item : {
                    name:'',
                    key:'',
                    value:'',
                    sort:0,
                    status:true,
                }
                if(item){
                    this.type = item.type.toString()
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
                            param.type = this.type
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
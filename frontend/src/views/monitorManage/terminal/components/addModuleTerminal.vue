<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="560px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto">
<!--                <el-form-item label="用户头像：">-->
<!--                    <el-upload-->
<!--                            class="avatar-uploader"-->
<!--                            action=""-->
<!--                            :show-file-list="false"-->
<!--                            ref="uploadDefaultImage"-->
<!--                            :http-request="imgUploadRequest"-->
<!--                            :on-success="imgUploadSuccess"-->
<!--                            :before-upload="imgBeforeUpload">-->
<!--                        <img v-if="formData.avatar" :src="formData.avatar" class="avatar" >-->
<!--                        <el-icon v-else class="avatar-uploader-icon" size="medium"><Plus /></el-icon>-->
<!--                    </el-upload>-->
<!--                </el-form-item>-->
                <el-form-item label="服务器IP：" prop="host">
                    <el-input v-model="formData.host"></el-input>
                </el-form-item>
                <el-form-item label="端口号：" prop="port">
                    <el-input-number v-model="formData.port" :min="1" :max="65536"></el-input-number>
                </el-form-item>
                <el-form-item label="SSH账号：" prop="username">
                    <el-input v-model="formData.username"></el-input>
                </el-form-item>
                <el-form-item label="验证方式：" prop="type">
                    <el-radio-group v-model="formData.type">
                        <el-radio-button label="0"  >密码验证</el-radio-button>
                        <el-radio-button label="1" >私钥验证</el-radio-button>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="密码：" prop="password" v-if="formData.type=='0'">
                    <el-input v-model="formData.password" :show-password="true"></el-input>
                </el-form-item>
                <el-form-item label="私钥：" prop="pkey" v-if="formData.type=='1'">
                    <el-input v-model="formData.pkey" type="textarea" :rows="2"></el-input>
                </el-form-item>
                <el-form-item label="私钥密码：" prop="pkey_passwd" v-if="formData.type=='1'">
                    <el-input v-model="formData.pkey_passwd"></el-input>
                </el-form-item>
                <el-form-item label="备注：" prop="remark">
                    <el-input v-model="formData.remark" type="textarea" :rows="2"></el-input>
                </el-form-item>
<!--                <el-form-item label="状态：" prop="is_active">-->
<!--                    <el-switch-->
<!--                        v-model="formData.is_active"-->
<!--                        active-color="#13ce66"-->
<!--                        inactive-color="#ff4949">-->
<!--                    </el-switch>-->
<!--                </el-form-item>-->
            </el-form>
            <template #footer>
                <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
                <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>
            </template>
        </ly-dialog>
    </div>
</template>

<script>
    import {apiTerminalAdd,apiTerminalEdit,platformsettingsUploadPlatformImg} from "@/api/api";
    import LyDialog from "../../../../components/dialog/dialog";
    export default {
        name: "addModuleTerminal",
        components: {LyDialog},
        emits: ['refreshData'],
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    username:'',
                    port:22,
                    host:'',
                    type:'0',
                    remark:'',
                    password:'',
                    pkey_passwd:'',
                    pkey:'',
                },

                rules:{
                    host: [
                        {required: true, message: '请输入服务器IP',trigger: 'blur'}
                    ],
                    port: [
                        {required: true, message: '请输入端口号',trigger: 'blur'}
                    ],
                    username: [
                        {required: true, message: '请输入SSH账号',trigger: 'blur'}
                    ],
                    // nickname: [
                    //     {required: true, message: '请输入昵称',trigger: 'blur'}
                    // ],
                },
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.formData = {
                    username:'',
                    port:22,
                    host:'',
                    type:'0',
                    remark:'',
                    password:'',
                    pkey_passwd:'',
                    pkey:'',
                }
                this.$emit('refreshData')
            },
            addUserFn(item,flag) {
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
                        // if(param.type === '0'){
                        //     if(param.password == ""){
                        //         this.loadingSave=false
                        //         this.$message.warning("密码不能为空")
                        //         return
                        //     }
                        // }
                        if(param.type === '1'){
                            if(param.pkey == ""){
                                this.loadingSave=false
                                this.$message.warning("秘钥不能为空")
                                return
                            }
                        }
                        if(this.formData.id){
                            apiTerminalEdit(param).then(res=>{
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
                            apiTerminalAdd(param).then(res=>{
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
                    vm.formData.avatar = res
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess() {
                this.$refs.uploadDefaultImage.clearFiles()
            }
        }
    }
</script>


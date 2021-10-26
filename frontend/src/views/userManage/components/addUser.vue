<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="560px"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="false" :model="formData" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item label="用户头像：">
                <img :src="formData.avatar" style="width: 60px;height:60px">

<!--                <el-upload-->
<!--                        class="avatar-uploader"-->
<!--                        action=""-->
<!--                        :show-file-list="false"-->
<!--                        :http-request="imgUploadRequest"-->
<!--                        :on-success="imgUploadSuccess"-->
<!--                        :before-upload="imgBeforeUpload">-->
<!--                    <img v-if="formData.img" :src="formData.img" class="avatar">-->
<!--                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>-->
<!--                </el-upload>-->
            </el-form-item>
            <el-form-item label="用户昵称：" prop="nickname">
                {{formData.nickname}}
            </el-form-item>
            <el-form-item label="手机号：" prop="mobile">
                {{formData.mobile}}
            </el-form-item>
            <el-form-item label="积分：" prop="integral">
                {{formData.integral}}
            </el-form-item>
            <el-form-item label="身份：" prop="identity">
                        <span  v-for='(item,index) in formData.identity' :key="index">
                            <label v-if="item==0">{{(index>0 && index < formData.identity.length?'、':'') +"普通用户"}}</label>
                            <label v-if="item==1">{{(index>0 && index < formData.identity.length?'、':'') +"回收员"}}</label>
                            <label v-if="item==2">{{(index>0 && index < formData.identity.length?'、':'') +"回收站点"}}</label>
                            <label v-if="item==3">{{(index>0 && index < formData.identity.length?'、':'') +"代理商"}}</label>
                        </span>
            </el-form-item>
            <el-form-item label="状态：" prop="is_active">
                <el-switch
                        v-model="formData.is_active"
                        active-color="#13ce66"
                        inactive-color="#ff4949" disabled>
                </el-switch>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
<!--            <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>-->
        </span>
    </el-dialog>
</template>

<script>
    import {apiSystemUserAdd,apiSystemUserEdit,apiSystemRole,apiSystemDept} from "@/api/api";
    export default {
        name: "addUser",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    name:'',
                    nickname:'',
                    integral:'',
                    mobile:'',
                    identity:'',
                    is_active:true,
                    avatar:''
                },
                rolelist:[],
                options:[],
            }
        },
        methods:{

            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.$emit('refreshData')
            },
            addUserFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                this.formData=item ? item : {
                    name:'',
                    nickname:'',
                    integral:'',
                    mobile:'',
                    identity:'',
                    is_active:true,
                    avatar:''
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
                            apiSystemUserEdit(param).then(res=>{
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
                            apiSystemUserAdd(param).then(res=>{
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
            async imgUploadRequest(option) {
                // OSS.ossUploadProductImg(option);
            },
            imgUploadSuccess(res) {
                if (res) {
                    this.formData.img = res.url
                }
            },
        }
    }
</script>


<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="45%"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="false" :model="formData" ref="rulesForm" label-position="right" label-width="130px" clas="form-data">
            <el-form-item label="用户头像：">
<!--                <img :src="formData.img" style="width: 60px;height:60px">-->
<!--                <el-upload-->
<!--                        class="avatar-uploader"-->
<!--                        action="https://jsonplaceholder.typicode.com/posts/"-->
<!--                        :show-file-list="false"-->
<!--                        :http-request="imgUploadRequest"-->
<!--                        :on-success="imgUploadSuccess"-->
<!--                        :before-upload="imgBeforeUpload">-->
<!--                    <img v-if="formData.img" :src="formData.img" class="avatar">-->
<!--                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>-->
<!--                </el-upload>-->
                 <el-image  :src=formData.info.images3 :preview-src-list="[formData.info.images3]" style="width: 30px;height:30px"></el-image>
            </el-form-item>
            <el-form-item label="代理商名称：" prop="name">
                {{formData.name}}
            </el-form-item>
            <el-form-item label="手机号：" prop="mobile">
                {{formData.mobile}}
            </el-form-item>
            <el-form-item label="身份证号：" prop="info">
                {{formData.info.idcard}}
            </el-form-item>
            <el-form-item label="代理商位置：" prop="info">
                        <span v-for='(item,index) in formData.info.agentaddress' :key="index">
                            {{(index>0 && index < formData.info.agentaddress.length?'、':'') +item}}
                        </span>
            </el-form-item>
            <el-form-item label="身份资料：" prop="info">
                <el-image :src=formData.info.images1 :preview-src-list="[formData.info.images1]" style="width: 80px;height:60px;margin: 5px 5px 0 0"></el-image>
                <el-image :src=formData.info.images2 :preview-src-list="[formData.info.images2]" style="width: 80px;height:60px;margin: 5px 5px 0 0"></el-image>
            </el-form-item>
            <el-form-item label="登陆账号：" prop="username">
                {{formData.username}}
            </el-form-item>
<!--            <el-form-item label="登陆密码：" prop="mobile">-->
<!--                {{formData.mobile}}-->
<!--            </el-form-item>-->
            <el-form-item label="状态：" prop="is_active">
<!--                <el-switch-->
<!--                    v-model="formData.is_active"-->
<!--                    active-color="#13ce66"-->
<!--                    inactive-color="#ff4949" disabled>-->
<!--                </el-switch>-->
                <el-tag v-if="formData.is_active">正常</el-tag>
                <el-tag v-else type="danger">禁用</el-tag>
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
        name: "addModule",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    info:{
                        'images3':''
                    }
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
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                this.formData=item ? item : {
                    info:{
                        'images3':''
                    }
                }

                // this.formData.role = item?item.role.join(" "):[]
            },
            submitData() {
                // this.$refs['rulesForm'].validate(obj=>{
                //     if(obj) {
                //         this.loadingSave=true
                //         let param = {
                //             ...this.formData
                //         }
                //         param.role = param.role?param.role.split(" "):[]
                //         if(typeof  param.dept == 'object') {
                //             param.dept=param.dept[param.dept.length-1]
                //         }
                //         if(this.formData.id){
                //             apiSystemUserEdit(param).then(res=>{
                //                 this.loadingSave=false
                //                 if(res.code ==2000) {
                //                     this.$message.success(res.msg)
                //                     this.handleClose()
                //                     this.$emit('refreshData')
                //                 } else {
                //                     this.$message.warning(res.msg)
                //                 }
                //             })
                //         }else{
                //             apiSystemUserAdd(param).then(res=>{
                //                 this.loadingSave=false
                //                 if(res.code ==2000) {
                //                     this.$message.success(res.msg)
                //                     this.handleClose()
                //                     this.$emit('refreshData')
                //                 } else {
                //                     this.$message.warning(res.msg)
                //                 }
                //             })
                //         }
                //
                //     }
                // })
            },
            // getapiSystemRole(){
            //     apiSystemRole().then(res=>{
            //         if(res.code ==2000) {
            //             this.rolelist = res.data.data
            //         } else {
            //             this.$message.warning(res.msg)
            //         }
            //     })
            // },
            // getapiSystemDept(){
            //     apiSystemDept().then(res=>{
            //         if(res.code ==2000) {
            //             let childrenList = res.data.data.filter(item=> item.parent)
            //             let parentList = res.data.data.filter(item=> !item.parent)
            //             if(parentList.length >0) {
            //                 parentList.forEach(item=>{
            //                     let children = childrenList.filter(itema=>itema.parent == item.id)
            //                     item.children=[...children]
            //                 })
            //             }
            //             this.options = parentList
            //         } else {
            //             this.$message.warning(res.msg)
            //         }
            //     })
            // },

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
<style>
    .form-data /deep/.el-form-item{
        margin-bottom: 10px !important;
    }
</style>

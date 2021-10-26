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
            <el-form-item label="头像：" prop="name">
<!--                <img src="" style="width: 60px;height:60px">-->
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
                 <el-image  :src=formData.avatar :preview-src-list="[formData.avatar]" style="width: 30px;height:30px"></el-image>
            </el-form-item>
            <el-form-item label="回收员：" prop="name">
                {{formData.name}}
            </el-form-item>
            <el-form-item label="手机号：" prop="mobile">
                {{formData.mobile}}
            </el-form-item>
            <el-form-item label="身份证号：" prop="info">
                {{formData.info.idcard}}
            </el-form-item>
<!--            <el-form-item label="登陆账号：" prop="username">-->
<!--                <el-input v-model.trim="formData.name" style="width: 300px"></el-input>-->
<!--            </el-form-item>-->
<!--            <el-form-item label="登录密码：" prop="password">-->
<!--                <el-input v-model.trim="formData.name" style="width: 300px"></el-input>-->
<!--            </el-form-item>-->
            <el-form-item label="代理商名称：" prop="info">
                {{formData.info.agentname}}
            </el-form-item>
            <el-form-item label="代理商位置：" prop="info">
                            {{formData.info.agentaddress}}
            </el-form-item>
             <el-form-item label="身份资料：" prop="info">
                <el-image :src=formData.info.images1 :preview-src-list="[formData.info.images1]" style="width: 80px;height:60px;margin: 5px 5px 0 0"></el-image>
                <el-image :src=formData.info.images2 :preview-src-list="[formData.info.images2]" style="width: 80px;height:60px;margin: 5px 5px 0 0"></el-image>
            </el-form-item>
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
                        'idcard':'',
                    }
                },
                rules:{
                    // name: [
                    //     {required: true, message: '请输入管理员名称',trigger: 'blur'}
                    // ],
                    // role: [
                    //     {required: true, message: '请选择角色',trigger: 'blur'}
                    // ],
                    // // dept: [
                    // //     {required: true, message: '请选择部门',trigger: 'blur'}
                    // // ],
                    // username: [
                    //     {required: true, message: '请输入管理员用户名',trigger: 'blur'}
                    // ],
                    // is_active: [
                    //     {required: true, message: '请选择是否启用',trigger: 'blur'}
                    // ]
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
                        'idcard':'',
                    }
                }
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
            getapiSystemRole(){
                apiSystemRole().then(res=>{
                    if(res.code ==2000) {
                        this.rolelist = res.data.data
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            },
            getapiSystemDept(){
                apiSystemDept().then(res=>{
                    if(res.code ==2000) {
                        let childrenList = res.data.data.filter(item=> item.parent)
                        let parentList = res.data.data.filter(item=> !item.parent)
                        if(parentList.length >0) {
                            parentList.forEach(item=>{
                                let children = childrenList.filter(itema=>itema.parent == item.id)
                                item.children=[...children]
                            })
                        }
                        this.options = parentList
                    } else {
                        this.$message.warning(res.msg)
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


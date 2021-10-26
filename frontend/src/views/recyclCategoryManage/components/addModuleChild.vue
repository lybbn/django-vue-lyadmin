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
            <el-form-item label="图片(71*60)：" prop="image">
<!--                <img src="" style="width: 60px;height:60px">-->

                <el-upload
                        class="avatar-uploader"
                        :limit="1"
                        action=""
                        :show-file-list="false"
                        :http-request="imgUploadRequest"
                        :on-success="imgUploadSuccess"
                        :before-upload="imgBeforeUpload">
                    <img v-if="formData.image" :src="formData.image" class="avatar">
                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
            </el-form-item>
            <el-form-item label="名称：" prop="name">
                <el-input v-model.trim="formData.name" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="简介：" prop="desc">
                <el-input v-model.trim="formData.desc" maxlength="200" type="textarea" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="价格：" prop="price">
                <el-input v-model.trim="formData.price" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="单位：" prop="unite">
                <el-input v-model.trim="formData.unite" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="一级分类：" prop="onelevel">
                <el-select size="small" v-model="formData.onelevel" placeholder="请选择" clearable style="width: 300px">
                    <el-option
                            v-for="item in parentList"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                    </el-option>
                </el-select>
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
    import {retrieveRetrievecategory2Add,retrieveRetrievecategory2Edit,retrieveRetrievecategory1,retrieveUploadretrievecategoryimg} from "@/api/api";
    export default {
        name: "addModuleChild",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    image:'',
                    name:'',
                    desc:'',
                    price:'',
                    unite:'',
                    onelevel:'',
                    status:true,
                    sort:'',
                },
                rules:{
                    name: [
                        {required: true, message: '请输入名称',trigger: 'blur'}
                    ],
                    desc: [
                        {required: true, message: '请输入简介',trigger: 'blur'}
                    ],
                    price: [
                        {required: true, message: '请输入价格',trigger: 'blur'}
                    ],
                    unite: [
                        {required: true, message: '请输入单位',trigger: 'blur'}
                    ],
                    onelevel: [
                        {required: true, message: '请选择一级分类',trigger: 'blur'}
                    ],
                    image: [
                        {required: true, message: '请上传图片',trigger: 'blur'}
                    ],
                },
                parentList:[]
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
                    image:'',
                    name:'',
                    desc:'',
                    price:'',
                    unite:'',
                    onelevel:'',
                    status:true,
                    sort:'',
                }
                this.getRecyclCategoryParent()
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        if(this.formData.id){
                            retrieveRetrievecategory2Edit(param).then(res=>{
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
                            retrieveRetrievecategory2Add(param).then(res=>{
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
            getRecyclCategoryParent(){
                let param = {
                    page: 1,
                    limit: 9999999,
                }
                retrieveRetrievecategory1(param).then(res => {
                    if(res.code ==2000) {
                        this.parentList = res.data.data
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
                let res= await retrieveUploadretrievecategoryimg(param)
                if(res.code == 2000) {
                    vm.formData.image = res.data.data.img
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess(res) {
                // console.log(res,'res-----')
            },
        }
    }
</script>

<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="560px"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="true" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <!--<el-form-item label="管理员编号：" prop="id">-->
                <!--<el-input v-model.trim="formData.id" style="width: 300px"></el-input>-->
            <!--</el-form-item>-->
            <el-form-item label="管理员名称：" prop="name">
                <el-input v-model="formData.name" style="width: 300px"></el-input>
            </el-form-item>
            <!--<el-form-item label="权限字符：" prop="name">
                <el-input v-model.trim="formData.name" style="width: 300px"></el-input>
            </el-form-item>-->
            <el-form-item label="登陆账号：" prop="username">
                <el-input v-model.trim="formData.username" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="登录密码：" prop="password">
                <el-input v-model.trim="formData.password" style="width: 300px"></el-input>
            </el-form-item>
            <!--<el-form-item label="排序：" prop="sort">-->
                <!--<el-input-number v-model="formData.sort" :min="1" :max="999999"></el-input-number>-->
            <!--</el-form-item>-->
            <el-form-item label="角色：" prop="role">
                <el-radio-group v-model="formData.role">
                    <el-radio :label="item.id" v-for="(item,index) in rolelist" :key="index">{{item.name}}</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="部门：" prop="dept" >
                <el-cascader style="width: 300px" :show-all-levels="false" v-model="formData.dept" :props="{checkStrictly: true ,label:'name',value:'id'}" :options="options"></el-cascader>
            </el-form-item>
            <el-form-item label="状态：" prop="is_active">
                <el-switch
                    v-model="formData.is_active"
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
    import {apiSystemUserAdd,apiSystemUserEdit,apiSystemRole,apiSystemDept} from "@/api/api";
    export default {
        name: "addAdmin",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    name:'',
                    username:'',
                    password:'123456',
                    dept:'',
                    role:'',
                    is_active:true
                },
                rules:{
                    name: [
                        {required: true, message: '请输入管理员名称',trigger: 'blur'}
                    ],
                    role: [
                        {required: true, message: '请选择角色',trigger: 'blur'}
                    ],
                    // dept: [
                    //     {required: true, message: '请选择部门',trigger: 'blur'}
                    // ],
                    username: [
                        {required: true, message: '请输入管理员用户名',trigger: 'blur'}
                    ],
                    is_active: [
                        {required: true, message: '请选择是否启用',trigger: 'blur'}
                    ]
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
            addAdminFn(item,flag) {
                this.getapiSystemRole()
                this.getapiSystemDept()
                this.loadingTitle=flag
                this.dialogVisible=true
                // console.log(item,'item----')
                if(item && item.dept) {
                    item.dept = item.dept.split(" ")
                }
                this.formData=item ? item : {
                    name:'',
                    username:'',
                    password:'123456',
                    dept:'',
                    role:'',
                    is_active:true
                }

                this.formData.role = item?item.role.join(" "):[]
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        param.role = param.role?param.role.split(" "):[]
                        if(typeof  param.dept == 'object') {
                            param.dept=param.dept[param.dept.length-1]
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


        }
    }
</script>


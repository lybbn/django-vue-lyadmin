<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="640px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto">
                <!--<el-form-item label="管理员编号：" prop="id">-->
                    <!--<el-input v-model.trim="formData.id" style="width: 300px"></el-input>-->
                <!--</el-form-item>-->
                <el-form-item label="管理员名称：" prop="name">
                    <el-input v-model="formData.name"></el-input>
                </el-form-item>
                <el-form-item label="登录账号：" prop="username">
                    <el-input v-model.trim="formData.username"></el-input>
                </el-form-item>
                <el-form-item label="登录密码：" prop="password">
                    <el-input v-model.trim="formData.password"></el-input>
                </el-form-item>
                <!--<el-form-item label="排序：" prop="sort">-->
                    <!--<el-input-number v-model="formData.sort" :min="1" :max="999999"></el-input-number>-->
                <!--</el-form-item>-->
                <el-form-item label="角色：" prop="role">
                    <el-checkbox-group v-model="formData.role">
                        <el-checkbox :label="item.id" v-for="(item,index) in rolelist" :key="index">{{item.name}}</el-checkbox>
                    </el-checkbox-group>
                </el-form-item>
                <el-form-item label="部门：" prop="dept">
                    <el-tree-select v-model="formData.dept" node-key="id" :data="options"
                            check-strictly filterable clearable :render-after-expand="false"
                            :props="{label:'name',value: 'id'}"
                            style="width: 100%" placeholder="请选择" />
                </el-form-item>
                <el-form-item label="状态：" prop="is_active">
                    <el-switch
                        v-model="formData.is_active"
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
    import {apiSystemUserAdd,apiSystemUserEdit,apiSystemRole,apiSystemDept} from "@/api/api";
    import LyDialog from "@/components/dialog/dialog";
    import XEUtils from "xe-utils";
    import {deepClone} from "@/utils/util";
    export default {
        components: {LyDialog},
        emits: ['refreshData'],
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
                    role:[],
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
                this.formData = {
                    name:'',
                    username:'',
                    password:'123456',
                    dept:'',
                    role:[],
                    is_active:true
                }
            },
            addAdminFn(item,flag) {
                this.getapiSystemRole()
                this.getapiSystemDept()
                this.loadingTitle=flag
                this.dialogVisible=true
                // console.log(item,'item----')
                // if(item && item.dept) {
                //     item.dept = item.dept.split(" ")
                // }
                if(item){
                    this.formData = deepClone(item)
                }

                this.formData.role = item?item.role:[]
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        if(param.role){
                            let rolearr = []
                            for(var r in param.role){
                                rolearr.push(param.role[r])
                            }
                            param.role = rolearr
                        }else{
                            param.role = []
                        }
                        if(param.dept){
                            if(typeof  param.dept == 'object') {
                                param.dept=param.dept[param.dept.length-1]
                            }
                        }else{
                            param.dept = ''
                        }

                        if(this.formData.nickname=="" || this.formData.nickname== undefined || this.formData.nickname.length<=0 || this.formData.nickname=='""'){
                            param.nickname = this.formData.name
                        }
                        if(this.formData.id){
                            if(param.post.length<1){
                                delete param.post
                            }
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
                apiSystemRole({page:1,limit:999,status:1}).then(res=>{
                    if(res.code ==2000) {
                        this.rolelist = res.data.data
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            },
            getapiSystemDept(){
                apiSystemDept({page:1,limit:999}).then(res=>{
                    if(res.code ==2000) {
                        this.options = XEUtils.toArrayTree(res.data.data, { parentKey: 'parent' })
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            },


        }
    }
</script>


<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="dialogTitle" width="640px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto" class="form-store">
                <el-form-item label="父级部门：" prop="parent">
                    <el-tree-select v-model="formData.parent" node-key="id" :data="options"
                            check-strictly filterable clearable :render-after-expand="false"
                            :props="{label:'name',value: 'id'}"
                            style="width: 100%" placeholder="请选择/为空则为顶级" />
                </el-form-item>
                <el-form-item label="部门名称：" prop="name">
                    <el-input v-model.trim="formData.name"></el-input>
                </el-form-item>
                <el-form-item label="负责人：" prop="owner">
                    <el-input v-model.trim="formData.owner"></el-input>
                </el-form-item>
                <el-form-item label="联系电话：" prop="phone">
                    <el-input v-model.trim="formData.phone"></el-input>
                </el-form-item>
                <el-form-item label="邮箱：" prop="email">
                    <el-input v-model.trim="formData.email"></el-input>
                </el-form-item>
                <el-form-item label="状态：" prop="status">
                    <el-radio-group v-model="formData.status">
                        <el-radio :label="1">启用</el-radio>
                        <el-radio :label="0">禁用</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="排序：" prop="sort">
                    <el-input-number v-model="formData.sort" :min="0" :max="999999"></el-input-number>
                </el-form-item>

            </el-form>
            <template #footer>
                <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
                <el-button type="primary" @click="submitData" :loading="loadingSave" v-if="dialogTitle!='详情'">确定</el-button>
            </template>
        </ly-dialog>
    </div>
</template>

<script>
    import {apiSystemDeptAdd,apiSystemDept,apiSystemDeptEdit} from '@/api/api'
    import LyDialog from "@/components/dialog/dialog.vue";
    import {deepClone} from "@/utils/util";
    import XEUtils from "xe-utils";
    export default {
        components: {LyDialog},
        emits: ['refreshData'],
        name: "addDepartment",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                dialogTitle:'',
                isResourceShow:0,
                formData:{
                    parent:'',
                    name:'',
                    phone:'',
                    owner:'',
                    status:1,
                    sort:0,
                },
                rules:{
                    // parent: [
                    //     {required: true, message: '请选择父级菜单',trigger: 'blur'}
                    // ],
                    name: [
                        {required: true, message: '请输入部门名称',trigger: 'blur'}
                    ],
                    // phone: [
                    //     {required: true, message: '请输入联系电话',trigger: 'blur'}
                    // ],
                    // owner: [
                    //     {required: true, message: '请输入负责人',trigger: 'blur'}
                    // ],
                    status: [
                        {required: true, message: '请选择状态',trigger: 'blur'}
                    ],
                    // sort: [
                    //     {required: true, message: '请输入排序',trigger: 'blur'}
                    // ],
                },
                options: []
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.formData = {
                    parent:'',
                    name:'',
                    phone:'',
                    owner:'',
                    status:1,
                    sort:0,
                }
            },
            addDepartmentFn(item,flag) {
                this.dialogVisible=true
                this.dialogTitle=flag
                this.options=[]
                if(item){
                    this.formData = deepClone(item)
                }
                this.getapiSystemDept()
            },
            submitData() {
                let param = {
                    ...this.formData
                }
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        if( typeof this.formData.parent== 'object') {
                            param.parent = this.formData.parent ?  this.formData.parent[this.formData.parent.length-1] : ''
                        }
                        if(this.dialogTitle=="新增"){
                            apiSystemDeptAdd(param).then(res=>{
                                this.loadingSave=false
                                if(res.code == 2000) {
                                    this.$message.success(res.msg)
                                    this.handleClose()
                                    this.$emit('refreshData')
                                } else {
                                    this.$message.warning(res.msg)
                                }
                            })
                        }else{
                            apiSystemDeptEdit(this.formData).then(res=>{
                                this.loadingSave=false
                                if(res.code == 2000) {
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
            getapiSystemDept() {
                var params = {
                    page:1,
                    limit:9999
                }
                apiSystemDept(params).then(res=>{
                    if(res.code == 2000) {
                        this.options = XEUtils.toArrayTree(res.data.data, { parentKey: 'parent' })
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            }
        }
    }
</script>


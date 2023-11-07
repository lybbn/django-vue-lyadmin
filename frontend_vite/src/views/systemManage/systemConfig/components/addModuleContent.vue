<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="560px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto">
                <el-form-item label="所属分组" prop="parent">
                    <el-select v-model="formData.parent" placeholder="请选择分组" clearable style="width: 100%">
                        <el-option :label="item.title" :value="item.id" :key="index" v-for="(item,index) in groupList"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="标题" prop="title">
                    <el-input v-model="formData.title" placeholder="请输入" clearable></el-input>
                </el-form-item>
                <el-form-item label="key值" prop="key">
                    <el-input v-model="formData.key" placeholder="请输入" clearable></el-input>
                </el-form-item>
                <el-form-item label="表单类型" prop="form_item_type">
                    <el-select v-model="formData.form_item_type" placeholder="请选择" clearable style="width: 100%">
                        <el-option :label="item.name" :value="item.id" :key="index" v-for="(item,index) in formTypeList"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="选项字典" prop="data_options" v-if="formData.form_item_type==5 ||formData.form_item_type==6">
                    <el-input v-model="formData.data_options" type="textarea" :rows="2" placeholder="请输入如[{'label':'启用','value':'1'},{'label':'禁用','value':'0'}]" />
                </el-form-item>
                <el-form-item label="校验规则" v-show="false">
                    <el-select v-model="formData.rule" multiple placeholder="请选择(可多选)" clearable style="width: 100%">
                        <el-option :label="item.label" :value="item.value" :key="index" v-for="(item,index) in ruleOptions"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="提示信息" prop="placeholder">
                    <el-input v-model="formData.placeholder" placeholder="请输入" clearable></el-input>
                </el-form-item>
                <el-form-item label="排序" prop="sort">
                    <el-input-number v-model="formData.sort" :min="0" :max="999"></el-input-number>
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
    import {platformsettingsSysconfig,platformsettingsSysconfigAdd,platformsettingsSysconfigEdit} from "@/api/api";
    import LyDialog from "@/components/dialog/dialog.vue";
    export default {
        name: "addModuleContent",
        components: {LyDialog},
        emits: ['refreshData'],
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    parent: null,
                    title: null,
                    key: null,
                    form_item_type: null,
                    rule: null,
                    placeholder: null
                },
                rules:{
                    title: [
                        {required: true, message: '请输入分组名称',trigger: 'blur'}
                    ],
                    key: [
                        {required: true, message: '请输入key值',trigger: 'blur'}
                    ],
                    form_item_type: [
                        {required: true, message: '请选择表单类型',trigger: 'blur'}
                    ],
                },
                groupList:[],
                ruleOptions: [
                    {
                      label: '必填项',
                      value: '{"required": true, "message": "必填项不能为空"}'
                    },
                    {
                      label: '邮箱',
                      value: '{ "type": "email", "message": "请输入正确的邮箱地址"}'
                    },
                    {
                      label: 'URL地址',
                      value: '{ "type": "url", "message": "请输入正确的URL地址"}'
                    },
                    {
                      label: '数字',
                      value: '{"type": "number", "message": "请输入正确的数字"}'
                    },
                ],
                formTypeList:[
                    {id:0, name:"text"},
                    {id:3, name:"textarea"},
                    {id:5, name:"checkbox"},
                    {id:6, name:"radio"},
                    {id:7, name:"image"},
                    {id:10, name:"number"},
                    {id:14, name:"richtext"},
                ],
                formTypeList2:[
                    {id:0, name:"text"},
                    {id:1, name:"datetime"},
                    {id:2, name:"date"},
                    {id:3, name:"textarea"},
                    {id:4, name:"select"},
                    {id:5, name:"checkbox"},
                    {id:6, name:"radio"},
                    {id:7, name:"image"},
                    {id:8, name:"file"},
                    {id:9, name:"switch"},
                    {id:10, name:"number"},
                    {id:11, name:"array"},
                    {id:12, name:"images"},
                    {id:13, name:"time"},
                    {id:14, name:"richtext"},
                ],
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.formData = {
                    parent: null,
                    title: null,
                    key: null,
                    form_item_type: null,
                    rule: null,
                    placeholder: null
                }
                this.$emit('refreshData')
            },
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                this.getData()
            },
            getGroups(){
                platformsettingsSysconfig({limit:999,parent__isnull:true}).then(res=>{
                    if(res.code == 2000){
                        this.groupList = res.data.data
                    }
                })
            },
            getData(){
                this.getGroups()
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        if(this.formData.id){
                            platformsettingsSysconfigEdit(param).then(res=>{
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
                            platformsettingsSysconfigAdd(param).then(res=>{
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
            }
        }
    }
</script>
<style scoped>

</style>
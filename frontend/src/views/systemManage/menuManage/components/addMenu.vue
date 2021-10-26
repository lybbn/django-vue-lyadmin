<template>
    <el-dialog
            :title="dialogTitle"
            :visible.sync="dialogVisible"
            width="560px"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="true" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px" class="form-store">
            <el-form-item label="ID：" prop="id" v-if="dialogTitle=='详情'">
                <el-input v-model.trim="formData.id" disabled style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="父级菜单：" prop="parent">
                <el-cascader
                        style="width: 300px"
                        :show-all-levels="false"
                        :options="options"
                        v-model="formData.parent"
                        @change="handleChange"
                        :props="{ checkStrictly: true ,label:'name',value:'id'}"
                        clearable></el-cascader>
            </el-form-item>
            <el-form-item label="菜单名称：" prop="name">
                <el-input v-model.trim="formData.name" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="侧边栏可见：" prop="visible">
                <el-radio-group v-model="formData.visible" style="width: 300px">
                    <el-radio :label="1">是</el-radio>
                    <el-radio :label="0">否</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="创建按钮权限：" prop="isautopm">
                <el-radio-group v-model="formData.isautopm" style="width: 300px">
                    <el-radio :label="1">是</el-radio>
                    <el-radio :label="0">否</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="图标：" prop="icon">
                <el-input v-model.trim="formData.icon" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item label="排序：" prop="sort">
                <el-input-number v-model="formData.sort" :min="1" :max="9999"></el-input-number>
            </el-form-item>
            <el-form-item label="路由地址：" prop="web_path">
                <el-input v-model.trim="formData.web_path" style="width: 300px"></el-input>
            </el-form-item>
            <!--<el-form-item label="组件名称：" prop="url">
                <el-input v-model.trim="formData.url" style="width: 300px"></el-input>
            </el-form-item>-->
            <!--<el-form-item label="权限：" prop="menuPermission">-->
                <!--<el-tag-->
                    <!--:key="tag"-->
                    <!--v-for="tag in formData.menuPermission"-->
                    <!--closable-->
                    <!--:disable-transitions="false"-->
                    <!--@close="handleCloseTag(tag)">-->
                    <!--{{tag}}-->
                <!--</el-tag>-->
                <!--<el-input-->
                    <!--class="input-new-tag"-->
                    <!--v-if="inputVisible"-->
                    <!--v-model="inputValue"-->
                    <!--ref="saveTagInput"-->
                    <!--size="small"-->
                    <!--@keyup.enter.native="handleInputConfirm"-->
                    <!--@blur="handleInputConfirm"-->
                <!--&gt;-->
                <!--</el-input>-->
                <!--<el-button v-else class="button-new-tag" size="small" @click="showInput">新增权限</el-button>-->
            <!--</el-form-item>-->
            <el-form-item label="状态：" prop="status">
                <el-radio-group v-model="formData.status" style="width: 300px">
                    <el-radio :label="1">启用</el-radio>
                    <el-radio :label="0">禁用</el-radio>
                </el-radio-group>
            </el-form-item>

        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {apiSystemMenuAdd,apiSystemMenuEdit,systemMenuTree} from '@/api/api'
    export default {
        name: "addMenu",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                dialogTitle:'',
                formData:{
                    parent:'',
                    name:'',
                    visible:1,
                    icon:'',
                    status:1,
                    sort:'',
                    web_path:'',
                    menuPermission:[],
                    id:null,
                    isautopm:1,
                },
                inputVisible: false,
                inputValue: '',
                rules:{
                   /* parent: [
                        {required: true, message: '请选择父级菜单',trigger: 'blur'}
                    ],*/
                    name: [
                        {required: true, message: '请输入菜单名称',trigger: 'blur'}
                    ],
                    visible: [
                        {required: true, message: '请选择侧边栏是否可见',trigger: 'blur'}
                    ],
                    sort: [
                        {required: true, message: '请输入排序',trigger: 'blur'}
                    ],
                    // icon: [
                    //     {required: true, message: '请填充图标',trigger: 'blur'}
                    // ],
                    status: [
                        {required: true, message: '请选择状态',trigger: 'blur'}
                    ],
                    // web_path: [
                    //     {required: true, message: '请输入路由地址',trigger: 'blur'}
                    // ],
                    isautopm: [
                        {required: true, message: '请选择是否自动创建按钮权限',trigger: 'blur'}
                    ],
                },
                options: []
            }
        },
        methods:{
            handleCloseTag(tag) {
                this.formData.menuPermission.splice(this.formData.menuPermission.indexOf(tag), 1);
            },

            showInput() {
                this.inputVisible = true;
                this.$nextTick(_ => {
                    this.$refs.saveTagInput.$refs.input.focus();
                });
            },

            handleInputConfirm() {
                let inputValue = this.inputValue;
                if (inputValue) {
                    this.formData.menuPermission.push(inputValue);
                }
                this.inputVisible = false;
                this.inputValue = '';
            },

            handleChange(e) {
              //console.log(e,'e----')
                // this.parent = e[e.length-1]
            },
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
            },
            addMenuFn(item,flag) {
                this.getsystemMenuTree()
                this.dialogVisible=true
                this.dialogTitle=flag
                this.formData=item?item:{
                    parent:'',
                    name:'',
                    visible:1,
                    icon:'',
                    status:1,
                    sort:'',
                    web_path:'',
                    menuPermission:[],
                    isautopm:1,
                }

                this.formData.menuPermission=item ? item.menuPermission : []

            },
            submitData() {
                //console.log(this.formData,'this.formData')
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        let param = {
                            ...this.formData
                        }
                        if( typeof this.formData.parent== 'object') {
                            param.parent = this.formData.parent ?  this.formData.parent[this.formData.parent.length-1] : ''
                        }
                        this.loadingSave=true
                        if(this.dialogTitle=="新增"){
                            apiSystemMenuAdd(param).then(res=>{
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
                            apiSystemMenuEdit(param).then(res=>{
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
            getsystemMenuTree() {
                systemMenuTree().then(res=>{
                    if(res.code == 2000) {
                        let menu = [{
                            label:'-1',
                            name:'根节点',
                            children:[...res.data.data]
                            }]
                        this.options = menu
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            }
        }
    }
</script>
<style lang="scss" scoped>
    .el-tag + .el-tag {
        margin-left: 10px;
    }
    .button-new-tag {
        margin-left: 10px;
        height: 32px;
        line-height: 30px;
        padding-top: 0;
        padding-bottom: 0;
    }
    .input-new-tag {
        width: 90px;
        margin-left: 10px;
        vertical-align: bottom;
    }
</style>



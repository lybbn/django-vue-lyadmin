<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="dialogTitle" width="560px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto" class="form-store">
                <el-form-item label="父级菜单：" prop="parent">
                    <el-cascader
                            style="width: 100%"
                            :key="isResourceShow"
                            :show-all-levels="false"
                            :options="options"
                            v-model="formData.parent"
                            @change="handleChange"
                            :props="{ checkStrictly: true ,label:'name',value:'id'}"
                            clearable></el-cascader>
                </el-form-item>
                <el-form-item label="菜单名称：" prop="name">
                    <el-input v-model.trim="formData.name" ></el-input>
                </el-form-item>
                <el-form-item label="侧边栏可见：" prop="visible">
                    <el-radio-group v-model="formData.visible" >
                        <el-radio :label="1">是</el-radio>
                        <el-radio :label="0">否</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="创建按钮权限：" prop="isautopm">
                    <el-radio-group v-model="formData.isautopm" >
                        <el-radio :label="1">是</el-radio>
                        <el-radio :label="0">否</el-radio>
                    </el-radio-group>
                    <span style="font-size: 7px;color: red;">*【否】表示创建一个目录</span>
                </el-form-item>
                <el-form-item label="图标：" prop="icon">
<!--                    <el-input v-model.trim="formData.icon" ></el-input>-->
                    <el-autocomplete
                            v-model.trim="formData.icon"
                            :fetch-suggestions="querySearch"
                            :trigger-on-focus="false"
                            clearable
                            style="width: 100%"
                            @select="handleSelect"
                            popper-append-to-body
                            placeholder="请输入icon">
                        <template #default="{ item }">
                            <div style="display: flex;align-items: center">
                                <el-icon :size="16">
                                    <component :is="item.value"></component>
                                </el-icon>
                                <div style="margin-left: 5px;">{{ item.value }}</div>
                            </div>
                        </template>
                    </el-autocomplete>
                </el-form-item>
                <el-form-item label="排序：" prop="sort">
                    <el-input-number v-model="formData.sort" :min="0" :max="9999"></el-input-number>
                </el-form-item>
                <el-form-item label="路由地址：" prop="web_path">
                    <el-input v-model.trim="formData.web_path" ></el-input>
                </el-form-item>
                <el-form-item label="状态：" prop="status">
                    <el-radio-group v-model="formData.status" style="width: 300px">
                        <el-radio :label="1">启用</el-radio>
                        <el-radio :label="0">禁用</el-radio>
                    </el-radio-group>
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
    import {apiSystemMenu,apiSystemMenuAdd,apiSystemMenuEdit,systemMenuTree} from '@/api/api'
    import XEUtils from "xe-utils";
    import {menuicons} from "@/utils/menuTree.js"
    import LyDialog from "../../../../components/dialog/dialog";
    export default {
        components: {LyDialog},
        emits: ['refreshData'],
        name: "addMenu",
        data() {
            return {
                menuicons:[],
                dialogVisible:false,
                loadingSave:false,
                dialogTitle:'',
                isResourceShow:0,
                formData:{
                    parent:'',
                    name:'',
                    visible:1,
                    icon:'',
                    status:1,
                    sort:0,
                    web_path:'',
                    menuPermission:[],
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
        mounted() {
            this.menuicons = menuicons
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
            handleSelect(item){
                // console.log(item)
            },
            querySearch(queryString, cb) {
                var menuicons = this.menuicons;
                var results = queryString ? menuicons.filter(this.createFilter(queryString)) : menuicons;
                // 调用 callback 返回建议列表的数据
                cb(results);
            },
            createFilter(queryString) {
                return (menuicons) => {
                  return (menuicons.value.toLowerCase().indexOf(queryString.toLowerCase()) === 0);
                };
            },

            handleChange(e) {
              //console.log(e,'e----')
                // this.parent = e[e.length-1]
            },
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.formData = {
                    parent:'',
                    name:'',
                    visible:1,
                    icon:'',
                    status:1,
                    sort:0,
                    web_path:'',
                    menuPermission:[],
                    isautopm:1,
                }
            },
            addMenuFn(item,flag) {
                this.getsystemMenuTree()
                this.dialogVisible=true
                this.dialogTitle=flag

                //解决Cannot read property ‘level‘ of null问题
                this.options=[]
                this.isResourceShow=0
                if(item){
                    this.formData = item
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
                            param.parent = (this.formData.parent==null || (this.formData.parent.length==1 && this.formData.parent[0] == undefined) || this.formData.parent.length==0) ?  '' : this.formData.parent[this.formData.parent.length-1]
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
                var params = {
                    page:1,
                    limit:9999
                }
                apiSystemMenu(params).then(res=>{
                    ++this.isResourceShow
                    if(res.code == 2000) {
                        let menu = [{
                            label:'-1',
                            name:'根节点',
                            children:XEUtils.toArrayTree(res.data.data, { parentKey: 'parent' })
                            }]
                        // 将菜单列表转换为树形列表
                        this.options = menu
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
                // systemMenuTree(params).then(res=>{
                //     ++this.isResourceShow
                //     if(res.code == 2000) {
                //         let menu = [{
                //             label:'-1',
                //             name:'根节点',
                //             children:[...res.data.data]
                //             }]
                //         this.options = menu
                //     } else {
                //         this.$message.warning(res.msg)
                //     }
                // })
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



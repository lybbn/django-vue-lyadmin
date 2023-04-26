<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="dialogTitle" width="760px"  :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto">
                <el-form-item label="名称：" prop="value">
                    <el-select v-model="formData.value" allow-create filterable placeholder="请选择" :size="size" style="width: 360px" @change="getName">
                        <el-option
                            v-for="item in buttonList"
                            :key="item.value"
                            :label="item.name"
                            :value="item.value">
                        </el-option>
                    </el-select>
                    <el-button type="primary" circle style="margin-left: 20px" :size="size"  @click="onLinkBtn"><el-icon><circle-plus /></el-icon></el-button>
                </el-form-item>
                <el-form-item label="请求方式：" prop="method">
                    <el-select v-model="formData.method"  placeholder="请选择" :size="size" style="width: 100%;">
                        <el-option
                            v-for="item in methodsList"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="接口地址：" prop="api">
                    <el-select  v-model.trim="formData.api" :size="size" filterable clearable  allow-create style="margin-bottom: 5px;width: 100%;" placeholder="请选择或手动输入">
                        <el-option
                            v-for="item in apiList"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value">
                        </el-option>
                    </el-select>
                    <el-alert title="请正确填写(或选择)，以免请求时被拦截。匹配编辑/单例/删除使用正则,如:/api/xxx/{id}/" type="info" show-icon/>
                </el-form-item>
<!--                <el-form-item label="接口地址：" prop="api">-->
<!--                    <el-input  v-model.trim="formData.api" :size="size" style="margin-bottom: 5px;"></el-input>-->
<!--                    <el-alert title="请正确填写，以免请求时被拦截。匹配编辑/单例/删除使用正则,如:/api/xxx/{id}/" type="info" show-icon/>-->
<!--                </el-form-item>-->

            </el-form>
            <template #footer>
                <el-button @click="handleClose" :loading="loadingSave">关闭</el-button>
                <el-button type="primary" @click="submitData"  :loading="loadingSave">保存</el-button>
            </template>
        </ly-dialog>
    </div>
</template>

<script>
    import {systemMenuButtonAdd,systemMenuButtonEdit,systemButton,getSystemLyapiList} from '@/api/api'
    import LyDialog from "@/components/dialog/dialog";
    import {deepClone} from "@/utils/util"
    export default {
        components: {LyDialog},
        emits: ['refreshData'],
        name: "addButton",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                dialogTitle:'',
                size:'large',
                formData:{
                    name: '',
                    api:'',
                    menu: '',
                    method: '',
                    value: '',
                },
                rules:{
                    value: [
                        {required: true, message: '请选择名称',trigger: 'blur'}
                    ],
                    method: [
                        {required: true, message: '请选择请求方式',trigger: 'blur'}
                    ],
                    api: [
                        {required: true, message: '请输入接口地址',trigger: 'blur'}
                    ],
                },

                buttonList:[],
                methodsList:[
                    {id:0,name:'GET'},
                    {id:1,name:'POST'},
                    {id:2,name:'PUT'},
                    {id:3,name:'DELETE'},
                    {id:4,name:'OPTIONS'},
                    {id:5,name:'WS'},
                ],
                apiList:[]
            }
        },
        methods:{
            // 跳转到添加按钮界面
            onLinkBtn () {
                this.$router.push({ name: 'buttonManage' })
            },
            getName(e) {
                this.formData.value=e
                this.formData.name=this.buttonList.filter(item=>item.value==e)[0].name
            },
            handleClose() {
                this.dialogVisible=false
                this.formData = {
                    name: '',
                    api:'',
                    menu: '',
                    method: '',
                    value: '',
                }
                this.$emit('refreshData')
            },
            addButtonFn(item,flag,menu) {
                this.dialogVisible=true
                this.dialogTitle=flag
                this.getSystemButton(item)
                if(item){
                    this.formData= deepClone(item)
                }else{
                    this.formData.menu = menu
                }
                this.getSystemLyapi()
            },
            getSystemLyapi(){
                getSystemLyapiList().then(res=>{
                    var result = Object.keys(res.paths)
                    var data = []
                    for (const item of result) {
                        const obj = {}
                        obj.label = item
                        obj.value = item
                        data.push(obj)
                    }
                    this.apiList = data
                })
            },
            submitData() {
                let param = {
                    ...this.formData
                }
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        if(this.dialogTitle=="新增"){
                            systemMenuButtonAdd(param).then(res=>{
                                this.loadingSave=false
                                if(res.code ==2000) {
                                    this.$message.success(res.msg)
                                    this.handleClose()
                                } else {
                                    this.$message.warning(res.msg)
                                }
                            })
                        }else{
                            systemMenuButtonEdit(param).then(res=>{
                                this.loadingSave=false
                                if(res.code ==2000) {
                                    this.$message.success(res.msg)
                                    this.handleClose()
                                } else {
                                    this.$message.warning(res.msg)
                                }
                            })
                        }

                    }
                })
            },
            getSystemButton(item) {
                var params = {
                    page:1,
                    limit:999
                }
                systemButton(params).then(res=>{
                    if(res.code == 2000) {
                        this.buttonList=res.data.data
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            }
        }
    }
</script>

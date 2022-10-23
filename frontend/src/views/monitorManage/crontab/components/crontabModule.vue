<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="750px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto">
<!--                <el-form-item label="用户头像：">-->
<!--                    <el-upload-->
<!--                            class="avatar-uploader"-->
<!--                            action=""-->
<!--                            :show-file-list="false"-->
<!--                            ref="uploadDefaultImage"-->
<!--                            :http-request="imgUploadRequest"-->
<!--                            :on-success="imgUploadSuccess"-->
<!--                            :before-upload="imgBeforeUpload">-->
<!--                        <img v-if="formData.avatar" :src="formData.avatar" class="avatar" >-->
<!--                        <el-icon v-else class="avatar-uploader-icon" size="medium"><Plus /></el-icon>-->
<!--                    </el-upload>-->
<!--                </el-form-item>-->
                <el-form-item label="任务名称：" prop="name">
                    <el-input v-model="formData.name"></el-input>
                </el-form-item>
                <el-form-item label="cron表达式：" prop="crontab">
                    <el-input
                        v-model="formData.crontab"
                        placeholder="* * * * *"
                    ><template #append><el-button type="primary" @click="togglePopover(true)" >点击辅助输入</el-button></template>
                    </el-input>
                    <el-drawer v-model="cronPopover" title="cron表达式辅助工具" size="40%">
                        <cron-expression
                            @change="changeCron"
                            @close="togglePopover(false)"
                            max-height="400px"
                            i18n="cn"
                        ></cron-expression>
                    </el-drawer>
                </el-form-item>
                <el-form-item label="celery任务：" prop="task">
                    <el-select size="default" v-model="formData.task" placeholder="请输入或选择" allow-create filterable clearable style="width: 100%">
                        <el-option
                                v-for="item in taskList"
                                :key="item.label"
                                :label="item.label"
                                :value="item.value">
                        </el-option>
                    </el-select>
                    <el-alert title="Celery任务调用示例：apps.lycrontab.tasks.lytask_test" type="info" show-icon/>
                </el-form-item>

                <el-form-item label="状态：" prop="enabled">
                    <el-switch
                        v-model="formData.enabled"
                        active-text="正常"
                        inactive-text="暂停"
                        active-color="#13ce66"
                        inactive-color="#ff4949">
                    </el-switch>
                </el-form-item>
                <el-form-item label="备注：" prop="description">
                    <el-input v-model="formData.description" type="textarea" :rows="2"></el-input>
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
    import {crontabPeriodictaskAdd,crontabPeriodictaskEdit,crontabPeriodictaskMethodlist,platformsettingsUploadPlatformImg} from "@/api/api";
    import LyDialog from "../../../../components/dialog/dialog";
    import cronExpression from "./cronExpression";
    export default {
        name: "crontabModule",
        components: {cronExpression,LyDialog},
        emits: ['refreshData'],
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    name:'',
                    crontab:'',
                    task:'',
                    enabled:false,
                    description:'',
                },
                rules:{
                    name: [
                        {required: true, message: '请输入任务名称',trigger: 'blur'}
                    ],
                    crontab: [
                        {required: true, message: '请输入cron表达式',trigger: 'blur'}
                    ],
                    task: [
                        {required: true, message: '请输入celery任务方法',trigger: 'blur'}
                    ],
                    // nickname: [
                    //     {required: true, message: '请输入昵称',trigger: 'blur'}
                    // ],
                },
                taskList:[],
                cronPopover: false,
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.formData = {
                    name:'',
                    crontab:'',
                    task:'',
                    enabled:false,
                    description:'',
                }
                this.cronPopover = false
                this.$emit('refreshData')
            },
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                this.getTasklist()
                if(item){
                    this.formData = item
                }
            },
            getTasklist(){
                crontabPeriodictaskMethodlist().then(res=>{
                    if(res.code ==2000) {
                        this.taskList = res.data.data
                    }
                })
            },
            togglePopover (bol){
                this.cronPopover = bol
            },
            changeCron(val){
              if (typeof val !== 'string') return false
              this.formData.crontab = val
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        // if(param.type === '0'){
                        //     if(param.password == ""){
                        //         this.loadingSave=false
                        //         this.$message.warning("密码不能为空")
                        //         return
                        //     }
                        // }
                        if(param.type === '1'){
                            if(param.pkey == ""){
                                this.loadingSave=false
                                this.$message.warning("秘钥不能为空")
                                return
                            }
                        }
                        if(this.formData.id){
                            crontabPeriodictaskEdit(param).then(res=>{
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
                            crontabPeriodictaskAdd(param).then(res=>{
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
                let obj= await platformsettingsUploadPlatformImg(param)
                if(obj.code == 2000) {
                    let res=''
                    if (obj.data.data[0].indexOf("://")>=0){
                        res = obj.data.data[0]

                    }else{
                        res = url.split('/api')[0]+obj.data.data[0]
                    }
                    vm.formData.avatar = res
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess() {
                this.$refs.uploadDefaultImage.clearFiles()
            }
        }
    }
</script>
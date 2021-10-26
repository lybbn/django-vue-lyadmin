<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="60%"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item label="图片(317*189)：" prop="image">
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
            <el-form-item label="排序：" prop="sort">
                <el-input-number v-model="formData.sort"  :min="1" :max="9999"></el-input-number>
            </el-form-item>
            <el-form-item label="内容：" prop="content">
<!--                <el-input type="textarea" v-model.trim="formData.name" style="width: 300px"></el-input>-->
                <div class="messageTxt">
                    <quill-editor ref="myQuillEditor" v-model="formData.content" :options="editorOptions">
                    </quill-editor>
                </div>
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
    import 'quill/dist/quill.core.css'
    import 'quill/dist/quill.snow.css'
    import 'quill/dist/quill.bubble.css'
    import quillConfig from '@/utils/quill-config.js'
    import {retrieveInfodynamicsAdd,retrieveInfodynamicsEdit,retrieveUploadPlatformImg} from "@/api/api";
    export default {
        name: "addModule",
        data() {
            return {
                editorOptions: quillConfig,
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                peopleList:[],
                formData:{
                    image:'',
                    sort:'',
                    content:'',
                    status:true,
                },
                rules:{
                    img: [
                        {required: true, message: '请上传图片',trigger: 'blur'}
                    ],
                    name: [
                        {required: true, message: '请输入内容',trigger: 'blur'}
                    ]
                }
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
                    sort:'',
                    content:'',
                    status:true,
                }
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        if(this.formData.id){
                            retrieveInfodynamicsEdit(param).then(res=>{
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
                            retrieveInfodynamicsAdd(param).then(res=>{
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
                // OSS.ossUploadProductImg(option);
                var vm = this
                let res= await retrieveUploadPlatformImg(param)
                if(res.code == 2000) {
                    vm.formData.image = res.data.data[0]
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess(res) {
                // if (res) {
                //     this.formData.img = res.url
                // }
            },

        }
    }
</script>

<style>
    .set-specs .el-form-item__content{
        background: #e6e6e6 !important;
    }

    .messageTxt /deep/ .ql-editor {
        width: 100%;
        /*height: 200px;*/
        background: #ffffff;
    }
    .ql-toolbar.ql-snow + .ql-container.ql-snow{
        min-height: 300px;
        height:calc(100vh - 700px)
    }
    .ql-snow .ql-picker-label{
        display: flex;
    }
    .editor {
        line-height: normal !important;
        height: 500px;
    }
    .ql-snow .ql-tooltip[data-mode="link"]::before {
        content: "请输入链接地址:";
    }
    .ql-snow .ql-tooltip.ql-editing a.ql-action::after {
        border-right: 0px;
        content: "保存";
        padding-right: 0px;
    }

    .ql-snow .ql-tooltip[data-mode="video"]::before {
        content: "请输入视频地址:";
    }

    /*.ql-snow .ql-picker.ql-size .ql-picker-label::before,*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-item::before {*/
    /*content: "14px";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="small"]::before,*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="small"]::before {*/
    /*content: "10px";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="large"]::before,*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="large"]::before {*/
    /*content: "18px";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="huge"]::before,*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="huge"]::before {*/
    /*content: "32px";*/
    /*}*/
    .ql-editor .ql-size-12px {
        font-size: 12px;
    }
    .ql-editor .ql-size-14px {
        font-size: 14px;
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item::before {
        content: '16px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="12px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="12px"]::before {
        content: '12px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="14px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="14px"]::before {
        content: '14px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="16px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="16px"]::before {
        content: '16px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="18px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="18px"]::before {
        content: '18px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="20px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="20px"]::before {
        content: '20px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="22px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="22px"]::before {
        content: '22px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="24px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="24px"]::before {
        content: '24px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="26px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="26px"]::before {
        content: '26px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="32px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="32px"]::before {
        content: '32px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="48px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="48px"]::before {
        content: '48px';
    }


    .ql-snow .ql-picker.ql-header .ql-picker-label::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item::before {
        content: "文本";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="1"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before {
        content: "标题1";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="2"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before {
        content: "标题2";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="3"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before {
        content: "标题3";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="4"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before {
        content: "标题4";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="5"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before {
        content: "标题5";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="6"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before {
        content: "标题6";
    }

    .ql-editor .ql-font-Microsoft-YaHei {
        font-family: "Microsoft YaHei";
    }
    .ql-editor .ql-font-SimSun {
        font-family: "SimSun";
    }
    .ql-editor .ql-font-SimHei {
        font-family: "SimHei";
    }
    .ql-editor .ql-font-KaiTi {
        font-family: "KaiTi";
    }
    .ql-editor .ql-font-Arial {
        font-family: "Arial";
    }
    .ql-editor .Times-New-Roman {
        font-family: "Times New Roman";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item::before {
        content: '微软雅黑';
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=Microsoft-YaHei]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=Microsoft-YaHei]::before {
        content: "微软雅黑";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=SimSun]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=SimSun]::before {
        content: "宋体";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=SimHei]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=SimHei]::before {
        content: "黑体";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=KaiTi]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=KaiTi]::before {
        content: "楷体";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=Arial]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=Arial]::before {
        content: "Arial";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=Times-New-Roman]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=Times-New-Roman]::before {
        content: "Times New Roman";
    }
    /*.ql-snow .ql-picker.ql-font .ql-picker-label::before,*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-item::before {*/
    /*content: "标准字体";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="serif"]::before,*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="serif"]::before {*/
    /*content: "衬线字体";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="monospace"]::before,*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="monospace"]::before {*/
    /*content: "等宽字体";*/
    /*}*/
    /*!* 编辑器内部出现滚动条 *!*/
    /*.ql-container{*/
    /*overflow-y:auto;*/
    /*height:8rem!important;*/
    /*}*/
    /*!*滚动条整体样式*!*/
    /*.ql-container ::-webkit-scrollbar{*/
    /*width: 10px;!*竖向滚动条的宽度*!*/
    /*height: 10px;!*横向滚动条的高度*!*/
    /*}*/
    /*.ql-container ::-webkit-scrollbar-thumb{!*滚动条里面的小方块*!*/
    /*background: #666666;*/
    /*border-radius: 5px;*/
    /*}*/
    /*.ql-container ::-webkit-scrollbar-track{!*滚动条轨道的样式*!*/
    /*background: #ccc;*/
    /*border-radius: 5px;*/
    /*}*/
</style>


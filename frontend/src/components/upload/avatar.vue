<template>
    <el-upload
        class="avatar-uploader"
        action=""
        :show-file-list="false"
        ref="uploadDefaultImage"
        :http-request="imgUploadRequest"
        :on-success="imgUploadSuccess"
        :before-upload="imgBeforeUpload">
        <img v-if="imageurl" :src="imageurl" :style="[{width:width},{height:height}]">
        <el-icon v-else class="ly-avatar-uploader-icon" :style="[{width:width},{height:height}]" ><Plus /></el-icon>
    </el-upload>
</template>

<script>
    import {platformsettingsUploadPlatformImg} from "@/api/api";
    export default {
        name: "LyUploadAvatar",
        data(){
            return{
                imageurl:"",
            }
        },
        props: {
            modelValue: {
              type: String,
              default: ""
            },
            width: {
              type: String,
              default: '140px'
            },
            height: {
              type: String,
              default: '140px'
            },
        },
        created() {
            this.imageurl = this.modelValue
        },
        watch:{
            modelValue: function(nval){
                this.imageurl = nval; // modelValue改变是同步子组件visible的值
            },
            imageurl: function(nval) {
                this.$emit('update:modelValue', nval); // visible改变时同步父组件modelValue的值
            }
        },
        methods:{
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
                    vm.imageurl = res
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess() {
                this.$refs.uploadDefaultImage.clearFiles()
            }
        },
    }
</script>

<style scoped>
    .ly-avatar-uploader-icon{
        font-size: 28px !important;
        color: #8c939d;
        text-align: center
    }
</style>
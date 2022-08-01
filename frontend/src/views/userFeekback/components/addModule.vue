<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="640px" :before-close="handleClose">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
                <el-form-item label="反馈内容：" prop="message">
                    <el-input type="textarea" v-model.trim="formData.message" :autosize="{ minRows: 4, maxRows: 6}"></el-input>
                </el-form-item>
                <el-form-item label="反馈图片：" prop="images">
                    <el-image fit="contain" v-for="item in formData.images" :src="item" :preview-src-list="[item]" v-bind:key="item.id" style="width: 100px;height: 100px"></el-image>
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            </template>
        </ly-dialog>
    </div>
</template>

<script>
    import LyDialog from "../../../components/dialog/dialog";
    export default {
        emits: ['refreshData'],
        name: "addModule",
        components: {LyDialog},
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                peopleList:[],
                formData:{
                    message:'',
                    images:[],
                },
                rules:{
                }
            }
        },
        methods: {
            handleClose() {
                this.dialogVisible = false
                this.loadingSave = false
                this.$emit('refreshData')
            },
            addModuleFn(item, flag) {
                this.loadingTitle = flag
                this.dialogVisible = true

                this.formData = item ? item : {
                    message:'',
                    images:[],
                }
            },
        }
    }
</script>


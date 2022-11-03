<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="50%" :before-close="handleClose">
            <el-form label-position="right" class="journal-detail" label-width="auto">
                <el-form-item label="请求模块：">
                    {{journalDetail && journalDetail.request_modular ? journalDetail.request_modular  : ''}}
                </el-form-item>
                <el-form-item label="请求地址：">
                    {{journalDetail && journalDetail.request_path ? journalDetail.request_path : ''}}
                </el-form-item>
                <el-form-item label="请求方法：">
                    {{journalDetail && journalDetail.request_method ? journalDetail.request_method : ''}}
                </el-form-item>
                <el-form-item label="IP地址：">
                    {{journalDetail && journalDetail.request_ip ? journalDetail.request_ip : ''}}
                </el-form-item>
                <el-form-item label="请求浏览器：">
                    {{journalDetail && journalDetail.request_browser ? journalDetail.request_browser : ''}}
                </el-form-item>
                <el-form-item label="请求数据：">
                    {{journalDetail && journalDetail.request_body ? journalDetail.request_body : ''}}
                </el-form-item>
                <el-form-item label="响应码：">
                    {{journalDetail && journalDetail.response_code ? journalDetail.response_code : ''}}
                </el-form-item>
                <el-form-item label="返回信息：">
                    {{journalDetail && journalDetail.json_result ? journalDetail.json_result : ''}}
                </el-form-item>
                <el-form-item label="操作人：">
                    {{journalDetail && journalDetail.creator_name ? journalDetail.creator_name : ''}}
                </el-form-item>
                <el-form-item label="创建时间：">
                    {{journalDetail && journalDetail.create_datetime ? journalDetail.create_datetime : ''}}
                </el-form-item>
            </el-form>
            <template v-slot:footer>
                <el-button @click="handleClose">关闭</el-button>
            </template>
        </ly-dialog>
    </div>
</template>

<script>
    import LyDialog from "../../components/dialog/dialog";
    export default {
        name: "journalManageDetail",
        components: {LyDialog},
        data() {
            return {
                dialogVisible:false,
                loadingTitle:"日志详情",
                journalDetail:''
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.journalDetail=''
            },
            journalManageDetailFn(item) {
                this.dialogVisible=true
                this.journalDetail = item
            }
        }
    }
</script>

<style>
    .journal-detail .el-form-item__content{
        background: var(--l-headertitle-bg);
        padding-left: 10px;
    }
</style>

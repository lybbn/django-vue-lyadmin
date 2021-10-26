<template>
    <el-dialog
            title="发货"
            :visible.sync="dialogVisible"
            width="500px"
            center
            top="3%"
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose"
            append-to-body>
        <el-form :inline="false" label-position="right" label-width="130px" :model="formData">
            <el-form-item label="请填写物流单号：">
                <el-input v-model.trim="formData.orderNo"></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose">取消</el-button>
            <el-button @click="deliverGoods" :loading="loadingPage" type="primary">发货</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {mallGoodsSendoutgoods} from '@/api/api'
    export default {
        name: "deliverGoodsModule",
        data() {
            return {
                dialogVisible:false,
                loadingPage:false,
                formData:{
                    id:'',
                    orderNo:'',
                }
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.$emit('refreshData')
            },
            deliverGoodsModuleFn(item) {
                this.dialogVisible=true
                // this.formData=item ? item : {
                this.formData={
                    id:item.id,
                    orderNo:''
                }
            },
            deliverGoods() {
                if(this.formData.orderNo.length<1) {
                    this.$message.warning('请填写物流单号')
                    return
                }
                let vm = this

                mallGoodsSendoutgoods(this.formData).then(res=>{
                    if(res.code == 2000) {
                        vm.$message.success(res.msg)
                        this.handleClose()
                        this.$emit('refreshData')
                    } else {
                        vm.$message.warning(res.msg)
                    }
                })

            }
        }
    }
</script>


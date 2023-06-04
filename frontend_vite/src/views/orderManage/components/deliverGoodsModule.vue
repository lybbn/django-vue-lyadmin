<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="500px" :before-close="handleClose">
            <el-form :inline="false" label-position="right" :rules="rules" ref="rulesForm" label-width="130px" :model="formData">
                <el-form-item label="物流公司：" prop="logistics_company">
                    <el-select  v-model="formData.logistics_company" placeholder="请选择"   >
                            <el-option
                                    v-for="item in wuliuList"
                                    :key="item.id"
                                    :label="item.name"
                                    :value="item.name">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="物流单号：" prop="orderNo">
                    <el-input v-model.trim="formData.orderNo"></el-input>
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="handleClose">取消</el-button>
                <el-button @click="deliverGoods" :loading="loadingPage" type="primary">发货</el-button>
            </template>
        </ly-dialog>
    </div>
</template>

<script>
    import {mallGoodsSendoutgoods} from '@/api/api'
    import LyDialog from "@/components/dialog/dialog.vue";
    export default {
        name: "deliverGoodsModule",
        components: {LyDialog},
        data() {
            return {
                dialogVisible:false,
                loadingPage:false,
                loadingTitle:"发货",
                formData:{
                    id:'',
                    orderNo:'',
                    logistics_company:'',
                },rules:{
                    logistics_company: [
                        {required: true, message: '请填写物流公司',trigger: 'blur'}
                    ],
                    orderNo: [
                        {required: true, message: '请填写物流单号',trigger: 'blur'}
                    ],

                },
                wuliuList:[
                    {id:1,name:'中通快递'},
                    {id:2,name:'圆通快递'},
                    {id:3,name:'百世快递'},
                    {id:4,name:'韵达快递'},
                    {id:5,name:'邮政快递'},
                    {id:6,name:'京东快递'},
                    {id:7,name:'顺丰快递'},
                    {id:8,name:'天天快递'},
                    {id:9,name:'申通快递'},
                ]
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


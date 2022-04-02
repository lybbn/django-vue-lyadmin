<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="580px"
            center
            v-dialogDrag
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item label="优惠券名称：" prop="name">
                <el-input v-model.trim="formData.name" style="width: 300px"  :disabled="loadingTitle=='详情'"></el-input>
            </el-form-item>
            <el-form-item label="发送方式：" prop="receive_type">
                <el-radio-group v-model="formData.receive_type" style="width: 400px">
                    <el-radio :label="1">手动领取</el-radio>
                    <el-radio :label="2">新人券</el-radio>
                    <el-radio :label="3">后台发放</el-radio>
                    <el-radio :label="4">邀请劵</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="优惠券类型：" prop="coupon_type">
                <el-select  v-model="formData.coupon_type" placeholder="请选择类型"  clearable filterable style="width: 300px" >
                        <el-option
                                v-for="item in coupontypeList"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
<!--                                <span style="float: left"><img v-if="item.default_image" :src="item.default_image" class="avatar" style="width: 30px;height: 30px"></span>-->
                                <span style="float: left;">{{ item.name }}</span>
                        </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="优惠券面值(元)：" prop="price">
                <el-input v-model.trim="formData.price" style="width: 300px" v-limit-positive-number-fixed2 :disabled="loadingTitle=='详情'"></el-input>
            </el-form-item>
            <el-form-item label="使用门槛：" prop="is_condition">
                <el-radio-group v-model="formData.is_condition" style="width: 300px">
                    <el-radio :label="false">无门槛</el-radio>
                    <el-radio :label="true">有门槛</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="" prop="use_min_price" v-if="formData.is_condition">
                满 <el-input v-model.trim="formData.use_min_price" style="width: 150px"  v-limit-positive-number-fixed2 ></el-input> 可使用优惠券
            </el-form-item>
            <el-form-item label="有效期：" prop="coupon_expiretime">
                领取后
                <el-input v-model.trim="formData.coupon_expiretime" style="width: 150px" placeholder="请输入正整数" v-limit-positive-int   :disabled="loadingTitle=='详情'"></el-input>
                 天有效
            </el-form-item>
<!--            <el-form-item label="排序：" prop="sort">-->
<!--                <el-input-number v-model="formData.sort" :min="0" :max="999999"></el-input-number>-->
<!--            </el-form-item>-->
            <el-form-item label="状态：" prop="status" :disabled="loadingTitle=='详情'" >
                <el-switch
                    active-text="启用"
                    inactive-text="禁用"
                    v-model="formData.status"
                    active-color="#13ce66"
                    inactive-color="#ff4949">
                </el-switch>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave" :disabled="loadingTitle=='详情'">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {mallGoodscouponAdd,mallGoodscouponEdit} from "@/api/api";
    export default {
        name: "addModuleCoupon",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                menkan:false,
                formData:{
                    name:"",
                    coupon_type:'',
                    price:"",
                    receive_type:3,
                    coupon_expiretime:'',
                    is_condition:false,
                    use_min_price:0,
                    sort:0,
                    status:true,
                },
                coupontypeList:[
                    {id:0,name:'通用券'},
                    {id:1,name:'商品类通用卷'},
                    {id:2,name:'服务类服务类'},
                ],
                rules:{
                    name: [
                        {required: true, message: '请输入优惠券名称',trigger: 'blur'}
                    ],
                    coupon_type: [
                        {required: true, message: '请选择优惠券类型',trigger: 'blur'}
                    ],
                    price: [
                        {required: true, message: '请输入优惠券面值',trigger: 'blur'}
                    ],
                    receive_type: [
                        {required: true, message: '请选择发送方式',trigger: 'blur'}
                    ],
                    coupon_expiretime: [
                        {required: true, message: '请输入有效期',trigger: 'blur'}
                    ],

                }
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.formData ={
                    name:"",
                    coupon_type:'',
                    price:"",
                    receive_type:3,
                    coupon_expiretime:'',
                    is_condition:false,
                    use_min_price:0,
                    sort:0,
                    status:true,
                },
                this.menkan = false
                this.$emit('refreshData')
            },
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                if(item){
                    this.formData=item
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
                            mallGoodscouponEdit(param).then(res=>{
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
                            mallGoodscouponAdd(param).then(res=>{
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
            }
        }
    }
</script>


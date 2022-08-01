<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="500px" :before-close="handleClose">
            <el-form :inline="false" label-position="right" label-width="110px" class="form-order" v-model="formData">
                <el-form-item label="收货信息：">
                    <span>收货人：{{formData.address.receiver}}</span>
                    <span>联系电话：{{formData.address.mobile}}</span>
                    <span>收货地址：{{formData.address.areas}}</span>
                </el-form-item>
                <el-form-item label="备注：">
                    <span>{{formData.remark}}</span>
                </el-form-item>
                <el-form-item label="物流单号：" style="width:100%">
                    <span>{{formData.logistics_id}}</span>
                </el-form-item>
                <el-form-item label="订单信息：" style="width:100%">
                    <div>
                        <span style="display: inline;margin-right: 20px">订单编号：{{formData.order_id}}</span>
                        <span style="display: inline">付款时间：{{formData.pay_time}}</span>
                    </div>
                    <el-table border size="small" :data="formData.goodsinfo" :span-method="objectSpanMethod">
                        <el-table-column label="商品信息" show-overflow-tooltip width="200">
                            <template #default="scope">
                                <div style="display: flex;align-items: center">
                                    <img :src="scope.row.sku_default_image" style="width: 40px;height:40px;margin-right: 5px">
                                    <span style="width: 150px" class="ellipsis">{{scope.row.sku_spec}}</span>
                                </div>
                            </template>
                        </el-table-column>
                        <el-table-column label="单价" >
                            <template #default="scope">
                                <span>{{scope.row.price}}积分</span>
                            </template>
                        </el-table-column>
                        <el-table-column label="数量">
                            <template #default="scope">
                                <span>{{scope.row.count}}</span>
                            </template>
                        </el-table-column>
                        <el-table-column label="总价" >{{Number(formData.total_amount)}}</el-table-column>
                        <el-table-column label="状态">
                            <template #default="scope">
                                <span>{{orderStatusList.filter(item=>item.id==formData.status)[0].name}}</span>
                            </template>
                        </el-table-column>
                    </el-table>
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="deliverGoods">发货</el-button>
                <el-button @click="handleClose" type="primary">取消</el-button>
            </template>
            <deliver-goods-module ref="deliverGoodsModuleFlag"></deliver-goods-module>
        </ly-dialog>
    </div>
</template>

<script>
    import deliverGoodsModule from "./deliverGoodsModule";
    import LyDialog from "../../../components/dialog/dialog";
    export default {
        name: "shoppingMallOrderDetail",
        components: {LyDialog, deliverGoodsModule},
        data() {
            return {
                dialogVisible:false,
                loadingPage:false,
                loadingTitle:"详情",
                formData:{
                    logistics_id:'',
                    address:{
                        receiver:'',
                        mobile:'',
                        areas:''
                    },
                    goodsinfo:[]
                },

                orderStatusList:[
                    {id:1,name:'待支付'},
                    {id:2,name:'待发货'},
                    {id:3,name:'待收货'},
                    {id:4,name:'待评价'},
                    {id:5,name:'已完成'},
                    {id:6,name:'已取消'}
                ],
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.$emit('refreshData')
            },
            orderDetailFn(item) {
                this.dialogVisible=true
                this.formData=item
            },
            deliverGoods() {
                // this.loadingPage=true
                let param = {
                    id:this.formData.id
                }
                this.$refs.deliverGoodsModuleFlag.deliverGoodsModuleFn(param)
            },
            //table表格合并行
            objectSpanMethod({ row, column, rowIndex, columnIndex }) {
                if (columnIndex === 3 || columnIndex === 4) {//第3和4列合并行
                  // if (rowIndex % 2 === 0) {
                  //   return {
                  //     rowspan: 2,//实际上就是给td加上rowspan属性
                  //     colspan: 1//实际上就是给td加上colspan属性
                  //   };
                  // } else {
                  //   return {
                  //     rowspan: 0,
                  //     colspan: 0
                  //   };
                  // }
                    var _row=0;
                    if(rowIndex===0){
                        _row = this.formData.goodsinfo.length
                    }
                    if(rowIndex>=1){
                        _row = 0
                    }

                    return {
                          rowspan: _row,
                          colspan: 1
                        };
                }
              }
        }
    }
</script>
<style lang="scss">
    .form-order{
        background: #f1f1f1;
        .el-form-item{
            margin-bottom: 10px;
            span{
                display: block;
            }
            .el-form-item__label{
                font-weight: bold;
            }
        }
        .el-table{
            width: 98%;
            margin-bottom: 20px;
            .price-show{
                display: flex;
                span{
                    margin-right: 5px;
                }
            }
        }
    }
</style>


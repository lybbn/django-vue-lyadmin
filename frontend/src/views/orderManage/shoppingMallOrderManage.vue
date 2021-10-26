<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="订单编号：">
                    <el-input size="small" v-model.trim="formInline.order_id" maxlength="60"  clearable placeholder="订单编号" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="购买人：">
                    <el-input size="small" v-model.trim="formInline.buyer" maxlength="60"  clearable placeholder="购买人" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="商品名称：">
                    <el-input size="small" v-model.trim="formInline.goodsname" maxlength="60"  clearable placeholder="商品名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="手机号：">
                    <el-input size="small" v-model.trim="formInline.mobile" maxlength="60"  clearable placeholder="手机号" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="状态：">
                    <el-select size="small" v-model="formInline.status" placeholder="请选择" clearable @change="search" style="width:130px">
                        <el-option
                                v-for="item in statusList"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="下单时间：">
                    <el-date-picker
                            style="width:100% !important;"
                            v-model="timers"
                            size="small"
                            type="datetimerange"
                            @change="timeChange"
                            range-separator="至"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                    </el-date-picker>
                </el-form-item>
<!--                <el-form-item label="">-->
<!--                    <el-button size="small" type="primary">发货</el-button>-->
<!--                </el-form-item>-->
            </el-form>
        </div>
        <el-table size="small" height="calc(100vh - 260px)" border :data="tableData" v-loading="loadingPage" style="width: 100%"
                  @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column min-width="150" prop="order_id" label="订单编号"></el-table-column>
            <el-table-column min-width="150"  label="商品" show-overflow-tooltip>
                <template slot-scope="scope">
                    <div style="display: flex;align-items: center;margin: 5px 0" v-for="(item,index) in scope.row.goodsinfo">
                        <img :src="item.sku_default_image" alt="" style="width: 50px;height:50px;margin-right: 5px">
                        <span style="width:90px" class="ellipsis">{{item.sku_name}}</span>
                    </div>
                </template>
            </el-table-column>
            <el-table-column min-width="150"  label="购买人">
                <template slot-scope="scope">
                    <div>{{scope.row.address.receiver}}</div>
                    <div>{{scope.row.address.mobile}}</div>
                </template>
            </el-table-column>
            <el-table-column min-width="120"  label="价格">
                <template slot-scope="scope">
                    <span>{{Number(scope.row.total_amount)}}</span>
                </template>
            </el-table-column>
            <el-table-column min-width="120" prop="create_datetime" label="下单时间"></el-table-column>
            <el-table-column min-width="150" prop="address.areas" label="收货地址"></el-table-column>
            <el-table-column min-width="100" label="状态">
                <template slot-scope="scope">
                    <span>{{statusList.filter(item=>item.id==scope.row.status)[0].name}}</span>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
            <el-table-column label="操作" fixed="right" width="130">
                <template slot-scope="scope">
                    <!--                        v-show="isShowBtn('recoveryOrderManage','回收订单管理','Delete')delivergoods"-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('shoppingMallOrderManage','商城订单管理','Retrieve')">详情</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'deliver')" v-if="scope.row.status==2" v-show="isShowBtn('shoppingMallOrderManage','商城订单管理','delivergoods')">发货</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('shoppingMallOrderManage','商城订单管理','Delete')">删除</span>
                </template>
            </el-table-column>
        </el-table>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <shopping-mall-order-detail ref="shoppingMallOrderDetailFlag"></shopping-mall-order-detail>
        <deliver-goods-module ref="deliverGoodsModuleFlag" @refreshData="search"></deliver-goods-module>
    </div>
</template>
<script>
    import shoppingMallOrderDetail from "./components/shoppingMallOrderDetail";
    import deliverGoodsModule from "./components/deliverGoodsModule";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {mallGoodsOrder,mallGoodsOrderDelete} from '@/api/api'
    export default {
        components:{
            Pagination,
            shoppingMallOrderDetail,
            deliverGoodsModule
        },
        name:'shoppingMallOrderManage',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    name:'',
                    status:'',
                    page: 1,
                    limit: 10,
                },
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                statusList:[
                    {id:1,name:'待支付'},
                    {id:2,name:'待发货'},
                    {id:3,name:'待收货'},
                    {id:4,name:'待评价'},
                    {id:5,name:'已完成'},
                    {id:6,name:'已取消'}
                ],
                timers:[],
                tableData:[],
            }
        },
        methods:{
            handleEdit(row,flag) {
                if(flag=='detail') {
                    this.$refs.shoppingMallOrderDetailFlag.orderDetailFn(row)
                }
                if(flag=='deliver') {
                    this.$refs.deliverGoodsModuleFlag.deliverGoodsModuleFn(row)
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('确定删除该订单？删除后无法恢复？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        mallGoodsOrderDelete({id:row.id}).then(res=>{
                            if(res.code == 2000) {
                                vm.$message.success(res.msg)
                                vm.search()
                            } else {
                                vm.$message.warning(res.msg)
                            }
                        })
                    }).catch(()=>{

                    })
                }
            },

            callFather(parm) {
                this.formInline.page = parm.page
                this.formInline.limit = parm.limit
                this.getData()
            },
            search() {
                this.formInline.page = 1
                this.formInline.limit = 10
                this.getData()
            },
            //获取列表
            async getData() {
                this.loadingPage = true
                 mallGoodsOrder(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                 })
            },

            timeChange(val){
                if (val) {
                    this.formInline.beginAt=dateFormats(val[0],'yyyy-MM-dd hh:mm:ss');
                    this.formInline.endAt=dateFormats(val[1],'yyyy-MM-dd hh:mm:ss');
                } else {
                    this.formInline.beginAt = null
                    this.formInline.endAt = null
                }
                this.search()
            },
            handleSelectionChange(e) {
              console.log(e,'e----')
            },
        },
        created() {
            this.getData()
        },
        timers(val){
            if (val) {
                this.formInline.beginAt=dateFormats(val[0],'yyyy-MM-dd hh:mm:ss');
                this.formInline.endAt=dateFormats(val[1],'yyyy-MM-dd hh:mm:ss');
            } else {
                this.formInline.beginAt = ''
                this.formInline.endAt = ''
            }
            this.getData()
        },
    }
</script>


<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="订单编号：">
                    <el-input v-model.trim="formInline.order_id" maxlength="60"  clearable placeholder="订单编号" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="购买人：">
                    <el-input v-model.trim="formInline.buyer" maxlength="60"  clearable placeholder="购买人" @change="search" style="width:150px"></el-input>
                </el-form-item>
<!--                <el-form-item label="商品名称：">-->
<!--                    <el-input size="small" v-model.trim="formInline.goodsname" maxlength="60"  clearable placeholder="商品名称" @change="search" style="width:200px"></el-input>-->
<!--                </el-form-item>-->
<!--                <el-form-item label="手机号：">-->
<!--                    <el-input size="small" v-model.trim="formInline.mobile" maxlength="60"  clearable placeholder="手机号" @change="search" style="width:200px"></el-input>-->
<!--                </el-form-item>-->
                <el-form-item label="状态：">
                    <el-select v-model="formInline.status" placeholder="请选择" clearable @change="search" style="width:130px">
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
                            style="width:350px"
                            v-model="timers"
                            type="datetimerange"
                            @change="timeChange"
                            range-separator="至"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                    </el-date-picker>
                </el-form-item>
                <el-form-item label=""><el-button  @click="search" type="primary" icon="Search" v-show="isShowBtn('mallOrderManage','商城订单','Search')">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleDelete" type="danger" :disabled="multiple" v-show="isShowBtn('mallOrderManage','商城订单','Delete')">删除</el-button></el-form-item>
            </el-form>
        </div>
        <ul class="order-static" ref="orderStatic">
            <li>订单量：{{orderstatics.totalcount}} 单</li>
            <li>订单金额：￥{{orderstatics.totalmoney}}</li>
        </ul>
        <el-table :height="tableHeight" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%" @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column type="index" width="60" align="center" label="序号">
                <template #default="scope">
                    <span v-text="getIndex(scope.$index)"></span>
                </template>
            </el-table-column>
            <el-table-column min-width="160" prop="order_id" label="订单编号"></el-table-column>
            <el-table-column min-width="70" prop="avatar" label="用户头像">
                    <template #default="scope">
                        <img  :src="scope.row.userinfo.avatar ? scope.row.userinfo.avatar : defaultImg" style="width: 30px;height: 30px" :onerror="defaultImg">
                    </template>
            </el-table-column>
            <el-table-column min-width="130"  label="购买人">
                <template #default="scope">
                    <div>{{scope.row.userinfo.nickname}}</div>
                    <div>{{scope.row.userinfo.mobile}}</div>
                </template>
            </el-table-column>
            <el-table-column min-width="150"  label="商品信息" show-overflow-tooltip>
                <template #default="scope">
                    <div style="display: flex;align-items: center;margin: 5px 0" v-for="(item,index) in scope.row.goodsinfo">
                        <img :src="item.sku_default_image" alt="" style="width: 50px;height:50px;margin-right: 5px">
                        <span style="width:90px" class="ellipsis">{{item.sku_spec}}</span>
                        <span>{{"￥"+item.price+"x"+item.count}}</span>
                    </div>
                </template>
            </el-table-column>
            <el-table-column min-width="100" prop="total_amount"  label="实付金额"></el-table-column>
            <el-table-column min-width="120"  label="下单时间/支付时间">
                <template #default="scope">
                    <div>{{scope.row.create_datetime}}</div>
                    <div>{{scope.row.pay_time}}</div>
                </template>
            </el-table-column>
            <el-table-column min-width="160"  label="收货地址">
                <template #default="scope">
                    <div>{{scope.row.address.receiver+" "+scope.row.address.mobile}}</div>
                    <div>{{scope.row.address.areas}}</div>
                </template>
            </el-table-column>
            <el-table-column min-width="80" prop="pay_method_name" label="支付方式"></el-table-column>
            <el-table-column min-width="80" label="状态">
                <template #default="scope">
                    <span>{{statusList.filter(item=>item.id==scope.row.status)[0].name}}</span>
                </template>
            </el-table-column>
<!--            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>-->
            <el-table-column label="操作" fixed="right" width="130">
                <template #header>
                    <div style="display: flex;justify-content: space-between;align-items: center;">
                        <div>操作</div>
                        <div @click="setFull">
                            <el-tooltip content="全屏" placement="bottom">
                                <el-icon ><full-screen /></el-icon>
                            </el-tooltip>
                        </div>
                    </div>
                </template>
                <template #default="scope">
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('mallOrderManage','商城订单','Retrieve')">详情</span>
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'deliver')" v-if="scope.row.status==2" v-show="isShowBtn('mallOrderManage','商城订单','Deliver')">发货</span>
<!--                    <span class="table-operate-btn" @click="handleEdit(scope.row,'closeorder')" v-if="scope.row.status==2" v-show="isShowBtn('mallOrderManage','商城订单','closeorder')">关闭订单</span>-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('mallOrderManage','商城订单','Delete')">删除</span>
                </template>
            </el-table-column>
        </el-table>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <shopping-mall-order-detail ref="shoppingMallOrderDetailFlag"></shopping-mall-order-detail>
        <deliver-goods-module ref="deliverGoodsModuleFlag" @refreshData="getData"></deliver-goods-module>
    </div>
</template>
<script>
    import shoppingMallOrderDetail from "./components/shoppingMallOrderDetail";
    import deliverGoodsModule from "./components/deliverGoodsModule";
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {mallGoodsOrder,mallGoodsOrderDelete,mallGoodsOrderstatistics} from '@/api/api'
    import { lyMixins } from "@/mixins/mixins"
    export default {
        mixins: [lyMixins],
        components:{
            Pagination,
            shoppingMallOrderDetail,
            deliverGoodsModule
        },
        name:'mallOrderManage',
        data() {
            return {
                isFull:false,
                loadingPage:false,
                defaultImg:"this.src='"+require('../../assets/img/avatar.jpg')+"'",
                // 选项框选中数组
                ids: [],
                // 选项框非单个禁用
                single: true,
                // 非多个禁用
                multiple: true,
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
                orderstatics:{
                    totalmoney: 0,
                    totalcount: 0,
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
            setFull(){
                this.isFull=!this.isFull
                window.dispatchEvent(new Event('resize'))
            },
            // 表格序列号
            getIndex($index) {
                // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
            //多选项框被选中数据
            handleSelectionChange(selection) {
                this.ids = selection.map(item => item.id);
                this.single = selection.length !== 1;
                this.multiple = !selection.length;
            },
            /** 批量删除按钮操作 */
            handleDelete(row) {
                const ids = this.ids;
                let vm = this
                vm.$confirm('是否确认删除选中的数据项?', "警告", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning"
                }).then(function() {
                    return mallGoodsOrderDelete({id:ids}).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
            handleEdit(row,flag) {
                let vm = this
                if(flag=='detail') {
                    this.$refs.shoppingMallOrderDetailFlag.orderDetailFn(row)
                }
                else if(flag=='deliver') {
                    this.$refs.deliverGoodsModuleFlag.deliverGoodsModuleFn(row)
                }
                else if(flag=='delete') {
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
                else if(flag=="reset"){
                    this.formInline = {
                        page:1,
                        limit: 10
                    }
                    this.pageparm={
                        page: 1,
                        limit: 10,
                        total: 0
                    }
                    this.search()
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
                this.getOrderstatistics()
            },
            //订单金额统计获取
            getOrderstatistics(){
                mallGoodsOrderstatistics(this.formInline).then(res => {
                     if(res.code ==2000) {
                         this.orderstatics = res.data.data
                     }
                 })
                  //   .finally(() => {
                  //  this.$nextTick(() => {
                  //     this.$refs.tableref.doLayout();
                  //   });
                  // });
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
            this.getOrderstatistics()
        },
    }
</script>
<style lang="scss">
    .order-static{
        display: flex;
        font-size: 14px;
        background: var(--l-order-statics);
        padding: 10px;
        li{
            margin-right: 30px;

        }
    }
</style>

<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="订单编号：">
                    <el-input size="small" v-model.trim="formInline.order_id" maxlength="60"  clearable placeholder="订单编号" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="下单人：">
                    <el-input size="small" v-model.trim="formInline.buyer" maxlength="60"  clearable placeholder="下单人" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="回收员：">
                    <el-input size="small" v-model.trim="formInline.retrieve_user" maxlength="60"  clearable placeholder="回收员" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="订单类型：">
                    <el-select size="small" v-model="formInline.order_type" placeholder="请选择" clearable @change="search">
                        <el-option
                                v-for="item in orderStyleList"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="订单状态：">
                    <el-select size="small" v-model="formInline.status" placeholder="请选择" clearable @change="search">
                        <el-option
                                v-for="item in orderStatusList"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="回收物：">
                    <el-input size="small" v-model.trim="formInline.rubbishs" maxlength="60"  clearable placeholder="回收物" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="代理商名称：">
                    <el-input size="small" v-model.trim="formInline.agent" maxlength="60"  clearable placeholder="代理商名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                                <el-form-item label="创建时间：">
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
            </el-form>
        </div>
        <ul class="order-static">
            <li>日订单：{{orderstatics.todaynum}}</li>
            <li>月订单：{{orderstatics.monthnum}}</li>
            <li>订单数量：{{orderstatics.totalnum}}</li>
        </ul>
        <el-table size="small" height="calc(100vh - 260px)" border :data="tableData" v-loading="loadingPage" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
            <el-table-column min-width="150" prop="order_id" label="订单编号"></el-table-column>
            <el-table-column min-width="150" prop="rubbishs" label="回收物">
                <template slot-scope="scope">
                    <div style="display: flex;align-items: center;margin: 5px 0" v-for="(item,index) in scope.row.rubbishs">
                        <img :src="item.image" alt="" style="width: 50px;height:50px;margin-right: 5px">
                        {{item.name}}
                    </div>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="user" label="下单人">
                <template slot-scope="scope">
                    <div>{{scope.row.user.name}}</div>
                    <div>{{scope.row.user.mobile}}</div>
                </template>
            </el-table-column>
            <el-table-column min-width="120" prop="total_amount" label="价格"></el-table-column>
            <el-table-column min-width="150" prop="yuyue_time" label="预约时间"></el-table-column>
            <el-table-column min-width="150" prop="address" label="上门地址"></el-table-column>
            <el-table-column min-width="150" prop="retrieve_user" label="回收员">
                <template slot-scope="scope">
                    <div>{{scope.row.retrieve_user.name}}</div>
                    <div>{{scope.row.retrieve_user.mobile}}</div>
                </template>
            </el-table-column>
            <el-table-column min-width="100" label="订单类型">
                <template slot-scope="scope">
                    <span>{{orderStyleList.filter(item=>item.id==scope.row.order_type)[0].name}}</span>
                </template>
            </el-table-column>
            <el-table-column min-width="100" label="状态">
                <template slot-scope="scope">
                    <span>{{orderStatusList.filter(item=>item.id==scope.row.status)[0].name}}</span>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
            <el-table-column label="操作" fixed="right" width="180">
                <template slot-scope="scope">
                    <!--                        v-show="isShowBtn('recoveryOrderManage','回收订单管理','Delete')"-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('recoveryOrderManage','回收订单管理','Retrieve')">详情</span><!--超管，代理都有此权限-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'recycler')" v-if="scope.row.status==1">指派回收员</span><!--代理有此权限-->
                    <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('recoveryOrderManage','回收订单管理','Delete')">删除</span><!--超管，代理都有此权限-->
                </template>
            </el-table-column>
        </el-table>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <order-detail ref="orderDetailFlag"></order-detail>
        <recycler-list ref="recyclerListFlag" @refreshData="search"></recycler-list>
    </div>
</template>
<script>
    import orderDetail from "./components/orderDetail";
    import Pagination from "@/components/Pagination";
    import recyclerList from "./components/recyclerList";
    import {dateFormats} from "@/utils/util";
    import {retrieveRetrieveorder,retrieveRetrieveorderDelete,retrieveOrderstatistics} from '@/api/api'
    export default {
        components:{
            Pagination,
            orderDetail,
            recyclerList
        },
        name:'recoveryOrderManage',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    page: 1,
                    limit: 10,
                },
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                statusList:[
                    {id:1,name:'正常'},
                    {id:0,name:'禁用'}
                ],
                timers:[],
                tableData:[],
                orderstatics:{
                    monthnum: 0,
                    todaynum: 0,
                    totalnum: 0
                },
                orderStatusList:[
                    {id:1,name:'待接单'},
                    {id:2,name:'已接单'},
                    {id:3,name:'待入库'},
                    {id:4,name:'待销毁'},
                    {id:5,name:'待评价'},
                    {id:6,name:'已完成'},
                    {id:7,name:'已取消'},
                    {id:8,name:'已逾期'},
                ],
                orderStyleList:[
                    {id:1,name:'线上订单'},
                    {id:2,name:'线下订单'},
                ],
            }
        },
        methods:{
            handleEdit(row,flag) {
                if(flag=='detail') {
                    this.$refs.orderDetailFlag.orderDetailFn(row)
                }
                if(flag=='recycler') {
                    this.$refs.recyclerListFlag.recyclerListFn(row)
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('确定删除该订单？删除后无法恢复？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        retrieveRetrieveorderDelete({id:row.id}).then(res=>{
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
                 retrieveRetrieveorder(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                 })
            },
            //订单统计获取
            getOrderstatistics(){
                retrieveOrderstatistics().then(res => {
                     if(res.code ==2000) {
                         this.orderstatics = res.data.data
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
        },
        created() {
            this.getData()
            this.getOrderstatistics()
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
<style lang="scss">
    .order-static{
        display: flex;
        font-size: 14px;
        background: #ecf5ff;
        padding: 10px;
        li{
            margin-right: 30px;

        }
    }
</style>

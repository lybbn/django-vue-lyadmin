<template>
    <div>
        <div class="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="优惠券名称：">
                    <el-input size="small" v-model.trim="formInline.search" maxlength="60"  clearable placeholder="优惠券名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <!--                <el-form-item label="创建时间：">-->
                <!--                    <el-date-picker-->
                <!--                            style="width:100% !important;"-->
                <!--                            v-model="timers"-->
                <!--                            size="small"-->
                <!--                            type="datetimerange"-->
                <!--                            @change="timeChange"-->
                <!--                            range-separator="至"-->
                <!--                            start-placeholder="开始日期"-->
                <!--                            end-placeholder="结束日期">-->
                <!--                    </el-date-picker>-->
                <!--                </el-form-item>-->

                 <!--代理商有此权限 v-show="isShowBtn('applyQuotaAgent','代理商申请额度','Create')"-->
                <el-form-item label=""><el-button size="small" @click="addModule" type="primary" v-show="isShowBtn('couponManage','优惠券管理','Create')">新增</el-button></el-form-item>
            </el-form>
        </div>

        <div class="table">
            <el-table size="small" height="calc(100vh - 280px)" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%"
                      @selection-change="handleSelectionChange">
<!--                <el-table-column type="selection" width="55"></el-table-column>-->
                <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
<!--                <el-table-column min-width="60" sortable prop="sort" label="排序"></el-table-column>-->
                <el-table-column min-width="120" prop="name" label="优惠券名称"></el-table-column>
                <el-table-column min-width="120" prop="coupon_type_name" label="优惠券类型"></el-table-column>
                <el-table-column min-width="120" prop="price" label="面值（元）"></el-table-column>
                <el-table-column min-width="120" prop="menkan" label="门槛"></el-table-column>
                <el-table-column min-width="120" prop="coupon_expiretime" label="有效期">
                    <template slot-scope="scope">
                        {{scope.row.coupon_expiretime+"天"}}
                    </template>
                </el-table-column>
                <el-table-column min-width="120" prop="sendto" label="发送对象"></el-table-column>
<!--                <el-table-column min-width="100" label="状态" prop="status">-->
<!--                    <template slot-scope="scope">-->
<!--                        <el-tag v-if="scope.row.status" size="small">正常</el-tag>-->
<!--                        <el-tag v-else type="danger" size="small">禁用</el-tag>-->
<!--                    </template>-->
<!--                </el-table-column>-->
                <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>
                <el-table-column label="操作" fixed="right"  width="220">
                    <template slot-scope="scope">
<!--                        <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('viptypeManage','会员卡管理','Retrieve')">详情</span>-->
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'watchuse')" v-show="isShowBtn('couponManage','优惠券管理','Update')">查看使用</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'sendcoupon')" v-if="scope.row.receive_type==3" v-show="isShowBtn('couponManage','优惠券管理','Update')">立即发送</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('couponManage','优惠券管理','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('couponManage','优惠券管理','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
        <add-module-coupon ref="addModuleFlag" @refreshData="search"></add-module-coupon>
        <add-module-send-coupon ref="addModuleSendCouponFlag" @refreshData="search"></add-module-send-coupon>
        <add-module-watch-coupon-use ref="addModuleWatchCouponUseFlag" @refreshData="search"></add-module-watch-coupon-use>
    </div>
</template>
<script>
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {mallGoodscoupon,mallGoodscouponDelete} from '@/api/api'
    import AddModuleCoupon from "./components/addModuleCoupon";
    import AddModuleSendCoupon from "./components/addModuleSendCoupon";
    import AddModuleWatchCouponUse from "./components/addModuleWatchCouponUse";
    export default {
        components:{
            AddModuleWatchCouponUse,
            AddModuleSendCoupon,
            AddModuleCoupon,
            Pagination,
        },
        name:'couponManage',
        data() {
            return {
                loadingPage:false,
                formInline:{
                    search:'',
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
                selectData:[]
            }
        },
        methods:{
            handleSelectionChange(e) {
                this.selectData=e
            },
            changeStatus(row) {
                console.log(row,'row----')
            },
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='detail') {
                    this.$refs.addModuleFlag.addModuleFn(row,'详情')
                }
                if(flag=='sendcoupon') {
                    this.$refs.addModuleSendCouponFlag.addModuleFn(row,'立即发送')
                }
                if(flag=='watchuse') {
                    this.$refs.addModuleWatchCouponUseFlag.addModuleFn(row,'查看使用')
                }
                if(flag=='edit') {
                    this.$refs.addModuleFlag.addModuleFn(row,'编辑')
                }
                if(flag=='delete') {
                    let vm = this
                    vm.$confirm('您确定要删除选中的数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        mallGoodscouponDelete({id:row.id}).then(res=>{
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
            async getData(){
                this.loadingPage = true
                 mallGoodscoupon(this.formInline).then(res => {
                     this.loadingPage = false
                     if(res.code ==2000) {
                         this.tableData = res.data.data
                         this.pageparm.page = res.data.page;
                         this.pageparm.limit = res.data.limit;
                         this.pageparm.total = res.data.total;
                     }
                     this.$nextTick(() => {
                        this.$refs.tableref.doLayout()
                    })
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




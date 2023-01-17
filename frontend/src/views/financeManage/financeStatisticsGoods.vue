<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="订单编号：">
                    <el-input v-model.trim="formInline.order_id" maxlength="60"  clearable placeholder="订单编号" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="昵称：">
                    <el-input v-model.trim="formInline.nickname" maxlength="60"  clearable placeholder="昵称" @change="search" style="width:150px"></el-input>
                </el-form-item>
                <el-form-item label="商品名称：">
                    <el-input v-model.trim="formInline.gname" maxlength="60"  clearable placeholder="商品名称" @change="search" style="width:200px"></el-input>
                </el-form-item>
                <el-form-item label="付款时间：">
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
<!--                <el-form-item label=""><el-button size="small" @click="addModule" type="primary">新增</el-button></el-form-item>&lt;!&ndash;超管有此权限&ndash;&gt;-->
<!--                <el-form-item label=""><el-button size="small" @click="exportData" type="primary">导出</el-button></el-form-item>&lt;!&ndash;超管有此权限&ndash;&gt;-->
                <el-form-item label=""><el-button  @click="search" type="primary" icon="Search" v-show="isShowBtn('financeStatisticsGoods','商品财务流水','Search')">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleEdit('','reset')" icon="Refresh">重置</el-button></el-form-item>
            </el-form>
        </div>
        <ul class="order-static" ref="orderStatic">
            <li>收益总金额：￥{{orderstatics.totalmoney}}</li>
        </ul>
        <el-table :height="tableHeight" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号">
                <template #default="scope">
                    <span v-text="getIndex(scope.$index)"></span>
                </template>
            </el-table-column>
            <el-table-column min-width="70" prop="avatar" label="用户头像">
                    <template #default="scope">
                        <img  :src="scope.row.userinfo.avatar ? scope.row.userinfo.avatar : defaultImg" style="width: 30px;height: 30px" :onerror="defaultImg">
                    </template>
            </el-table-column>
            <el-table-column min-width="110" prop="userinfo.nickname" label="昵称"></el-table-column>
            <el-table-column min-width="150" prop="gname" label="商品名称"></el-table-column>
            <el-table-column min-width="150" prop="total_amount" label="实付金额"></el-table-column>
            <el-table-column min-width="150" prop="pay_method" label="支付方式"></el-table-column>
            <el-table-column min-width="150" prop="order_id" label="订单编号"></el-table-column>
            <el-table-column min-width="150" prop="pay_time" label="付款时间"></el-table-column>
<!--            <el-table-column min-width="100" label="状态">-->
<!--                <template slot-scope="scope">-->
<!--                    <el-tag v-if="scope.row.is_active">正常</el-tag>-->
<!--                    <el-tag v-else type="danger">禁用</el-tag>-->
<!--                </template>-->
<!--            </el-table-column>-->
<!--            <el-table-column min-width="150" prop="create_datetime" label="创建时间"></el-table-column>-->
<!--            <el-table-column label="操作" fixed="right" width="180">-->
<!--                <template slot-scope="scope">-->
<!--                    &lt;!&ndash;                        v-show="isShowBtn('financeStatisticsAgent','分销设置','Update')"&ndash;&gt;-->
<!--                    <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="isShowBtn('financeStatisticsAgent','代理商财务统计','Retrieve')">详情</span>-->
<!--                </template>-->
<!--            </el-table-column>-->
        </el-table>
        <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
    </div>
</template>
<script>
    import Pagination from "@/components/Pagination";
    import {dateFormats} from "@/utils/util";
    import {mallGoodsforderinfo,mallGoodsforderinfoOrderstatistics} from '@/api/api'
    import { lyMixins } from "@/mixins/mixins"
    export default {
        mixins: [lyMixins],
        components:{
            Pagination,
        },
        name:'financeStatisticsGoods',
        data() {
            return {
                isFull:false,
                loadingPage:false,
                formInline:{
                    name:'',
                    type:3,
                    page: 1,
                    limit: 10,
                },
                orderstatics:{
                    totalmoney: 0,
                },
                defaultImg:"this.src='"+require('../../assets/img/avatar.jpg')+"'",
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                tableData:[],
                timers:[],
            }
        },
        methods:{
            setFull(){
                this.isFull=!this.isFull
            },
            // 表格序列号
            getIndex($index) {
                // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增','1')
            },
            handleEdit(row,flag) {
                let vm = this
                if(flag=='detail') {
                    vm.$refs.addModuleFlag.addModuleFn(row,'详情','1')
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
                    this.timers = []
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
                mallGoodsforderinfoOrderstatistics(this.formInline).then(res => {
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
            async getData(){
                this.loadingPage = true
                 mallGoodsforderinfo(this.formInline).then(res => {
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
            /**
             * 从URL里下载文件
            */
            // 下载文件
            downloadFile(url) {
                var iframe =document.createElement("iframe")
                iframe.style.display ="none";
                iframe.src = url;
                document.body.appendChild(iframe);
            },
            exportData() {
                // var params = {
                //     type:3,
                //     page: 1,
                //     limit: 9999,
                // }
                // retrieveFinancestatisticsExport(params).then(res => {
                //      if(res.code ==2000) {
                //          this.downloadFile(res.data.data)
                //          //this.$message.warning(res.data.data)
                //      }
                //  })
            }
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
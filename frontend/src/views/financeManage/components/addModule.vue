<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="70%"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-table size="small" height="calc(100vh - 260px)" border :data="tableList" v-loading="loadingPage" style="width: 100%" v-show="flagNum==3">
<!--            <el-table-column min-width="150" prop="name" label="余额"></el-table-column>-->
            <el-table-column min-width="120" prop="cashout_integral" label="提现积分"></el-table-column>
                <el-table-column min-width="120" prop="money" label="提现金额"></el-table-column>
                <el-table-column min-width="120" prop="audit_remarks" label="原因"></el-table-column>
            <el-table-column min-width="100" label="状态">
                <template slot-scope="scope">
                    <el-tag v-if="scope.row.audit_status==20">正常</el-tag>
                    <el-tag v-else-if="scope.row.audit_status==10" type="danger">审核中</el-tag>
                    <el-tag v-else type="danger">驳回</el-tag>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="时间"></el-table-column>
        </el-table>
        <el-table size="small" height="calc(100vh - 260px)" border :data="tableList" v-loading="loadingPage" style="width: 100%" v-show="flagNum==10">
<!--            <el-table-column min-width="150" prop="name" label="余额"></el-table-column>-->
            <el-table-column min-width="120" prop="type" label="类型">
                    <template slot-scope="scope">
                        <span v-if="scope.row.type==1">回收订单交易成功</span>
                        <span v-if="scope.row.type==2">商城购买</span>
                        <span v-if="scope.row.type==3">提现成功</span>
                        <span v-if="scope.row.type==4">推广获取积分</span>
                    </template>
            </el-table-column>
                <el-table-column min-width="120" prop="income" label="收入/支出">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.income==0" type="danger">支出</el-tag>
                        <el-tag v-else-if="scope.row.income==1">收入</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="120" prop="integral" label="积分"></el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="时间"></el-table-column>
        </el-table>
        <el-table size="small" height="calc(100vh - 260px)" border :data="tableList" v-loading="loadingPage" style="width: 100%" v-show="flagNum==1 || flagNum==2">
            <el-table-column min-width="150" prop="amount" label="金额"></el-table-column>
            <el-table-column min-width="150" prop="object" label="对象"></el-table-column>
            <el-table-column min-width="150" prop="income" label="用途">
                <template slot-scope="scope">
                     <el-tag v-if="scope.row.income">充值</el-tag>
                     <el-tag v-else type="danger">支出</el-tag>
<!--                    <el-switch-->
<!--                            v-model="scope.row.is_active"-->
<!--                            active-color="#13ce66"-->
<!--                            inactive-color="#ff4949"-->
<!--                            @change="changeStatus(scope.row)">-->
<!--                    </el-switch>-->
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="reson" label="原因"></el-table-column>
            <el-table-column min-width="100" label="状态" prop="status">
                <template slot-scope="scope">
                    <el-tag v-if="scope.row.status">正常</el-tag>
                    <el-tag v-else type="danger">驳回</el-tag>
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="时间"></el-table-column>
        </el-table>
        <span slot="footer">
            <el-button @click="handleClose">取消</el-button>
            <el-button v-if="flagNum == 2 || flagNum == 1" @click="exportdata" type="primary">导出</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {retrieveFinancestatisticsGetamountrecord,retrieveFinancestatisticsGetintegralrecord,retrievejifencashout,retrieveFinancestatisticsamountrecordExport} from "@/api/api";
    export default {
        name: "addModule",
        data() {
            return {
                dialogVisible:false,
                loadingPage:false,
                loadingTitle:'',
                tableList:[
                ],
                flagNum:'',
                userid:'',
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.tableList = []
                this.flagNum = ''
                this.userid=''
                this.loadingTitle = ''
                // this.$destroy()
                // this.$el.parentNode.removeChild(this.$el)
                this.$emit('refreshData')
            },
            addModuleFn(item,flag,num) {
                this.loadingTitle=flag
                this.flagNum=num
                this.userid = item.id
                this.dialogVisible=true
                if(num==2 || num==1){
                    this.getFundDetialList(item)
                }
                if(num==3){
                    this.getUserJifenRecordList(item)
                }
                if(num==10){
                    this.getUserJifenDetialRecordList(item)
                }
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
            exportdata(){
                if(this.flagNum==2 || this.flagNum==1){
                        var params = {
                        userid:this.userid,
                        page: 1,
                        limit: 9999,
                    }
                    retrieveFinancestatisticsamountrecordExport(params).then(res => {
                         if(res.code ==2000) {
                             this.downloadFile(res.data.data)
                             //this.$message.warning(res.data.data)
                         }
                     })
                }
                if(this.flagNum==3){

                }

            },
            getFundDetialList(item) {
                var params={
                    user:item.id,
                }
                retrieveFinancestatisticsGetamountrecord(params).then(res=>{
                    if(res.code == 2000) {
                        this.tableList=res.data.data
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            },
            getUserJifenDetialRecordList(item) {
                var params={
                    userid:item.id,
                }
                retrieveFinancestatisticsGetintegralrecord(params).then(res=>{
                    if(res.code == 2000) {
                        this.tableList=res.data.data
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            },
            getUserJifenRecordList(item) {
                var params={
                    user:item.id,
                }
                retrievejifencashout(params).then(res=>{
                    if(res.code == 2000) {
                        this.tableList=res.data.data
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            }
        }
    }
</script>


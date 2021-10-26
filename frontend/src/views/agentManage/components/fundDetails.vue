<template>
    <el-dialog
        title="资金明细"
        :visible.sync="dialogVisible"
        width="60%"
        center
        top="3%"
        :destroy-on-close="true"
        :close-on-click-modal="false"
        :before-close="handleClose">
        <el-form :inline="true" class="tableSelect">
            <el-form-item label="余额：" prop="balance">
                {{formData.balance}}
            </el-form-item>
            <el-form-item label="总资金：" prop="totalamount">
                {{formData.totalamount}}
            </el-form-item>
            <el-form-item label="总支出：" prop="mobile">
                {{totalSumAll}}
            </el-form-item>
        </el-form>

        <el-table size="small" height="calc(100vh - 360px)" border :data="tableList" v-loading="loading" style="width: 100%">
            <el-table-column type="index" width="60" align="center" label="序号"></el-table-column>
            <el-table-column min-width="120" prop="amount" label="金额"></el-table-column>
            <el-table-column min-width="150" prop="object" label="对象"></el-table-column>
            <el-table-column min-width="150" prop="income" label="资金类型">
                <template slot-scope="scope">
                     <el-tag v-if="scope.row.income">转入</el-tag>
                     <el-tag v-else type="danger">支出</el-tag>
<!--                    <el-switch-->
<!--                            v-model="scope.row.is_active"-->
<!--                            active-color="#13ce66"-->
<!--                            inactive-color="#ff4949"-->
<!--                            @change="changeStatus(scope.row)">-->
<!--                    </el-switch>-->
                </template>
            </el-table-column>
            <el-table-column min-width="150" prop="create_datetime" label="时间"></el-table-column>
        </el-table>

        <span slot="footer">
            <el-button @click="handleClose">取消</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {retrieveFinancestatisticsGetamountrecord} from "@/api/api";
    export default {
        name: "fundDetails",
        data() {
            return {
                dialogVisible:false,
                loading:false,
                formData:{
                    name:'',
                },
                tableList:[]
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.loading=false
                this.$emit('refreshData')
            },
            fundDetailsFn(item) {
                this.dialogVisible=true
                this.getFundDetialList(item)
                this.formData=item ? item : {
                    name:'',
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
            }

        },
        computed:{
            //求和
            totalSumAll(){
                let totalSumAll = 0
                this.tableList.forEach((item)=>{
                    if (item.income ==0){
                        totalSumAll = totalSumAll+ (item.amount-0)
                        // totalSumAll = totalSumAll +parseFloat(item.amount)
                    }
                })
                return totalSumAll.toFixed(2)
            },
        }
    }
</script>


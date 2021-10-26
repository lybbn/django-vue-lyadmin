<template>
    <el-dialog
        title="详情"
        :visible.sync="dialogVisible"
        width="900px"
        center
        top="3%"
        :destroy-on-close="true"
        :close-on-click-modal="false"
        :before-close="handleClose">
        <el-form :inline="false"  label-position="right" label-width="110px" class="form-order" v-if="formData1">
            <el-form-item label="下单人：">
                <span>姓名：{{formData1.user.name}}</span>
                <span>手机号：{{formData1.user.mobile}}</span>
            </el-form-item>
            <el-form-item label="回收员信息：">
                <span>姓名：{{formData1.retrieve_user.name}}</span>
                <span>手机号：{{formData1.retrieve_user.mobile}}</span>
            </el-form-item>
            <el-form-item label="站点信息：">
                <span>站点名称：{{siteragent.site.name}}</span>
                <span>站点位置：{{siteragent.site.areas}}</span>
            </el-form-item>
            <el-form-item label="代理商信息：">
                <span>代理商名称：{{siteragent.agent.name}}</span>
                <span>代理区域：{{siteragent.agent.areas}}</span>
            </el-form-item>
            <el-form-item label="废品描述：" style="width:100%">
                <span>{{formData1.desc}}</span>
            </el-form-item>
            <el-form-item label="品类图片：" style="width:100%">
                <el-image fit="contain" v-for="(item,index) in formData1.rubbishs" :src="item.image" :preview-src-list="[item.image]" :key="index"  style="width:50px;height:50px;margin:0 5px 5px 0"></el-image>
                <!--<template slot-scope="scope">-->
                    <!--<img :src="formData[0].img" alt="" style="width:50px;height:50px;margin:0 5px 5px 0">-->
                    <!--<img :src="formData[0].img" alt="" style="width:50px;height:50px;margin:0 5px 5px 0">-->
                <!--</template>-->
            </el-form-item>
            <el-form-item label="销毁图片：" style="width:100%">
                <el-image fit="contain" v-for="(item,index) in formData1.ximages" :src="item" :preview-src-list="[item]"  :key="index" style="width:50px;height:50px;margin:0 5px 5px 0"></el-image>
                <!--<img :src="formData[0].img" alt="" style="width:50px;height:50px;margin:0 5px 5px 0">-->
                <!--<img :src="formData[0].img" alt="" style="width:50px;height:50px;margin:0 5px 5px 0">-->
            </el-form-item>
            <el-form-item label="上门地址：" style="width:100%">
                <span>{{formData1.address}}</span>
            </el-form-item>
            <el-form-item label="订单信息：" style="width:100%">
                <div>
                    <span style="display: inline;margin-right: 20px">订单编号：{{formData1.order_id}}</span>
                    <span style="display: inline">预约时间：{{formData1.yuyue_time}}</span>
                </div>
                <el-table border size="small" :data="formData1.rubbishs" :span-method="objectSpanMethod">
                    <el-table-column label="回收物" show-overflow-tooltip>
                        <template slot-scope="scope">
                            <div style="display: flex;align-items: center">
                                <img :src="scope.row.image" style="width: 40px;height:40px;margin-right: 5px">
                                {{scope.row.name}}
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column label="价格"  min-width="200">
                        <template slot-scope="scope">
                            <div class="price-show">
<!--                                <span>单价:￥{{scope.row.money}}</span>-->
                                <span>数量:{{scope.row.num}}</span>
                                <span>总价:￥{{scope.row.money}}</span>
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column label="总价（元）" >{{formData1.total_amount}}</el-table-column>
                    <el-table-column label="状态">
                            {{orderStatusList.filter(item=>item.id==formData1.status)[0].name}}
                    </el-table-column>
                </el-table>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose">取消</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {retrieveGetsiterandagent} from '@/api/api'
    export default {
        name: "orderDetail",
        data() {
            return {
                dialogVisible:false,
                siteragent:{
                    agent:{
                        name:'',
                        areas:''
                    },
                    site:{
                        name:'',
                        areas:''
                    }
                },
                formData1:'',
                formData:{
                    user:{
                        name:'',
                        mobile:'',
                    },
                    retrieve_user:{
                        name:'',
                        mobile:'',
                    },
                    name:'',
                    img:'',
                    rubbishs:[]
                },
                rubbishs:[],
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
            }
        },
        methods:{
            handleClose() {
                this.dialogVisible=false
                this.$emit('refreshData')
            },
            orderDetailFn(item) {
                this.dialogVisible=true

                this.formData1={
                    ...item
                }
                this.formData=[item]
                // console.log(this.formData,'formData')
                this.getData(item)
            },
            //获取列表
            getData(item) {
                retrieveGetsiterandagent({'id':item.id}).then(res => {
                     if(res.code ==2000) {
                         if (res.data.data){
                             this.siteragent = res.data.data
                         }

                     }
                 })
            },
            //table表格合并行
            objectSpanMethod({ row, column, rowIndex, columnIndex }) {
                if (columnIndex === 2 || columnIndex === 3) {//第2和3列合并行
                  // if (rowIndex % 2 === 0) {//合并行数如：0,2,4的列
                  //   return {
                  //     rowspan: 2,
                  //     colspan: 1
                  //   };
                  // } else {
                  //   return {
                  //     rowspan: 0,
                  //     colspan: 0
                  //   };
                  // }
                  //   var c_row = this.formData1.rubbishs.length
                    var _row=0;
                    if(rowIndex===0){
                        _row = this.formData1.rubbishs.length
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
        display: flex;
        flex-wrap: wrap;
        background: #f1f1f1;
        .el-form-item{
            width: 50%;
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

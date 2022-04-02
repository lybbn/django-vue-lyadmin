<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="1000px"
            center
            top="1%"
            v-dialogDrag
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-tabs v-model="activeName">
                <el-tab-pane label="基础信息" name="1">
                    <div style="display: flex;align-items: center;">
                        <el-form-item label="商品分类：" prop="category1" class="is-required">
                        <el-select size="small" v-model="formData.category1" placeholder="请选择分类" clearable filterable  style="width: 300px">
                            <el-option
                                    v-for="item in category_list"
                                    :key="item.id"
                                    :label="item.name"
                                    :value="item.id">
                            </el-option>
                        </el-select>
                        </el-form-item>
                    </div>
                    <el-form-item label="商品名称：" prop="name">
                        <el-input size="small" v-model.trim="formData.name" placeholder="请输入商品名称" style="width: 300px"></el-input>
                    </el-form-item>
<!--                    <el-form-item label="商品单位：" prop="unit">-->
<!--                        <el-input size="small" v-model.trim="formData.unit" placeholder="请输入商品单位" style="width: 300px"></el-input>-->
<!--                    </el-form-item>-->
                    <el-form-item label="商品排序：" prop="sort">
                        <el-input-number v-model="formData.sort"  :min="0" :max="9999"></el-input-number>
                    </el-form-item>
                    <el-form-item label="是否推荐：" prop="is_tuijian">
                        <el-radio-group v-model="formData.is_tuijian" style="width: 380px">
                            <el-radio :label="true">是</el-radio>
                            <el-radio :label="false">否</el-radio>
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item label="商品状态：" prop="is_launched">
                        <el-radio-group v-model="formData.is_launched" style="width: 380px">
                            <el-radio :label="true">上架</el-radio>
                            <el-radio :label="false">下架</el-radio>
                        </el-radio-group>
                    </el-form-item>
                </el-tab-pane>
                <!-- 商品图片-->
                <el-tab-pane label="商品图片" name="2">
                    <el-form-item label="商品缩略图：" prop="default_image">
                        <el-upload
                                class="avatar-uploader"
                                :limit="1"
                                action=""
                                :show-file-list="false"
                                :http-request="imgUploadRequest"
                                :on-success="imgUploadSuccess"
                                :before-upload="imgBeforeUpload">
                            <img v-if="formData.default_image" :src="formData.default_image" class="avatar">
                            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                        </el-upload>
                    </el-form-item>
                    <el-form-item label="商品轮播图：" style="margin-bottom: 0" >
                        <div class="uploadImg" style="display: block">
                            <div style="width: 100%;display: flex">
                                <div class="input-file input-fileup">
                                    <span style="display: inline-block; width: 100%;">{{submitLoading || (newData.length > 0 && detailDataA.length !== newData.length) ? '' : '上传图片'}}</span>
                                    <el-button style="width: 100%;height:36px" size="small" type="primary" v-if="submitLoading || (newData.length > 0 && detailDataA.length !== newData.length)"  :loading="submitLoading || (newData.length > 0 && detailDataA.length !== newData.length)">上传图片</el-button>
                                    <input ref="file" title="请上传图片"  class="fileUploaderClass" type='file' multiple name="file" v-else @change.stop="changesData"/>
                                </div>

                                <div class="deleteBtn" v-if="pics.length > 0"><el-button size="mini" type="delete"  :loading="submitLoading || (newData.length > 0 && detailDataA.length !== newData.length)" @click="clearPhotoData">清空照片</el-button></div>
                                <div class="elProgress" v-if="newData.length > 0 && detailDataA.length !== newData.length">
                                    <el-progress class="progress" :text-inside="true" :stroke-width="20" :percentage="parseInt(detailDataA.length*100/newData.length)" status="success"></el-progress>
                                    您还有 <span>（{{newData.length - detailDataA.length}}）</span>张照片等待上传
                                </div>
                            </div>
                            <span style="color: #999999; display: block;font-size:12px">(最多可上传9张图，<!--宽750px，<em style="color:#ff0000;font-style: normal">保持图片高度一致，便于前端效果展示</em>，--> 2MB以内，支持PNG/JPG格式)</span>
                        </div>
                    </el-form-item>
                    <el-form-item>
                        <div class="pickAlbumPreListO" :style="isEqual ? 'border:1px solid #ff0000' : ''">
                            <ul class="pickAlbumPreList" v-if="pics.length > 0">
                                <li v-for="(item, index) in pics">
                                    <el-image :src="item.pic" fit="contain" :preview-src-list="[item.pic]"></el-image>
                                    <i class="el-icon-close" @click="deletePhoto(index)"></i>
                                    <p>{{index+1}}页</p>
                                    <div class="btnchang">
                                        <el-button size="small" class="btnLf" @click="changeLf(index)" v-if="index != 0">左移</el-button>
                                        <el-button size="small" class="btnRg" @click="changeRg(index)" v-if="index != pics.length-1">右移</el-button>
                                    </div>
                                    <div class="sizeImg" v-if="isEqual">750*{{item.height}}</div>
                                </li>
                            </ul>
                            <ul class="pickAlbumPreList" v-else>
                                <li>
                                    <i class="el-icon-picture"></i>
                                    <div class="btnchang">
                                        <el-button size="small" class="btnRg">右移</el-button>
                                    </div>
                                </li>
                            </ul>
                            <div class="tipsCon">（左移/右移，可以调整图片前端展示顺序）</div>
                            <div class="tipsCon" style="color:#ff0000" v-if="isEqual">上传图片的高度，要求一致！</div>
                        </div>
                    </el-form-item>
                </el-tab-pane>
                <!-- 商品规格-->
                <el-tab-pane label="规格配置" name="3">
                    <el-form-item label="商品规格：" prop="spec_type">
                        <el-radio-group v-model="formData.spec_type" style="width: 380px">
                            <el-radio :label="0">单规格</el-radio>
                            <el-radio :label="1">多规格</el-radio>
                        </el-radio-group>
                    </el-form-item>
                    <!-- 单规格-->
                    <div v-if="formData.spec_type==0">
                        <el-form-item size="small" label="商品价格：" prop="shop_price" class="is-required">
                            <el-input v-model.trim="formData.shop_price" style="width: 300px" placeholder="请输入商品价格"></el-input>
                        </el-form-item>
                        <el-form-item size="small" label="库存：" prop="stock" class="is-required">
                            <el-input v-model.trim="formData.stock" style="width: 300px" placeholder="请输入库存"></el-input>
                        </el-form-item>
                     </div>
                    <!-- 多规格-->
                    <div v-if="formData.spec_type==1">
<!--                        <el-form-item size="small" label="选择规格："  >-->
<!--                            <el-select size="small" v-model="formData.category1" placeholder="请选择规格模板" clearable filterable  style="width: 300px">-->
<!--                                <el-option-->
<!--                                        v-for="item in category_list"-->
<!--                                        :key="item.id"-->
<!--                                        :label="item.name"-->
<!--                                        :value="item.id">-->
<!--                                </el-option>-->
<!--                            </el-select>-->
<!--                        </el-form-item>-->
                        <el-form-item size="small" label=""  class="is-required">
                            <el-button size="small" type="primary" @click="addSpec()" v-if="createBnt">添加新规格</el-button>
                            <el-button size="small" type="success" @click="generateSpec()"  v-if="generatenowBnt" style="margin-left:10px">立即生成</el-button>
                        </el-form-item>
                        <div style="display: flex;align-items: center;" v-if="isSpecBtn">
                            <el-form-item size="small" label="规格名：" prop="specName" >
                                <el-input v-model.trim="specName" style="width: 200px" placeholder="请输入规格名"></el-input>
                            </el-form-item>
                            <el-form-item size="small" label="规格值：" prop="specValue" >
                                <el-input v-model.trim="specValue" style="width: 200px" placeholder="请输入规格值"></el-input>
                            </el-form-item>
                            <el-button size="small" type="primary" @click="createSpecName()" style="margin-bottom: 18px;margin-left: 10px;">确定</el-button>
                            <el-button size="small"  @click="cancelAddSpec()" style="margin-bottom: 18px;margin-left: 10px;">取消</el-button>
                        </div>
                        <el-form-item size="small" label="" >
                            <draggable group="guige"  :list="specList" :move="checkMove" @end="end" handle=".move-icon"  :no-transition-on-drag="true" animation="500">
                                <div v-for="(item, index) in specList" :key="index" class="tag-item">
                                    <div class="move-icon">
                                      <span class="el-icon-s-grid"></span>
                                    </div>
                                    <div class="input-item" :class="moveIndex === index ? 'borderStyle' : ''">
                                        <div>
                                            <span >{{ item.value }}</span>
                                            <i class="el-icon-error" @click="deleteSpec(index)"></i>
                                        </div>
                                        <div class="spec-item">
                                            <draggable :list="item.detail" :no-transition-on-drag="true" animation="500">
                                                <el-tag
                                                type="warning"
                                                closable
                                                color="primary"
                                                v-for="(j, indexn) in item.detail"
                                                :key="indexn"
                                                :name="j"
                                                @close="handleRemove2(item.detail, indexn)"
                                                >{{ j }}</el-tag>
                                            </draggable>
                                            <el-input placeholder="请输入属性名称" size="small" v-model="item.detail.attrsVal" style="width: 200px">
                                                <el-button slot="append" style="color: #FFF;background-color: #409EFF;border-color: #409EFF;" @click="addSpecDetail(item.detail.attrsVal,index)" :disabled="!generatenowBnt">添加</el-button>
                                            </el-input>
                                      </div>
                                </div>
                                </div>
                            </draggable>
                            <!-- 多规格表格展示设置-->
                            <!-- 批量设置-->
                            <div class="table" v-if="tableColumnList.tableHeaderList.length>0">
                                <span>批量设置：</span>
                                <el-table :data="manySpecBatchData" border size="mini" style="width: 100%">
                                    <el-table-column prop="price" label="售价" min-width="150">
                                        <template slot-scope="scope">
                                            <el-input-number v-model="scope.row.price" v-limit-positive-number-fixed2 :precision="2" controls-position="right" :min="0" :max="9999999" label="售价" style="width: 100%"></el-input-number>
                                        </template>
                                    </el-table-column>
                                    <el-table-column prop="stock" label="库存" min-width="150">
                                        <template slot-scope="scope">
                                            <el-input-number v-model="scope.row.stock" v-limit-positive-number :precision="0" controls-position="right" :min="0" :max="9999999" label="库存" style="width: 100%"></el-input-number>
                                        </template>
                                    </el-table-column>
                                    <el-table-column label="操作" min-width="100">
                                      <template slot-scope="scope">
                                          <span class="table-operate-btn" @click="batchAdd">批量添加</span>
                                          <span class="table-operate-btn" @click="batchDel">清空</span>
                                      </template>
                                    </el-table-column>
                                </el-table>
                            </div>
                            <!-- 多规格表格-->
                            <div class="table" v-if="tableColumnList.tableBodyList.length>0">
                                <span>商品规格：</span>
                                <el-table :data="tableColumnList.tableBodyList" border size="mini" style="width: 100%">
                                    <el-table-column show-overflow-tooltip :label="item.propName" :property="item.prop" v-for="item in tableColumnList.tableHeaderList" :key="item.prop" min-width="150">
                                        <template slot-scope="scope">
                                          <span>{{ scope.row[scope.column.property] }}</span>
                                        </template>
                                    </el-table-column>
                                    <el-table-column prop="default_image" label="图片" min-width="80">
                                        <template slot-scope="scope">
                                            <el-upload
                                                    class="avatar-uploader"
                                                    action=""
                                                    :show-file-list="false"
                                                    :http-request="imgUploadRequest_sku"
                                                    :on-success="(response, file, fileList)=>imgUploadSuccess_sku(response, file, fileList,scope.$index)"
                                                    :before-upload="imgBeforeUpload_sku">
                                                <img v-if="scope.row.default_image" :src="scope.row.default_image" class="avatar" style="width: 60px;height: 60px;line-height: 60px;">
                                                <i v-else class="el-icon-plus avatar-uploader-icon" style="width: 60px;height: 60px;line-height: 60px;"></i>
                                            </el-upload>
                                        </template>
                                    </el-table-column>
                                    <el-table-column prop="price" label="售价" min-width="150">
                                        <template slot-scope="scope">
                                            <el-input-number v-model="scope.row.price" v-limit-positive-number-fixed2 :precision="2" controls-position="right" :min="0" :max="9999999" label="售价" style="width: 100%"></el-input-number>
                                        </template>
                                    </el-table-column>
                                    <el-table-column prop="stock" label="库存" min-width="150">
                                        <template slot-scope="scope">
                                            <el-input-number v-model="scope.row.stock" v-limit-positive-number :precision="0" controls-position="right" :min="0" :max="9999999" label="库存" style="width: 100%"></el-input-number>
                                        </template>
                                    </el-table-column>
                                    <el-table-column label="操作" min-width="100">
                                      <template slot-scope="scope">
                                          <span class="table-operate-btn" @click="singleSpecDel(scope.$index)" v-if="generatenowBnt">删除</span>
                                          <span class="table-operate-btn" @click="handleEdit(scope.row)" v-if="!generatenowBnt">保存修改</span>
                                      </template>
                                    </el-table-column>
                                </el-table>
                            </div>
                        </el-form-item>
                    </div>

                </el-tab-pane>
                <!-- 商品详情-->
                <el-tab-pane label="商品详情" name="4">
                    <el-form-item label="商品详情：" class="is-required">
                        <div >
                            <TEditor v-model="formData.desc_detail"  v-if="dialogVisible" :lyheight=550></TEditor>
                        </div>
                </el-form-item>
                </el-tab-pane>
            </el-tabs>

        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave" size="medium">取消</el-button>
            <el-button @click="handleStep('back')" v-if="activeName!='1'" size="medium">上一步</el-button>
            <el-button type="primary" @click="handleStep('next')" v-if="activeName!='4'" size="medium">下一步</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave" size="medium">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import TEditor from '@/components/TEditor'
    import vuedraggable from "vuedraggable"
    import {
        mallGoodstype,
        mallGoodsspu,
        mallGoodsspuAdd,
        mallGoodsspuEdit,
        mallGoodsspueEditskups,
        platformsettingsUploadPlatformImg
    } from "@/api/api";
    import {sortName} from '@/utils/util'
    import {url} from '@/api/url'
    export default {
        name: "addModuleGoodsManage",
        components: {
            TEditor,
            draggable: vuedraggable,
        },
        data() {
            return {
                //轮播图
                newData:[],
                newDataAll:[],
                detailDataA:[],
                submitLoading:false,
                isEqual:false,
                pics:[],
                //轮播图结束
                //自定义规格开始
                specList:[],//规格
                specName:'',//要添加的规格名
                specValue:'',//要添加的规格值
                isSpecBtn:false,//是否点击了添加规格
                createBnt: true,//添加规格按钮是否显示
                generatenowBnt:true,//立即生成按钮是否显示
                upload_sku_default_image_res:"",//sku图片上传结果
                moveIndex: "",
                manySpecBatchData:[{
                    price:0,
                    stock:0,
                }],
                tableColumnList: {
                    tableHeaderList: [],
                    tableBodyList: []
                },//表格展示
                //自定义规格结束
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                formData:{
                    name: '',
                    sub_name: '',
                    category1: '',
                    shop_price:0,
                    cost_price:0,
                    market_price:0,
                    price:0,
                    stock: 0,
                    sort:0,
                    default_image:'',
                    is_launched:true,
                    goods_imagelist:[],//轮播图
                    skus:[],//sku/规格
                    spu_specs:[],//spu规格信息
                    spec_type:0,
                    is_tuijian:false,
                    desc_detail:'',
                },
                activeName:'1',
                rules:{
                    name: [
                        {required: true, message: '请输入商品名称',trigger: 'blur'}
                    ],
                    default_image: [
                        {required: true, message: '请上传商品默认图片',trigger: 'blur'}
                    ],
                },
                category_list:[],
            }
        },
        methods:{
            addModuleFn(item,flag) {
                // console.log(item,'item----')
                this.loadingTitle=flag
                this.dialogVisible=true
                this.getMallGoodscategoryList()

                //轮播图开始
                this.pics=[]
                if(item && item.goods_imagelist&&item.goods_imagelist.length >0) {
                    item.goods_imagelist.forEach(items=>{
                        this.pics.push({
                            pic:items.image
                        })
                    })
                }
                //轮播图结束

                if(item){
                    this.formData=item

                    //多规格编辑打开时需要前端数据转换
                    if(item.spec_type){
                        //禁用立即生成和添加规格的按钮
                        this.createBnt = false
                        this.generatenowBnt = false

                        let temp_spu_spec = item.spu_specs
                        let temp_skus = item.skus
                        temp_spu_spec.map((item) => {
                            let temp_spu_spec_options = []
                            item.options.map((item2)=>{
                                temp_spu_spec_options.push(item2.value)
                            })
                            this.specList.push({
                                value:item.name,
                                detail:temp_spu_spec_options
                            })
                            this.tableColumnList.tableHeaderList.push({
                                prop:item.name,
                                propName:item.name,
                            })
                        })
                        temp_skus.map((item3)=>{
                            let temp_table_body_list = {
                                id:item3.id,
                                price:item3.price,
                                stock:item3.stock,
                                default_image:item3.default_image,
                            }
                            item3.specs.map((item4)=>{
                                let temp_sepc_name = item4.spec
                                temp_table_body_list[temp_sepc_name] = item4.option
                            })
                            this.tableColumnList.tableBodyList.push(temp_table_body_list)
                        })
                        // console.log(this.tableColumnList)

                    }

                }

            },
            handleEdit(row){
                const params = {
                    id:row.id,
                    price:row.price,
                    stock:row.stock,
                    default_image:row.default_image,
                }
                let vm = this
                vm.$confirm('确定要修改保存吗？', "警告", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning"
                }).then(function() {
                    return mallGoodsspueEditskups(params).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
            //el-tab上一步下一步
            handleStep(flag){
                if(flag=='next'){
                    if(this.activeName=='1'){
                        this.activeName='2'
                    }
                    else if(this.activeName=='2'){
                        this.activeName='3'
                    }
                    else if(this.activeName=='3'){
                        this.activeName='4'
                    }
                }
                if(flag=='back'){
                    if(this.activeName=='2'){
                        this.activeName='1'
                    }
                    else if(this.activeName=='3'){
                        this.activeName='2'
                    }
                    else if(this.activeName=='4'){
                        this.activeName='3'
                    }
                }
            },
            /*
            * 规格方法自定义开始
            * */
            //清空添加的规格和值得缓存
            clearAttr() {
              this.specName = "";
              this.specValue = "";
            },
            //添加规格
            addSpec(){
                this.clearAttr()
                this.isSpecBtn = true
                this.createBnt = false
            },
            // 取消添加规格
            cancelAddSpec() {
              this.isSpecBtn = false
              this.createBnt = true
            },
            //添加规格属性值
            addSpecDetail(num,index) {
                if(num){
                    if(this.specList[index].detail.includes(this.specList[index].detail.attrsVal)) {
                        this.$message.warning('此属性值已存在~')
                        return
                    }
                // this.specList[index].detail.push(this.specList[index].detail.attrsVal)
                    this.specList[index].detail.push(num);
                    this.specList[index].detail.attrsVal=''
                }else{
                    this.$message.warning("请添加属性");
                }

            },
            // 删除规格
            deleteSpec(index) {
                if(!this.generatenowBnt){
                    return
                }
                this.$confirm('确定删除此规格？').then(_=>{
                    this.specList.splice(index,1)
                }).catch(_=>{

                })
            },
            // 添加规格名称
            createSpecName() {
              if (this.specName && this.specValue) {
                let data = {
                  value: this.specName,
                  detail: [this.specValue],
                };
                this.specList.push(data);
                var hash = {};
                this.specList = this.specList.reduce(function (item, next) {
                  /* eslint-disable */
                  hash[next.value] ? "" : (hash[next.value] = true && item.push(next));
                  return item;
                }, []);
                this.clearAttr()
                this.isSpecBtn = false;
                this.createBnt = true;
              } else {
                this.$message.warning("请添加完整的规格！");
              }
            },
            checkMove(evt) {
              this.moveIndex = evt.draggedContext.index;
            },
            end() {
              this.moveIndex = "";
            },
            // 删除属性
            handleRemove2(item, index) {
                if(!this.generatenowBnt){
                    return
                }
                item.splice(index, 1);
            },
            // 笛卡尔积算法
            cartesianProductOf(array) {
                if (array.length < 2) return array[0] || []
                return [].reduce.call(array, function(col, set) {
                    var res = []
                    col.forEach(function(c) {
                      set.forEach(function(s) {
                        var t = [].concat(Array.isArray(c) ? c : [c])
                        t.push(s)
                        res.push(t)
                      })
                    })
                    return res
                })
            },
            //立即生成规格表
            generateSpec(){
                let clonespecList = this.specList
                if(clonespecList.length<=0){
                    return
                }
                let attrName = [] //规格名数组
                let attrValue = [] //规格值数组[['x','s'],['黑色','白色']]
                for (let key in clonespecList) {
                    attrName.push(clonespecList[key].value)
                    this.$delete(clonespecList[key].detail,'attrsVal')
                    attrValue.push(clonespecList[key].detail)
                }
                // 表格内容数据（笛卡尔积算法）
                let finalArr = this.cartesianProductOf(attrValue)
                let tableObj = {
                  tableBodyList: [],
                  tableHeaderList: []
                }
                // 表格内容(两种及以上规格名的规格)
                if(attrValue.length>1){
                    tableObj.tableBodyList = finalArr.map((item) => {
                          let obj = {
                            price: 0,
                            stock: 0,
                          }
                          for (let i = 0; i < item.length; i++) {
                            obj[attrName[i]] = item[i]
                          }
                          return obj
                        })
                }else{
                    //一种规格名的规格
                    tableObj.tableBodyList = finalArr.map((item) => {
                          let obj = {
                            price: 0,
                            stock: 0,
                          }
                          obj[attrName[0]] = item
                          return obj
                        })
                }
                this.tableColumnList.tableBodyList = tableObj.tableBodyList //表格内容数据
                // 表头
                let skuTableArr = attrName
                tableObj.tableHeaderList = skuTableArr.map((item) => {
                  return {
                    prop: item,
                    propName: item
                  }
                })
                this.tableColumnList.tableHeaderList = tableObj.tableHeaderList // 表头
                // console.log(this.tableColumnList)
                // console.log(this.specList)
            },
            //批量设置-清空
            batchDel() {
              this.manySpecBatchData=[{
                    price:0,
                    stock:0,
                }]
            },
            //批量设置-添加
            batchAdd(){
             for (let val of this.tableColumnList.tableBodyList) {
                    if (this.manySpecBatchData[0].stock) {
                      val.stock = this.manySpecBatchData[0].stock
                    }
                    if (this.manySpecBatchData[0].price > 0) {
                      val.price = this.manySpecBatchData[0].price
                    }
                  }
             },
            //规格表格展示-删除
            singleSpecDel(index){
                let vm = this
                //提示框，判断用户是否操作失误
                this.$confirm('确定要删除吗', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    if(vm.tableColumnList.tableBodyList.length<=1){
                        vm.$message.warning("只有一个不能删除")
                        return
                    }
                    vm.tableColumnList.tableBodyList.splice(index,1)
                    this.$message({
                        type: 'success',
                        message: '删除成功!'
                    })
                }).catch(() => {
                });
            },
            //sku图片上传
            imgBeforeUpload_sku(file) {
                const isJPG = file.type === 'image/jpeg' || file.type === 'image/png';
                if (!isJPG) {
                    this.$message.error('图片只能是 JPG/PNG 格式!');
                    return false
                }
                return isJPG;
            },
            async imgUploadRequest_sku(param) {
                var vm = this
                let res= await platformsettingsUploadPlatformImg(param)
                if(res.code == 2000) {
                    vm.upload_sku_default_image_res = res.data.data[0]
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess_sku(response,file,fileList,index) {
                // 设置（更新）对应行文件图片
                this.$set(this.tableColumnList.tableBodyList[index],"default_image",this.upload_sku_default_image_res)
            },
            /*
            * 规格方法自定义结束
            * */
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.clearAttr()
                this.formData={
                    name: '',
                    sub_name: '',
                    category1: '',
                    shop_price:0,
                    cost_price:0,
                    market_price:0,
                    stock: 0,
                    default_image:'',
                    is_launched:true,
                    goods_imagelist:[],
                    spec_type:0,
                    sort:0,
                    is_tuijian:false,
                    desc_detail:'',
                },
                this.activeName='1'
                this.category_list=[]
                this.specList=[]
                this.manySpecBatchData=[{
                    price:0,
                    stock:0,
                }]
                this.tableColumnList={
                    tableHeaderList: [],
                    tableBodyList: []
                }//表格展示
                this.isSpecBtn=false//是否点击了添加规格
                this.createBnt=true//添加规格按钮是否显示
                this.generatenowBnt=true//立即生成按钮是否显示
                this.$emit('refreshData')
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        let param = {
                            ...this.formData
                        }
                        param.is_launched==param.is_launched?1:0

                        //轮播图开始
                        if(this.pics.length <1) {
                            this.$message.warning('请先上传商品轮播图~')
                            return
                        }
                        let picList = []
                        this.pics.forEach(item=>{
                            let res = {}
                            res = {
                                image:item.pic,
                            }
                            picList.push(res)
                        })
                        param.goods_imagelist=picList
                        //轮播图结束

                        param.sub_name = param.name
                        delete(param.category1_name)

                        this.loadingSave=true
                        if(this.formData.id){
                            mallGoodsspuEdit(param).then(res=>{
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
                            if(this.formData.spec_type===0){
                                if(this.formData.shop_price<=0){
                                    this.$message.warning("商品规格价格要大于0")
                                    this.loadingSave=false
                                    return
                                }
                                if(this.formData.stock<=0){
                                    this.$message.warning("商品规格库存要大于0")
                                    this.loadingSave=false
                                    return
                                }
                                //单规格
                                let skus = []
                                skus.push({
                                    price:this.formData.shop_price,
                                    stock:this.formData.stock,
                                    default_image:this.formData.default_image,
                                })
                                param.skus = skus
                                param.price = this.formData.shop_price
                            }else{
                                //多规格
                                //规格sku数据处理
                                let skus = []
                                let spu_specs = []
                                let minprice=0
                                this.tableColumnList.tableBodyList.map((item) => {
                                    if(item.price<minprice){
                                        minprice = item.price
                                    }
                                    let sepcs = []
                                    if(item.price<=0){
                                        this.$message.warning("商品规格价格要大于0")
                                        this.loadingSave=false
                                        return
                                    }
                                    if(item.stock<=0){
                                        this.$message.warning("商品规格库存要大于0")
                                        this.loadingSave=false
                                        return
                                    }
                                    if(!item.default_image){
                                        this.$message.warning("SKU商品图片未上传")
                                        this.loadingSave=false
                                        return
                                    }
                                    let tempsku = {
                                        price:item.price,
                                        shop_price:item.price,
                                        stock:item.stock,
                                        default_image:item.default_image,
                                    }
                                    for (var i in item) {
                                        if(i!='price' && i!='stock'&& i!='default_image'){
                                            sepcs.push({
                                                option:item[i],
                                                spec:i,
                                        })
                                        }
                                    }
                                    tempsku.specs = sepcs
                                    skus.push(tempsku)
                                })
                                this.specList.map((item) => {
                                    this.$delete(item.detail,'attrsVal')
                                    let options = []
                                    item.detail.map((item2) =>{
                                            options.push({
                                                value:item2
                                            })
                                        }
                                    )
                                    spu_specs.push({
                                        name:item.value,
                                        options:options,
                                    })
                                })
                                if(skus.length<1){
                                    this.loadingSave=false
                                    this.$message.warning("请点击立即生成")
                                    return;
                                }
                                param.skus = skus
                                param.spu_specs = spu_specs
                                param.price = minprice

                            }
                            mallGoodsspuAdd(param).then(res=>{
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
                        this.loadingSave=false
                    }
                })
            },

            imgBeforeUpload(file) {
                const isJPG = file.type === 'image/jpeg' || file.type === 'image/png';
                if (!isJPG) {
                    this.$message.error('图片只能是 JPG/PNG 格式!');
                    return false
                }
                return isJPG;
            },
            async imgUploadRequest(param) {
                var vm = this
                let res= await platformsettingsUploadPlatformImg(param)
                if(res.code == 2000) {
                    vm.formData.default_image = res.data.data[0]
                } else {
                    vm.$message.warning(res.msg)
                }
            },
            imgUploadSuccess(res) {
                if (res) {
                    this.formData.default_image = res.url
                }
            },
            //获取商品分类列表
            getMallGoodscategoryList(){
                let param = {
                    page: 1,
                    limit: 9999999,
                }
                mallGoodstype(param).then(res => {
                    if(res.code ==2000) {
                        this.category_list = res.data.data
                    }
                })
            },
            // 上传轮播图片
            async changesData () {
                let vm = this
                vm.detailDataA = []
                let aList = vm.$refs.file.files
                let _aList = []
                for (let i in aList) {
                    _aList.push(aList[i]);
                }
                let filterList=[]
                let flag = 0
                _aList=_aList.filter(item=> typeof item == 'object')
                _aList.forEach((item,index)=>{
                    if( typeof item == 'object') {
                        var reader = new FileReader();
                        reader.readAsDataURL(item);
                        reader.onload = function (e) { //让页面中的img标签的src指向读取的路径
                            var img = new Image()
                            img.crossOrigin = 'anonymous'
                            img.src= e.target.result
                            img.onload=function () {
                                var height = img.naturalHeight;
                                var width = img.naturalWidth;
                                let name = item.name.substring(0,item.name.lastIndexOf("."))
                                /*if(width != 750) {
                                    vm.$message.warning(`${name}的宽度不是750`)
                                    return false
                                } else {*/
                                filterList.push(item)
                                // }
                                flag=index
                                if(flag==_aList.length-1) {
                                    vm.uploadImg(filterList)
                                }
                            }
                        }
                    }
                })
            },
            uploadImg(filterList) {
                let vm = this
                if(filterList.length >0) {
                    // vm.pics=[]
                    // vm.newData = _aList && _aList.filter(item => (item.type== 'image/jpeg' || item.type =='image/png'))
                    vm.newData = filterList && filterList.filter(item => (item.type == 'image/jpeg' || item.type == 'image/png'))
                    /*console.log(vm.newData, 'vm.newData------')
                    console.log(vm.$refs.file, 'vm.$refs.file-----mmmm')*/
                    if (vm.$refs.file) {
                        vm.$refs.file.value = null; // 避免连续点击相同文件上传的bug
                    }
                    let _length = 9 - vm.pics.length
                    if (vm.newData.length > _length) {
                        vm.$confirm(`最多只能再上传${_length}张照片，是否确定提交`, `提示`, {
                            confirmButtonText: '是',
                            cancelButtonText: '否',
                            type: 'warning'
                        }).then(() => {
                            vm.newData = vm.newData.slice(0, _length)
                            if (vm.newData.length > 9) {
                                vm.$message.warning('最大可上传9张图片')
                                return false
                            }
                            if (vm.newData.length > 0) {
                                vm.uploadImgLoadingFlag = true
                                vm.submitLoading = true
                                vm.getImgList(vm.newData)
                            }
                        }).catch(() => {
                            vm.newData = []
                            vm.detailDataA = []
                            vm.submitLoading = false
                            return false
                        })


                    } else {
                        if (vm.newData.length > 9) {
                            vm.$message.warning('最大可上传9张图片')
                            return false
                        }
                        if (vm.newData.length > 0) {
                            vm.uploadImgLoadingFlag = true
                            vm.submitLoading = true
                            vm.getImgList(vm.newData)
                        }
                    }
                }
            },

            getImgList(param) {
                let vm = this
                for (let i =0 ; i< param.length; i++) {
                    vm.topImageUploadRequest(param[i], i)
                }
            },
            topImageUploadRequest(option, index) {
                let vm = this
                //console.log(option,'option-----')

                option = {
                    action: "https://jsonplaceholder.typicode.com/posts/",
                    path: '/',    // 上传图片时指定的地址路径，类似form变淡的action属性
                    onSuccess: function (res) {    // 上传成功后执行的方法，res是接收的ajax响应内容
                        // console.log(res);
                    },
                    onFailure: function (res) {    // 上传失败后执行的方法，res是接收的ajax响应内容
                        // console.log(res);
                    },
                    file: option
                }
                platformsettingsUploadPlatformImg(option).then(obj=>{
                    let res={}
                    res = {
                        url:obj.data.data[0],
                        name:obj.data.data[0].split("/")[obj.data.data[0].split("/").length-1]
                    }

                    let img = new Image()
                    img.crossOrigin = 'anonymous'
                    img.src = res.url;
                    img.onload = function () {
                        var height = img.naturalHeight;
                        var width = img.naturalWidth;
                        let type = res.name.substr(res.name.lastIndexOf("."))
                        res.name = res.name.substr(0, res.name.indexOf(type))
                        let img1 = {
                            pic: res.url,
                            name: res.name,
                            index: vm.pics.length,
                            height: height
                        }
                        vm.pics.push(img1)
                        vm.pics.sort(vm.compare("index"))
                        vm.detailDataA.push({
                            pic: res.url,
                            name: res.name,
                        })
                        vm.pics.sort((a1, a2) => {
                            return sortName(a1.name, a2.name)
                        });
                        // vm.compareImg()
                        vm.detailDataA.sort((a1, a2) => {
                            return sortName(a1.name, a2.name)
                        });
                        vm.newData = []
                        vm.detailDataA = []
                        vm.submitLoading = false
                        vm.uploadImgLoadingFlag = false
                    }
                })
                if(index === vm.newData.length-1) {
                    vm.uploadImgLoadingFlag = false
                    vm.submitLoading = false
                }
            },

            compareImg() {
                let vm = this
                if(vm.pics.length > 1) {
                    let isEqual = vm.pics.filter(item=>item.height!=vm.pics[0].height)
                    vm.isEqual = isEqual.length >0
                }else {
                    vm.isEqual  = false
                }
            },
            compare(property) {
                return function(a,b) {
                    var value1 = a[property];
                    var value2 = b[property];
                    return value1 - value2
                }
            },
            changeLf: function(e) {
                this.pics.splice(e, 1, ...this.pics.splice(e - 1, 1, this.pics[e]));
            },
            changeRg: function(e) {
                this.pics.splice(e + 1, 1, ...this.pics.splice(e, 1, this.pics[e + 1]));
            },
            // 删除图片
            deletePhoto(index) {
                this.$confirm('确定要删除该照片', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.$message({
                        type: 'success',
                        message: '删除成功!'
                    })
                    this.pics = this.pics.slice(0, index).concat(this.pics.slice(index + 1, this.pics.length))
                    this.detailDataA = []
                    this.newData = []
                    // this.compareImg(true)
                }).catch(() => {
                });
            },

            // 清空图片
            clearPhotoData(id) {
                let _vm = this
                _vm.$confirm('确定要清空该组照片', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    _vm.detailDataA = []
                    _vm.newData = []
                    _vm.pics=[]
                    _vm.editForm.detail=[]
                    _vm.$message({
                        type: 'success',
                        message: '清空成功!'
                    });
                }).catch(() => {
                });
            },
            // 上传轮播图片结束

        },
        mounted(){
        }
    }
</script>
<style lang="scss" scoped>
    .add-specs-inner{
        padding: 10px;
        background: #fffcfc;
        border: 1px solid #e0e0e0;
        .tips{
            font-size: 12px;
            color: #999999;
        }
        .add-specs-item{
            display: flex;
            align-items: center;
            .name{
                width: 60px;
                font-size: 12px;
            }
        }
    }
    .uploadImg{
        display: flex;
        line-height: 36px;
        font-size: 14px;
        .photoNum{
            font-weight: bold;
            em{
                font-style: normal;
                color: #ff0000;
            }
        }
        .input-fileup{
            width: 120px;
            height: 36px;
            line-height: 36px;
            text-align: center;
            overflow: hidden;
            position: relative;
            background: #409EFF;
            color: #ffffff;
            border: 1px solid #dcdfe6;
            text-decoration: none;
            display: block;
            margin: 0 15px 0 5px;
            border-radius: 3px;
            /*color: #666666;*/
            input{
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                opacity: 0;
                cursor: pointer;
            }
        }
    }

    .pickAlbumPreListO{
        width: 100%;
        background: #f1f1f1;
        /*height: 224px;*/
        .tipsCon{
            text-align: center;
            color: #999999;
        }
    }
    .pickAlbumPreList {
        display: table;
        margin: 0;
        padding: 0;
        /*height: 174px;*/
        li {
            width: 110px;
            padding: 10px;
            box-sizing: border-box;
            /*height: 140px;*/
            display: block;
            float: left;
            margin: 5px;
            position: relative;
            font-size: 12px;
            text-align: center;
            img,.el-image {
                display: block;
                width: 90px;
                height: 90px;
                border: 1px solid #d6d6d6;
            }
            i.el-icon-close{
                display: none;
                position: absolute;
                right: 0;
                top: 0;
                background: #409eff;
                color: #ffffff;
                font-size: 20px;
                cursor: pointer;
            }
            .btnchang{
                display: flex;
                margin-top: 10px;
                align-items: center;
                align-content: center;
            }
            .sizeImg{
                color: #ff0000;
            }
            button{
                width: 40px;
                margin: 0 auto;
                padding: 0;
                height: 28px;
            }
            &:hover i.el-icon-close{
                display: block;
            }
            i.el-icon-picture{
                width: 90px;
                height: 90px;
                display: block;
                text-align: center;
                line-height: 90px;
                border: 1px solid #e1e1e1;
                font-size: 20px;
                border-radius: 4px;
                background: #fff;
            }
        }
    }
    // 规格样式
    .tag-item{
        display: flex;
        flex-direction: row;
        column-gap: 10px;
        background: #f1f1f1;
        padding: 8px;
        margin-bottom: 10px;
        .el-icon-s-grid{
            color: #e6ddd8;
            font-size: 32px;
            cursor: move;
        }
        .input-item{
            flex: 1;
            display: flex;
            flex-direction: column;
            column-gap: 10px;
            .el-icon-error{
                font-size: 16px;
                color: #000000;
                cursor: pointer;
            }
            .spec-item{
                flex: 1;
                display: flex;
                flex-direction: row;
                align-items: center;
                column-gap: 10px;

            }
        }
    }
</style>

<template>
    <div>
        <ly-dialog v-model="dialogVisible" :title="loadingTitle" width="70%" top="2%"  :before-close="handleClose" class="form-dialog">
            <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="auto" class="form-data">
                <div class="form-data-item">
                <div class="form-title">基础信息</div>
                        <div style="display: flex;align-items: center;">
                            <el-form-item label="商品分类：" prop="category1">
                            <el-select v-model="formData.category1" placeholder="请选择分类" clearable filterable  style="width: 300px">
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
                            <el-input v-model.trim="formData.name" placeholder="请输入商品名称" style="width: 300px"></el-input>
                        </el-form-item>
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
                    </div>
                 <div class="form-data-item">
                    <div class="form-title">商品图片</div>
                        <el-form-item label="商品缩略图：" prop="default_image" style="padding: 10px">
                            <el-upload
                                    ref="lyimagupload"
                                    class="avatar-uploader"
                                    :limit="1"
                                    action=""
                                    :show-file-list="false"
                                    :http-request="imgUploadRequest"
                                    :on-success="imgUploadSuccess"
                                    :before-upload="imgBeforeUpload">
                                <img v-if="formData.default_image" :src="formData.default_image" class="avatar">
                                 <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
                            </el-upload>
                        </el-form-item>
                        <el-form-item label="商品轮播图：" style="padding: 10px">
                            <ly-upload-goods v-model="pics"></ly-upload-goods>
                        </el-form-item>
                    </div>
                <div class="form-data-item">
                    <div class="form-title">规格配置</div>
                        <el-form-item label="商品规格：" prop="spec_type">
                            <el-radio-group v-model="formData.spec_type" style="width: 380px">
                                <el-radio :label="0">单规格</el-radio>
                                <el-radio :label="1">多规格</el-radio>
                            </el-radio-group>
                        </el-form-item>
                        <!-- 单规格-->
                        <div v-if="formData.spec_type==0">
                            <el-form-item label="商品价格：" prop="price" class="is-required">
                                <el-input-number v-model="formData.price" :precision="2" style="width: 300px" placeholder="请输入商品价格"></el-input-number>
                            </el-form-item>
                            <el-form-item label="库存：" prop="stock" class="is-required">
                                <el-input-number v-model="formData.stock" style="width: 300px" placeholder="请输入库存"></el-input-number>
                            </el-form-item>
                         </div>
                        <!-- 多规格-->
                        <div v-if="formData.spec_type==1">
    <!--                        <el-form-item  label="选择规格："  >-->
    <!--                            <el-select  v-model="formData.category1" placeholder="请选择规格模板" clearable filterable  style="width: 300px">-->
    <!--                                <el-option-->
    <!--                                        v-for="item in category_list"-->
    <!--                                        :key="item.id"-->
    <!--                                        :label="item.name"-->
    <!--                                        :value="item.id">-->
    <!--                                </el-option>-->
    <!--                            </el-select>-->
    <!--                        </el-form-item>-->
                            <el-form-item  label=""  class="is-required">
                                <el-button  type="primary" @click="addSpec()" v-if="createBnt">添加新规格</el-button>
                                <el-button  type="success" @click="generateSpec()"  v-if="generatenowBnt" style="margin-left:10px">立即生成</el-button>
                            </el-form-item>
                            <div style="display: flex;align-items: center;" v-if="isSpecBtn">
                                <el-form-item  label="规格名：" prop="specName" >
                                    <el-input v-model.trim="specName" style="width: 200px" placeholder="请输入规格名"></el-input>
                                </el-form-item>
                                <el-form-item label="规格值：" prop="specValue" >
                                    <el-input v-model.trim="specValue" style="width: 200px" placeholder="请输入规格值"></el-input>
                                </el-form-item>
                                <el-button type="primary" @click="createSpecName()" style="margin-bottom: 18px;margin-left: 10px;">确定</el-button>
                                <el-button   @click="cancelAddSpec()" style="margin-bottom: 18px;margin-left: 10px;">取消</el-button>
                            </div>
                            <el-form-item  label="" style="padding-right: 10px">
                                <div style="width: 100%">
                                    <draggable group="guige" :list="specList" :move="checkMove" @end="end" handle=".move-icon"  animation="500" item-key="value">
                                        <template #item="{ element,index}">
                                            <div class="tag-item">
                                                <div class="move-icon">
                                                  <span class="el-icon-s-grid"><el-icon><Grid /></el-icon></span>
                                                </div>
                                                <div class="input-item" :class="moveIndex === index ? 'borderStyle' : ''">
                                                    <div>
                                                        <span >{{ element.value }}</span>
                                                        <i class="el-icon-error" @click="deleteSpec(index)"><el-icon><CircleCloseFilled /></el-icon></i>

                                                    </div>
                                                    <div class="spec-item">
                                                        <el-tag
                                                        type="warning"
                                                        size="large"
                                                        closable
                                                        color="primary"
                                                        v-for="(j, indexn) in element.detail"
                                                        :key="indexn"
                                                        :name="j"
                                                        @close="handleRemove2(element.detail, indexn)"
                                                        >{{ j }}</el-tag>
                                                        <el-input placeholder="请输入属性名称"  v-model="element.detail.attrsVal" style="width: 200px">
                                                            <template #append>
                                                                <el-button style="color: #FFF;background-color: #409EFF;border-color: #409EFF;" @click="addSpecDetail(element.detail.attrsVal,index)" :disabled="!generatenowBnt">添加</el-button>
                                                            </template>
                                                        </el-input>
                                                    </div>
                                                </div>
                                            </div>
                                        </template>
                                    </draggable>
                                </div>
                                <!-- 多规格表格展示设置-->
                                <!-- 批量设置-->
                                <div style="width: 100%">
                                    <div class="table" v-if="tableColumnList.tableHeaderList.length>0">
                                        <span>批量设置：</span>
                                        <el-table :data="manySpecBatchData" border style="width: 100%">
                                            <el-table-column prop="price" label="售价" min-width="140">
                                                <template #default="scope">
                                                    <el-input-number v-model="scope.row.price" v-limit-positive-number-fixed2 :precision="2" controls-position="right" :min="0" :max="9999999" label="售价" style="width: 100%"></el-input-number>
                                                </template>
                                            </el-table-column>
                                            <el-table-column prop="stock" label="库存" min-width="140">
                                                <template #default="scope">
                                                    <el-input-number v-model="scope.row.stock" v-limit-positive-number :precision="0" controls-position="right" :min="0" :max="9999999" label="库存" style="width: 100%"></el-input-number>
                                                </template>
                                            </el-table-column>
                                            <el-table-column label="操作" min-width="160">
                                              <template #default="scope">
                                                  <span class="table-operate-btn" @click="batchAdd">批量添加</span>
                                                  <span class="table-operate-btn" @click="batchDel">清空</span>
                                              </template>
                                            </el-table-column>
                                        </el-table>
                                    </div>
                                    <!-- 多规格表格-->
                                    <div class="table" v-if="tableColumnList.tableBodyList.length>0">
                                        <span>商品规格：</span>
                                        <el-table :data="tableColumnList.tableBodyList" border  style="width: 100%">
                                            <el-table-column show-overflow-tooltip :label="item.propName" :property="item.prop" v-for="item in tableColumnList.tableHeaderList" :key="item.prop" min-width="150">
                                                <template #default="scope">
                                                  <span>{{ scope.row[scope.column.property] }}</span>
                                                </template>
                                            </el-table-column>
                                            <el-table-column prop="default_image" label="图片" min-width="80">
                                                <template #default="scope">
                                                    <el-upload
                                                            class="avatar-uploader"
                                                            action=""
                                                            :show-file-list="false"
                                                            :http-request="imgUploadRequest_sku"
                                                            :on-success="(response, file, fileList)=>imgUploadSuccess_sku(response, file, fileList,scope.$index)"
                                                            :before-upload="imgBeforeUpload_sku">
                                                        <img v-if="scope.row.default_image" :src="scope.row.default_image" class="avatar" style="width: 60px;height: 60px;line-height: 60px;">
                                                        <i v-else class="el-icon-plus avatar-uploader-icon" style="width: 60px;height: 60px;line-height: 60px;"><el-icon><Plus /></el-icon></i>
                                                    </el-upload>
                                                </template>
                                            </el-table-column>
                                            <el-table-column prop="price" label="售价" min-width="150">
                                                <template #default="scope">
                                                    <el-input-number v-model="scope.row.price" :precision="2" controls-position="right" :min="0" :max="9999999" label="售价" style="width: 100%"></el-input-number>
                                                </template>
                                            </el-table-column>
                                            <el-table-column prop="stock" label="库存" min-width="150">
                                                <template #default="scope">
                                                    <el-input-number v-model="scope.row.stock" :precision="0" controls-position="right" :min="0" :max="9999999" label="库存" style="width: 100%"></el-input-number>
                                                </template>
                                            </el-table-column>
                                            <el-table-column label="操作" min-width="100">
                                              <template #default="scope">
                                                  <span class="table-operate-btn" @click="singleSpecDel(scope.$index)" v-if="generatenowBnt">删除</span>
                                                  <span class="table-operate-btn" @click="handleEdit(scope.row)" v-if="!generatenowBnt">保存修改</span>
                                              </template>
                                            </el-table-column>
                                        </el-table>
                                    </div>
                                </div>
                            </el-form-item>
                        </div>
                    </div>
                    <div class="form-data-item">
                        <div class="form-title">商品详情</div>
                        <el-form-item label="商品详情：" class="is-required" style="padding-right: 10px">
                            <TEditor v-model="formData.desc_detail"  v-if="dialogVisible" :lyheight=550></TEditor>
                        </el-form-item>
                    </div>

            </el-form>
            <template #footer>
                <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
                <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>
            </template>
        </ly-dialog>
    </div>
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
    import LyDialog from "../../../components/dialog/dialog";
    import LyUploadGoods from "../../../components/upload/goods";
    export default {
        emits: ['refreshData'],
        name: "addModuleGoodsManage",
        components: {
            LyUploadGoods,
            LyDialog,
            TEditor,
            draggable: vuedraggable,
        },
        data() {
            return {
                pics:[],
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
                    price:0,
                    stock: 0,
                    sort:0,
                    default_image:'',
                    is_launched:true,
                    image_list:[],//轮播图
                    skus:[],//sku/规格
                    spu_specs:[],//spu规格信息
                    spec_type:0,
                    is_tuijian:false,
                    desc_detail:'',
                },
                activeName:'1',
                rules:{
                    category1: [
                        {required: true, message: '请选择商品分类',trigger: 'blur'}
                    ],
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
        mounted() {
            window.addEventListener("focusin", this.onFocusIn,true);
        },
        unmounted() {
            window.removeEventListener("focusin", this.onFocusIn);
        },
        methods:{
            onFocusIn(e){
                e.stopImmediatePropagation()//阻止当前和后面的一系列事件
            },
            addModuleFn(item,flag,categoryList) {
                this.loadingTitle=flag
                this.dialogVisible=true
                // this.getMallGoodscategoryList()
                this.category_list = categoryList
                if(item){
                    this.formData = item
                    //轮播图开始
                    this.pics=[]
                    if(item && item.image_list&&item.image_list.length >0) {
                        item.image_list.forEach(items=>{
                            this.pics.push({
                                pic:items
                            })
                        })
                    }
                    //轮播图结束
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
               let isSame = false
              if (this.specName && this.specValue) {
                let data = {
                  value: this.specName,
                  detail: [this.specValue],
                };
                for(var i=0;i<this.specList.length;i++){
                    if(this.specList[i].value == this.specName){
                        isSame = true
                        break
                    }
                }
                if(isSame){
                    this.$message.warning("已存在该规格请添加其他规格！");
                    return
                }
                this.specList.push(data);
                var hash = {};
                // this.specList = this.specList.reduce(function (item, next) {
                //   /* eslint-disable */
                //   hash[next.value] ? "" : (hash[next.value] = true && item.push(next));
                //   return item;
                // }, []);
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
                    delete(clonespecList[key].detail,'attrsVal')
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
                this.tableColumnList.tableBodyList[index].default_image = this.upload_sku_default_image_res
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
                    price:0,
                    stock: 0,
                    default_image:'',
                    is_launched:true,
                    image_list:[],
                    spec_type:0,
                    sort:0,
                    is_tuijian:false,
                    desc_detail:'',
                },
                this.activeName='1'
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
                            picList.push(item.pic)
                        })
                        param.image_list=picList
                        //轮播图结束

                        param.sub_name = param.name
                        delete(param.category1_name)
                        // param.image_list= JSON.stringify(param.image_list)
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
                                if(this.formData.price<=0){
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
                                    price:this.formData.price,
                                    stock:this.formData.stock,
                                    default_image:this.formData.default_image,
                                })
                                param.skus = skus
                                param.price = this.formData.price
                            }else{
                                //多规格
                                //规格sku数据处理
                                let skus = []
                                let spu_specs = []
                                let minprice=0
                                let errormsg = "";
                                let that = this;
                                let thetemptabledata = that.tableColumnList.tableBodyList
                                for(var s=0;s< thetemptabledata.length;s++){
                                    let item = thetemptabledata[s]
                                    let sepcs = []
                                    if(item.price<=0){
                                        errormsg="商品规格价格要大于0"
                                        that.loadingSave=false
                                        break
                                    }
                                    // if(item.stock<=0){
                                    //     errormsg="商品规格库存要大于0"
                                    //     this.loadingSave=false
                                    //     return
                                    // }
                                    if(item.default_image==""){
                                        errormsg="SKU商品图片未上传"
                                        that.loadingSave=false
                                        break
                                    }
                                    let tempsku = {
                                        price:item.price,
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
                                }
                                if(errormsg !=""){
                                    this.loadingSave=false
                                    this.$message.warning(errormsg)
                                    return;
                                };
                                (async function() {
                                    that.specList.map((item) => {
                                        delete(item.detail,'attrsVal')
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
                                })();

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
            imgUploadSuccess(response,file,fileList) {
               this.$refs.lyimagupload.clearFiles()
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

        },
    }
</script>
<style lang="scss" scoped>
    /*::v-deep(.el-dialog__body) {*/
    /*    padding: 0 30px !important;*/
    /*}*/
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
                font-size: 14px;
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
    .avatar-uploader .el-upload {
      border: 1px dashed #d9d9d9;
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
    }
    .avatar-uploader .el-upload:hover {
      border-color: #409EFF;
    }
    .avatar-uploader-icon {
      font-size: 28px;
      color: #8c939d;
      width: 128px;
      height: 128px;
      line-height: 128px;
      text-align: center;
    }
    .avatar {
      width: 128px;
      height: 128px;
      display: block;
    }
    .form-data {
        height: calc(100vh - 200px);
        overflow-y: auto;
        border: 1px solid  #b3d8ff;
        .form-title{
            color: #409eff;
            background: #ecf5ff;
            padding: 10px;
            margin-bottom: 20px;
        }
    }
</style>

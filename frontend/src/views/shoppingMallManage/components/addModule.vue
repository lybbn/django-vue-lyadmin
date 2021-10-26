<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="1000px"
            center
            top="3%"
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <div style="display: flex;align-items: center;">
                <el-form-item label="分类：" prop="category_id" class="is-required">
                <el-select size="small" v-model="formData.category_id" placeholder="请选择" clearable @change="handlecategoryselected(formData.category_id)">
                    <el-option
                            v-for="item in category_list"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                    </el-option>
                </el-select>
                </el-form-item>
                <el-form-item label="上下架：" prop="is_launched">
                    <el-switch
                            v-model="formData.is_launched"
                            active-color="#13ce66"
                            inactive-color="#ff4949">
                    </el-switch>
                </el-form-item>
            </div>

            <el-form-item label="商品SPU:" prop="spu_id">
                <el-select v-model="formData.spu_id" size="small" @change="handlespuselected(formData.spu_id)">
                    <el-option
                            v-for="item in goods_list"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id"
                    >
                    </el-option>
                </el-select>
                <el-input v-model.trim="spuName" style="width:180px;margin-left: 5px" size="small" placeholder="输入名称，新建spu"></el-input>
                <el-button type="primary" size="small" style="margin-left: 5px" @click="getSpu" >添加</el-button>
            </el-form-item>

            <div style="background: rgb(241, 241, 241); display: table; width: 100%; padding-top: 10px; margin-bottom: 20px;" v-if="formData.spu_id" class="set-specs">
                <el-form-item label="规格：" style="margin-bottom: 10px">
                    <div v-for="(item,index) in specs_list" :key="item.id" style="width: 100%;display: flex">
                        <span style="width: 140px;text-align: right">{{item.name+'：'}}</span>
                        <el-select v-model="formData.specs[item.id]" size="small" @change="getSpecId">
                            <el-option
                                    v-for="opt in item.options"
                                    :key="opt.id"
                                    :label="opt.value"
                                    :value="opt.id"
                            >
                            </el-option>
                        </el-select>
                        <el-input v-model.trim="specsName[index]" style="width:180px;margin-left: 5px" size="small" placeholder="输入名称，新建规格值" @change="getSpecs(item.id,index)"></el-input>
                    </div>
                    <el-button size="small" type="primary" plain @click="addSpecs" v-if="specs_list.length<2" style="margin-left:5px">新建规格</el-button>
                </el-form-item>

                <el-form-item label="" v-if="addSpecsFlag">
                    <div class="add-specs-inner">
                        <div class="add-specs-item">
                            <span class="name">规格名称</span> <el-input v-model.trim="specsKey" maxlength="8" size="small" style="width: 150px" placehoder="8个字以内"></el-input>
                        </div>
                        <div class="add-specs-item">
                            <span class="name">规格值</span>
                            <div class="tips">根据填写的规格名称来添加规格（如规格名称为：尺寸，则值可以是：大，中，小）</div>
                        </div>
                        <div class="add-specs-item">
                            <span class="name"></span>

                            <el-tag
                                    :key="tag"
                                    v-for="tag in dynamicTags"
                                    closable
                                    :disable-transitions="false"
                                    @close="closeTag(tag)">
                                {{tag}}
                            </el-tag>
                            <el-input
                                    class="input-new-tag"
                                    v-if="inputVisible"
                                    v-model="inputValue"
                                    ref="saveTagInput"
                                    size="small"
                                    @keyup.enter.native="handleInputConfirm"
                                    @blur="handleInputConfirm"
                            >
                            </el-input>

                            <el-button v-else class="button-new-tag" size="small" @click="showInput" type="warning">添加</el-button>
                        </div>
                        <div class="add-specs-item" style="justify-content: center; margin-top: 20px;">
                            <el-button size="small" type="primary" @click="submitSpecs">确定</el-button>
                            <el-button size="small" @click="closeSpecs">取消</el-button>
                        </div>
                    </div>

                </el-form-item>

            </div>


            <el-form-item label="封面图：" prop="default_image">
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
            <div style="display: flex;align-items: center;">
               <el-form-item label="商品名称：" prop="name">
                    <el-input v-model.trim="formData.name" style="width: 300px"></el-input>
                </el-form-item>
                <el-form-item label="商品简介：" prop="caption">
                    <el-input type="text" v-model.trim="formData.caption" style="width: 300px"></el-input>
                </el-form-item>
            </div>
            <div style="display: flex;align-items: center;">
                <el-form-item label="所需积分：" prop="price">
                    <el-input v-model.trim="formData.price" style="width: 300px"></el-input>
                </el-form-item>
                <el-form-item label="库存：" prop="stock">
                    <el-input v-model.trim="formData.stock" style="width: 300px"></el-input>
                </el-form-item>
            </div>


            <!--<el-form-item label="商品图片：">
                <el-upload
                        class="avatar-uploader"
                        action=""
                        :show-file-list="false"
                        :http-request="imgUploadRequest1"
                        :on-success="imgUploadSuccess1"
                        :before-upload="imgBeforeUpload1">
                    <img v-if="formData.p_image" :src="formData.p_image" class="avatar">
                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
            </el-form-item>-->


            <el-form-item label="商品图片：" style="margin-bottom: 0" class="is-required">
                <div class="uploadImg" style="display: block">
                    <div style="width: 100%;display: flex">
                        <div class="input-file input-fileup">
                            <span style="display: inline-block; width: 100%;">{{submitLoading || (newData.length > 0 && detailDataA.length !== newData.length) ? '' : '上传商品图片'}}</span>
                            <el-button style="width: 100%;height:36px" size="small" type="primary" v-if="submitLoading || (newData.length > 0 && detailDataA.length !== newData.length)"  :loading="submitLoading || (newData.length > 0 && detailDataA.length !== newData.length)">上传商品图片</el-button>
                            <input ref="file" title="请以文件夹的形式上传"  class="fileUploaderClass" type='file' multiple name="file" v-else @change.stop="changesData"/>
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
                            <el-image :src="item.pic" fit="contain"></el-image>
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
                    <div class="tipsCon">（左移/右移，可以调整产品图片前端展示顺序）</div>
                    <div class="tipsCon" style="color:#ff0000" v-if="isEqual">上传图片的高度，要求一致！</div>
                </div>
            </el-form-item>


            <el-form-item label="商品详情：" class="is-required">
                <!--<el-input type="textarea"  v-model.trim="formData.spu.desc_detail" style="width: 300px"></el-input>-->
                <div class="messageTxt">
                    <quill-editor ref="myQuillEditor" v-model="formData.spu.desc_detail" :options="editorOptions">
                    </quill-editor>
                </div>
            </el-form-item>
        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import 'quill/dist/quill.core.css'
    import 'quill/dist/quill.snow.css'
    import 'quill/dist/quill.bubble.css'
    import quillConfig from '@/utils/quill-config.js'
    import {
        mallGoodscategory,
        mallGoodspu,
        mallGoodspuspec,
        mallGoodspuallspecbyid,
        mallGoodspuAdd,
        mallgoodspuspec,
        mallCreatespuspecandpotionsAdd,
        mallgoodspuspecoptionAdd,
        mallUploadgoodsimg,
        mallgoodskuAdd,
        mallgoodskuEdit
    } from "@/api/api";
    import {sortName} from '@/utils/util'
    import {url} from '@/api/url'
    export default {
        name: "addModule",
        data() {
            return {
                editorOptions: quillConfig,
                isEqual:false,
                newData:[],
                newDataAll:[],
                detailDataA:[],
                submitLoading:false,
                pics:[],
                dynamicTags: [],
                specsKey: '',
                dialogVisible:false,
                loadingSave:false,
                addSpecsFlag:false,
                loadingTitle:'',
                spuName:'',
                specsName:[],
                formData:{
                    name: '',
                    spu_id:'',
                    spu:{id:'',desc_detail:'',name:'',category1:''},
                    caption: '',
                    category_id: '',
                    price: '',
                    cost_price:'',
                    market_price:'',
                    stock: '',
                    default_image:'',
                    is_launched:true,
                    specs:[],
                    p_image:'',
                    goods_imagelist:[],
                    goodsimagelist:[],
                },
                rules:{
                    spu_id: [
                        {required: true, message: '请选择spu',trigger: 'blur'}
                    ],
                    name: [
                        {required: true, message: '请输入商品名称',trigger: 'blur'}
                    ],
                    default_image: [
                        {required: true, message: '请上传商品默认图片',trigger: 'blur'}
                    ],
                    caption: [
                        {required: true, message: '请输入商品简介',trigger: 'blur'}
                    ],
                    price: [
                        {required: true, message: '请输入商品所需积分',trigger: 'blur'}
                    ],
                    stock: [
                        {required: true, message: '请输入商品库存',trigger: 'blur'}
                    ],
                },
                category_list:[],
                goods_list:[],
                specs_list:[],
                inputVisible: false,
                inputValue: '',
                checkList:[]
            }
        },
        methods:{
            closeTag(tag) {
                this.dynamicTags.splice(this.dynamicTags.indexOf(tag), 1);
            },

            showInput() {
                this.inputVisible = true;
                this.$nextTick(_ => {
                    this.$refs.saveTagInput.$refs.input.focus();
                });
            },
            handlespuselected(val){
                this.formData.specs=[]
                this.addSpecsFlag=false
                this.goods_list.forEach((item,index)=>{
                    if(item.id == val){
                       this.formData.spu =item
                    }
                })

                this.pics=[]
                if(this.formData.spu) {
                    this.formData.spu.sku_images.forEach(item=>{
                        this.pics.push({
                            pic:item.image
                        })
                    })
                }

            },
            handlecategoryselected(val){
                this.getMallGoodspuListByGoodscategory(val)

            }
            ,
            handleInputConfirm() {
                let inputValue = this.inputValue;
                if (inputValue) {
                    this.dynamicTags.push(inputValue);
                }
                this.inputVisible = false;
                this.inputValue = '';
            },
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.$emit('refreshData')
            },
            addModuleFn(item,flag) {
                // console.log(item,'item----')
                this.loadingTitle=flag
                this.dialogVisible=true
                this.getMallGoodscategoryList()
                // this.getMallGoodspuList()
                this.getMallGoodspuListByGoodscategory(this.formData.category_id)
                var specs_data_list = {};
                if(item && item.specs) {
                    for(var i=0;i<item.specs.length;i++){
                        specs_data_list[item.specs[i].spec_id] = item.specs[i].option_id;
                    }
                    item.specs=specs_data_list
                }

                this.pics=[]
                if(item && item.goodsimagelist&&item.goodsimagelist.length >0) {
                    item.goodsimagelist.forEach(item=>{
                        this.pics.push({
                            pic:item.image
                        })
                    })
                }

                this.formData=item ? item : {
                    name: '',
                    spu_id:'',
                    spu:{id:'',desc_detail:'',name:'',category1:''},
                    caption: '',
                    category_id: '',
                    price: '',
                    cost_price:'',
                    market_price:'',
                    stock: '',
                    default_image:'',
                    is_launched:true,
                    specs:{},
                    goods_imagelist:[],
                    goodsimagelist:[],
                }
                if(item && item.goodsimagelist) {
                    this.formData.goods_imagelist=this.formData.goodsimagelist
                }
                this.specsName=[]
                this.$forceUpdate()

            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        var specs_sub_list = [];
                        for(var k in this.formData.specs){
                            specs_sub_list.push({'spec_id':k,'option_id':this.formData.specs[k]})
                        }
                        let param = {
                            ...this.formData
                        }
                        param.is_launched==param.is_launched?1:0
                        param.specs=[...specs_sub_list]


                        if(this.pics.length <1) {
                            this.$message.warning('请先上传商品图片~')
                            return
                        }
                        let picList = []
                        this.pics.forEach(item=>{
                            picList.push({'image':item.pic})
                        })
                        param.goods_imagelist=picList

                        this.formData.spu.id = this.formData.spu_id

                        // console.log(param,'param---')
                        this.loadingSave=true
                        if(this.formData.id){
                            mallgoodskuEdit(param).then(res=>{
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
                            mallgoodskuAdd(param).then(res=>{
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
                console.log(param,'param-----')
                let res= await mallUploadgoodsimg(param)
                console.log(res)
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

            imgBeforeUpload1(file) {
                const isJPG = file.type === 'image/jpeg' || file.type === 'image/png';
                if (!isJPG) {
                    this.$message.error('图片只能是 JPG/PNG 格式!');
                    return false
                }
                return isJPG;
            },
            async imgUploadRequest1(param) {
                var vm = this
                let res= await mallUploadgoodsimg(param)
                // console.log(res)
                if(res.code == 2000) {
                    vm.formData.p_image = res.data.data[0]
                } else {
                    vm.$message.warning(res.msg)
                }
                // console.log( vm.formData.p_image,' vm.formData.p_image---')
                this.$forceUpdate()
            },
            imgUploadSuccess1(res) {
                if (res) {
                    this.formData.p_image = res.url
                }
            },
            //获取商品分类列表
            getMallGoodscategoryList(){
                let param = {
                    page: 1,
                    limit: 9999999,
                }
                mallGoodscategory(param).then(res => {
                    if(res.code ==2000) {
                        this.category_list = res.data.data
                    }
                })
            },
            //获取商品SPU列表
            getMallGoodspuList(){
                let param = {
                    page: 1,
                    limit: 9999999,
                }
                mallGoodspu(param).then(res => {
                    if(res.code ==2000) {
                        this.goods_list = res.data.data
                    }
                })
            },
            //根据选择的分类获取该分类下的商品SPU列表
            getMallGoodspuListByGoodscategory(category_id){
                let param = {
                    category1:category_id,
                    page: 1,
                    limit: 9999999,
                }
                mallGoodspu(param).then(res => {
                    if(res.code ==2000) {
                        this.goods_list = res.data.data
                    }
                })
            },
            //获取商品SPU规格列表
            getMallGoodspuspecList(){
                let param = {
                    id:this.formData.spu_id,
                }
                mallGoodspuallspecbyid(param).then(res => {
                    if(res.code ==2000) {
                        this.specs_list = res.data.data
                    }
                })
            },
            //添加spu
            getSpu() {
                // mallGoodspuAdd
                if(!this.formData.category_id) {
                    this.$message.warning('请先选择商品分类')
                    return
                }
                let param = {
                    category1:this.formData.category_id,
                    name:this.spuName
                }
                mallGoodspuAdd(param).then(res=>{
                    if(res.code == 2000) {

                        this.$message.success(res.msg)
                        this.formData.spu_id=res.data.data.id
                        this.formData.spu = res.data.data
                        this.getMallGoodspuList()
                    } else{
                        this.$message.warning(res.msg)
                    }
                })

            },
            //给规格新增规格值
            getSpecs(e,index) {
                let param = {
                    spec:e,
                    value:this.specsName[index]
                }
                mallgoodspuspecoptionAdd(param).then(res=>{
                    if(res.code == 2000) {
                        this.$message.success(res.msg)
                        this.getMallGoodspuspecList()
                    } else{
                        this.$message.warning(res.msg)
                    }
                })
            },
            addSpecs() {
                this.addSpecsFlag=true
            },
            submitSpecs() {
                // console.log(this.dynamicTags,'dynamicTags----')
                // console.log(this.specsKey,'specsKey----')
                // console.log(this.formData.spu_id,'this.formData.spu_id----')
                // console.log(this.pics,'pics---')
                if(!this.specsKey) {
                    this.$message.warning('请先输入规格名称')
                    return
                }
                if(this.dynamicTags.length<1) {
                    this.$message.warning('请先添加规格值')
                    return
                }


                let param={
                    id:this.formData.spu_id,
                    name:this.specsKey,
                    value:this.dynamicTags,
                }
                mallCreatespuspecandpotionsAdd(param).then(res=>{
                    if(res.code == 2000) {
                        this.$message.success(res.msg)
                        this.getMallGoodspuspecList()
                        this.specsKey=''
                        this.dynamicTags=[]
                        this.addSpecsFlag=false
                    } else{
                        this.$message.warning(res.msg)
                    }
                })
            },
            closeSpecs() {
                this.addSpecsFlag=false
                this.specsKey=''
                this.dynamicTags=[]
            },
            getSpecId(e){
                console.log(e,'e---')
                console.log(this.formData.specs,'this.formData.specs')
            },

            // 上传商品图
            async changesData () {
                let vm = this
                vm.detailDataA = []
                //console.log(vm.$refs.file,'vm.$refs.file-----')
                let aList = vm.$refs.file.files
                //console.log(aList,'aList-----')
                let _aList = []
                for (let i in aList) {
                    _aList.push(aList[i]);
                }
                let filterList=[]
                let flag = 0
                //console.log(_aList,'_aList----')
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
                                //console.log(height,'img.naturalHeight')
                                //console.log(width,'img.naturalWidth')
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
                /*if(vm.formData.goods_imagelist.length >0) {
                    let img = new Image()
                    img.crossOrigin = 'anonymous'
                    img.src = vm.formData.goods_imagelist[0];
                    img.onload = function () {
                        let height = img.naturalHeight;
                        vm.pics.map(item => {
                            item.height = height
                        })
                    }
                }*/
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
                        console.log(res);
                    },
                    onFailure: function (res) {    // 上传失败后执行的方法，res是接收的ajax响应内容
                        console.log(res);
                    },
                    file: option
                }
                mallUploadgoodsimg(option).then(obj=>{
                    let res={}
                    if (obj.data.data[0].indexOf("://")>=0){
                        res = {
                            url:obj.data.data[0],
                            name:obj.data.data[0].split("/")[obj.data.data[0].split("/").length-1]
                        }
                    }else{
                        res = {
                            url:url.split('/api')[0]+obj.data.data[0],
                            name:obj.data.data[0].split("/")[obj.data.data[0].split("/").length-1]
                        }
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

        },
        mounted(){
            // this.getMallGoodscategoryList()
            // this.getMallGoodspuList()
        }
        ,computed:{
            look_good_id(){
                return this.formData.spu_id
            }
        },
        watch:{
            look_good_id(newVal,oldVal){
                this.getMallGoodspuspecList();
            }
        }
    }
</script>

<style>
    .set-specs .el-form-item__content{
        background: #e6e6e6 !important;
    }

    .messageTxt /deep/ .ql-editor {
        width: 100%;
        /*height: 200px;*/
        background: #ffffff;
    }
    .ql-toolbar.ql-snow + .ql-container.ql-snow{
        min-height: 300px;
        height:calc(100vh - 800px)
    }
    .ql-snow .ql-picker-label{
        display: flex;
    }
    .editor {
        line-height: normal !important;
        height: 500px;
    }
    .ql-snow .ql-tooltip[data-mode="link"]::before {
        content: "请输入链接地址:";
    }
    .ql-snow .ql-tooltip.ql-editing a.ql-action::after {
        border-right: 0px;
        content: "保存";
        padding-right: 0px;
    }

    .ql-snow .ql-tooltip[data-mode="video"]::before {
        content: "请输入视频地址:";
    }

    /*.ql-snow .ql-picker.ql-size .ql-picker-label::before,*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-item::before {*/
    /*content: "14px";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="small"]::before,*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="small"]::before {*/
    /*content: "10px";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="large"]::before,*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="large"]::before {*/
    /*content: "18px";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="huge"]::before,*/
    /*.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="huge"]::before {*/
    /*content: "32px";*/
    /*}*/
    .ql-editor .ql-size-12px {
        font-size: 12px;
    }
    .ql-editor .ql-size-14px {
        font-size: 14px;
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item::before {
        content: '16px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="12px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="12px"]::before {
        content: '12px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="14px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="14px"]::before {
        content: '14px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="16px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="16px"]::before {
        content: '16px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="18px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="18px"]::before {
        content: '18px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="20px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="20px"]::before {
        content: '20px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="22px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="22px"]::before {
        content: '22px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="24px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="24px"]::before {
        content: '24px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="26px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="26px"]::before {
        content: '26px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="32px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="32px"]::before {
        content: '32px';
    }
    .ql-snow .ql-picker.ql-size .ql-picker-label[data-value="48px"]::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item[data-value="48px"]::before {
        content: '48px';
    }


    .ql-snow .ql-picker.ql-header .ql-picker-label::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item::before {
        content: "文本";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="1"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before {
        content: "标题1";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="2"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before {
        content: "标题2";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="3"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before {
        content: "标题3";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="4"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before {
        content: "标题4";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="5"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before {
        content: "标题5";
    }
    .ql-snow .ql-picker.ql-header .ql-picker-label[data-value="6"]::before,
    .ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before {
        content: "标题6";
    }

    .ql-editor .ql-font-Microsoft-YaHei {
        font-family: "Microsoft YaHei";
    }
    .ql-editor .ql-font-SimSun {
        font-family: "SimSun";
    }
    .ql-editor .ql-font-SimHei {
        font-family: "SimHei";
    }
    .ql-editor .ql-font-KaiTi {
        font-family: "KaiTi";
    }
    .ql-editor .ql-font-Arial {
        font-family: "Arial";
    }
    .ql-editor .Times-New-Roman {
        font-family: "Times New Roman";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item::before {
        content: '微软雅黑';
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=Microsoft-YaHei]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=Microsoft-YaHei]::before {
        content: "微软雅黑";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=SimSun]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=SimSun]::before {
        content: "宋体";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=SimHei]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=SimHei]::before {
        content: "黑体";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=KaiTi]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=KaiTi]::before {
        content: "楷体";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=Arial]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=Arial]::before {
        content: "Arial";
    }
    .ql-snow .ql-picker.ql-font .ql-picker-label[data-value=Times-New-Roman]::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item[data-value=Times-New-Roman]::before {
        content: "Times New Roman";
    }
    /*.ql-snow .ql-picker.ql-font .ql-picker-label::before,*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-item::before {*/
    /*content: "标准字体";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="serif"]::before,*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="serif"]::before {*/
    /*content: "衬线字体";*/
    /*}*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="monospace"]::before,*/
    /*.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="monospace"]::before {*/
    /*content: "等宽字体";*/
    /*}*/
    /*!* 编辑器内部出现滚动条 *!*/
    /*.ql-container{*/
    /*overflow-y:auto;*/
    /*height:8rem!important;*/
    /*}*/
    /*!*滚动条整体样式*!*/
    /*.ql-container ::-webkit-scrollbar{*/
    /*width: 10px;!*竖向滚动条的宽度*!*/
    /*height: 10px;!*横向滚动条的高度*!*/
    /*}*/
    /*.ql-container ::-webkit-scrollbar-thumb{!*滚动条里面的小方块*!*/
    /*background: #666666;*/
    /*border-radius: 5px;*/
    /*}*/
    /*.ql-container ::-webkit-scrollbar-track{!*滚动条轨道的样式*!*/
    /*background: #ccc;*/
    /*border-radius: 5px;*/
    /*}*/
</style>
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
</style>

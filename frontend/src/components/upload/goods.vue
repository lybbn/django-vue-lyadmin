<template>
    <div style="width: 100%">
        <div class="uploadImg" style="display: block">
            <div style="width: 100%;display: flex">
                <div class="input-file input-fileup">
                    <span style="display: inline-block; width: 100%;cursor:pointer; ">{{submitLoading || (newData.length > 0 && detailDataA.length !== newData.length) ? '' : '上传图片'}}</span>
                    <el-button style="width: 100%;height:36px" type="primary" v-if="submitLoading || (newData.length > 0 && detailDataA.length !== newData.length)"  :loading="submitLoading || (newData.length > 0 && detailDataA.length !== newData.length)">上传图片</el-button>
                    <input ref="file" title="请上传图片"  class="fileUploaderClass" type='file' multiple name="file" v-else @change.stop="changesData"/>
                </div>

                <div class="deleteBtn" v-if="pics.length > 0"><el-button :loading="submitLoading || (newData.length > 0 && detailDataA.length !== newData.length)" @click="clearPhotoData">清空照片</el-button></div>
                <div class="elProgress" v-if="newData.length > 0 && detailDataA.length !== newData.length">
                    <el-progress class="progress" :text-inside="true" :stroke-width="20" :percentage="parseInt(detailDataA.length*100/newData.length)" status="success"></el-progress>
                    您还有 <span>（{{newData.length - detailDataA.length}}）</span>张照片等待上传
                </div>
            </div>
            <span style="color: #999999; display: block;font-size:12px">(最多可上传9张图，<!--宽750px，<em style="color:#ff0000;font-style: normal">保持图片高度一致，便于前端效果展示</em>，--> 2MB以内，支持PNG/JPG格式)</span>
        </div>
        <div class="pickAlbumPreListO" :style="isEqual ? 'border:1px solid #ff0000' : ''">
            <ul class="pickAlbumPreList" v-if="pics.length > 0">
                <li v-for="(item, index) in pics">
                    <el-image :src="item.pic" fit="contain" :preview-src-list="[item.pic]"></el-image>
                    <i class="el-icon-close" @click="deletePhoto(index)"><el-icon><Close /></el-icon></i>
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
                    <i class="el-icon-picture"><el-icon><PictureFilled /></el-icon></i>
                    <div class="btnchang">
                        <el-button size="small" class="btnRg">右移</el-button>
                    </div>
                </li>
            </ul>
            <div class="tipsCon">（左移/右移，可以调整图片前端展示顺序）</div>
            <div class="tipsCon" style="color:#ff0000" v-if="isEqual">上传图片的高度，要求一致！</div>
        </div>
    </div>
</template>

<script>
    import {platformsettingsUploadPlatformImg} from "@/api/api";
    import {sortName} from "@/utils/util"
    export default {
        name: "LyUploadGoods",
        data(){
            return{
                //轮播图
                newData:[],
                newDataAll:[],
                detailDataA:[],
                submitLoading:false,
                isEqual:false,
                pics:[],
                //轮播图结束
            }
        },
        props: {
            modelValue: {
              type:Array,
              default: []
            },

        },
        mounted() {
            //轮播图开始
            this.pics= this.modelValue
            //轮播图结束
        },
        watch:{
            modelValue: function(nval){
                this.pics= nval; // modelValue改变是同步子组件visible的值
            },
            pics: function(nval) {
                this.$emit('update:modelValue', nval); // visible改变时同步父组件modelValue的值
            }
        },
        methods:{
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
    }
</script>

<style lang="scss" scoped>
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
                width: 20px;
                height: 20px;
                line-height: 20px;
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
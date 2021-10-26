<template>
    <el-dialog
            :title="loadingTitle"
            :visible.sync="dialogVisible"
            width="600px"
            center
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :before-close="handleClose">
        <el-form  :inline="false" :model="formData" :rules="rules" ref="rulesForm" label-position="right" label-width="130px">
            <el-form-item label="站点名称：" prop="sitename">
                <el-input v-model.trim="formData.sitename" style="width: 300px" :disabled="loadingTitle=='详情'"></el-input>
            </el-form-item>
            <el-form-item label="站点员：" prop="user" >
                <el-select  v-model="formData.user" @change="changeOnsiterSelect" placeholder="请选择"  style="width: 300px" :disabled="loadingTitle=='详情'">
                    <el-option
                            v-for="item in peopleList"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="头像：" prop="avatar" >
                <el-image :src="userinfo.avatar" style="width: 60px;height:60px" ></el-image>


<!--                <el-upload-->
<!--                        class="avatar-uploader"-->
<!--                        action="https://jsonplaceholder.typicode.com/posts/"-->
<!--                        :show-file-list="false"-->
<!--                        :http-request="imgUploadRequest"-->
<!--                        :on-success="imgUploadSuccess"-->
<!--                        :before-upload="imgBeforeUpload">-->
<!--                    <img v-if="formData.img" :src="formData.img" class="avatar">-->
<!--                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>-->
<!--                </el-upload>-->
            </el-form-item>

            <el-form-item label="手机号：" prop="mobile" >
                <el-input v-model.trim="userinfo.mobile" style="width: 300px" :disabled="true"></el-input>
            </el-form-item>
            <el-form-item label="站点位置：" prop="selectedOptions">
<!--                <el-input v-model.trim="formData.name" style="width: 300px"></el-input>-->
                <el-cascader
                        :placeholder="placeholderinfo"
                        v-model="selectedOptions"
                        style="width: 300px"
                        @change="handleChange"
                        ref="myCascader"
                        :props="props"
                        :disabled="loadingTitle=='详情'"></el-cascader>
            </el-form-item>
            <el-form-item label="详细地址：" prop="place" >
                <el-input v-model.trim="formData.place" style="width: 300px" :disabled="loadingTitle=='详情'"></el-input>
            </el-form-item>
            <div style="display: flex;align-items: center;">
                <el-form-item label="经度" prop="longitude">
                    <el-input type="text" size="small" style="width: 120px"  v-model="formData.longitude" :disabled="loadingTitle=='详情'"></el-input>
                </el-form-item>
                <el-form-item label="纬度" prop="latitude" label-width="60px">
                    <el-input type="text"  size="small" style="width: 120px"  v-model="formData.latitude" :disabled="loadingTitle=='详情'"></el-input>
                </el-form-item>
                <el-form-item label-width="10px"><el-button size="small" type="primary" @click="handleclickadress" :loading="loadingSave" :disabled="loadingTitle=='详情'">点击获取</el-button></el-form-item>
            </div>


            <el-form-item label="状态：" prop="status">
                <el-switch :disabled="loadingTitle=='详情'"
                        v-model="formData.status"
                        active-color="#13ce66"
                        inactive-color="#ff4949">
                </el-switch>
<!--                <el-select size="small" v-model="formData.status" placeholder="请选择" clearable style="width: 300px">-->
<!--                    <el-option-->
<!--                            v-for="item in statusList"-->
<!--                            :key="item.id"-->
<!--                            :label="item.name"-->
<!--                            :value="item.id">-->
<!--                    </el-option>-->
<!--                </el-select>-->
            </el-form-item>

        </el-form>
        <span slot="footer">
            <el-button @click="handleClose" :loading="loadingSave">取消</el-button>
            <el-button type="primary" @click="submitData" :loading="loadingSave" :disabled="loadingTitle=='详情'">确定</el-button>
        </span>
    </el-dialog>
</template>

<script>
    import {retrieveRecyclingsiteAdd,retrieveRecyclingsiteEdit,getProvince,getCityDistrictByID,retrieveRecyclerusers,getAddressaccuracy} from "@/api/api";
    export default {
        name: "addModule",
        data() {
            return {
                dialogVisible:false,
                loadingSave:false,
                loadingTitle:'',
                peopleList:[],
                placeholderinfo:"请选择省/市/区",
                selectedOptions:[],
                formData:{
                    sitename:'',
                    user:'',
                    province:'',
                    city:'',
                    district:'',
                    street:'',
                    place:'',
                    longitude:'',
                    latitude:'',
                    status:true,
                },
                userinfo:{
                    avatar:'',
                    mobile:'',
                },
                rules:{
                    sitename: [
                        {required: true, message: '请输入站点名称',trigger: 'blur'}
                    ],
                    user: [
                        {required: true, message: '请选择站点员',trigger: 'blur'}
                    ],
                    province: [
                        {required: true, message: '请选择省市区',trigger: 'blur'}
                    ],
                    city: [
                        {required: true, message: '请选择省市区',trigger: 'blur'}
                    ],
                    district: [
                        {required: true, message: '请选择省市区',trigger: 'blur'}
                    ],
                    place: [
                        {required: true, message: '请输入详细地址',trigger: 'blur'}
                    ],
                    longitude: [
                        {required: true, message: '请输入精度',trigger: 'blur'}
                    ],
                    latitude: [
                        {required: true, message: '请输入纬度',trigger: 'blur'}
                    ],

                },
                statusList:[
                    {id:1,name:'正常'},
                    {id:2,name:'禁用'},
                ],
                options:[],
                props:{
                    lazy: true,
                    lazyLoad(node, resolve) {
                      setTimeout(() => {
                        if (node.level == 0) {
                          getProvince().then(response => {
                            const cities = response.data.data.map((value, i) => ({
                              value: value.id,
                              label: value.name,
                              leaf: node.level >= 2
                            }));
                            resolve(cities);
                          });
                        }
                        if (node.level == 1) {
                          getCityDistrictByID({'id':node.value}).then(response => {
                            const areas = response.data.data.subs.map((value, i) => ({
                              value: value.id,
                              label: value.name,
                              leaf: node.level >= 2
                            }));
                            resolve(areas);
                          });
                        } else if (node.level == 2) {
                          getCityDistrictByID({'id':node.value}).then(response => {
                            const areas = response.data.data.subs.map((value, i) => ({
                              value: value.id,
                              label: value.name,
                              leaf: node.level >= 2
                            }));
                            resolve(areas);
                          });
                        }
                      }, 100);
                    },
                },
            }
        },
        methods:{
            //级联器事件
            handleChange(e){
                 //console.log(e,'e---- 查看根节点')
                 //console.log(this.$refs.myCascader.getCheckedNodes()[0].pathLabels )
                 //console.log(this.$refs.myCascader.getCheckedNodes()[0].value )
                  // var label = this.$refs.myCascader.getCheckedNodes()[0].label
                var lables = this.$refs.myCascader.getCheckedNodes()[0].pathLabels
                if (lables.length==3){
                    this.formData.province = lables[0]
                    this.formData.city = lables[1]
                    this.formData.district = lables[2]
                }
                this.placeholderinfo="请选择省/市/区"
            },
            //站点员选择绑定站点信息数据
            changeOnsiterSelect(data){
                var objValue={}
                this.peopleList.forEach(function (item,index) {
                    if(item.id == data){
                        objValue = item
                    }
                })
                this.userinfo.avatar = objValue.avatar
                this.userinfo.mobile = objValue.mobile
            },
            //根据详细地址获取经纬度信息
            handleclickadress(){
                if(this.formData.place==""){
                    this.$message.warning("请填写详细地址")
                    return
                }
                if(this.formData.district==""){
                    this.$message.warning("请选择省市区")
                    return
                }
                var param = {
                    address : this.formData.province+this.formData.city+this.formData.district+this.formData.place
                }
                getAddressaccuracy(param).then(res=>{
                                if(res.code ==2000) {
                                    var datas = res.data.data
                                    this.formData.longitude = datas.lng
                                    this.formData.latitude = datas.lat
                                } else {
                                    this.$message.warning(res.msg)
                                }
                            })
            },
            addModule() {
                this.$refs.addModuleFlag.addModuleFn(null,'新增')
            },
            handleClose() {
                this.dialogVisible=false
                this.loadingSave=false
                this.$emit('refreshData')
            },
            addModuleFn(item,flag) {
                this.loadingTitle=flag
                this.dialogVisible=true
                this.formData=item ? item : {
                    sitename:'',
                    user:'',
                    province:'',
                    city:'',
                    district:'',
                    street:'',
                    place:'',
                    longitude:'',
                    latitude:'',
                    status:true,
                }
                if (item){
                    this.userinfo = {
                        avatar:item.info.avatar,
                        mobile:item.info.mobile,
                    }
                    this.placeholderinfo = item.province + "/" +item.city + "/" +item.district
                }else{
                   this.userinfo = {
                        avatar:'',
                        mobile:'',
                    }
                    this.selectedOptions=[]
                    this.placeholderinfo = "请选择省/市/区"
                }

                this.getRecyclerUsers()
            },
            submitData() {
                this.$refs['rulesForm'].validate(obj=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        if(this.formData.id){
                            retrieveRecyclingsiteEdit(param).then(res=>{
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
                            retrieveRecyclingsiteAdd(param).then(res=>{
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
            //获取回收员列表
            getRecyclerUsers(){
                this.peopleList = []
                var params={
                    page: 1,
                    limit: 9999,
                }
                 retrieveRecyclerusers(params).then(res => {
                     if(res.code ==2000) {
                         this.peopleList = res.data.data
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
            async imgUploadRequest(option) {
                // OSS.ossUploadProductImg(option);
            },
            imgUploadSuccess(res) {
                if (res) {
                    this.formData.img = res.url
                }
            },

        }
    }
</script>


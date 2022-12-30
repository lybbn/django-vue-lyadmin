<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect" v-if="showSearchBar && searchBar.searchColums.length>0">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item :label="sitem.label+':'" v-for="(sitem,sindex) in searchBar.searchColums">
                    <el-input v-if="sitem.type === 'input'" size="default" v-model="formInline[sitem.prop]" :maxlength="sitem.maxlength"  clearable :placeholder="sitem.placeholder" @change="search" :style="{width:(sitem.width?sitem.width:200)+'px'}"></el-input>
                    <el-select v-else-if="sitem.type === 'select'" size="default" v-model="formInline[sitem.prop]" :placeholder="sitem.placeholder" clearable filterable :style="{width:(sitem.width?sitem.width:200)+'px'}" @change="search">
                        <el-option
                                v-if="sitem.options"
                                v-for="option in sitem.options"
                                :key="option.value"
                                :label="option.label"
                                :value="option.value"
                                >
                        </el-option>
                    </el-select>
                    <el-date-picker
                            v-else-if="sitem.type === 'datepicker-datetimerange'"
                            style="width:350px"
                            v-model="timers"
                            type="datetimerange"
                            @change="timeChange"
                            range-separator="至"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                    </el-date-picker>
                </el-form-item>
                <slot name="searchBar"></slot>
                <el-form-item label=""><el-button  @click="handleSearchClick('search')" type="primary" icon="Search" v-show="rowHandle.permission.search">查询</el-button></el-form-item>
                <el-form-item label=""><el-button  @click="handleSearchClick('reset')" icon="Refresh">重置</el-button></el-form-item>
<!--                <el-form-item label=""><el-button  @click="addAdmin" type="primary" v-show="isShowBtn('userManage','用户管理','Create')">新增</el-button></el-form-item>-->
<!--                <el-form-item label=""><el-button  @click="exportDataBackend" type="primary">导出</el-button></el-form-item>-->
            </el-form>
        </div>

        <div class="table">
            <!-- 表格头部操作栏 -->
            <div class="tableToolBar" ref="tableToolBar">
                <!-- 左侧按钮栏目 -->
                <div>
                    <div>
                        <el-button  @click="handleEdit('','add')" type="primary" icon="Plus" v-show="rowHandle.permission.add">新增</el-button>
                        <el-button  @click="handleMutiDelete" type="danger" icon="Delete" :disabled="multiple" v-if="showSelectable && rowHandle.permission.del">删除</el-button>
                        <slot name="tablebar-l"></slot>
                    </div>

                </div>
                <div>
                    <slot name="tablebar-c"></slot>
                </div>
                <div>
                    <slot name="tablebar-r"></slot>
                    <!-- 右侧表头筛选 -->
<!--                    <div class="transfer">-->
<!--                        <el-button icon="Refresh" circle @click="handleRefresh"></el-button>-->
<!--                        <el-button icon="Search" circle type="primary" @click="showSearchBar=showSearchBar?false:true"></el-button>-->
<!--                        <el-button icon="Filter" @click="drawer=true" circle type="success"></el-button>-->
<!--                        <el-drawer v-model="drawer" direction="rtl" title="显示/隐藏列" size="20%">-->
<!--                            <el-checkbox :indeterminate="drawerIndeterminate" @change="handleDrawerCheckAllChange">全选 {{ "("+drawerCheckedValue.length+"/"+tableColumns.length+")"}}</el-checkbox>-->
<!--                            <el-checkbox-group v-model="drawerCheckedValue" @change="handleDrawerColumnsChange" style="overflow: auto;display: flex;flex-direction: column">-->
<!--                                <el-checkbox  v-for="ckitem in tableColumns" :key="ckitem.prop" :label="ckitem.label" :checked="!ckitem.hidden"></el-checkbox>-->
<!--                            </el-checkbox-group>-->

<!--                        </el-drawer>-->
<!--                    </div>-->
                    <div class="transfer">
                        <el-button type="primary" link @click="handleRefresh">
                            <el-icon size="20px"><Refresh/></el-icon>
                        </el-button>
                        <el-popover placement="bottom" trigger="click" :width="100">
                            <el-checkbox :indeterminate="drawerIndeterminate" @change="handleDrawerCheckAllChange">全选 {{ "("+drawerCheckedValue.length+"/"+tableColumns.length+")"}}</el-checkbox>
                            <el-divider style="margin:  5px auto"></el-divider>
                            <el-checkbox-group v-model="drawerCheckedValue" @change="handleDrawerColumnsChange" style="overflow: auto;display: flex;flex-direction: column">
                                <el-checkbox  v-for="ckitem in tableColumns" :key="ckitem.prop" :label="ckitem.label" :checked="!ckitem.hidden"></el-checkbox>
                            </el-checkbox-group>
                            <template #reference>
                                <el-button link type="primary">
                                    <el-icon size="20px"><Setting/></el-icon>
                                </el-button>
                            </template>
                        </el-popover>
                        <el-button link type="primary" @click="showSearchBar=!showSearchBar">
                            <el-icon size="20px"><Search/></el-icon>
                        </el-button>
                        <el-button type="primary" link @click="setFull">
                            <el-icon size="20px"><FullScreen/></el-icon>
                        </el-button>
                    </div>
                </div>
            </div>
            <el-table  v-bind="tableOptions" :height="tableHeight" :data="tableData" ref="tableref" v-loading="loadingPage" :row-key="rowKey" style="width: 100%" @selection-change="handleSelectionChange">
                <!-- 选择框列/序号列是否开启 -->
                <el-table-column type="selection" width="55" align="center" v-if="showSelectable"></el-table-column>
                <el-table-column type="index" width="60" align="center" label="序号" v-if="showSequence">
                     <template #default="scope">
                         <span v-text="getTableIndex(scope.$index)"></span>
                     </template>
                </el-table-column>
                <!-- 普通列 -->
                <template v-for="(column,columnIndex) in tableColumns" :key="columnIndex">
                    <span v-if="column.slot" >
                        <slot :name="column.slot" :tit="columnIndex"></slot>
                    </span>
                    <el-table-column
                    :prop="column.prop"
                    :label="column.label"
                    :sortable="column.sortable"
                    :min-width="column.minWidth"
                    :show-overflow-tooltip="true"
                    v-if="(column.hidden !== undefined && column.slot==undefined)?!column.hidden:true"
                    >
                        <template #default="{row,$index}">
                            <template v-if="!column.render">
                                <span>{{ row[column.prop] || '-' }}</span>
                            </template>
                            <template v-else>
                                <ly-render :render="column.render" :row="row" :index="$index" :column="column" ></ly-render>
                            </template>
                        </template>
                    </el-table-column>
                </template>
                <!-- 操作列 -->
                <el-table-column label="操作" :fixed="rowHandle.fixed" :width="rowHandle.width">
                    <template #header>
                        <div style="display: flex;justify-content: space-between;align-items: center;">
                            <div>操作</div>
<!--                            <div @click="setFull">-->
<!--                                <el-tooltip content="全屏" placement="bottom">-->
<!--                                    <el-icon ><full-screen /></el-icon>-->
<!--                                </el-tooltip>-->
<!--                            </div>-->
                        </div>
                    </template>
                    <template #default="scope">
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'detail')" v-show="rowHandle.permission.detail">详情</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="rowHandle.permission.edit">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'del')" v-show="rowHandle.permission.del">删除</span>
                        <!-- 自定义操作按钮 -->
                        <slot name="customHandle" :row="scope.row"></slot>
                    </template>
                </el-table-column>
                <!-- 自定义空数据 -->
                <template v-slot:empty>
                     <el-empty :image-size="150" description="暂无数据" />
                </template>
            </el-table>
        </div>
        <!-- 分页 -->
        <Pagination v-bind:child-msg="pageparm" :page-options="pageparams" @callFather="callFather" v-if="showPagination"></Pagination>
        <!-- 弹窗 -->
        <ly-dialog v-model="isDialogShow" :title="dialogTitle" :width="formOptions.width?formOptions.width:'50%'" :before-close="handleDialogClose">
            <el-form :model="formData" :rules="rules" ref="rulesForm" label-width="auto" :disabled="formDisabled">
                <el-row :gutter="formOptions.gutter?formOptions.gutter:20">
                    <el-col :span="fitem.form.span?fitem.form.span:24" v-for="(fitem,findex) in formColumns">
                        <el-form-item :label="fitem.label+'：'" :prop="fitem.prop" v-if="(fitem.form.hidden!==undefined && dialogTitle!=='详情')?!fitem.form.hidden:true">
                            <el-input v-if="fitem.type=='input'" :show-password="fitem.form.showPassword?fitem.form.showPassword:false"  v-model="formData[fitem.prop]" clearable :placeholder="fitem.form.placeholder?fitem.form.placeholder:''" @change="fitem.form.valueChange"></el-input>
                            <el-input v-else-if="fitem.type=='textarea'"  type="textarea" v-model="formData[fitem.prop]" :placeholder="fitem.form.placeholder?fitem.form.placeholder:''" @change="fitem.form.valueChange"></el-input>
                            <el-input-number v-else-if="fitem.type=='number'"  v-model="formData[fitem.prop]"  :min="0" :max="999999" @change="fitem.form.valueChange"></el-input-number>
                            <el-input-number v-else-if="fitem.type=='price'"  v-model="formData[fitem.prop]" :precision="2" :step="0.1"    @change="fitem.form.valueChange"></el-input-number>
                            <el-switch v-else-if="fitem.type=='switch'" v-model="formData[fitem.prop]" active-color="#13ce66" inactive-color="#ff4949" @change="fitem.form.valueChange"></el-switch>
                            <el-select v-else-if="fitem.type === 'select'" v-model="formData[fitem.prop]" :placeholder="fitem.placeholder" clearable filterable  @change="fitem.form.valueChange" style="width: 100%;">
                                <el-option
                                        v-if="fitem.form.options"
                                        v-for="option in fitem.form.options"
                                        :key="option.value"
                                        :label="option.label"
                                        :value="option.value"
                                        >
                                </el-option>
                            </el-select>
                            <el-radio-group v-else-if="fitem.type=='radio'" v-model="formData[fitem.prop]" @change="fitem.form.valueChange">
                                <el-radio :label="rditem.value" v-for="(rditem,rdindex) in fitem.form.options">{{rditem.label}}</el-radio>
                            </el-radio-group>
                            <el-checkbox-group v-else-if="fitem.type=='checkbox'" v-model="formData[fitem.prop]" @change="fitem.form.valueChange">
                                <el-checkbox v-if="fitem.options"  v-for="option in fitem.options" :label="option.label" />
                            </el-checkbox-group>
                            <ly-upload-avatar v-else-if="fitem.type=='image-avatar'" v-model="formData[fitem.prop]" :width="fitem.form.width?fitem.form.width+'px':'80px'" :height="fitem.form.width?fitem.form.width+'px':'80px'"></ly-upload-avatar>
                            <ly-upload-goods v-else-if="fitem.type=='image-goods'" v-model="formData[fitem.prop]"></ly-upload-goods>
                            <t-editor v-else-if="fitem.type=='tinymce'" v-model="formData[fitem.prop]"></t-editor>
                        </el-form-item>
                    </el-col>
                </el-row>
                <!-- 自定义form部分 -->
                <slot name="formExtend" :formData="formData"></slot>
            </el-form>
            <template v-slot:footer>
                <el-button @click="handleDialogClose">取消</el-button>
                <el-button @click="submitData" type="primary" :loading="loadingSave" :disabled="formDisabled">确定</el-button>
                <!-- 自定义dialog底部按钮 -->
                <slot name="customDialogHandle"></slot>
            </template>
        </ly-dialog>
    </div>
</template>
<script>
    //ly-crud需要的组件/方法
    import {dateFormats,getTableHeight} from "@/utils/util";
    import Pagination from "@/components/pagination/pagination";
    import LyRender from "./render/render";
    import LyDialog from "./dialog/dialog";
    import LyUploadAvatar from "./upload/avatar";
    import TEditor from "./TEditor";
    import LyUploadGoods from "./upload/goods";
    export default {
        components:{
            LyUploadGoods,
            TEditor,
            LyUploadAvatar,
            LyDialog,
            LyRender,
            Pagination,
        },
        name:'LyCrud',
        data() {
            return {
                isFull:false,
                loadingPage:false,
                tableHeight:500,
                formInline:{
                    page: 1,
                    limit: 10,
                },
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0,
                },
                defaultImg:require('../assets/img/avatar.jpg'),
                statusList:[
                    {id:1,name:'是'},
                    {id:0,name:'否'}
                ],
                identityList:[
                    {id:0,name:'普通用户'},
                    {id:1,name:'会员'},
                ],
                tableData:[],
                timers:[],
                drawer:false,
                drawerIndeterminate:true,
                drawerCheckedValue:[],
                // 选项框选中数组
                ids: [],
                // 选项框非单个禁用
                single: true,
                // 非多个禁用
                multiple: true,
                showSearchBar:true,
                //弹窗
                isDialogShow:false,
                dialogTitle:"",
                formData:{},
                rules:{},
                formColumns:[],
                loadingSave:false,
                formDisabled:false,
            }
        },
        props: {
             // 表头配置
            tableColumns: {
                type: Array,
                default: () => {
                    return [];
                }
            },
            //是否显示分页
            showPagination: {
                type: Boolean,
                default: true
            },
            //分页参数
            pageparams:{
                type: Object,
                default: () => {
                    return {
                        limit: 10,
                        pageSizes:[10,20,30,40,50,100],
                        layout:'total, sizes, prev, pager, next, jumper',
                    }
                }
            },
            // 是否显示复选框
            showSelectable: {
              type: Boolean,
              default: false
            },
            // 是否显示序号列
            showSequence: {
              type: Boolean,
              default: true
            },
            // 行唯一值
            rowKey: {
              type: String,
              default: 'id'
            },
            //操作列属性
            rowHandle:{
                type: Object,
                default:() => {
                    return{
                        width: 180,//操作列宽度
                        fixed:false,//类型：string/boolean	true false / 'left' / 'right',默认不固定
                        permission:{
                            add:true,
                            del:true,
                            edit:true,
                            search:true,
                            detail:true,
                        }
                    }
                },
            },
            //增删改查httpq请求方法
            crudRequest:{
                type: Object,
                default:() => {
                    return{
                        add:Function,
                        del:Function,
                        edit:Function,
                        search:Function,
                    }
                }
            },
            //搜索栏目配置
            searchBar:{
                type: Object,
                default:() => {
                    return{
                        showSearchBar:true,//是否显示搜索栏目
                        searchColums:[]
                    }
                }
            },
            //dialog表单
            formOptions:{
                type: Object,
                default: () => {
                    return{
                        width: '560px',//dialog弹窗宽度：类型：百分比或字符串
                        gutter: 20, // Layout布局栅格间隔
                    }
                }
            },
            //表格属性
            tableOptions:{
                type: Object,
                default: () => {
                    return {
                        stripe: false, // 斑马纹
                        highlightCurrentRow: false, // 是否要高亮当前行
                        border: true, // 是否有纵向边框
                        fit: true, // 列的宽度是否自撑开
                        size: 'default', // Table 的尺寸
                        lazy:false,// 是否需要懒加载
                        showHeader:true,//是否显示表头
                        defaultExpandAll:false,//是否默认展开所有行
                    }
                }
            },


        },
        watch:{
            pageparams(newValue, oldValue){
                this.pageparm.limit = newValue.limit?newValue.limit:this.pageparm.limit
            },
            searchBar(newValue, oldValue){
                this.showSearchBar = newValue.showSearchBar
            },
            showSearchBar(newValue, oldValue){
                this.$nextTick(() => {
                    this.getTheTableHeight()
                })
            }

        },
        created() {
            this.showSearchBar = this.searchBar.showSearchBar
            this.pageparm.limit = this.pageparams.limit?this.pageparams.limit:this.pageparm.limit
            this.formInline.limit = this.pageparm.limit
            this.formColumns = this.tableColumns.filter(item=>{
                if(item.form !== undefined ){
                    return true
                }else{
                    return false
                }
            })
            this.rules = {}
            this.formColumns.forEach(item=>{
                if(item.form.rules !== undefined){
                    this.rules[item.prop] = item.form.rules
                }
            })
            this.getData()
        },
        methods:{
            // 表格序列号（递增，翻页不重置）
            getTableIndex($index) {
            // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
            setFull(){
                this.isFull=!this.isFull
                window.dispatchEvent(new Event('resize'))
            },
            //多选项框被选中数据
            handleSelectionChange(selection) {
                this.ids = selection.map(item => item.id);
                this.single = selection.length !== 1;
                this.multiple = !selection.length;
            },
            /** 批量删除按钮操作 */
            handleMutiDelete() {
                const ids = this.ids;
                let vm = this
                vm.$confirm('是否确认删除选中的数据项?', "警告", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning"
                }).then(function() {
                    return vm.crudRequest.del({id:ids}).then(res=>{
                        if(res.code == 2000) {
                            vm.ids=[]
                            vm.single=true
                            vm.multiple=false
                            vm.$message.success(res.msg)
                            vm.handleRefresh()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
            handleDrawerColumnsChange(val){
                const newColumns = this.tableColumns.map(item=>{
                    let newitem = item
                    if(this.drawerCheckedValue.includes(item.label)){
                        newitem.hidden = false
                    }else{
                        newitem.hidden = true
                    }
                    return newitem
                })
                this.$emit('update:tableColumns', newColumns);
            },
            handleDrawerCheckAllChange(val){
                this.drawerCheckedValue  = val ? this.tableColumns.map(item=> item.label) : []
                const newColumns = this.tableColumns.map(item=>{
                    let newitem = item
                    if(val){
                        newitem.hidden = false
                    }else{
                        newitem.hidden = true
                    }
                    return newitem
                })
                this.$emit('update:tableColumns', newColumns);
                this.drawerIndeterminate  = false

            },
            //searchBar点击事件
            handleSearchClick(flag){
                if(flag=="search"){
                    this.search()
                }
                else if(flag=="reset"){
                    this.formInline = {
                        page:1,
                        limit: this.pageparm.limit
                    }
                    this.timers = []
                    this.getData()
                }
            },
            handleRefresh(){
                this.getData()
            },
            handleEdit(row,flag) {
                let vm = this
                if(flag=='del') {
                    vm.$confirm('您确定要删除该条数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        vm.crudRequest.del({id:row.id}).then(res=>{
                            if(res.code == 2000) {
                                vm.$message.success(res.msg)
                                vm.handleRefresh()
                            } else {
                                vm.$message.warning(res.msg)
                            }
                        })
                    }).catch(()=>{

                    })
                }
                else if (flag=='detail'){
                    this.dialogTitle = "详情"
                    this.formDisabled = true
                    this.tableColumns.forEach(item=>{
                        this.formData[item.prop] = row[item.prop]
                    })
                    this.isDialogShow = true
                }
                else if(flag=='add'){
                    this.dialogTitle = "添加"
                    //默认值处理
                    this.formColumns.forEach(item=>{
                         if(item.form.defaultValue !==undefined){
                             this.formData[item.prop] = item.form.defaultValue
                         }
                         if(item.prop === "password" && item.form.rules!==undefined){
                            this.rules.password = item.form.rules
                        }
                     })
                    this.isDialogShow = true
                }
                else if(flag=='edit'){
                    this.dialogTitle = "编辑"
                    this.formColumns.forEach(item=>{
                        this.formData[item.prop] = row[item.prop]
                        if(item.prop === "password"){
                            delete this.rules.password
                        }
                    })
                    this.isDialogShow = true
                }
            },
            handleDialogClose(){
                this.isDialogShow = false
                this.loadingSave =false
                this.formData = {}
                this.formDisabled = false
            },
            submitData() {
                this.$refs['rulesForm'].validate((obj)=>{
                    if(obj) {
                        this.loadingSave=true
                        let param = {
                            ...this.formData
                        }
                        if(this.dialogTitle=="编辑"){
                            this.crudRequest.edit(param).then(res=>{
                                this.loadingSave=false
                                if(res.code ==2000) {
                                    this.$message.success(res.msg)
                                    this.handleDialogClose()
                                    this.handleRefresh()
                                } else {
                                    this.$message.warning(res.msg)
                                }
                            })
                        }else{
                            this.crudRequest.add(param).then(res=>{
                                this.loadingSave=false
                                if(res.code ==2000) {
                                    this.$message.success(res.msg)
                                    this.handleDialogClose()
                                    this.search()
                                } else {
                                    this.$message.warning(res.msg)
                                }
                            })
                        }

                    }
                })
                this.loadingSave=false
            },
            /**
             * 从URL里下载文件
            */
            // 下载文件
            downloadFileURL(url) {
                var iframe =document.createElement("iframe")
                iframe.style.display ="none";
                iframe.src = url;
                document.body.appendChild(iframe);
            },
            exportDataBackend() {
                var params = {
                    page: 1,
                    limit: 9999,
                }
                // UsersUsersExportexecl(params).then(res => {
                //      if(res.code ==2000) {
                //          this.downloadFileURL(res.data.data)
                //          //this.$message.warning(res.data.data)
                //      }
                //  })
            },
            callFather(parm) {
                this.formInline.page = parm.page
                this.formInline.limit = parm.limit
                this.pageparm.page = parm.page
                this.pageparm.limit = parm.limit
                this.getData()
            },
            search() {
                this.formInline.page = 1
                this.formInline.limit = this.pageparm.limit
                this.getData()
            },
            //获取列表
            async getData() {
                this.loadingPage = true
                this.crudRequest.search(this.formInline).then(res => {
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
            // 计算搜索栏的高度
            listenResize() {
				this.$nextTick(() => {
				    this.getTheTableHeight()
				})
			},
            getTheTableHeight(){
                let searchBarHeight = (this.$refs.tableSelect!=undefined && this.$refs.tableSelect.offsetHeight)?this.$refs.tableSelect.offsetHeight:0
                const tableToolbarHeight = (this.$refs.tableToolBar!=undefined && this.$refs.tableToolBar.offsetHeight)?this.$refs.tableToolBar.offsetHeight:0
                searchBarHeight = this.isFull?searchBarHeight - 110:searchBarHeight
                this.tableHeight =  getTableHeight(searchBarHeight+tableToolbarHeight)
            }

        },
        //解决table 表格缩放错位问题
        handleResize() {
            this.$nextTick(()=> {
                this.$refs.tableref.doLayout();
            });
        },
        mounted() {
            //解决table 表格缩放错位问题
            window.addEventListener('resize', this.handleResize);
            // 监听页面宽度变化搜索框的高度
            window.addEventListener('resize', this.listenResize);
            this.$nextTick(() => {
              this.getTheTableHeight()
            })
        },

        unmounted() {
            //解决table 表格缩放错位问题
            window.removeEventListener("resize", this.handleResize);
             // 页面销毁，去掉监听事件
			window.removeEventListener("resize", this.listenResize);
        },
    }
</script>
<style lang="scss" scoped>
    .tableToolBar{
        margin-left: 1px;
        margin-right: 1px;
        display: flex;
        justify-content: space-between;
        font-size: 14px;
        background: var(--el-bg-color);
        padding: 10px;
        box-shadow: 0 0 4px #cccccc;
    }
</style>
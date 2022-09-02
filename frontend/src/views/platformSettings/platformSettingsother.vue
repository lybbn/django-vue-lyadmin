<template>
    <div :class="{'ly-is-full':isFull}">
        <div class="tableSelect" ref="tableSelect">
            <el-form :inline="true" :model="formInline" label-position="left">
                <el-form-item label="">
                    <el-button type="primary" @click="addModule"  icon="Plus" v-show="isShowBtn('platformSettingsother','其他设置','Create')">新增</el-button>
                </el-form-item>
                <el-form-item label="">
                    <el-button @click="handleDelete" type="danger" :disabled="multiple" icon="Delete" v-show="isShowBtn('platformSettingsother','其他设置','Delete')">删除</el-button>
                </el-form-item>
                <el-form-item label="">
                    <el-switch v-model="is_allow_fronted" active-color="#13ce66" inactive-color="#ff4949" active-text="前端访问已开启" inactive-text="前端访问已关闭"  @change="handleSuperOperate"></el-switch>
                </el-form-item>
            </el-form>
        </div>
        <el-form class="table">
            <el-table  :height="'calc('+(tableHeight)+'px)'" border :data="tableData" ref="tableref" v-loading="loadingPage" style="width: 100%" tooltip-effect="dark" @selection-change="handleSelectionChange">
                <el-table-column type="selection" width="55" align="center" disabled='false'></el-table-column>
                <el-table-column type="index" width="60" align="center" label="序号">
                    <template #default="scope">
                        <span v-text="getIndex(scope.$index)"></span>
                    </template>
                </el-table-column>
                <el-table-column min-width="120" prop="name" label="名称"></el-table-column>
                <el-table-column min-width="180" prop="value" label="键值">
                    <template #default="scope">
                         <div v-if="scope.row.type==2" v-html="ellipsis(scope.row.value)" class="ellipsis"></div>
                         <el-image v-else-if="scope.row.type==3" :src="scope.row.value" :preview-src-list="[scope.row.value]" :preview-teleported="true" style="width: 20px;height: 20px"></el-image>
                         <el-icon v-else-if="scope.row.type==4" @click="showvideohandle(scope.row.value)" style="font-size: 20px;cursor: pointer"><VideoCameraFilled /></el-icon>
                         <div v-else>{{scope.row.value}}</div>
                    </template>
                </el-table-column>
                <el-table-column min-width="140" prop="key" label="键名"></el-table-column>
                <el-table-column min-width="60" prop="sort" label="排序"></el-table-column>
                <el-table-column min-width="80" label="状态" v-if="false">
                    <template #default="scope">
                         <el-tag v-if="scope.row.status">正常</el-tag>
                         <el-tag v-else type="danger">禁用</el-tag>
                    </template>
                </el-table-column>
                <el-table-column min-width="150" prop="create_datetime" label="创建时间" show-overflow-tooltip></el-table-column>
                <el-table-column label="操作" fixed="right" width="180">
                    <template #header>
                        <div style="display: flex;justify-content: space-between;align-items: center;">
                            <div>操作</div>
                            <div @click="setFull">
                                <el-tooltip content="全屏" placement="bottom">
                                    <el-icon ><full-screen /></el-icon>
                                </el-tooltip>
                            </div>
                        </div>
                    </template>
                    <template #default="scope">
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'edit')" v-show="isShowBtn('platformSettingsother','其他设置','Update')">编辑</span>
                        <span class="table-operate-btn" @click="handleEdit(scope.row,'delete')" v-show="isShowBtn('platformSettingsother','其他设置','Delete')">删除</span>
                    </template>
                </el-table-column>
            </el-table>
        </el-form>
        <pagination-module v-bind:child-msg="pageparm" @callFather="callFather"></pagination-module>

        <add-module-other ref="AddModuleFlag" @refreshData="search"></add-module-other>
    </div>
</template>
<script>
    import PaginationModule from "@/components/Pagination";
    import {dateFormats,getTableHeight} from "@/utils/util";
    import {platformsettingsOther,platformsettingsOtherDelete,superOerateGet,superOerateSet} from '@/api/api'
    import AddModuleOther from "./components/addModuleOther";
    export default {
        components:{
            AddModuleOther,
            PaginationModule,
        },
        name:'PlatformSettingsother',
        data() {
            return {
                isFull:false,
                tableHeight:500,
                loadingPage:false,
                // 选项框选中数组
                ids: [],
                // 选项框非单个禁用
                single: true,
                // 非多个禁用
                multiple: true,
                formInline:{
                    page: 1,
                    limit: 10,
                },
                is_allow_fronted:true,
                pageparm: {
                    page: 1,
                    limit: 10,
                    total: 0
                },
                statusList:[
                    {id:1,name:'正常'},
                    {id:0,name:'禁用'}
                ],
                timers:[],
                tableData:[]
            }
        },
        methods:{
            // 表格序列号
            getIndex($index) {
                // (当前页 - 1) * 当前显示数据条数 + 当前行数据的索引 + 1
                return (this.pageparm.page-1)*this.pageparm.limit + $index +1
            },
            setFull(){
                this.isFull=!this.isFull
            },
            showvideohandle(url) {
              this.$alert(
                `<video width="320" height="240" controls>
                              <source src="${url}"  type="video/mp4">
                              您的浏览器不支持 HTML5 video 标签。
                            </video>`,
                "视频预览",
                {
                  dangerouslyUseHTMLString: true
                }
              );
            },
            //当渲染的文字超出9字后显示省略号
            ellipsis(value) {
                // value = value.replace(/<.*?>/ig,"")       //把v-html的格式标签替换掉
                if(!value) return ""
                if (value.length > 10) {
                    return value.slice(0, 10) + "..."
                }else{
                    return value
                }
                // return value
            },
            //多选项框被选中数据
            handleSelectionChange(selection) {
                this.ids = selection.map(item => item.id);
                this.single = selection.length !== 1;
                this.multiple = !selection.length;
            },
            /** 批量删除按钮操作 */
            handleDelete(row) {
                const ids = this.ids;
                let vm = this
                vm.$confirm('是否确认删除选中的数据项?', "警告", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning"
                }).then(function() {
                    return platformsettingsOtherDelete({id:ids}).then(res=>{
                        if(res.code == 2000) {
                            vm.$message.success(res.msg)
                            vm.search()
                        } else {
                            vm.$message.warning(res.msg)
                        }
                    })
                })
            },
            changeStatus(row) {
                // console.log(row,'row----')
            },
            addModule() {
                this.$refs.AddModuleFlag.addModuleFn(null,'新增')
            },
            handleEdit(row,flag) {
                if(flag=='edit') {
                    this.$refs.AddModuleFlag.addModuleFn(row,'编辑')
                }
                else if(flag=='delete') {
                    let vm = this
                    vm.$confirm('确定删除该数据吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        platformsettingsOtherDelete({id:row.id}).then(res=>{
                            if(res.code == 2000) {
                                vm.$message.success(res.msg)
                                vm.search()
                            } else {
                                vm.$message.warning(res.msg)
                            }
                        })
                    }).catch(()=>{

                    })
                }
            },
            //关闭前端方法开始----------------
            getSuperOperate(){
                let vm = this
                superOerateGet().then(res => {
                     if(res.code ==2000) {
                         vm.is_allow_fronted = res.data.data.is_allow
                     }else{
                         vm.$message.warning("获取前端访问权限失败")
                     }
                 })
            },
            handleSuperOperate(){
                let vm = this
                let flat = vm.is_allow_fronted
                vm.is_allow_fronted = !vm.is_allow_fronted
                let temp_is_allow = 1
                vm.$confirm('确定要改变前端访问状态吗？',{
                        closeOnClickModal:false
                    }).then(res=>{
                        flat ? vm.is_allow_fronted = true : vm.is_allow_fronted = false
                        if(vm.is_allow_fronted){
                            temp_is_allow = 1
                        }else{
                            temp_is_allow = 0
                        }
                        superOerateSet({is_allow:temp_is_allow}).then(res => {
                             if(res.code ==2000) {
                                 vm.is_allow_fronted = res.data.data.is_allow
                                 vm.$message.warning(res.msg)
                             }else{
                                 flat ? vm.is_allow_fronted = false : vm.is_allow_fronted = true
                                 vm.$message.warning(res.msg)
                             }
                         })
                    }).catch(()=>{

                    })
            },
            //关闭前端方法结束----------------
            callFather(parm) {
                this.formInline.page = parm.page
                this.formInline.limit = parm.limit
                this.getData()
            },
            search() {
                this.formInline.page = 1
                this.formInline.limit = 10
                this.getData()
            },
            //获取列表
            async getData(){
                this.loadingPage = true
                platformsettingsOther(this.formInline).then(res => {
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
               this.tableHeight =  getTableHeight(this.$refs.tableSelect.offsetHeight)
            }
        },
        created() {
            this.getData()
            this.getSuperOperate()
        },
        timers(val){
            if (val) {
                this.formInline.beginAt=dateFormats(val[0],'yyyy-MM-dd hh:mm:ss');
                this.formInline.endAt=dateFormats(val[1],'yyyy-MM-dd hh:mm:ss');
            } else {
                this.formInline.beginAt = ''
                this.formInline.endAt = ''
            }
            this.getData()
        },
        mounted() {
            // 监听页面宽度变化搜索框的高度
            window.addEventListener('resize', this.listenResize);
            this.$nextTick(() => {
              this.getTheTableHeight()
            })
        },
        unmounted() {
              // 页面销毁，去掉监听事件
			window.removeEventListener("resize", this.listenResize);
        },
    }
</script>
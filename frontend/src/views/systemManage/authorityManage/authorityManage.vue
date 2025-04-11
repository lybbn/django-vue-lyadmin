<template>
    <div style="overflow-y: hidden;">
        <el-form>
        <div class="auth-outer">
            <div>
                <div class="auth-item" style="width: 320px;height: 300px">
                    <div class="auth-item-header">
                        <el-tag size="large" style="font-size: 13px" type="primary">当前选择:{{ roleObj.name ? roleObj.name : "无" }}</el-tag>
                        <el-button type="primary"  @click="submitPermisson" size="default">保存</el-button>
                    </div>
                    <el-scrollbar>
                        <div style="margin: 10px 0px 50px 0px;">
                            <el-form-item>
                                <el-tree
                                    class="filter-tree"
                                    :data="data"
                                    :highlight-current="true"
                                    :props="{ label: 'name' }"
                                    default-expand-all
                                    :filter-node-method="filterNode"
                                    @node-click="nodeClick"
                                    node-key="node_id"
                                    ref="tree"/>
                            </el-form-item>
                        </div>
                    </el-scrollbar>
                </div>
                <div class="auth-item" style="height: calc(100vh - 420px);">
                    <el-scrollbar>
                        <div class="auth-title">
                            数据授权：
                            <el-tooltip
                                class="item"
                                effect="dark"
                                content="授权用户可操作的数据范围"
                                placement="right">
                                <el-icon><question-filled /></el-icon>
                            </el-tooltip>
                        </div>
                        <el-select
                                size="large"
                                v-show="roleObj.name"
                                v-model="roleObj.data_range"
                                @change="dataScopeSelectChange" style="width: 90%;margin: 10px auto;display: block;">
                            <el-option
                                v-for="item in dataScopeOptions"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                            </el-option>
                        </el-select>
                        <div style="margin-bottom: 50px" v-show="roleObj.data_range === 4">
                            <el-form-item>
                                <el-tree
                                class="tree-border"
                                :data="deptOptions"
                                show-checkbox
                                default-expand-all
                                :default-checked-keys="deptCheckedKeys"
                                ref="dept"
                                node-key="id"
                                size="small"
                                :check-strictly="true"
                                :props="{ label: 'name',children: 'children', disabled: 'disabled'}"/>
                            </el-form-item>
                        </div>
                    </el-scrollbar>
                </div>
            </div>
            <div class="auth-item" style="height: calc(100vh - 120px);">
                <div class="auth-title">
                    菜单授权：
                    <el-tooltip
                        effect="dark"
                        content="授权用户在菜单中可操作的范围"
                        placement="right">
                        <el-icon><question-filled /></el-icon>
                    </el-tooltip>
                </div>
                <el-scrollbar>
                    <div style="margin: 20px 20px 90px 20px;" >
                        <el-form-item>
                            <el-tree
                                class="lymenupermisson"
                                ref="menuTree"
                                :data="menuOptions"
                                node-key="id"
                                default-expand-all
                                show-checkbox
                                :expand-on-click-node="false"
                                :check-on-click-leaf="false"
                                :default-checked-keys="menuCheckedKeys"
                                :check-on-click-node="false"
                                :check-strictly="true"
                                empty-text="请先选择角色"
                                @check-change="handleCheckClick">
                                 <template v-slot="{ node, data }">
                                      <span class="custom-tree-node" >
                                        <div class="menu-data">
                                          <div :style="{width:((4-node.level)*18+118)+'px'}">{{ data.name }}</div>
                                          <div>
                                            <el-checkbox
                                                v-for="(item, index) in data.menuPermission"
                                                :key="index"
                                                v-model="item.checked">{{ item.name }}</el-checkbox>
                                          </div>
                                        </div>
                                      </span>
                                 </template>
                            </el-tree>
                        </el-form-item>
                    </div>
                </el-scrollbar>
            </div>
        </div>
        </el-form>
    </div>
</template>

<script>
    import {apiSystemRole,apiSystemRoleAdd,apiSystemDeptTree,apiSystemRoleIdToMenuid, apiSystemDept,apiSystemRoleEdit,apiPermissionSave} from '@/api/api'
    import XEUtils from 'xe-utils'
    export default {
        name: "authorityManage",
        data() {
            return {
                filterText: '',
                activeName:'',
                menuOptions: [],
                menuCheckedKeys: [], // 菜单默认选中的节点
                deptOptions:[],
                deptCheckedKeys:[],
                data: [],
                roleObj: {
                    name: null,
                    data_range: null
                },
                loadingPage:false,
                optionsData:[],
                optionsDataAll:[],
                dataScopeOptions: [
                    {
                        value: 0,
                        label: '仅本人数据权限'
                    },
                    {
                        value: 1,
                        label: '本部门数据权限'
                    },
                    {
                        value: 2,
                        label: '本部门及以下数据权限'
                    },
                    {
                        value: 3,
                        label: '全部数据权限'
                    },
                    {
                        value: 4,
                        label: '自定义数据权限'
                    }
                ],
            }
        },
        created() {
            this.pageRequest()
        },
        methods:{
            // 获取角色
            pageRequest (query) {
                let params = {page:1,limit:999,...query}
                return apiSystemRole(params).then((res) => {

                    // res.map((value, index) => {
                    //     value.node_id = index
                    // })
                    this.data = res.data.data
                    this.data.map((value, index) => {
                            value.node_id = index
                        })
                    this.$nextTick().then(() => {
                        this.initNode()
                    })
                })
            },
            initNode () {
                if (history.state.id && this.$refs.tree) {
                    this.data.map((value) => {
                        if (history.state.id === value.id) {
                            this.node_id = value.node_id
                        }
                    })
                    const node = this.$refs.tree.getNode(this.node_id)
                    this.$refs.tree.setCurrentKey(node)
                    this.nodeClick(node.data, node)
                }
            },
            // 部门数据
            getapiSystemDept(){
                apiSystemDept().then(res=>{
                    if(res.code ==2000) {
                        this.optionsDataAll = res.data.data.length > 0 ? res.data.data : []
                        let childrenList = res.data.data.filter(item=> item.parent)
                        let parentList = res.data.data.filter(item=> !item.parent)
                        if(parentList.length >0) {
                            parentList.forEach(item=>{
                                let children = childrenList.filter(itema=>itema.parent == item.id)
                                item.children=[...children]
                            })
                        }
                        this.optionsData = parentList
                        //console.log(this.optionsData,'this.optionsData----')
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            },

            // 提交修改
            submitPermisson() {
                this.roleObj.menu = this.getMenuAllCheckedKeys() // 获取选中的菜单
                this.roleObj.dept = this.getDeptAllCheckedKeys() // 获取选中的部门
                const menuData = XEUtils.toTreeArray(this.menuOptions)
                const permissionData = []
                menuData.forEach((x) => {
                    const checkedPermission = x.menuPermission.filter((f) => {
                        return f.checked
                    })

                    if (checkedPermission.length > 0) {
                        for (const item of checkedPermission) {
                            permissionData.push(item.id)
                        }
                    }
                })
                this.roleObj.permission = permissionData

                this.updateRequest(this.roleObj)
            },
            updateRequest (row) {
                apiPermissionSave(row).then(res=>{
                    if(res.code ==2000) {
                        this.$message.success(res.msg)
                        this.pageRequest()
                    } else {
                        this.$message.warning(res.msg)
                    }
                })
            },
            // 获取菜单数据
            getMenuData (data) {
                apiSystemRoleIdToMenuid(data.id).then((res) => {
                    res.data.data.forEach((x) => {
                        // 根据当前角色的permission,对menuPermisson进行勾选处理
                        x.menuPermission.forEach((a) => {
                            if (data.permission.indexOf(a.id) > -1) {
                                // this.$set(a, 'checked', true)
                                // a.checked = true
                                a.checked = true
                            } else {
                                // this.$set(a, 'checked', false)
                                a.checked = false
                            }
                        })
                    })
                    // 将菜单列表转换为树形列表
                    this.menuOptions = XEUtils.toArrayTree(res.data.data, { parentKey: 'parent' })
                    // console.log(this.menuOptions,"menuOptions---"	)
                })
            },

            // 所有勾选菜单节点数据
            getMenuAllCheckedKeys () {
                // 目前被选中的菜单节点
                const checkedKeys = this.$refs.menuTree.getCheckedKeys()
                // 半选中的菜单节点
                const halfCheckedKeys = this.$refs.menuTree.getHalfCheckedKeys()
                checkedKeys.unshift.apply(checkedKeys, halfCheckedKeys)
                return checkedKeys
            },
            // 所有自定义权限时,勾选的部门节点数据
            getDeptAllCheckedKeys () {
                // 目前被选中的部门节点
                const checkedKeys = this.$refs.dept.getCheckedKeys()
                // 半选中的部门节点
                const halfCheckedKeys = this.$refs.dept.getHalfCheckedKeys()
                checkedKeys.unshift.apply(checkedKeys, halfCheckedKeys)
                return checkedKeys
            },
            filterNode (value, data) {
                if (!value) return true
                return data.label.indexOf(value) !== -1
            },
            // 获取部门数据
            getDeptData () {
                apiSystemDept({page:1,limit:9999}).then((res) => {
                     res.data.data.forEach(item=>{
                         item.disabled=false
                     })
                    // this.deptOptions = ret.data.data
                    // 将列表数据转换为树形数据
                    this.deptOptions = XEUtils.toArrayTree(res.data.data, { parentKey: 'parent', strict: false })
                })
            },
            // 角色树被点击
            nodeClick (data, node, self) {
                this.menuOptions = []
                this.roleObj = data
                this.getDeptData()
                this.getMenuData(data)
                this.menuCheckedKeys = data.menu // 加载已勾选的菜单
                this.deptCheckedKeys = data.dept
            },
            /** 选择角色权限范围触发 */
            dataScopeSelectChange (value) {
                if (value !== 4) {
                    // this.$refs.dept.setCheckedKeys([]);
                }
            },
            /**
             * 菜单树点击,全选权限部分数据
             * @param data
             */
            handleCheckClick(data, checked) {
                // console.log(data)
                // console.log(checked)
              const {
                menuPermission,
                children
              } = data
              for (let item of menuPermission) {
                // this.$set(item, 'checked', checked)
                  item.checked=checked
              }
              if (children) {
                for (let item of children) {
                  this.$refs.menuTree.setChecked(item.id, checked)
                }
              }
            },

        },
        watch: {
            filterText (val) {
                this.$refs.tree.filter(val)
            }
        },
    }
</script>

<style lang="scss" scoped>
    .el-tree{
        width: 100%;
    }
    .auth-title{
        display: flex;
        font-size: 15px;
        background: var(--l-headertitle-bg);
        padding: 15px;
        .el-tooltip{
            cursor: pointer;
        }
    }
    .custom-tree-node{
        .menu-data{
            display: flex;
            margin: 10px 0;
        }
    }
    .auth-outer{
        display: flex;
        column-gap: 10px;
        .auth-item{
            flex: 1;
            background: var(--el-bg-color);
            /*&:last-child{*/
            /*    flex: 2;*/
            /*}*/
            .auth-item-header{
                background: var(--l-headertitle-bg);
                padding: 6.5px 15px;
                display: flex;
                justify-content: space-between;
            }
        }
    }
    .filter-tree{
        ::v-deep(.el-tree-node__content){
            height: 40px;
        }
    }
    .lymenupermisson{
        ::v-deep(.el-tree-node__content){
            height: 30px;
        }
    }
</style>

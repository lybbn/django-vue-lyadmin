<template>
    <div>
        <el-table :data="formList" ref="tableref" v-loading="loadingPage" style="width: 100%">
            <el-table-column min-width="100" label="名称">
                <template #default="scope">
                    <el-input v-if="scope.row.edit" v-model="scope.row.title" placeholder="请输入名称"></el-input>
                    <span v-else>{{scope.row.title}}</span>
                </template>
            </el-table-column>
            <el-table-column min-width="300" prop="avatar" label="变量值">
                <template #default="scope">
                    <!--    文本      -->
                    <el-input :key="scope.row.id" v-if="['text','textarea'].indexOf(scope.row.form_item_type_label) >-1"
                            :type="scope.row.form_item_type_label"
                            v-model="form[scope.row.key]" :placeholder="scope.row.placeholder" clearable></el-input>

                    <el-input-number :key="scope.row.id" v-else-if="scope.row.form_item_type_label === 'number'" v-model="form[scope.row.key]"
                                   :min="0"></el-input-number>
                    <!--     datetime、date、time     -->
                    <el-date-picker
                        v-else-if="['datetime','date','time'].indexOf(scope.row.form_item_type_label) >-1"
                        v-model="form[scope.row.key]"
                        :key="scope.row.id"
                        :type="scope.row.form_item_type_label"
                        :placeholder="scope.row.placeholder">
                    </el-date-picker>
                    <!--    select      -->
                    <el-select
                        :key="scope.row.id"
                        v-else-if="scope.row.form_item_type_label === 'select'"
                        v-model="form[scope.row.key]"
                        :placeholder="scope.row.placeholder"
                        clearable
                    >
                    <el-option
                        v-for="item in scope.row.setting || []"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                  </el-select>
                    <!--    checkbox      -->
                    <el-checkbox-group
                        :key="scope.row.id"
                        v-else-if="scope.row.form_item_type_label === 'checkbox'"
                        v-model="form[scope.row.key]"
                        :placeholder="scope.row.placeholder"
                    >
                        <el-checkbox
                            v-for="item in dictionary(scope.row.setting)  || []"
                            :key="item.value"
                            :label="item.value"
                            :value="item.value">
                            {{ item.label }}
                        </el-checkbox>
                    </el-checkbox-group>
                  <!--    radio      -->
                  <el-radio-group
                    :key="scope.row.id"
                    v-else-if="scope.row.form_item_type_label === 'radio'"
                    v-model="form[scope.row.key]"
                    :placeholder="scope.row.placeholder"
                    clearable
                  >
                    <el-radio
                      v-for="item in scope.row.setting  || []"
                      :key="item.value"
                      :label="item.value"
                      :value="item.value">
                      {{ item.label }}
                    </el-radio>
                  </el-radio-group>
                  <!--    switch      -->
                  <el-switch
                    :key="scope.row.id"
                    v-else-if="scope.row.form_item_type_label === 'switch'"
                    v-model="form[scope.row.key]"
                    active-color="#13ce66"
                    inactive-color="#ff4949">
                  </el-switch>
                  <!--     图片     -->
                  <div v-else-if="scope.row.form_item_type_label === 'image'" :key="scope.row.id">
                      <ly-upload-avatar  v-model="form[scope.row.key]" :width="'100px'" :height="'100px'"></ly-upload-avatar>
                  </div>
                  <!--     富文本     -->
                  <TEditor v-else-if="scope.row.form_item_type_label === 'richtext'" v-model="form[scope.row.key]" :style="{height:'200'}"></TEditor>
                </template>
            </el-table-column>
            <el-table-column min-width="130" prop="avatar" label="变量名">
                <template #default="scope">
                    <el-input v-if="scope.row.edit" v-model="scope.row.new_key" style="width: 200px;" placeholder="请输入变量key">
                        <template #prepend>
                            <span style="padding: 0px 5px">{{ editableTabsItem.key }}</span>
                        </template>
                    </el-input>
                    <span v-else>{{ editableTabsItem.key }}.{{ scope.row.key }}</span>
                </template>
            </el-table-column>
            <el-table-column label="操作" fixed="right" width="180">
                <template #default="scope">
                    <span v-if="scope.row.edit" class="table-operate-btn" @click="onEditSave(scope.row)" v-show="hasPermission(this.$route.name,'Update')">保存</span>
                    <span v-if="scope.row.edit" class="table-operate-btn" @click="onEditCancel(scope.$index)" v-show="hasPermission(this.$route.name,'Update')">取消</span>
                    <span v-else class="table-operate-btn" @click="onEdit(scope.$index)"  v-show="hasPermission(this.$route.name,'Update')">编辑</span>
                    <el-popconfirm title="确定删除该条数据吗？" @confirm="onDelRow(scope.row)">
                        <template #reference>
                            <span class="table-operate-btn" v-show="hasPermission(this.$route.name,'Delete')">删除</span>
                        </template>
                    </el-popconfirm>
                </template>
            </el-table-column>
         </el-table>
        <el-button type="primary" @click="onSubmit" style="margin-top: 20px;text-align: center" v-show="hasPermission(this.$route.name,'Save')">保存配置</el-button>
    </div>
</template>

<script>
    import {platformsettingsSysconfig,platformsettingsSysconfigDelete,platformsettingsSysconfigEdit,platformsettingsSysconfigSavecontent} from '@/api/api'
    import TEditor from '@/components/TEditor'
    import LyUploadAvatar from "@/components/upload/avatar"
    export default {
        name: 'formItem',
        components: {
            TEditor,
            LyUploadAvatar
        },
        props: {
        options: {
            type: Object
        },
        editableTabsItem: {
            type: Object
        }
        },
        watch: {
          options: {
              handler (nv) {
                  if (nv && nv.id) {
                      this.getInit()
                  }
              },
              immediate: true
            }
        },
        data () {
        return {
            loadingPage:false,
            formList: [],
            form: {},
            childTableData: [],
            childRemoveVisible: false,
            validRules: {
                title: [
                    {
                        required: true,
                        message: '必须填写'
                    }
                ],
                key: [
                    {
                        required: true,
                        message: '必须填写'
                    }
                ],
                value: [
                    {
                        required: true,
                        message: '必须填写'
                    }
                ]
            },
        }
        },
        methods: {
        // 获取数据
        getInit () {
            const that = this
            platformsettingsSysconfig({ parent: this.options.id, limit: 999 }).then(res => {
                const { data } = res.data
                this.formList = data
                const form = {}
                for (const item of data) {
                    const key = item.key
                    if (item.value) {
                        form[key] = item.value
                    } else {
                        if ([5, 12].indexOf(item.form_item_type) !== -1) {
                            form[key] = []
                        } else {
                            form[key] = undefined
                        }
                    }
                    if (item.form_item_type_label === 'array') {
                        that.$nextTick(() => {
                            const tableName = 'xTable_' + key
                            const $table = this.$refs[tableName][0]
                            $table.loadData(item.chinldern)
                        })
                    }
                }
                this.form = JSON.parse(JSON.stringify(form))
            })
        },
        // 提交数据
        onSubmit () {
            const that = this
            const form = JSON.parse(JSON.stringify(this.form))
            const keys = Object.keys(form)
            const values = Object.values(form)
            for (const index in this.formList) {
                const item = this.formList[index]
                const form_item_type_label = item.form_item_type_label
                if (form_item_type_label === 'array') {
                    const parentId = item.id
                    const tableName = 'xTable_' + item.key
                    const $table = this.$refs[tableName][0]
                    const { tableData } = $table.getTableData()
                    for (const child of tableData) {
                        if (!child.id && child.key && child.value) {
                            child.parent = parentId
                            child.id = null
                            this.formList.push(child)
                        }
                    }
                    // 必填项的判断
                    for (const arr of item.rule) {
                        if (arr.required && tableData.length === 0) {
                            that.$message.error(item.title + '不能为空')
                            return
                        }
                    }
                    item.value = tableData
                }
                // 赋值操作
                keys.map((mapKey, mapIndex) => {
                    if (mapKey === item.key) {
                        if (item.form_item_type_label !== 'array') {
                            item.value = values[mapIndex]
                        }
                    }
                })
          }

        let params = this.formList
        params.id = this.options.id
        platformsettingsSysconfigSavecontent(params).then(res => {
              if(res.code == 2000){
                  this.$message.success('保存成功')
                  this.getInit()
              }else{
                  this.$message.warning(res.msg)
              }

        })
        },
        // 配置的行删除
        onDelRow (obj) {
            platformsettingsSysconfigDelete(obj.id).then(res => {
                if(res.code == 2000){
                    this.getInit()
                }else{
                    this.$message.warning(res.msg)
                }
            })
        },
        // 行编辑
        onEdit (index) {
            const that = this
            that.formList[index].new_key= that.formList[index].key
            that.formList[index].edit = true
        },
        onEditCancel(index){
            const that = this
            that.formList[index].new_key= that.formList[index].key
            that.formList[index].edit = false
        },
        // 行编辑保存
        onEditSave (obj) {
            obj.value = this.form[obj.key]
            obj.key = JSON.parse(JSON.stringify(obj.new_key))
            platformsettingsSysconfigEdit(obj).then(res => {
                if(res.code == 2000){
                    this.getInit()
                }else{
                    this.$message.warning(res.msg)
                }
            })
        }
        },
        mounted () {
        }
    }
</script>

<style lang="scss" scoped>
    ::v-deep(.el-table .el-table__cell){
        z-index: unset !important;
    }
    ::v-deep(.tox .tox-editor-header){
         z-index: unset !important;
    }
</style>

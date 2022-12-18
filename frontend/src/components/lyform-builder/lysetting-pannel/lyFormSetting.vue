<template>
    <div>
        <el-form :model="formConfig" size="small" label-position="left" label-width="100px" class="lyformsetting" @submit.prevent>
            <el-collapse v-model="lyCollapseActiveList" class="lyformsetting-collapse">
                <el-collapse-item name="lyfs01" title="基本属性">
                    <el-form-item label="表单尺寸">
                        <el-select v-model="formConfig.size" @change="handleChange">
                            <el-option v-for="item in formSizes" :key="item.value" :label="item.label"
                            :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="标签位置">
                        <el-radio-group v-model="formConfig.labelPosition" class="radio-group-custom" @change="handleChange">
                            <el-radio-button label="left">左边</el-radio-button>
                            <el-radio-button label="right">右边</el-radio-button>
                            <el-radio-button label="top">顶部</el-radio-button>
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item label="标签宽度(px)" @change="handleChange">
                        <el-input v-model="formConfig.labelWidth"  style="width: 100%"></el-input>
                    </el-form-item>
                    <el-form-item label="表单全局CSS">
                        <el-button type="info" icon="edit" plain round @click="editFormCss">编写CSS</el-button>
                    </el-form-item>
                    <el-form-item label="自定义CSS样式">
                        <el-select v-model="formConfig.customClass" multiple filterable allow-create default-first-option>
                            <el-option v-for="(item, idx) in cssClassList" :key="idx" :label="item" :value="item"></el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="表单全局方法">
                        <el-button type="info" icon="edit" plain round @click="editGlobalFunctions">编写代码</el-button>
                    </el-form-item>
                    <el-form-item label-width="0">
                        <el-divider>生成SFC设置</el-divider>
                    </el-form-item>
                    <el-form-item label="数据对象名称">
                        <el-input type="text" v-model="formConfig.modelName"></el-input>
                    </el-form-item>
                    <el-form-item label="引用名称">
                        <el-input type="text" v-model="formConfig.refName"></el-input>
                    </el-form-item>
                    <el-form-item label="验证规则名称">
                        <el-input type="text" v-model="formConfig.rulesName"></el-input>
                    </el-form-item>
                </el-collapse-item>

                <el-collapse-item v-if="showEventCollapse()" name="lyfs02" title="事件属性">
                    <el-form-item label="onFormCreated" label-width="150px">
                        <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onFormCreated')">编写代码</el-button>
                    </el-form-item>
                    <el-form-item label="onFormMounted" label-width="150px">
                        <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onFormMounted')">编写代码</el-button>
                    </el-form-item>
                    <el-form-item label="onFormDataChange" label-width="150px">
                        <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onFormDataChange')">编写代码</el-button>
                    </el-form-item>
                </el-collapse-item>
            </el-collapse>
        </el-form>
    </div>
</template>

<script setup>
    import {ref, onMounted, reactive, computed, nextTick, watch} from 'vue'
    import { useBuilderStore } from "@/store/lyFormBuilder";

    const props = defineProps({
        formConfig: Object
    })

    let lyCollapseActiveList =  ref([])
    const formSizes = ref([
        {label: 'default', value: ''},
        {label: 'large', value: 'large'},
        {label: 'small', value: 'small'},
    ])
    let cssClassList = ref([])
    let formCssCode = ref("")
    let showEditFormCssDialogFlag = ref(false)

    const builderStore = useBuilderStore()

    function handleChange(newValue) {
         builderStore.saveCurrentHistoryStep()
    }

    function editFormCss() {
        formCssCode.value = builderStore.formConfig.cssCode
        showEditFormCssDialogFlag.value = true
    }

    function showEventCollapse(){
        if (builderStore.builderConfig['showEventCollapse'] === undefined) {
          return true
        }
        return !!builderStore.builderConfig['showEventCollapse']
    }
    function editGlobalFunctions() {

    }
    function editFormEventHandler(flag){

    }

    onMounted(() => {
        lyCollapseActiveList.value = ['lyfs01','lyfs02']
    })

</script>

<style lang="scss" scoped>
    .lyformsetting{
        ::v-deep(.el-form-item__label) {
          font-size: 13px;
          overflow: hidden;
          white-space: nowrap;
        }
        .lyformsetting-collapse{
            ::v-deep(.el-collapse-item__header) {
                font-weight: bold;
            }
        }
    }
</style>
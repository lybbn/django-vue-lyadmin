<template>
    <div>
        <el-form size="small" label-position="left" label-width="100px" class="lywidgetsetting" @submit.prevent>
            <el-form-item label="字段标识">
                <el-input  v-model="optionModel.name" @change="handleChange"></el-input>
            </el-form-item>
            <el-form-item label="隐藏">
                <el-switch v-model="optionModel.hidden" @change="handleChange"></el-switch>
            </el-form-item>
            <el-form-item label="禁用">
                <el-switch v-model="optionModel.disabled" @change="handleChange"></el-switch>
            </el-form-item>
            <el-form-item label="只读">
                <el-switch v-model="optionModel.readonly" @change="handleChange"></el-switch>
            </el-form-item>
            <el-form-item label="可清除">
                <el-switch v-model="optionModel.clearable" @change="handleChange"></el-switch>
            </el-form-item>
            <el-form-item label="标签文本">
                <el-input v-model="optionModel.label"  style="width: 100%" @change="handleChange"></el-input>
            </el-form-item>
            <el-form-item label="标签宽度">
                <el-input v-model="optionModel.labelWidth"  style="width: 100%" @change="handleChange"></el-input>
            </el-form-item>
            <el-form-item label="隐藏字段标签">
                <el-switch v-model="optionModel.labelHidden" @change="handleChange"></el-switch>
            </el-form-item>
            <el-form-item label="显示类型">
                <el-select v-model="optionModel.type" @change="handleChange">
                    <el-option label="text" value="text"></el-option>
                    <el-option label="password" value="password"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="默认值">
                <el-input v-model="optionModel.defaultValue"  style="width: 100%" @change="handleChange"></el-input>
            </el-form-item>
            <el-form-item label="占位提示">
                <el-input v-model="optionModel.placeholder"  style="width: 100%" @change="handleChange"></el-input>
            </el-form-item>
            <el-form-item label="行数">
                <el-input-number :min="1" v-model="optionModel.rows" style="width: 100%" @change="handleChange"></el-input-number>
            </el-form-item>
            <el-form-item label="组件大小">
                <el-select v-model="optionModel.size" @change="handleChange">
                    <el-option v-for="item in formSizes" :key="item.value" :label="item.label"
                    :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="必填字段">
                <el-switch v-model="optionModel.required" @change="handleChange"></el-switch>
            </el-form-item>
            <validationCommonLy :selected-widget="selectedWidget" :option-model="optionModel"></validationCommonLy>
            <el-form-item label="校验失败提示">
                <el-input v-model="optionModel.validationHint"  style="width: 100%" @change="handleChange"></el-input>
            </el-form-item>
            <el-form-item label-width="0">
                <el-divider>高级属性</el-divider>
            </el-form-item>
            <el-form-item label="最小输入长度">
                <el-input-number :min="1" v-model="optionModel.minLength" style="width: 100%" @change="handleChange"></el-input-number>
            </el-form-item>
            <el-form-item label="最大输入长度">
                <el-input-number :min="1" v-model="optionModel.maxLength" style="width: 100%" @change="handleChange"></el-input-number>
            </el-form-item>
            <el-form-item label="显示统计字数">
                <el-switch v-model="optionModel.showWordLimit" @change="handleChange"></el-switch>
            </el-form-item>
            <div v-if="showEventCollapse">
                <el-form-item label-width="0">
                    <el-divider>事件属性</el-divider>
                </el-form-item>
                <el-form-item label="onCreated" label-width="150px">
                    <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onCreated')">编写代码</el-button>
                </el-form-item>
                <el-form-item label="onMounted" label-width="150px">
                    <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onMounted')">编写代码</el-button>
                </el-form-item>
                <el-form-item label="onInput" label-width="150px">
                    <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onInput')">编写代码</el-button>
                </el-form-item>
                <el-form-item label="onChange" label-width="150px">
                    <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onChange')">编写代码</el-button>
                </el-form-item>
                <el-form-item label="onFocus" label-width="150px">
                    <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onFocus')">编写代码</el-button>
                </el-form-item>
                <el-form-item label="onBlur" label-width="150px">
                    <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onBlur')">编写代码</el-button>
                </el-form-item>
                <el-form-item label="onValidate" label-width="150px">
                    <el-button type="info" icon="edit" plain round @click="editFormEventHandler('onValidate')">编写代码</el-button>
                </el-form-item>
            </div>
        </el-form>
    </div>
</template>

<script setup>
    import {ref, onMounted, reactive, computed, watch} from 'vue'
    import { useBuilderStore } from "@/store/lyFormBuilder";
    import validationCommonLy from "@/components/lyform-builder/lysetting-pannel/lywidget-common/validation-common-ly"
    const props = defineProps({
        selectedWidget: Object,
        optionModel: Object,
    })
    const builderStore = useBuilderStore()
    function handleChange(newValue) {
         builderStore.saveCurrentHistoryStep()
    }
     const formSizes = ref([
        {label: 'default', value: ''},
        {label: 'large', value: 'large'},
        {label: 'small', value: 'small'},
    ])
    function showEventCollapse(){
        if (builderStore.builderConfig['showEventCollapse'] === undefined) {
          return true
        }
        return !!builderStore.builderConfig['showEventCollapse']
    }
    function editFormEventHandler(flag){

    }

</script>

<style lang="scss" scoped>
    .lywidgetsetting{
        margin-top: 20px;
        ::v-deep(.el-form-item__label) {
          font-size: 13px;
          overflow: hidden;
          white-space: nowrap;
        }
    }

</style>
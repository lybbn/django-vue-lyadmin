<template>
    <el-form-item>
        <template #label>
            <span style="display: flex;align-items: center;">字段校验
                <el-tooltip effect="dark" content="支持正则表达式" >
                    <svg-icon icon-class="InfoFilled" style="margin-left: 5px"/>
                </el-tooltip>
            </span>
        </template>
        <el-select v-model="optionModel.validation" filterable clearable allow-create default-first-option @change="handleChange">
            <el-option v-for="(item, index) in fieldValidators"
                     :key="index"
                     :label="item.label"
                     :value="item.value">
            </el-option>
        </el-select>
    </el-form-item>
</template>

<script setup>
    import {ref, reactive} from 'vue'
    import { useBuilderStore } from "@/store/lyFormBuilder";
    const props = defineProps({
        selectedWidget: Object,
        optionModel: Object,
    })
    const builderStore = useBuilderStore()
    const fieldValidators = ref(
        [
            {value: 'number', label: "数字"},
            {value: 'letter', label: "字母"},
            {value: 'letterAndNumber', label: "数字字母"},
            {value: 'mobilePhone', label: "手机号"},
            {value: 'email', label: "邮箱"},
            {value: 'url', label: "URL网址"},
            {value: 'noChinese', label: "非中文字符"},
            {value: 'chinese', label: "中文字符"},
        ],
    )
    function handleChange(newValue) {
         builderStore.saveCurrentHistoryStep()
    }
</script>

<style lang="scss" scoped>

</style>
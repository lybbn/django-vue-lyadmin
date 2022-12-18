<template>
    <form-item-wrapper-ly :field="field" :rules="rules" :design-state="designState"
                     :parent-widget="parentWidget" :parent-list="parentList" :index-of-parent-list="indexOfParentList"
                     :sub-form-row-index="subFormRowIndex" :sub-form-col-index="subFormColIndex" :sub-form-row-id="subFormRowId">
        <el-input ref="lyfieldEditor" v-model="fieldModel"
              :disabled="field.options.disabled" :readonly="field.options.readonly"
              :size="widgetSize"
              :type="inputType"
              :show-password="field.options.showPassword"
              :placeholder="field.options.placeholder"
              :clearable="field.options.clearable"
              :minlength="field.options.minLength" :maxlength="field.options.maxLength"
              :show-word-limit="field.options.showWordLimit"
              :prefix-icon="field.options.prefixIcon" :suffix-icon="field.options.suffixIcon"
              @focus="handleFocusCustomEvent" @blur="handleBlurCustomEvent" @input="handleInputCustomEvent"
              @change="handleChangeEvent">
            <template #prepend v-if="field.options.prependSlot">
                {{field.options.prependSlot}}
            </template>
            <template #append v-if="field.options.appendSlot">
                {{field.options.appendSlot}}
            </template>
        </el-input>
    </form-item-wrapper-ly>
</template>

<script setup>
    import {ref, onMounted, reactive, computed, watch} from 'vue'
    import { useBuilderStore } from "@/store/lyFormBuilder";

    const props = defineProps({
        field: Object,
        parentWidget: Object,
        parentList: Array,
        indexOfParentList: Number,
        designState: {
            type: Boolean,
            default: false
        },
        subFormRowIndex: { /* 子表单组件行索引，从0开始计数 */
            type: Number,
            default: -1
        },
        subFormColIndex: { /* 子表单组件列索引，从0开始计数 */
            type: Number,
            default: -1
        },
        subFormRowId: { /* 子表单组件行Id，唯一id且不可变 */
            type: String,
            default: ''
        },
        rules: Array,
    })
    const builderStore = useBuilderStore()
    const fieldModel = ref(null)
    let oldFieldValue = ref(null)  //field组件change之前的值
    let rules = ref([])
    const inputType = computed(() => {
        if (props.field.options.type === 'number') {
          return 'text'  //当input的type设置为number时，如果输入非数字字符，则v-model拿到的值为空字符串，无法实现输入校验！故屏蔽之！！
        }
        return props.field.options.type
    })
    const widgetSize = computed(() => {
        return props.field.options.size || 'default'
    })
    function handleFocusCustomEvent(event) {
        oldFieldValue.value = fieldModel.value //保存修改change之前的值
        if (!!props.field.options.onFocus) {
            let customFn = new Function('event', props.field.options.onFocus)
            customFn.call(event)
        }
    }
    function handleBlurCustomEvent(event) {
        if (!!props.field.options.onBlur) {
            let customFn = new Function('event', props.field.options.onBlur)
            customFn.call(event)
        }
    }
    function handleInputCustomEvent(value) {
        if (!!props.field.options.onInput) {
            let customFn = new Function('value', props.field.options.onInput)
            customFn.call(value)
        }
    }
    function handleChangeEvent(value) {
        oldFieldValue.value = value
    }

    function initFieldModel() {
        if (!props.field.formItemFlag) {
            return
        }
        fieldModel.value = props.field.options.defaultValue
        oldFieldValue.value = fieldModel.value
    }
    watch(()=>props.field.options.defaultValue,(n,o)=>{
        fieldModel.value = n
        oldFieldValue.value = fieldModel.value
    })

    onMounted(()=>{
        initFieldModel()
    })



</script>

<style lang="scss" scoped>

</style>
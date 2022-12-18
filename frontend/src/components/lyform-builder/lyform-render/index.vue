<!--
/**
 * author: lybbn
 * program django-vue-lyadmin
 * email: 1042594286@qq.com
 * website: http://www.lybbn.cn
 * date: 2022.11.17
 * remark: 如果要分发django-vue-lyadmin源码或其中组件等，需在本文件顶部保留此文件头信息！！！
 */
-->
<template>
    <el-form :label-position="labelPosition" :size="size" :class="[customClass]" class="lyrenderform" :label-width="labelWidth" :validate-on-rule-change="false" :model="formData" ref="renderForm" @submit.prevent>
        <template v-for="(widget, index) in widgetList">
            <template v-if="widget.category === 'container'">
                <component :is="getContainerWidgetName(widget)" :widget="widget" :key="widget.id" :parent-list="widgetList" :index-of-parent-list="index" :parent-widget="null" :design-state="false">
                    <template v-for="slot in Object.keys($slots)" v-slot:[slot]="scope">
                        <slot :name="slot" v-bind="scope"/>
                    </template>
                </component>
            </template>
            <template v-else>
                <component :is="getWidgetName(widget)" :field="widget" :design-state="false" :key="widget.id" :parent-list="widgetList" :index-of-parent-list="index" :parent-widget="null">
                    <template v-for="slot in Object.keys($slots)" v-slot:[slot]="scope">
                        <slot :name="slot" v-bind="scope"/>
                    </template>
                </component>
            </template>
        </template>
    </el-form>
</template>

<script setup>
    import {ref, onMounted ,reactive,watch,computed} from 'vue'

    const props = defineProps({
        formJson: { //prop传入的表单JSON配置
            type: Object,
            default: () => buildDefaultFormJson()
        },
        formData: { //prop传入的表单数据
            type: Object,
            default: () => ({})
        },
        optionData: { //prop传入的选项数据
            type: Object,
            default: () => ({})
        },
        previewState: { //是否表单预览状态
            type: Boolean,
            default: false
        }
    })
    let formData = ref({})

    function getContainerWidgetName(widget){
        return widget.type + '-widget-ly'
    }

    function getWidgetName(widget) {
        return widget.type + '-widget-ly'
    }
    const formConfig = computed(() => {
        return props.formJson.formConfig
    })
    const widgetList = computed(() => {
        return props.formJson.widgetList
    })
    const labelPosition = computed(() => {
        if (!!formConfig && !!formConfig.labelPosition) {
          return formConfig.labelPosition
        }
        return 'left'
    })
    const labelWidth = computed(() => {
        if (!!formConfig && !!formConfig.labelWidth) {
          return this.formConfig.labelWidth
        }
        return 'auto'
    })
    const size = computed(() => {
        if (!!formConfig && !!formConfig.size) {
          return formConfig.size
        }
        return 'default'
    })
    const customClass = computed(() => {
        return !!formConfig && !!formConfig.customClass ? formConfig.customClass : ''
    })

</script>

<style lang="scss" scoped>

</style>
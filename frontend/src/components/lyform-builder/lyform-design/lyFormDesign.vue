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
    <div>
        <el-scrollbar class="lyfd-scrow" :style="{height: scrollerHeight+'px'}">
            <el-form class="lyfd-form"  :validate-on-rule-change="false" :label-position="labelPosition"  :class="[customClass]" :size="size" :label-width="labelWidth">
                <div class="lyfd-drag" :style="{minHeight: scrollerHeight - 40+'px'}">
                    <template v-if="builderStore.widgetList.length === 0">
                        <el-empty class="ly-empty-text" description="从左侧选择组件添加" />
                    </template>
                    <draggable :list="builderStore.widgetList" item-key="id" tag="transition-group" group="lyDragGroup" ghostClass="lyformbuilder-ghost" animation="300" :component-data="{name: 'fade', type: 'transition'}" handle=".drag-handler" @end="handleDragEnd" @add="handleDragAdd" @update="handleDragUpdate" :move="handleMove">
                        <template #item="{ element: widget, index }">
                            <div>
                                <template v-if="widget.category === 'container'">
                                    <component :is="getWidgetName(widget)" :widget="widget" :key="widget.id" :parent-list="builderStore.widgetList" :index-of-parent-list="index" :parent-widget="null" :design-state="true"></component>
                                </template>
                                <template v-else>
                                    <component :is="getWidgetName(widget)" :field="widget" :key="widget.id" :parent-list="builderStore.widgetList" :index-of-parent-list="index" :parent-widget="null" :design-state="true"></component>
                                </template>
                            </div>
                        </template>
                    </draggable>
                </div>
            </el-form>
        </el-scrollbar>
    </div>
    
</template>

<script setup>
    import {ref, onMounted ,reactive,nextTick,onBeforeUnmount,watch,computed} from 'vue'
    import { useBuilderStore } from "@/store/lyFormBuilder";

    const props = defineProps({
        isFull:{
            type:Boolean,
            default:false
        }
    })

    const builderStore = useBuilderStore()
    const labelPosition = computed(()=>{
        if (!!builderStore.formConfig && !!builderStore.formConfig.labelPosition) {
            return builderStore.formConfig.labelPosition
        }
        return 'left'
    })
    const customClass = computed(()=>{
        return builderStore.formConfig.customClass || ''
    })
    const size = computed(()=>{
        if (!!builderStore.formConfig && !!builderStore.formConfig.size) {
          return builderStore.formConfig.size
        }
        return 'default'
    })
    const labelWidth= computed(()=>{
        if (!!builderStore.formConfig && !!builderStore.formConfig.labelWidth&&builderStore.formConfig.labelWidth!='auto') {
            return builderStore.formConfig.labelWidth+"px"
        }
        return 'auto'
    })


    function getWidgetName(widget) {
        return widget.type + '-widget-ly'
    }
    function disableFirefoxDefaultDrop() {
        let isFirefox = (navigator.userAgent.toLowerCase().indexOf("firefox") !== -1)
        if (isFirefox) {
            document.body.ondrop = function (event) {
                event.stopPropagation();
                event.preventDefault();
            }
        }
    }

    function handleDragEnd(e){
    }
    function handleDragAdd(e){
        const newIndex = e.newIndex
        if (!!builderStore.widgetList[newIndex]) {
            builderStore.setSelected(builderStore.widgetList[newIndex])
        }
        builderStore.emitHistoryChange()
    }
    function handleDragUpdate(e){
        builderStore.emitHistoryChange()
    }
    function handleMove(e){
        builderStore.handleWidgetMove(e)
    }

    let scrollerHeight = ref(0)

    function lyHandleResize(){
        nextTick(() => {
            if(props.isFull){
                scrollerHeight.value = window.innerHeight - 49
            }else{
                scrollerHeight.value = window.innerHeight - 160
            }

        })
    }
    watch(() => props.isFull, (n) => {
        lyHandleResize()
    })
    watch(()=>[builderStore.widgetList,builderStore.formConfig], (n,o) => {
        // console.log(n)

    },{deep: true})
    onMounted(()=>{
        builderStore.initBuilder()
        disableFirefoxDefaultDrop()
        builderStore.registerFormWidget()
        lyHandleResize()
        window.addEventListener('resize',lyHandleResize)
    })
    onBeforeUnmount(() => {
        window.removeEventListener('resize',lyHandleResize)
    })

</script>

<style lang="scss" scoped>
    .lyfd-scrow{
        height:100%;
        ::v-deep(.el-scrollbar__wrap){
            overflow-x: hidden;
        }
        .lyfd-form{
            overflow-x: hidden;
            overflow-y: hidden;
            background:var(--l-changetab-bg);
            margin: 10px;
            .lyfd-drag{
                padding: 10px;
                .ly-empty-text{
                    top: -10%;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    margin: auto;
                    position: absolute;
                    z-index: 100;
                }
            }
        }
    }
</style>
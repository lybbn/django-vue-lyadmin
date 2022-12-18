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
        <el-scrollbar class="lywp-scrow" :style="{height: scrollerHeight}">
            <div class="lywp-main">
                <el-tabs v-model = "lyTabValue" class="lywp-first-tabs" tab-position="left" :style="{height: scrollerHeight}">
                    <el-tab-pane name="lyfirst">
                        <template #label>
                            <span class="lycustom-tabs-label"><el-icon size="28"><SetUp /></el-icon><span>组件库</span></span>
                        </template>
                        <el-collapse class="lywp-collapse" v-model="lyCollapseActiveList">
                            <el-collapse-item name="lywpc01" title="容器">
                                <draggable tag="ul" :list="containers" item-key="key" :group="{name: 'lyDragGroup', pull: 'clone', put: false}" :clone="handleContainerClone" ghost-class="ghost" :sort="false" :move="handleContainerMove" @end="handleContainerEnd">
                                    <template #item="{ element: lycn }">
                                          <li class="lycontainer-widget-item" :title="lycn.displayName" @dblclick="handleContainerByDbClick(lycn)">
                                                <span class="lyflex-center lymarginleft2">
                                                    <svg-icon :icon-class="lycn.icon?lycn.icon:'Menu'" style="color:#409eff;font-size: 16px;"></svg-icon>
                                                    {{lycn.displayName}}
                                                </span>
                                          </li>
                                    </template>
                                </draggable>
                            </el-collapse-item>
                            <el-collapse-item name="lywpc02" title="基础组件">
                                <draggable tag="ul" :list="basicFields" item-key="key" :group="{name: 'lyDragGroup', pull: 'clone', put: false}" :clone="handleFieldClone" ghost-class="ghost" :sort="false" :move="handleFieldMove" @end="handleFieldEnd">
                                    <template #item="{ element: lycn }">
                                          <li class="lycontainer-widget-item" :title="lycn.displayName" @dblclick="handleFieldByDbClick(lycn)">
                                                <span class="lyflex-center lymarginleft2">
                                                    <svg-icon :icon-class="lycn.icon?lycn.icon:'Menu'" style="color:#409eff;font-size: 16px;"></svg-icon>
                                                    {{lycn.displayName}}
                                                </span>
                                          </li>
                                    </template>
                                </draggable>
                            </el-collapse-item>
                            <el-collapse-item name="lywpc03" title="高级组件">
                                <draggable tag="ul" :list="advancedFields" item-key="key" :group="{name: 'lyDragGroup', pull: 'clone', put: false}" :clone="handleFieldClone" ghost-class="ghost" :sort="false" :move="handleFieldMove" @end="handleFieldEnd">
                                    <template #item="{ element: lycn }">
                                          <li class="lycontainer-widget-item" :title="lycn.displayName" @dblclick="handleFieldByDbClick(lycn)">
                                                <span class="lyflex-center lymarginleft2">
                                                    <svg-icon :icon-class="lycn.icon?lycn.icon:'Menu'" style="color:#409eff;font-size: 16px;"></svg-icon>
                                                    {{lycn.displayName}}
                                                </span>
                                          </li>
                                    </template>
                                </draggable>
                            </el-collapse-item>
                            <el-collapse-item name="lywpc04" title="自定义组件">
                                <draggable tag="ul" :list="customFields" item-key="key" :group="{name: 'lyDragGroup', pull: 'clone', put: false}" :clone="handleFieldClone" ghost-class="ghost" :sort="false" :move="handleFieldMove" @end="handleFieldEnd">
                                    <template #item="{ element: lycn }">
                                          <li class="lycontainer-widget-item" :title="lycn.displayName" @dblclick="handleFieldByDbClick(lycn)">
                                                <span class="lyflex-center lymarginleft2">
                                                    <svg-icon :icon-class="lycn.icon?lycn.icon:'Menu'" style="color:#409eff;font-size: 16px;"></svg-icon>
                                                    {{lycn.displayName}}
                                                </span>
                                          </li>
                                    </template>
                                </draggable>
                            </el-collapse-item>
                        </el-collapse>
                    </el-tab-pane>
                    <el-tab-pane name="lytwo" v-if="builderConfig.showFormTemplates">
                        <template #label>
                            <span class="lycustom-tabs-label"><el-icon size="28"><CopyDocument /></el-icon><span>模板库</span></span>
                        </template>

                    </el-tab-pane>
                </el-tabs>
            </div>
        </el-scrollbar>
    </div>
</template>

<script setup>
    import { ref, onMounted ,reactive,nextTick,onBeforeUnmount,watch,inject } from 'vue'
    import {lyContainers, lyBasicFields, lyAdvancedFields, lyCustomFields} from "./lyWidgetConfig"
    import {randomId} from '@/utils/util'
    import { useBuilderStore } from "@/store/lyFormBuilder";

    const props = defineProps({
        isFull:{
            type:Boolean,
            default:false
        },
        builder: Object,
    })
    const builderStore = useBuilderStore()
    const builderConfig = builderStore.builderConfig
    let lyCollapseActiveList = ref([])
    let lyTabValue = ref("lyfirst")

    let containers = ref([])
    let basicFields = ref([])
    let advancedFields = ref([])
    let customFields = ref([])


    function lyLoadWidgetConfig() {
        containers = lyContainers.map(item => {
            return {
                key: randomId(),
                ...item
            }
        }).filter(item => {
            return !item.internal
        })

        basicFields = lyBasicFields.map(item => {
            return {
                key: randomId(),
                ...item
            }
        })

        advancedFields = lyAdvancedFields.map(item => {
            return {
                key: randomId(),
                ...item
            }
        })

        customFields = lyCustomFields.map(item => {
            return {
                key: randomId(),
                ...item
            }
        })
    }

    function handleContainerClone(e) {
        return builderStore.cloneNewContainerWidget(e)
    }
    function handleContainerMove(e){
        return builderStore.handleWidgetMove(e)
    }
    function handleContainerEnd(e){

    }
    function handleContainerByDbClick(e){
        builderStore.addContainerByDbClick(e)
    }
    function handleFieldByDbClick(e){
        builderStore.addFieldByDbClick(e)
    }
    function handleFieldClone(e) {
        return builderStore.cloneNewFieldWidget(e)
    }
    function  handleFieldMove(e) {
        return builderStore.handleFieldMove(e)
    }
    function handleFieldEnd(e){
        
    }

    let scrollerHeight = ref(0)

    function lyHandleResize(){
        nextTick(() => {
            if(props.isFull){
                scrollerHeight.value = window.innerHeight - 49 + 'px'
            }else{
                scrollerHeight.value = window.innerHeight - 160 + 'px'
            }

        })
    }
    watch(() => props.isFull, (n) => {
        lyHandleResize()
    })
    onMounted(()=>{
        lyLoadWidgetConfig()
        lyHandleResize()
        window.addEventListener('resize',lyHandleResize)
        lyCollapseActiveList.value=['lywpc01','lywpc02','lywpc03','lywpc04']
    })
    onBeforeUnmount(() => {
        window.removeEventListener('resize',lyHandleResize)
    })

</script>

<style lang="scss" scoped>
    .lywp-scrow{
        background:var(--l-changetab-bg);
        ::v-deep(.el-scrollbar__wrap) {
            overflow-x: hidden;
        }
    }
    .lywp-first-tabs{
        background:var(--l-changetab-bg);
        ::v-deep(.el-tabs__header) {
            margin-bottom: 0;
        }
        ::v-deep(.el-tabs__header){
            width: 71px;
        }
        ::v-deep(.el-tabs__nav){
            margin-top: 15px;
        }
        ::v-deep(.el-tabs__active-bar){
            background-color:unset;
        }
        ::v-deep(.el-tabs__item){
            height: 80px;
        }
        ::v-deep(.el-tabs__nav-wrap.is-left::after){
            width: 1px;
        }
        ::v-deep(.el-collapse-item__header) {
            font-weight: bold;
        }
        .lycustom-tabs-label{
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .lywp-collapse{
            border-top-width: 0;
            ::v-deep(.el-collapse-item__content){
                padding-bottom:2px;
                ul{
                    margin-block-end: 0.25em;
                    .lycontainer-widget-item{
                        display: inline-block;
                        height: 28px;
                        line-height: 28px;
                        width: 100px;
                        margin: 2px 6px 1px 1px;
                        cursor: move;
                        white-space: nowrap;
                        text-overflow: ellipsis;
                        overflow: hidden;
                        background: var(--el-bg-color-page);
                        .el-icon{
                            margin-right: 3px;
                        }
                    }
                    .lycontainer-widget-item:hover{
                        background: var(--el-color-primary-light-9);
                        outline: 1px solid var(--el-color-primary);
                    }
                }

            }
        }
    }
    .lyflex-center{
        display: flex;
        align-items: center;
    }
    .lymarginleft2{
        margin-left: 2px;
    }

    .lywp-main{

    }

</style>
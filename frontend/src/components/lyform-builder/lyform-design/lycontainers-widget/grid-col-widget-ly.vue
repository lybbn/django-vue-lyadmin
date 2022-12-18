<template>
    <el-col v-if="designState"  v-bind="layoutProps" :class="[designState ? 'lygrid-col':'',selected ? 'selected' : '', customClass]" :style="colHeightStyle" :key="widget.id" @click.stop="selectWidget(widget,designState)">
        <draggable :list="widget.widgetList" item-key="id" tag="transition-group" group="lyDragGroup" ghostClass="lyformbuilder-ghost" animation="200" :component-data="{name: 'fade', type: 'transition'}" handle=".drag-handler" @end="(evt) => onGridDragEnd(evt, widget.widgetList)"
              @add="(evt) => onGridDragAdd(evt, widget.widgetList)" @update="onGridDragUpdate" :move="handleContainerMove">
            <template #item="{ element: subWidget, index: swIdx }">
                <div class="form-widget-list">
                  <template v-if="subWidget.category === 'container'">
                    <component :is="subWidget.type + '-widget-ly'" :widget="subWidget" :key="subWidget.id" :parent-list="widget.widgetList" :index-of-parent-list="swIdx" :parent-widget="widget" :design-state="designState"></component>
                  </template>
                  <template v-else>
                    <component :is="subWidget.type + '-widget-ly'" :field="subWidget" :key="subWidget.id" :parent-list="widget.widgetList" :index-of-parent-list="swIdx" :parent-widget="widget" :design-state="designState"></component>
                  </template>
                </div>
            </template>
        </draggable>
        <div class="grid-col-action" v-if="builderStore.selectedId === widget.id && widget.type === 'grid-col' && designState">
            <el-tag effect="dark" type="warning" closable @close="handleCloseActionTag()" v-show="isActionShow">
                <span title="选中父组件" @click.stop="selectParentWidget(parentWidget)"><svg-icon icon-class="back" /></span>
                <span v-if="!!parentList && (parentList.length > 1)" title="上移组件" @click.stop="moveUpWidget()"><svg-icon icon-class="top" /></span>
                <span v-if="!!parentList && (parentList.length > 1)" title="下移组件" @click.stop="moveDownWidget()"><svg-icon icon-class="bottom" /></span>
                <span title="复制组件" @click.stop="cloneGridCol(widget)"><svg-icon icon-class="lyicon-clone" /></span>
                <span title="移除组件" @click.stop="removeWidget"><svg-icon icon-class="delete" /></span>
            </el-tag>
        </div>
        <div class="grid-col-handler" v-if="builderStore.selectedId === widget.id && widget.type === 'grid-col' && designState">
            <el-tag effect="dark" type="warning" closable @close="handleCloseDragTag()" v-show="isDragHandlerShow">{{widget.displayName}}</el-tag>
        </div>
    </el-col>
    <el-col v-else v-bind="layoutProps" :class="[customClass]" :style="colHeightStyle" :key="widget.id" v-show="!widget.options.hidden">
        <template v-if="!!widget.widgetList && (widget.widgetList.length > 0)">
            <template v-for="(subWidget, swIdx) in widget.widgetList">
                <template v-if="subWidget.category === 'container'">
                    <component :is="subWidget.type + '-widget-ly'" :widget="subWidget" :key="swIdx" :parent-list="widget.widgetList" :index-of-parent-list="swIdx" :parent-widget="widget" :design-state="designState">
                        <template v-for="slot in Object.keys($slots)" v-slot:[slot]="scope">
                            <slot :name="slot" v-bind="scope"/>
                        </template>
                    </component>
                </template>
                <template v-else>
                    <component :is="subWidget.type + '-widget-ly'" :field="subWidget" :key="swIdx" :parent-list="widget.widgetList" :index-of-parent-list="swIdx" :parent-widget="widget" :design-state="designState">
                        <template v-for="slot in Object.keys($slots)" v-slot:[slot]="scope">
                            <slot :name="slot" v-bind="scope"/>
                        </template>
                    </component>
                </template>
            </template>
        </template>
    </el-col>
</template>

<script setup>
    import {ref, onMounted, reactive, computed, nextTick, watch} from 'vue'
    import useCommon from '@/components/lyform-builder/lyform-design/useCommon'
    import { useBuilderStore } from "@/store/lyFormBuilder";

    const props = defineProps({
        widget: Object,
        parentWidget: Object,
        parentList: Array,
        indexOfParentList: Number,
        designState: {
            type: Boolean,
            default: false
        },
        colHeight: {
            type: String,
            default: null
        },
    })

    let isDragHandlerShow = ref(true)
    let isActionShow = ref(true)

    const builderStore = useBuilderStore()

    let layoutProps= computed(()=>{
        return{
            span: props.widget.options.span || 12,
            offset: props.widget.options.offset || 0,
            push: props.widget.options.push || 0,
            pull: props.widget.options.pull || 0,
        }
    })

    const selected = computed(() => {
        return props.designState&&props.widget.id === builderStore.selectedId
    })
    const customClass = computed(() => {
        return props.widget.options.customClass || ''
    })
    const colHeightStyle = computed(() => {
        return !!props.colHeight ? {height: props.colHeight + 'px'} : {}
    })

    let {selectWidget,selectParentWidget} = useCommon()
    function onGridDragEnd(e,subList) {

    }
    function onGridDragAdd(e, subList) {
        const newIndex = e.newIndex
        if (!!subList[newIndex]) {
            builderStore.setSelected( subList[newIndex] )
        }
        builderStore.emitHistoryChange()
    }

    function onGridDragUpdate() {
        builderStore.emitHistoryChange()
    }

    function handleContainerMove(e) {
        return builderStore.handleWidgetMove(e)
    }

    function moveUpWidget() {
        builderStore.moveUpWidget(props.parentList, props.indexOfParentList)
        builderStore.emitHistoryChange()
    }

    function moveDownWidget() {
        builderStore.moveDownWidget(props.parentList, props.indexOfParentList)
        builderStore.emitHistoryChange()
    }

    function removeWidget() {
        if (!!props.parentList) {
            let nextSelected = null
            if (props.parentList.length === 1) {
                if (!!props.parentWidget) {
                    nextSelected = props.parentWidget
                }
            } else if (props.parentList.length === (1 + props.indexOfParentList)) {
                nextSelected = props.parentList[props.indexOfParentList - 1]
            } else {
                nextSelected = props.parentList[props.indexOfParentList + 1]
            }
            nextTick(() => {
                props.parentList.splice(props.indexOfParentList, 1)
                builderStore.setSelected(nextSelected)
                builderStore.emitHistoryChange()
            })
        }
    }

    function cloneGridCol(widget) {
        builderStore.cloneGridCol(widget, props.parentWidget)
    }

    function handleCloseDragTag() {
        isDragHandlerShow.value = false
    }
    function handleCloseActionTag() {
        isActionShow.value = false
    }

    watch(()=>builderStore.selectedId,(n,o)=>{
        if(n === props.widget.id && props.widget.type === 'grid-col'&&props.designState){
            isDragHandlerShow.value = true
            isActionShow.value = true
        }
    })
</script>

<style lang="scss" scoped>
    .lygrid-col{
        min-height: 58px !important;
        padding: 3px;
        outline: 1px dashed #336699;
        position: relative;
        .form-widget-list {
            min-height: 28px;
        }
        .grid-col-action{
            position: absolute;
            bottom: -1px;
            right: -5px;
            z-index: 999;
            .el-tag{
                border-radius:0;
                .el-icon{
                    font-size: 14px !important;
                }
            }
            span {
                color: #fff;
                margin: 0 5px;
                cursor: pointer;
            }
        }
        .grid-col-handler {
            position: absolute;
            top: -1px;
            left: -2px;
            z-index: 9;

            .el-tag{
                border-radius:0;
                ::v-deep(.el-tag__content){
                    display: flex;
                    align-items: center;
                }
                ::v-deep(.svg-icon-lyicon){
                    cursor: move !important;
                }
                ::v-deep(.svg-icon){
                    cursor: move !important;
                }

            }
        }
    }

</style>
<template>
    <div :class="[designState ? 'lyconwp-container' : '',customClass]">
        <slot></slot>
        <div class="container-action" v-if="builderStore.selectedId === widget.id && !widget.internal && designState">
            <el-tag effect="dark" closable @close="handleCloseActionTag()" v-show="isActionShow">
                <span title="选中父组件" @click.stop="selectParentWidget(widget)"><svg-icon icon-class="back" /></span>
                <span v-if="!!parentList && (parentList.length > 1)" title="上移组件" @click.stop="moveUpWidget()"><svg-icon icon-class="top" /></span>
                <span v-if="!!parentList && (parentList.length > 1)" title="下移组件" @click.stop="moveDownWidget()"><svg-icon icon-class="bottom" /></span>
                <span v-if="widget.type === 'table'" title="插入新行" @click.stop="builderStore.appendTableRow(widget)"><svg-icon icon-class="lyicon-insert-row" /></span>
                <span v-if="widget.type === 'table'" title="插入新列" @click.stop="builderStore.appendTableCol(widget)"><svg-icon icon-class="lyicon-insert-column" /></span>
                <span v-if="(widget.type === 'grid') || (widget.type === 'table')" title="复制组件" @click.stop="cloneContainer(widget)"><svg-icon icon-class="lyicon-clone" /></span>
                <span title="移除组件" @click.stop="removeWidget"><svg-icon icon-class="delete" /></span>
            </el-tag>
        </div>

        <div class="drag-handler" v-if="builderStore.selectedId === widget.id && !widget.internal && designState">
            <span title="拖拽手柄">
                <el-tag effect="dark" closable @close="handleCloseDragTag()" v-show="isDragHandlerShow"><svg-icon icon-class="lyicon-drag-move" style="font-size: 18px" /><span>{{widget.displayName}}</span><span v-if="widget.options.hidden === true"><svg-icon icon-class="lyicon-hide" /></span></el-tag>
            </span>
        </div>
    </div>
</template>

<script setup>
    import {ref, onMounted, reactive, computed, nextTick,watch} from 'vue'
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

    let {selectWidget,selectParentWidget} = useCommon()

    const selected = computed(() => {
        return props.designState&&props.widget.id === builderStore.selectedId
    })
    const customClass = computed(() => {
        return !!props.widget.options.customClass ? props.widget.options.customClass.join(' ') : ''
    })
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

    function cloneContainer(widget) {
        if (!!props.parentList) {
            let newCon = builderStore.cloneContainer(widget)
            props.parentList.splice(props.indexOfParentList + 1, 0, newCon)
            builderStore.setSelected(newCon)
            builderStore.emitHistoryChange()
        }
    }
    function handleCloseDragTag() {
        isDragHandlerShow.value = false
    }
    function handleCloseActionTag() {
        isActionShow.value = false
    }

    watch(()=>builderStore.selectedId,(n,o)=>{
        if(n === props.widget.id && !props.widget.internal&&props.designState){
            isDragHandlerShow.value = true
            isActionShow.value = true
        }
    })

</script>

<style lang="scss" scoped>
    .lyconwp-container{
        position: relative;
        margin-bottom: 5px;
        .container-action{
            position: absolute;
            bottom: -2px;
            right: -11px;
            z-index: 999;
            .el-tag{
                border-radius:0;
                .el-icon{
                    font-size: 14px;
                }
            }
            span {
                color: #fff;
                margin: 0 5px;
                cursor: pointer;
            }
        }
        .drag-handler {
            position: absolute;
            top: -1px;
            left: -6px;
            z-index: 9;
            cursor: move;
            .el-tag{
                .el-icon{
                    font-size: 14px !important;
                }
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
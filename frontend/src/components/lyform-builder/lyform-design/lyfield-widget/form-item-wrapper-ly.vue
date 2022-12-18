<template>
    <div class="lyfw-container">
        <el-form-item  v-if="!!field.formItemFlag && (!field.options.hidden || (designState === true))"
                  :label="label"
                  :label-width="labelWidth"
                  :rules="rules"
                  :prop="getPropName()"
                  :class="[selected ? 'selected' : '', customClass, required ? 'is-required' : '',designState ? 'lyfw-form-item':'']"
                  @click.stop="selectWidget(field,designState)">
            <slot></slot>
        </el-form-item>
        <template v-if="designState">
            <div class="field-action" v-if="builderStore.selectedId === field.id">
                <el-tag effect="dark" closable @close="handleCloseActionTag()" v-show="isActionShow">
                    <span title="选中父组件" @click.stop="selectParentWidget(parentWidget)"><svg-icon icon-class="back" /></span>
                    <span v-if="!!parentList && (parentList.length > 1)" title="上移组件" @click.stop="moveUpWidget()"><svg-icon icon-class="top" /></span>
                    <span v-if="!!parentList && (parentList.length > 1)" title="下移组件" @click.stop="moveDownWidget()"><svg-icon icon-class="bottom" /></span>
                    <span v-if="(field.type === 'grid') || (field.type === 'table')" title="复制组件" @click.stop="cloneContainer(field)"><svg-icon icon-class="lyicon-clone" /></span>
                    <span title="移除组件" @click.stop="removeWidget"><svg-icon icon-class="delete" /></span>
                </el-tag>
            </div>

            <div class="drag-handler" v-if="builderStore.selectedId === field.id">
                <span title="拖拽手柄">
                    <el-tag effect="dark" closable @close="handleCloseDragTag()" v-show="isDragHandlerShow"><svg-icon icon-class="lyicon-drag-move" style="font-size: 18px" /><span>{{field.displayName}}</span><span v-if="field.options.hidden === true"><svg-icon icon-class="lyicon-hide" /></span></el-tag>
                </span>
            </div>
        </template>
    </div>
</template>

<script setup>
    import {ref, onMounted, reactive, computed, nextTick, watch} from 'vue'
    import useCommon from '@/components/lyform-builder/lyform-design/useCommon'
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
    let isDragHandlerShow = ref(true)
    let isActionShow = ref(true)
    const builderStore = useBuilderStore()

    let {selectWidget,selectParentWidget} = useCommon()

    const formConfig = computed(() => {
        return builderStore.formConfig
    })
    const selected = computed(() => {
        return props.designState && props.field.id === builderStore.selectedId
    })
    const customClass = computed(() => {
        return !!props.field.options.customClass ? props.field.options.customClass.join(' ') : ''
    })
    const required = computed(() => {
        return !!props.field.options.required ? true : false
    })
    const label = computed(() => {
        if (!!props.field.options.labelHidden) {
          return ''
        }
        return props.field.options.label
    })
    const labelWidth = computed(() => {
        if (!!props.field.options.labelHidden) {
            return 0
        }

        if (!!props.field.options.labelWidth) {
            return props.field.options.labelWidth
        }

        if (!!builderStore) {
            return builderStore.formConfig.labelWidth
        } else {
            return formConfig.labelWidth
        }
    })
    const subFormName = computed(() => {
        return !!props.parentWidget ? props.parentWidget.options.name : ''
    })
    const subFormItemFlag = computed(() => {
        return !!props.parentWidget ? props.parentWidget.type === 'sub-form' : false
    })

    function getPropName() {
        if (subFormItemFlag && !props.designState) {
            return subFormName + "." + props.subFormRowIndex + "." + props.field.options.name + ""
        } else {
            return props.field.options.name
        }
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
    function handleCloseDragTag() {
        isDragHandlerShow.value = false
    }
    function handleCloseActionTag() {
        isActionShow.value = false
    }
    watch(()=>builderStore.selectedId,(n,o)=>{
        if(n === props.field.id && props.designState){
            isDragHandlerShow.value = true
            isActionShow.value = true
        }
    })



</script>

<style lang="scss" scoped>
    .lyfw-container{
        position: relative;
        .lyfw-form-item{
            /*padding-bottom: 20px;*/
            position: relative;
            outline: 1px dashed #336699;
            margin: 2px;
        }
        .el-form-item.selected, .static-content-item.selected {
            outline: 2px solid var(--el-color-primary);
            /*border: none;*/
        }
        .field-action{
            position: absolute;
            bottom: -2px;
            right: 0px;
            z-index: 999;
            background: var(--el-color-primary);
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
            left: 0px;
            z-index: 9;
            cursor: move;
            .el-tag{
                opacity:0.4;
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
                &:hover {
                    opacity: 1;
                }
            }
        }
    }

</style>
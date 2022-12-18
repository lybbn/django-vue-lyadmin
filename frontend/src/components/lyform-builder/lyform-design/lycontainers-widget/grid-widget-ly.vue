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
        <containers-wrapper-ly v-if="designState" :widget="widget" :parent-widget="parentWidget" :parent-list="parentList" :index-of-parent-list="indexOfParentList" :design-state="designState">
            <el-row :key="widget.id" :gutter="widget.options.gutter" :class="[designState ? 'lygrid-container':'',selected ? 'selected' : '', customClass]" @click.stop="selectWidget(widget,designState)">
                <template v-for="(colWidget, colIdx) in widget.cols" :key="colWidget.id">
                    <grid-col-widget-ly :widget="colWidget" :parent-list="widget.cols" :index-of-parent-list="colIdx" :parent-widget="widget" :col-height="widget.options.colHeight" :design-state="designState"></grid-col-widget-ly>
                </template>
            </el-row>
        </containers-wrapper-ly>
        <containers-wrapper-ly v-else :widget="widget">
            <el-row :key="widget.id" :gutter="widget.options.gutter" :class="[customClass]" v-show="!widget.options.hidden" :ref="widget.id">
                <template v-for="(colWidget, colIdx) in widget.cols" :key="colIdx">
                    <grid-col-widget-ly :widget="colWidget" :parent-list="widget.cols" :index-of-parent-list="colIdx" :parent-widget="widget" :col-height="widget.options.colHeight" :design-state="designState">
                        <template v-for="slot in Object.keys($slots)" v-slot:[slot]="scope">
                            <slot :name="slot" v-bind="scope"/>
                        </template>
                    </grid-col-widget-ly>
                </template>
            </el-row>
        </containers-wrapper-ly>
    </div>
</template>

<script setup>
    import {ref, onMounted ,reactive,computed} from 'vue'
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
    })
    const builderStore = useBuilderStore()
    const selected = computed(() => {
        return props.designState&&props.widget.id === builderStore.selectedId
    })
    let {selectWidget} = useCommon()
    const customClass = computed(() => {
        return props.widget.options.customClass || ''
    })


</script>

<style lang="scss" scoped>
    .lygrid-container{
        min-height: 70px;
        outline: 1px dashed #336699;

        .form-widget-list {
          min-height: 28px;
        }
        padding: 6px;
    }
    .lygrid-container.selected{
        outline: 2px solid var(--el-color-primary) !important;
    }
    .lygrid-col.selected {
        outline: 2px solid var(--el-color-warning) !important;
    }
</style>
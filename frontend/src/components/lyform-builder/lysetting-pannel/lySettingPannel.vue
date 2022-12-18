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
    <div class="lysp-main">
        <el-tabs v-model="activeTab" stretch>
            <el-tab-pane name="lyfirst" label="组件属性">
                <el-scrollbar class="lysp-scrow" :style="{height: scrollerHeight}">
                    <template v-if="!!builderStore.selectedWidget">
                        <component :is="getWidgetSettingName(selectedWidget)" :key="selectedWidget.id" :selected-widget="selectedWidget" :option-model="optionModel"></component>
                    </template>
                    <template v-if="Object.keys(builderStore.selectedWidget).length==0">
                        <el-empty class="ly-empty-text" description="请选择组件" />
                    </template>
                </el-scrollbar>
            </el-tab-pane>
            <el-tab-pane name="lytwo" label="表单属性">
                <el-scrollbar class="lysp-scrow" :style="{height: scrollerHeight}">
                    <lyFormSetting  :form-config="builderStore.formConfig"></lyFormSetting>
                </el-scrollbar>
            </el-tab-pane>
        </el-tabs>
    </div>
</template>

<script setup>
    import {ref, onMounted, reactive, nextTick, onBeforeUnmount, watch, computed} from 'vue'
    import { useBuilderStore } from "@/store/lyFormBuilder";
    import lyFormSetting from '@/components/lyform-builder/lysetting-pannel/lyFormSetting'

    const props = defineProps({
        isFull:{
            type:Boolean,
            default:false
        },
        selectedWidget: Object
     })

    const builderStore = useBuilderStore()

    const optionModel = computed({
        get:()=> {
            return props.selectedWidget.options
        },
        set:(n)=> {
            props.selectedWidget.options = n
        }
    })

    let activeTab = ref("lytwo")

    function getWidgetSettingName(selectedWidget) {
        return selectedWidget.type + '-setting-ly'
    }

    let scrollerHeight = ref(0)

    function lyHandleResize(){
        nextTick(() => {
            if(props.isFull){
                scrollerHeight.value = window.innerHeight - 89 + 'px'
            }else{
                scrollerHeight.value = window.innerHeight - 200 + 'px'
            }

        })
    }
    watch(() => props.isFull, (n) => {
        lyHandleResize()
    })
    onMounted(()=>{
        if (!builderStore.selectedWidget) {
            activeTab.value = "lytwo"
        } else {
            activeTab.value = "lyfirst"
        }
        lyHandleResize()
        window.addEventListener('resize',lyHandleResize)
    })
    onBeforeUnmount(() => {
        window.removeEventListener('resize',lyHandleResize)
    })

</script>

<style lang="scss" scoped>
    .lysp-main{
        .lysp-scrow{
            padding: 0 8px 0 8px;
            background:var(--l-changetab-bg);
            ::v-deep(.el-scrollbar__wrap) {
                overflow-x: hidden;
            }
            ::v-deep(.el-scrollbar__view){
                margin-bottom: 30px;
            }
        }
        .el-tabs{
            ::v-deep(.el-tabs__header) {
                margin:0;
                background:var(--l-changetab-bg);
            }
        }
        .ly-empty-text{
            margin-top: 30px;
        }
       ::v-deep(.el-form-item--small){
           margin-bottom: 10px;
       }
    }

</style>
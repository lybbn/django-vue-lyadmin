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
  <div :class="{'ly-is-full-design':isFull}" style="overflow: overlay;">
    <el-container class="lyformbuildermain">
      <el-header class="lyformbuilderheader">
        <div class="lyfbhtitle">
          <span style="display: flex"><el-icon size="32px" color="#409eff"><Cpu /></el-icon></span>
          <span>lyFormBuilder</span>
          <span>表单构建器</span>
          <span>Ver {{LYFORMBUILDER_VERSION}}</span>
        </div>
        <div class="lyfbhlink">
          <el-button type="primary" link @click="handleClick('delete')" style="margin-right: 8px">
              <el-icon size="15px"><Delete/></el-icon>清空
          </el-button>
          <el-button type="primary" link @click="handleClick('preview')" style="margin-right: 8px">
              <el-icon size="15px"><View/></el-icon>预览
          </el-button>
          <el-button type="primary" link @click="handleClick('exportjson')" style="margin-right: 8px">
              <el-icon size="15px"><Download/></el-icon>导出JSON
          </el-button>
          <el-button type="primary" link @click="handleClick('exportjson')" style="margin-right: 8px">
              <el-icon size="15px"><Document/></el-icon>生成SFC
          </el-button>
          <el-button type="primary" link @click="lysetFull" style="margin-right: 8px">
              <el-icon size="15px"><full-screen/></el-icon>全屏
          </el-button>
          <el-button type="primary" link @click="handleClick('opendocment')" style="margin-right: 8px" v-if="builderConfig.showExtraLink">
              <el-icon size="15px"><Reading/></el-icon>文档
          </el-button>
        </div>
      </el-header>
      <el-container>
        <el-aside class="ly-left-pannel">
          <lyWidgetPannel :isFull="isFull"></lyWidgetPannel>
        </el-aside>
        <el-container class="ly-center-containers">
          <el-main>
            <lyFormDesign :isFull="isFull"></lyFormDesign>
          </el-main>
        </el-container>
        <el-aside class="ly-right-containers">
          <lySettingPannel :isFull="isFull" :selected-widget="builderStore.selectedWidget"></lySettingPannel>
        </el-aside>
      </el-container>
    </el-container>
    <lyDialog v-model="showPreviewDialog" title="预览" width="70%" :before-close="handleDialogClose">
      <div>
        <lyFormRender ref="lyFormPreview" :form-json="formJson" :preview-state="true"></lyFormRender>
      </div>
      <template v-slot:footer>
        <el-button @click="handleDialogClose">关闭</el-button>
        <!-- 自定义dialog底部按钮 -->
        <slot name="customDialogHandle"></slot>
      </template>
    </lyDialog>
  </div>
</template>

<script setup>
  import {ref, onMounted ,reactive,provide,watch,computed} from 'vue'
  import lyWidgetPannel from '@/components/lyform-builder/lywidget-pannel/lyWidgetPannel'
  import lySettingPannel from '@/components/lyform-builder/lysetting-pannel/lySettingPannel'
  import lyFormDesign from './lyform-design/lyFormDesign'
  import {LYFORMBUILDER_VERSION} from "@/components/lyform-builder/config"
  import {parseString2Json} from '@/utils/util'
  import lyDialog from '@/components/dialog/dialog'
  import lyFormRender from '@/components/lyform-builder/lyform-render/index'
  import { useBuilderStore } from "@/store/lyFormBuilder";

  const props = defineProps({
     builderConfig :{
       type:Object,
       default:{
         showExtraLink:true,//是否显示头部右侧外链按钮
         showFormTemplates:true,//是否显示表单模板
         showEventCollapse:true,//是否显示组件事件属性折叠面板
       }
     },

  })

  const isFull = ref(false)
  let showPreviewDialog = ref(false)
  const builderStore = useBuilderStore()
  builderStore.builderConfig = props.builderConfig

  const formJson = computed(() => {
    return {
      widgetList: builderStore.widgetList,
      formConfig: builderStore.formConfig
    }
  })
  
  function handleDialogClose() {
    showPreviewDialog.value = false
  }

  function lysetFull(){
    isFull.value=!isFull.value
  }

  let jsonContent = ref("")
  function handleClick(flag) {
    if(flag==="exportjson"){
      let widgetList = builderStore.widgetList
      let formConfig = builderStore.formConfig
      jsonContent.value = JSON.stringify({widgetList, formConfig}, null, '  ')
      console.log(jsonContent.value)
    }else if(flag==="opendocment"){
      window.open("https://www.lybbn.cn")
    }else if(flag==="delete"){
      builderStore.clearBuilder()
    }else if(flag==="preview"){
      showPreviewDialog.value = true
    }
  }

</script>

<style lang="scss" scoped>
  .lyformbuilderheader{
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: var(--l-changetab-bg);
    height: 48px;
    line-height: 48px;
    min-width: 1100px;
    border-bottom: 2px dotted var(--l-lyformbuilder-border-color);
  }
  .lyfbhtitle{
    font-size: 18px;
    color: var(--l-lyformbuilder-font-color);
    display: flex;
    align-items: center;
    justify-content: center;
    span:nth-child(2){
      font-weight: bold;
      font-size: 20px;
      margin: 0 6px 0 6px;
    }
    span:last-child{
      font-size: 14px;
      margin-left: 6px;
    }
  }
  .lyfbhlink{
    display: flex;
    align-items: center;
    font-size: 13px;
  }
  .ly-left-pannel{
    width: 300px!important;
    overflow-y: hidden;
  }
  .ly-right-containers{
    width: 300px!important;
    overflow-y: hidden;
  }
  .ly-center-containers{
    min-width: 500px;
    border-left: 2px dotted var(--l-lyformbuilder-border-color);
    border-right: 2px dotted var(--l-lyformbuilder-border-color);
    ::v-deep(.el-main){
      padding: 0px;
    }
  }
</style>
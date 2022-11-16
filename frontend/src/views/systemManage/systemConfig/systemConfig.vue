<template>
    <div class="lycontainer">
        <div class="tableSelect" ref="tableSelect" v-if="hasPermission(route.name,'Create')">
            <el-form :inline="true"  label-position="left">
                <el-form-item label="" v-show="hasPermission(route.name,'Create')"><el-button  @click="handleClick('addgroup')" type="warning" icon="FolderAdd" >新增分组</el-button></el-form-item>
                <el-form-item label="" v-show="hasPermission(route.name,'Create')"><el-button  @click="handleClick('addcontent')" type="primary" icon="Plus" >新增配置项</el-button></el-form-item>
            </el-form>
        </div>
        <div>
             <el-tabs type="border-card" v-model="activeTab" :before-leave="onBeforeLeave">
                 <el-tab-pane
                     v-for="(item, index) in editableTabs"
                    :key="index"
                    :label="item.title"
                    :name="item.key"
                    >
                     <FormItem :options="item" :editableTabsItem="item"></FormItem>
                 </el-tab-pane>
                 <el-tab-pane
                    name="add_config"
                    label="新增配置项"
                    >
                     <template #label>
                        <span style="display: flex;align-items: center">
                          <el-icon><Plus /></el-icon>
                          <span>新增配置项</span>
                        </span>
                     </template>
                 </el-tab-pane>
            </el-tabs>
        </div>
        <AddModuleGroup ref="addGroupFlag" @refreshData="getGroups"></AddModuleGroup>
        <AddModuleContent ref="addContentFlag" @refreshData="getGroups"></AddModuleContent>
    </div>
</template>

<script setup>
    import {ref, onMounted} from 'vue'
    import AddModuleGroup from "./components/addModuleGroup";
    import {platformsettingsSysconfig} from '@/api/api'
    import AddModuleContent from "./components/addModuleContent";
    import FormItem from "./components/formItem";
    import {hasPermission} from "@/utils/util";
    import { useRoute } from "vue-router";

    const route = useRoute();

    let activeTab = ref("base")
    let editableTabs = ref([])

    let addContentFlag = ref();
    function onBeforeLeave (newTabName) {
        if (newTabName == 'add_config') {
            addContentFlag.value.addModuleFn('',"新增配置项")
            return false
        }
    }

    let addGroupFlag = ref();

    function handleClick(flag) {
        if(flag == 'addgroup'){
            addGroupFlag.value.addModuleFn('',"新增分组")
        }else if(flag == 'addcontent'){
            if(hasPermission(route.name,'Create')){
                addContentFlag.value.addModuleFn('',"新增配置项")
            }
        }
    }
    function getGroups() {
        platformsettingsSysconfig({limit:999,parent__isnull:true}).then(res=>{
            if(res.code == 2000){
                editableTabs.value = res.data.data
            }
        })
    }
    onMounted(() => {
        getGroups()
    })

</script>

<style scoped lang="scss">
    ::v-deep(.el-tabs__content){
        // overflow:hidden 会导致 分页下拉框超出部分会被.el-tabs__content隐藏
        overflow: visible;
    }
</style>

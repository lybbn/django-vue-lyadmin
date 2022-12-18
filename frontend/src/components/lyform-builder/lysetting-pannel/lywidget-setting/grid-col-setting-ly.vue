<template>
    <div>
        <el-form size="small" label-position="left" label-width="100px" class="lywidgetsetting" @submit.prevent>
            <el-form-item label="字段标识">
                <el-input  v-model="optionModel.name" @change="handleChange"></el-input>
            </el-form-item>
            <el-form-item label="隐藏">
                <el-switch v-model="optionModel.hidden" @change="handleChange"></el-switch>
            </el-form-item>
            <el-form-item label="栅格占据列数">
                <el-input-number v-model="optionModel.span" :min="0" :max="24" style="width: 100%" @change="handleChange"></el-input-number>
            </el-form-item>
            <el-form-item label="左侧间隔格数">
                <el-input-number type="number" v-model="optionModel.offset" :min="0" style="width: 100%" @change="handleChange"></el-input-number>
            </el-form-item>
            <el-form-item label="向右移动格数">
                <el-input-number type="number" v-model="optionModel.push" :min="0" style="width: 100%" @change="handleChange"></el-input-number>
            </el-form-item>
            <el-form-item label="向左移动格数">
                <el-input-number type="number" v-model="optionModel.pull" :min="0" style="width: 100%" @change="handleChange"></el-input-number>
            </el-form-item>
        </el-form>
    </div>
</template>

<script setup>
    import {ref, onMounted, reactive, computed, watch} from 'vue'
    import { useBuilderStore } from "@/store/lyFormBuilder";
    const props = defineProps({
        selectedWidget: Object,
        optionModel: Object,
    })
    const builderStore = useBuilderStore()
    function handleChange(newValue) {
         builderStore.saveCurrentHistoryStep()
    }


</script>

<style lang="scss" scoped>
    .lywidgetsetting{
        margin-top: 20px;
        ::v-deep(.el-form-item__label) {
          font-size: 13px;
          overflow: hidden;
          white-space: nowrap;
        }
    }

</style>
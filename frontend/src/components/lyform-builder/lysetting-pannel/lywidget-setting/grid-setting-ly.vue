<template>
    <div>
        <el-form size="small" label-position="left" label-width="100px" class="lywidgetsetting" @submit.prevent>
            <el-form-item label="字段标识">
                <el-input  v-model="optionModel.name" @change="handleChange"></el-input>
            </el-form-item>
            <el-form-item label="隐藏">
                <el-switch v-model="optionModel.hidden" @change="handleChange"></el-switch>
            </el-form-item>
            <el-form-item label="栅格间隔(px)">
                <el-input-number v-model="optionModel.gutter" :min="0" style="width: 100%" @change="handleChange"></el-input-number>
            </el-form-item>
            <el-form-item label="删格列高度(px)">
                <el-input type="number" v-model="optionModel.colHeight" min="0" @change="handleChange"></el-input>
            </el-form-item>
            <el-form-item label="当前栅格列："></el-form-item>
            <el-form-item label-width="0">
                <li v-for="(colItem, colIdx) in selectedWidget.cols" :key="colIdx" class="col-item">
                    <span class="col-span-title">栅格宽度{{colIdx + 1}}</span>
                    <el-input-number v-model.number="colItem.options.span" :min="1" :max="24" @change="handleChange" class="cell-span-input"></el-input-number>
                    <el-button circle plain size="small" type="danger" @click="deleteCol(selectedWidget, colIdx)" icon="Delete" class="col-delete-button"></el-button>
                </li>
                <div>
                    <el-button link type="primary" @click="addNewCol(selectedWidget)" icon="plus">增加栅格</el-button>
                </div>
            </el-form-item>
        </el-form>
    </div>
</template>

<script setup>
    import { ref, onMounted ,reactive,computed ,watch} from 'vue'
    import { useBuilderStore } from "@/store/lyFormBuilder";
    const props = defineProps({
        selectedWidget: Object,
        optionModel: Object,
    })
    const builderStore = useBuilderStore()

    function handleChange(newValue) {
         builderStore.saveCurrentHistoryStep()
    }

    function deleteCol(curGrid, colIdx) {
        builderStore.deleteColOfGrid(curGrid, colIdx)
        builderStore.emitHistoryChange()
    }

    function addNewCol(curGrid) {
        builderStore.addNewColOfGrid(curGrid)
        builderStore.emitHistoryChange()
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
        li.col-item {
            list-style: none;
            span.col-span-title {
              display: inline-block;
              width: 100px;
            }

            .col-delete-button {
              margin-left: 6px;
            }

        }
        .el-button--small{
            padding: 0;
        }
    }

</style>
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
    <el-icon v-if="isEleIcon" :style="style">
        <component
            v-if="iconName"
            :is="iconName"
            :class="svgClass"
        ></component>
    </el-icon>
    <i class="el-icon" v-else :style="style">
        <svg :class="svgClass" aria-hidden="true">
            <use :xlink:href="iconName"></use>
        </svg>
    </i>

</template>

<script setup>
    import { ref,computed } from 'vue'

    const props = defineProps({
        // icon 图标
        iconClass: {
            type: String,
            required: true
        },
        // 图标类名
        className: {
            type: String,
            default: ''
        },
        style:Object
    })
    const isEleIcon = computed(() => {
        if(props.iconClass.includes('lyicon-')){
            return false
        }
        return true
    })
    const iconName = computed(() => {
        if(isEleIcon.value){
            return props.iconClass
        }
        const newName = props.iconClass.replace(/lyicon-/g, '')
        return `#icon-${newName}`

    })
    const svgClass = computed(() => {
        if (props.className) {
            return props.className
        }else{
            if(!isEleIcon.value){
                return 'svg-icon-lyicon'
            }
            return 'svg-icon'
        }

    })
</script>

<style lang="scss" scoped>
    .svg-icon-lyicon{
        height: 1em;
        width: 1em;
    }
</style>
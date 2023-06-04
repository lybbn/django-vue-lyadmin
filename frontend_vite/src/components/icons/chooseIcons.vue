<template>
    <div>
        <el-button :icon="iconText" @click="handleClick">{{iconText?iconText:"请选择图标"}}</el-button>
        <ly-dialog  v-model="dialogVisible" :title="dialogTitle"  width="50%" @close="handleClose">
            <div style="display: flex">
                <el-input  size="large" v-model="searchIconText" @input="handleChange" clearable class="searchinput" placeholder="搜索如：avatar" prefix-icon="Search"></el-input>
                <el-button size="large" icon="Delete" @click="deleteAll" type="danger">清除</el-button>
            </div>
            <el-scrollbar height="600px">
                <div class="icons-container">
                    <div v-for="(v, i) in icons" :key="i" class="lyicon" @click="chooseIcon(v)">
                        <div class="lyicon2">
                            <component class="inicon" :is="v"></component>
                            <span class="icon-text"> {{ v }}</span>
                        </div>
                    </div>
                </div>
            </el-scrollbar>
        </ly-dialog>
    </div>
</template>

<script>
    import * as Icons from '@element-plus/icons-vue'
    import LyDialog from "../dialog/dialog.vue";
    export default {
        name: "LYChooseIcons",
        components: {LyDialog},
        props: {
            modelValue: {
                type: String,
                default: ""
            },
        },
        data(){
            return{
                dialogTitle:"Icon选择器",
                dialogVisible:false,
                icons:Object.keys(Icons),
                oldIcons:Object.keys(Icons),
                iconText:"",
                searchIconText:"",
            }
        },
         created() {
            this.iconText = this.modelValue
        },
        watch:{
            modelValue: function(nval){
                this.iconText = nval; // modelValue改变是同步子组件visible的值
            },
            iconText: function(nval) {
                this.$emit('update:modelValue', nval); // visible改变时同步父组件modelValue的值
            },
        },
        methods:{
            handleClick(){
                this.dialogVisible = true
            },
            handleClose(){
                this.dialogVisible = false
            },
            chooseIcon(v){
                this.iconText = v
                this.handleClose()
            },
            handleChange(){
                if(this.searchIconText == ""){
                    this.icons = this.oldIcons
                }else{
                    this.icons = this.oldIcons.filter(item=>item.toLowerCase().indexOf(this.searchIconText.toLowerCase()) === 0)
                }

            },
            deleteAll(){
                this.iconText=''
                this.searchIconText = ""
                this.icons = this.oldIcons
            },

        },

    }
</script>

<style lang="scss" scoped>
    .searchinput{
       padding-bottom: 20px;
    }
    .icons-container {
      display: flex;
      flex-wrap: wrap;
      .lyicon {
        /*border-right:  1px solid var(--el-border-color);*/
        /*border-bottom:  1px solid var(--el-border-color);*/
        width: 20%;
        height: 70px;
        display: flex;
        flex-direction: column;
        align-items: center;
        box-sizing: border-box;
        cursor: pointer;
        .lyicon2{
            display: flex;
            align-items: center;
            flex-direction: column;
            height: 60px;
            width: 85%;
            border:  1px solid var(--el-border-color);
        }
        .inicon{
          margin-top:5px;
        }
        .icon-text {
          flex: 1;
          font-size: 12px;
        }
        &:hover {
          color: #409efa;
        }
      }
      svg {
        width: 1.5em;
        height: 1.5em;
      }
    }
</style>
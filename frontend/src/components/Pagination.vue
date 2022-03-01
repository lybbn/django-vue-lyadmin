/**
* 分页组件
*/
<template>
  <el-pagination class="page-box" @size-change="handleSizeChange" @current-change="handleCurrentChange" background :current-page="childMsg.page" :page-sizes="[10,20,30,40,50,100]" :page-size="childMsg.limit" layout="total, sizes, prev, pager, next, jumper" :total="childMsg.total">
  </el-pagination>
</template>
<script>
  export default {
    name: 'Pagination',
    props: ['childMsg'],
    data() {
      return {
        pageparm: {
          page: this.childMsg.page,
          limit: this.childMsg.limit
        }
      }
    },
    methods: {
      handleSizeChange(val) {
        this.pageparm.limit = val
        this.pageparm.page = 1
        this.$emit('callFather', this.pageparm)
      },
      handleCurrentChange(val) {
        this.pageparm.page = val
        this.$emit('callFather', this.pageparm)
      }
    }
  }
</script>

<style lang="scss">
  .page-box {
    margin: 20px auto;
    text-align: center;
    .el-pagination__editor.el-input{
      width: 70px !important;
      .el-input__inner{
        text-indent: 0 !important;
      }
    }
  }
</style>

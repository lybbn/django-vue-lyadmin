/**
* 分页组件
*/
<template>
  <div class="lyPagination-page">
    <el-pagination class="page-box" @size-change="handleSizeChange" @current-change="handleCurrentChange" background :current-page="childMsg.page" :page-sizes="pageSizes" :page-size="childMsg.limit" :layout="layout" :total="childMsg.total"></el-pagination>
  </div>
</template>
<script>
  export default {
    name: 'Pagination',
    props: {
      childMsg: { type: Object, default: () => {} },
      pageSizes: { type: Array, default: [10,20,30,40,50,100] },
      layout: { type: String, default: "total, sizes, prev, pager, next, jumper" },
    },
    data() {
      return {
        pageparm: {
          page: this.childMsg.page || 1,
          limit: this.childMsg.limit || 20,
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

<style lang="scss" scoped>
  .lyPagination-page{
    display: flex;
    align-items: center;
    background: var(--el-fill-color-blank);
    border-bottom: 1px solid var(--el-border-color-light);
    border-left: 1px solid var(--el-border-color-light);
    border-right: 1px solid var(--el-border-color-light);
  }
  .page-box {
    margin: 12px auto;
    text-align: center;
    .el-pagination__editor.el-input{
      width: 70px !important;
      .el-input__inner{
        text-indent: 0 !important;
      }
    }
  }
</style>

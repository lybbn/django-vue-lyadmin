import {getTableHeight} from "@/utils/util";
export const lyMixins = {

    data() {
        return {
            tableHeight:500,
        }
    },
    methods:{
        // 计算搜索栏的高度
        listenResize() {
            this.$nextTick(() => {
                this.getTheTableHeight()
            })
        },
        getTheTableHeight(){
            let orderstaticHeight = 0
            if(this.$refs.orderStatic && this.$refs.orderStatic !==undefined){
                orderstaticHeight = this.$refs.orderStatic.offsetHeight
            }
            orderstaticHeight = this.isFull?orderstaticHeight - 110:orderstaticHeight
            this.tableHeight =  getTableHeight(this.$refs.tableSelect.offsetHeight+orderstaticHeight)
        }
    },
    mounted() {
            // 监听页面宽度变化搜索框的高度
            window.addEventListener('resize', this.listenResize);
            this.$nextTick(() => {
                this.getTheTableHeight()
            })
    },
    unmounted() {
          // 页面销毁，去掉监听事件
        window.removeEventListener("resize", this.listenResize);
    },
}
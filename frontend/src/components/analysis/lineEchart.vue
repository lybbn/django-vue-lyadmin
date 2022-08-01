<template>
    <div id="lyechartmain"  style="width: 100%;height: 280px"></div>
</template>

<script>
    import {onBeforeUnmount, onMounted} from "vue";
    // 按需引入echarts
    import echarts from "@/components/analysis/echartsInstall";
    export default {
        name: "LyLineEchart",
        setup() {
            let myChart = null
            let option = {
                title: {
                text: ''
                },
                tooltip: {
                trigger: 'axis',
                axisPointer: {
                  type: 'cross',
                  label: {
                    backgroundColor: '#6a7985'
                  }
                }
                },
                legend: {
                data: ['衣服', '零食', '手机', '生鲜', '母婴']
                },
                toolbox: {
                feature: {
                  saveAsImage: {}
                }
                },
                grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
                },
                xAxis: [
                {
                  type: 'category',
                  boundaryGap: false,
                  data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                }
                ],
                yAxis: [
                {
                  type: 'value'
                }
                ],
                series: [
                {
                  name: '衣服',
                  type: 'line',
                  stack: 'Total',
                  areaStyle: {},
                  emphasis: {
                    focus: 'series'
                  },
                  data: [120, 132, 101, 134, 90, 230, 210]
                },
                {
                  name: '零食',
                  type: 'line',
                  stack: 'Total',
                  areaStyle: {},
                  emphasis: {
                    focus: 'series'
                  },
                  data: [220, 182, 191, 234, 290, 330, 310]
                },
                {
                  name: '手机',
                  type: 'line',
                  stack: 'Total',
                  areaStyle: {},
                  emphasis: {
                    focus: 'series'
                  },
                  data: [150, 232, 201, 154, 190, 330, 410]
                },
                {
                  name: '生鲜',
                  type: 'line',
                  stack: 'Total',
                  areaStyle: {},
                  emphasis: {
                    focus: 'series'
                  },
                  data: [320, 332, 301, 334, 390, 330, 320]
                },
                {
                  name: '母婴',
                  type: 'line',
                  stack: 'Total',
                  label: {
                    show: true,
                    position: 'top'
                  },
                  areaStyle: {},
                  emphasis: {
                    focus: 'series'
                  },
                  data: [820, 932, 901, 934, 1290, 1330, 1320]
                }
                ]
                };
            onMounted(() => {//需要获取到element,所以是onMounted的Hook
                setTimeout(() => {
                    myChart = echarts.init(document.getElementById("lyechartmain"));
                    myChart.setOption(option);
                },300)
                // myChart = echarts.init(document.getElementById("lyechartmain"));
                // // 绘制图表
                // myChart.setOption(option);
                window.onresize = function () {//自适应大小
                    myChart.resize();
                };
            });
            onBeforeUnmount(() => {
                window.onresize = null;
            })
            function handleResize() {
                if(myChart){
                    myChart.resize();
                }
            }
            return ({
                handleResize
            })
        },


    }
</script>

<style scoped>

</style>
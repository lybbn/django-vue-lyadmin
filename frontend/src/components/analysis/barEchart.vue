<template>
    <div id="lyechartmain"  style="width: 100%;height: 280px"></div>
</template>

<script>
    import {onMounted, nextTick, watch, onUnmounted,onBeforeUnmount,ref } from "vue";
    // import * as echarts from 'echarts'
    // 按需引入echarts
    import echarts from "@/components/analysis/echartsInstall";
    export default {
        name: "LyBarEchart",
        setup() {
            let myChart = null
            let option = {
                xAxis: {
                    type: 'category',
                    data: ['1月', '2月', '3月', '4月', '5月', '6月', '7月','8月','9月','10月','11月','12月']
                },
                yAxis: {
                    type: 'value'
                },
                series: [
                {
                    data: [120, 200, 150, 80, 70, 110, 130,20,180,75,69,190],
                    type: 'bar'
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

        },
    }
</script>

<style scoped>

</style>
import { defineStore } from 'pinia'
import colorTool from '@/utils/color'

export const useSiteThemeStore = defineStore('siteTheme', {
    state:() => {
        return {
            //控制主题:light正常模式、dark暗黑模式
            siteTheme:localStorage.getItem('siteTheme')?localStorage.getItem('siteTheme'):"light",
            colorPrimary:localStorage.getItem('colorPrimary')?localStorage.getItem('colorPrimary'):"#409EFF",
        }
    },
    getters:{
    },
    actions: {
        setSiteTheme(val) {
            this.siteTheme = val;
            localStorage.setItem('siteTheme',val);
            if (this.siteTheme === 'dark') {
                document.documentElement.classList.add('dark')
            } else {
                document.documentElement.classList.remove('dark')
            }
        },
        setColorPrimary(val) {
            this.colorPrimary = val;
            localStorage.setItem('colorPrimary',val);
            if(this.colorPrimary){
                document.documentElement.style.setProperty('--el-color-primary', this.colorPrimary);
                for (let i = 1; i <= 9; i++) {
                    document.documentElement.style.setProperty(`--el-color-primary-light-${i}`, colorTool.lighten(this.colorPrimary,i/10));
                }
                for (let i = 1; i <= 9; i++) {
                    document.documentElement.style.setProperty(`--el-color-primary-dark-${i}`, colorTool.darken(this.colorPrimary,i/10));
                }
            }
        },
    },
})
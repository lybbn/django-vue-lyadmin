import { defineStore } from 'pinia'
import colorTool from '@/utils/color'
import {setStorage,getStorage} from '@/utils/util'
import config from "@/config"

export const useSiteThemeStore = defineStore('siteTheme', {
    state:() => {
        return {
            //控制主题:light正常模式、dark暗黑模式
            siteTheme:getStorage('siteTheme')?getStorage('siteTheme'):config.THEME,
            colorPrimary:getStorage('colorPrimary')?getStorage('colorPrimary'):config.COLOR,
        }
    },
    getters:{
    },
    actions: {
        setSiteTheme(val) {
            this.siteTheme = val;
            setStorage('siteTheme',val);
            if (this.siteTheme === 'dark') {
                document.documentElement.classList.add('dark')
            } else {
                document.documentElement.classList.remove('dark')
            }
        },
        setColorPrimary(val) {
            this.colorPrimary = val;
            setStorage('colorPrimary',val);
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
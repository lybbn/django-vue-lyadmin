import { defineStore } from 'pinia'

export const useSiteThemeStore = defineStore('siteTheme', {
    state:() => {
        return {
            //控制主题:light正常模式、dark暗黑模式
            siteTheme:localStorage.getItem('siteTheme')?localStorage.getItem('siteTheme'):"light",
        }
    },
    getters:{
    },
    actions: {
        setSiteTheme(val) {
            this.siteTheme = val;
            localStorage.setItem('siteTheme',val);
        },
    },
})
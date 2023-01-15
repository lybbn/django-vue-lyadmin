import { defineStore } from 'pinia'
import colorTool from '@/utils/color'
import {setStorage,getStorage} from '@/utils/util'
import config from "@/config"
import i18n from '@/locales'

export const useSiteThemeStore = defineStore('siteTheme', {
    state:() => {
        return {
            //控制主题:light正常模式、dark暗黑模式
            siteTheme:getStorage('siteTheme')?getStorage('siteTheme'):config.THEME,
            //主题颜色
            colorPrimary:getStorage('colorPrimary')?getStorage('colorPrimary'):config.COLOR,
            //语言
            language:getStorage('language')?getStorage('language'):config.LANG,
            // elementplus 组件大小： small、default、large
            elementSize: getStorage('elementSize')?getStorage('elementSize'):config.ELEMENT_SIZE,
            // elementplus 组件 zIndex
            elementzIndex: getStorage('elementzIndex')?getStorage('elementzIndex'):config.ELEMENT_ZINDEX,
            // elementplus button组件 autoInsertSpace 是否自动在两个中文字符之间插入空格
            elementButton: getStorage('elementButton')?getStorage('elementButton'):config.ELEMENT_BUTTON,
            //菜单宽度
            menuWidth:getStorage('menuWidth')?getStorage('menuWidth'):config.MENU_WIDTH,
            //左侧菜单和顶部导航颜色
            menuHeaderColor:getStorage('menuHeaderColor')?getStorage('menuHeaderColor'):config.MENU_HEADER_COLOR
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
        setLanguage(val){
            this.language = val
            i18n.global.locale.value = val;
            setStorage('language',val);
        },
        setElementSize(val){
            this.elementSize = val
            setStorage('elementSize',val);
        },
        setElementzIndex(val){
            this.elementzIndex = val
            setStorage('elementzIndex',val);
        },
        setElementButton(val){
            this.elementButton = val
            setStorage('elementButton',val);
        },
        setMenuWidth(val){
            this.menuWidth = val
            setStorage('menuWidth',val);
        },
        setMenuHeaderColor(val){
            this.menuHeaderColor = val
            setStorage('menuHeaderColor',val);
            if(this.menuHeaderColor && this.siteTheme === 'light'){
                document.documentElement.style.setProperty('--l-header-bg', this.menuHeaderColor);
            }
        },
    },
})
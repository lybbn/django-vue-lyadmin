import { defineStore } from 'pinia'

export const useKeepAliveStore = defineStore('keepAlive', {
    state:() => {
        return {
            keepAliveRoute:['server'],//希望缓存的页面name，如['server']
        }
    },
    getters:{

    },
    actions: {
    },
})
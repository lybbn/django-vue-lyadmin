const modules = require.context('.', true, /\.vue$/)

export default {
    install(app) {
        modules.keys().forEach(e => {
            const component = modules(e).default
            const cname = e.split('/').pop()?.split('.')[0]//根据路径截取name文件名（去除后缀和前面目录）
            app.component(cname,component)
        })
    }
}
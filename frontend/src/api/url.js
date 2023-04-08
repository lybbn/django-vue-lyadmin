import config from "@/config"
// let _url;
// let _domain
// if (process.env.NODE_ENV == "development") {
//     _domain = "127.0.0.1:8000"
//     //本地开发
//     _url = "http://"+_domain+"/api/"; //测试地址/
// } else {
//     _domain = "django-vue3-lyadmin.lybbn.cn"
//     _url = "https://"+_domain+"/api/"; //线上地址
// }
export const domain = config.API_DOMAIN;
export const url = config.API_URL;

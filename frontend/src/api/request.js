import axios from 'axios';
import { ElMessage,ElMessageBox } from 'element-plus'
require("babel-polyfill");
import { url } from './url';
import router from "../router";

var request = axios.create({
    timeout: 10000,
});
function ajax(opt,method){
  var token= localStorage.getItem('logintoken')
  // var timestamp=new Date().getTime();
  var params;

  if(opt.params){
    //对传入的参数进行深拷贝，防止传入的参数对象被页面上其他逻辑改变，导致签名错误
    if (Object.prototype.toString.call(opt.params) != '[object FormData]') {
      // 不是formdata类型
      params = JSON.parse(JSON.stringify(opt.params));
    }else{//formdata类型
      params= opt.params
    }
    if(method=='GET') {
      params={
        ...params,
        // 't':timestamp
      }
    }
  }else{
    params={}
  }

  if(method == 'PUT' || method == 'DELETE') {
      var config={
          url: url + opt.url + params.id+'/',
          method: method,
          headers:{
              Authorization: 'JWT ' + token,
          }
      }
      if(!params.id){
          config={
          url: url + opt.url,
          method: method,
          headers:{
              Authorization: 'JWT ' + token,
          }
        }
      }

      method==="PUT"&&(config.params=params);
      return new Promise((resolve,reject)=>{
          request({
                url: config.url,
                method: method,
                headers:{
                    Authorization: 'JWT ' + token,
                },
                data: params
              }).then(res=>{
              if(res.data.code==4001){
                  ElMessageBox.alert('登录信息失效,请重新登录！','登录失效',{
                      confirmButtonText:'确定',
                      type: 'warning',
                      callback: action => {
                          //跳转登录页   callback点击确定按钮后的回调函数
                          localStorage.clear();
                          sessionStorage.clear();
                          window.location.href="/"
                      }
                  })
              }else{
                  resolve(res.data)
              }
          }).catch(res=>{
              ElMessage.error("请求失败");
              reject(res)
          })
      })
  }else if(method == 'GET2'){
      var config2={
          url: url + opt.url + params.id+'/',
          method: 'GET',
          headers:{
              Authorization: 'JWT ' + token,
          }
      }
      if(!params.id){
          config2={
              url: url + opt.url,
              method: 'GET',
              headers:{
                  Authorization: 'JWT ' + token,
              }
          }
      }
      return new Promise((resolve,reject)=>{
          // console.log(config,'config')
          request({
              url: config2.url,
              method: 'GET',
              headers:{
                  Authorization: 'JWT ' + token,
              },
              data: params
          }).then(res=>{
              if(res.data.code==4001){
                  ElMessageBox.alert('登录信息失效,请重新登录！','登录失效',{
                      confirmButtonText:'确定',
                      type: 'warning',
                      callback: action => {
                          //跳转登录页   callback点击确定按钮后的回调函数
                          localStorage.clear();
                          sessionStorage.clear();
                          window.location.href="/"
                      }
                  })
              }else{
                  resolve(res.data)
              }
          }).catch(res=>{
              ElMessage.error("请求失败");
              reject(res)
          })
      })
  }
  else {
      var config1={
          url: url + opt.url,
          method: method,
          headers:{
              Authorization: 'JWT ' + token,
          }
      }
      method==="GET"&&(config1.params=params);
      method==="POST"&&(config1.data=params);
      method==="PATCH"&&(config1.data=params);
      return new Promise((resolve,reject)=>{
          request(config1).then(res=>{
              if(res.data.code==4001){
                  ElMessageBox.alert('登录信息失效,请重新登录！','登录失效',{
                      confirmButtonText:'确定',
                      type: 'warning',
                      callback: action => {
                          //跳转登录页   callback点击确定按钮后的回调函数
                          localStorage.clear();
                          sessionStorage.clear();
                          window.location.href="/"
                      }
                  })
              }else{
                  resolve(res.data)
              }
          }).catch(res=>{
              ElMessage.error("请求失败");
              reject(res)
          })
      })
  }
}



export function ajaxGet (opt) {
    return ajax(opt,"GET")
}
export function ajaxPut (opt) {
    return ajax(opt,"PUT")
}
export function ajaxDelete (opt) {
    return ajax(opt,"DELETE")
}
export function ajaxPost (opt) {
  return ajax(opt,"POST")
}
export function ajaxPatch (opt) {
  return ajax(opt,"PATCH")
}
// 单例详情获取get /api/test/12xxxxxxxx/
export function ajaxGetDetailByID (opt) {
    return ajax(opt,"GET2")
}

//websocket获取jwt请求token
export function getJWTAuthorization() {
    var token= localStorage.getItem('logintoken')
    var jwt = 'JWTlybbn' + token
    return jwt
}

export function reqExpost (method, url, params) {
  // const timestamp = new Date().getTime().toString();
  let token = localStorage.getItem('logintoken')
  for (let key in params){
    if(params[key]==null || params[key] == 'undefined' ||  params[key]==''){
      delete params[key]
    }
  }
  const keys = Object.keys(params).sort(); let i;
  const length = keys.length;
  let key;
  let sortedString = '';
  for (i = 0; i < length; i++) {
    key = keys[i];
    sortedString += (key + '=' + params[key]);
  }
  return axios({
    method: method,
    url: url ,
    headers: {
      'Content-Type': 'application/json',
      Authorization: 'JWT ' + token,
    },
    data: params,
    responseType: 'blob' // 表明返回服务器返回的数据类型
  }).then(res => res.data);
}
// 上传图片
export function uploadImg (param) {
    let formData = new FormData()
    formData.append('file', param.params.file)
    let token= localStorage.getItem('logintoken')
    return axios({
        method: 'post',
        url: url+param.url ,
            headers: {
                'Content-Type': 'multipart/form-data',
                Authorization: 'JWT ' + token,
        },
        data:formData,
        onUploadProgress: progressEvent => {
            // progressEvent.loaded:已上传文件大小
            // progressEvent.total:被上传文件的总大小
            let loadProgress = (progressEvent.loaded / progressEvent.total * 100)
            if(param.params.onProgress){
                param.params.onProgress({percent: loadProgress})
            }
            // console.info(progressEvent.loaded)
            // console.info(progressEvent.total)
          }
    }).then(res => res.data);
}
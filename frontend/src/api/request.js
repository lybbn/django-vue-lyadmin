import axios from 'axios';
import Vue from '../main.js';
require("babel-polyfill");
import { url } from './url';
import md5 from 'js-md5';
import router from '../router';
// import store from '@/store';

var request = axios.create({
  timeout: 120000,
});

function sortObj(params) {
  let sortedStr = '';
  let keys = Object.keys(params).sort();
  for (let key of keys) {
    if (Array.isArray(params[key])) {
      if (Object.prototype.toString.call(params[key][0]) === '[object Object]') {
        for (let obj of params[key]) {
          sortedStr += (key + "=" + sortObj(obj));
        }
      } else {
        sortedStr += (key + "=" + JSON.stringify(params[key]));
      }
    } else {
      sortedStr += (key + "=" + params[key]);
    }
  }
  return sortedStr;
}

function ajax(opt,method){
  var token= sessionStorage.getItem('logintoken')
  var timestamp=new Date().getTime();
  var params;

  if(opt.params){
    //对传入的参数进行深拷贝，防止传入的参数对象被页面上其他逻辑改变，导致签名错误
    params=JSON.parse(JSON.stringify(opt.params));
    if(method=='GET') {
      params={
        ...params,
        // 't':timestamp
      }
    }
  }else{
    params={}
  }
  //axios会自动过滤值为undefined和null的参数，因此手动去掉这些参数，不让其参与签名，避免出现签名错误
  for (let key in params){
    if(params[key]==null || params[key] == 'undefined'){
      delete params[key]
    }
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
          // console.log(config,'config')
          request({
                url: config.url,
                method: method,
                headers:{
                    Authorization: 'JWT ' + token,
                },
                data: params
              }).then(res=>{
              if(res.data.code==4001){
                  localStorage.clear();
                  router.replace("/login");
                  sessionStorage.clear();
                  reject(res.data)
              }else{
                  resolve(res.data)
              }
          }).catch(res=>{
              Vue.$message.error("请求失败");
              // Vue.$message.error(JSON.stringify(res));
              reject(res)
          })
      })
  }else if(method == 'GET2'){
      var config={
          url: url + opt.url + params.id+'/',
          method: 'GET',
          headers:{
              Authorization: 'JWT ' + token,
          }
      }
      if(!params.id){
          config={
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
              url: config.url,
              method: 'GET',
              headers:{
                  Authorization: 'JWT ' + token,
              },
              data: params
          }).then(res=>{
              if(res.data.code==4001){
                  localStorage.clear();
                  router.replace("/login");
                  sessionStorage.clear();
                  reject(res.data)
              }else{
                  resolve(res.data)
              }
          }).catch(res=>{
              Vue.$message.error("请求失败");
              // Vue.$message.error(JSON.stringify(res));
              reject(res)
          })
      })
  }
  else {
      var config={
          url: url + opt.url,
          method: method,
          headers:{
              Authorization: 'JWT ' + token,
          }
      }
      method==="GET"&&(config.params=params);
      method==="POST"&&(config.data=params);
      method==="PATCH"&&(config.data=params);
      return new Promise((resolve,reject)=>{
          request(config).then(res=>{
              if(res.data.code==4001){
                  localStorage.clear();
                  router.replace("/login");
                  sessionStorage.clear();
                  reject(res.data)
              }else{
                  resolve(res.data)
              }
          }).catch(res=>{
              Vue.$message.error("请求失败");
              // Vue.$message.error(JSON.stringify(res));
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

export function reqExpost (method, url, params) {
  const timestamp = new Date().getTime().toString();
  let token = sessionStorage.getItem('logintoken')
  for (let key in params){
    if(params[key]==null || params[key] == 'undefined' ||  params[key]==''){
      delete params[key]
    }
  }
  const keys = Object.keys(params).sort(); let i;
  const length = keys.length; let key; let sortedString = '';
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
};
// 上传图片
export function uploadImg (param) {
    let formData = new FormData()
    formData.append('file', param.params.file)
    let token= sessionStorage.getItem('logintoken')
    return axios({
        method: 'post',
        url: url+param.url ,
            headers: {
                'Content-Type': 'multipart/form-data',
                Authorization: 'JWT ' + token,
        },
        data:formData,
    }).then(res => res.data);
};


import OSS from 'ali-oss';

// const client = new OSS({
//   region: 'oss-cn-beijing',
//   accessKeyId: this.accessKeyId,
//   accessKeySecret: this.accessKeySecret,
//   bucket: this.backetName
// })
import {url} from '@/api/url'
let token = sessionStorage.getItem('logintoken')

/*富文本编辑图片上传配置*/
const uploadConfig = {
  action:  url+'platformsettings/uploadplatformimg/',  // 必填参数 图片上传地址
  methods: 'POST',  // 必填参数 图片上传方式
  token: 'JWT '+token,  // 可选参数 如果需要token验证，假设你的token有存放在sessionStorage
  name: 'file',  // 必填参数 文件的参数名
  size: 5000000,  // 可选参数   图片大小，单位为Kb, 1M = 1024Kb
  accept: 'image/png, image/gif, image/jpeg, image/bmp, image/x-icon'  // 可选 可上传的图片格式
};

import Quill from 'quill'  //引入编辑器
var fonts = ['Microsoft-YaHei','SimSun', 'SimHei','KaiTi','Arial','Times-New-Roman'];
var Font = Quill.import('formats/font');
Font.whitelist = fonts; //将字体加入到白名单

let fontSizeStyle = Quill.import('attributors/style/size')
fontSizeStyle.whitelist = ['10px', '12px', '14px', '16px', '18px', '20px', '22px', '24px', '26px', '32px', '48px']
Quill.register(fontSizeStyle, true)

// toolbar工具栏的工具选项（默认展示全部）
const toolOptions = [
  ['bold', 'italic', 'underline', 'strike'],// 加粗 斜体 下划线 删除线
  ['blockquote', 'code-block'],// 引用  代码块
  [{'header': 1}, {'header': 2}],// 1、2 级标题
  [{'list': 'ordered'}, {'list': 'bullet'}],// 有序、无序列表
  [{'script': 'sub'}, {'script': 'super'}],// 上标/下标
  [{'indent': '-1'}, {'indent': '+1'}],// 缩进
  [{'direction': 'rtl'}],// 文本方向
  // [{'size': ['small', false, 'large', 'huge']}], // 字体大小
  [{'size': fontSizeStyle.whitelist}],
  [{'header': [1, 2, 3, 4, 5, 6, false]}],// 标题
  [{'color': [] }, {'background': [] }],// 字体颜色、字体背景颜色
  [{'font': fonts }],// 字体种类
  [{'align': [] }],// 对齐方式
  ['clean'],// 清除文本格式
  ['link', 'image', 'video']// 链接、图片、视频
];
const handlers = {
  image: function image() {
    var self = this;

    var fileInput = this.container.querySelector('input.ql-image[type=file]');
    let editFileList = [];
    if (fileInput === null) {
      fileInput = document.createElement('input');
      fileInput.setAttribute('type', 'file');
      fileInput.setAttribute("multiple","multiple")
      // 设置图片参数名
      if (uploadConfig.name) {
        fileInput.setAttribute('name', uploadConfig.name);
      }
      // 可设置上传图片的格式
      fileInput.setAttribute('accept', uploadConfig.accept);
      fileInput.classList.add('ql-image');
      // 监听选择文件
      fileInput.addEventListener('change', () => {
        let fileList = [];
        for (let i = 0; i < fileInput.files.length; i++) {
          fileList.push(fileInput.files[i]);
        }
        fileList.forEach((singleFile) => {
          // 创建formData
          let formData = new FormData();
          formData.append(uploadConfig.name, singleFile);
          formData.append('object','product');
          // // 如果需要token且存在token
          // if (uploadConfig.token) {
          //   formData.append('token', uploadConfig.token)
          // }
          // 图片上传
          let xhr = new XMLHttpRequest();
          xhr.open(uploadConfig.methods, uploadConfig.action, true);
          //设置图片上传身份认证
          if (uploadConfig.token) {
              xhr.setRequestHeader('authorization', uploadConfig.token)
          }
          // 上传数据成功，会触发
          xhr.onload = function (e) {
            if (xhr.status === 200) {
              var res =JSON.parse(xhr.responseText);
              // console.log(res)
              // editFileList.push(res.data.data)
              // // console.log('111', editFileList.length, fileList.length)
              // if (editFileList.length === fileList.length) {
              //   // 图片排序
              //   editFileList.sort((f1, f2) => {
              //     let num1 = parseInt(f1.substring(f1.lastIndexOf('\/') + 1, f1.lastIndexOf('\.')).replace(/[^0-9]/ig,""));
              //     let num2 = parseInt(f2.substring(f2.lastIndexOf('\/') + 1, f2.lastIndexOf('\.')).replace(/[^0-9]/ig,""));
              //     return num1 - num2;
              //   });
              //   // 将图片插入编辑器中
              //   for (let i = 0; i < editFileList.length; i++) {
              //     let length = self.quill.getSelection(true).index;
              //     console.log(editFileList[i],'------------------')
              //     // 获取光标所在位置
              //     self.quill.insertEmbed(length, 'image', editFileList[i])        // 插入图片  res.info为服务器返回的图片地址
              //     self.quill.setSelection(length + 1)                             // 调整光标到最后
              //   }
              // }
              let length = self.quill.getSelection(true).index;

              //这里很重要，你图片上传成功后，img的src需要在这里添加，res.path就是你服务器返回的图片链接。
              let imgpath=''
              if (res.data.data[0].indexOf("://")>=0){
                  imgpath = res.data.data[0]

              }else{
                  imgpath = url.split('/api')[0]+res.data.data[0]
              }
              self.quill.insertEmbed(length, 'image', imgpath);

              self.quill.setSelection(length +1)
            }
            fileInput.value = ''
          };
          // 开始上传数据
          xhr.upload.onloadstart = function (e) {
            fileInput.value = ''
          };
          // 当发生网络异常的时候会触发，如果上传数据的过程还未结束
          xhr.upload.onerror = function (e) {
          };
          // 上传数据完成（成功或者失败）时会触发
          xhr.upload.onloadend = function (e) {
            // console.log('上传结束')
          };
          xhr.send(formData)
        });
      });
      this.container.appendChild(fileInput);
    }
    fileInput.click();
  }
};

export default {
  placeholder: '请输入内容',
  theme: 'snow',  // 主题
  modules: {
      history: {
          delay: 1000,
          maxStack: 50,
          userOnly: false
      },
      imageDrop: true,
      imageResize: {
          displayStyles: {
              backgroundColor: 'black',
              border: 'none',
              color: 'white'
          },
          modules: [ 'Resize', 'DisplaySize', 'Toolbar' ]
      },
    toolbar: {
      container: toolOptions,  // 工具栏选项
      handlers: handlers  // 事件重写
    }
  }
};

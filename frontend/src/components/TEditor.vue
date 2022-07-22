<template>
  <div class="tinymce-editor">
    <Editor
      :id="tinymceId"
      v-model="myValue"
      :init="init"
      :disabled="disabled"
      @onClick="onClick"
    />
  </div>
</template>

<script>
import {url} from '@/api/url'
import axios from 'axios'
let token = sessionStorage.getItem('logintoken')
import tinymce from 'tinymce/tinymce' // tinymce默认hidden，不引入不显示
import Editor from '@tinymce/tinymce-vue' // 编辑器引入

import 'tinymce/themes/silver' // 编辑器主题，不引入则报错
import 'tinymce/icons/default' // 引入编辑器图标icon，不引入则不显示对应图标
// import 'tinymce/skins/ui/oxide/content.css'
// import 'tinymce/skins/content/default/content.css'
// // 引入编辑器插件（基本免费插件都在这儿了）
import 'tinymce/plugins/advlist' // 高级列表
import 'tinymce/plugins/anchor' // 锚点
import 'tinymce/plugins/autolink' // 自动链接
import 'tinymce/plugins/autoresize' // 编辑器高度自适应,注：plugins里引入此插件时，Init里设置的height将失效
import 'tinymce/plugins/autosave' // 自动存稿
import 'tinymce/plugins/charmap' // 特殊字符
import 'tinymce/plugins/code' // 编辑源码
import 'tinymce/plugins/codesample' // 代码示例
import 'tinymce/plugins/directionality' // 文字方向
import 'tinymce/plugins/emoticons' // 表情
import 'tinymce/plugins/fullpage' // 文档属性
import 'tinymce/plugins/fullscreen' // 全屏
import 'tinymce/plugins/help' // 帮助
import 'tinymce/plugins/hr' // 水平分割线
import 'tinymce/plugins/image' // 插入编辑图片
import 'tinymce/plugins/importcss' // 引入css
import 'tinymce/plugins/insertdatetime' // 插入日期时间
import 'tinymce/plugins/link' // 超链接
import 'tinymce/plugins/lists' // 列表插件
import 'tinymce/plugins/media' // 插入编辑媒体
import 'tinymce/plugins/nonbreaking' // 插入不间断空格
import 'tinymce/plugins/pagebreak' // 插入分页符
import 'tinymce/plugins/paste' // 粘贴插件
import 'tinymce/plugins/preview'// 预览
// import 'tinymce/plugins/print'// 打印
import 'tinymce/plugins/quickbars' // 快速工具栏
import 'tinymce/plugins/save' // 保存
import 'tinymce/plugins/searchreplace' // 查找替换
// import 'tinymce/plugins/spellchecker'  //拼写检查，暂未加入汉化，不建议使用
import 'tinymce/plugins/tabfocus' // 切入切出，按tab键切出编辑器，切入页面其他输入框中
import 'tinymce/plugins/table' // 表格
// import 'tinymce/plugins/template' // 内容模板
import 'tinymce/plugins/textcolor' // 文字颜色
import 'tinymce/plugins/textpattern' // 快速排版
import 'tinymce/plugins/toc' // 目录生成器
import 'tinymce/plugins/visualblocks' // 显示元素范围
import 'tinymce/plugins/visualchars' // 显示不可见字符
import 'tinymce/plugins/wordcount' // 字数统计

const fonts = [
  '宋体=宋体',
  '微软雅黑=微软雅黑',
  '新宋体=新宋体',
  '黑体=黑体',
  '楷体=楷体',
  '隶书=隶书',
  'Courier New=courier new,courier',
  'AkrutiKndPadmini=Akpdmi-n',
  'Andale Mono=andale mono,times',
  'Arial=arial,helvetica,sans-serif',
  'Arial Black=arial black,avant garde',
  'Book Antiqua=book antiqua,palatino',
  'Comic Sans MS=comic sans ms,sans-serif',
  'Courier New=courier new,courier',
  'Georgia=georgia,palatino',
  'Helvetica=helvetica',
  'Impact=impact,chicago',
  'Symbol=symbol',
  'Tahoma=tahoma,arial,helvetica,sans-serif',
  'Terminal=terminal,monaco',
  'Times New Roman=times new roman,times',
  'Trebuchet MS=trebuchet ms,geneva',
  'Verdana=verdana,geneva',
  'Webdings=webdings',
  'Wingdings=wingdings,zapf dingbats'
]
export default {
  name:'tEditor',
  components: {
    Editor
  },
  props: {
    // 内容
    value: {
      type: String,
      default: ''
    },
    tinymceId: {
      type: String,
      default: 'tinymce'
    },
    // 是否禁用
    disabled: {
      type: Boolean,
      default: false
    },
    // 插件
    plugins: {
      type: [String, Array],
      default: 'emoticons preview searchreplace autolink directionality visualblocks visualchars fullscreen image link media code codesample table charmap hr pagebreak nonbreaking anchor insertdatetime advlist lists wordcount textpattern autosave '
    },
    // 工具栏
    toolbar: {
      type: [String, Array],
      default:
        'fullscreen undo redo restoredraft | cut copy paste pastetext | forecolor backcolor bold italic underline strikethrough link anchor \ table image | alignleft aligncenter alignright alignjustify outdent indent | \ styleselect formatselect fontselect fontsizeselect | bullist numlist | blockquote subscript superscript removeformat | media charmap emoticons hr pagebreak insertdatetime print preview | code selectall searchreplace visualblocks | indent2em lineheight formatpainter axupimgs'
    }
  },
  data() {
    return {
      myValue: this.value,
      init: {
        relative_urls : false,
        convert_urls: false,
        deprecation_warnings: false,
        cleanup: true,
        // forced_root_block:false,//去除回车换行自动添加的p标签
        selector: '#tinymce',
        language_url: 'static/tinymce/langs/zh_CN.js', // 汉化路径是自定义的，一般放在public或static里面
        language: 'zh_CN',
        emoticons_database_url: 'static/tinymce/plugins/emoticons/js/emojis.js',
        skin_url: 'static/tinymce/skins/ui/oxide', // 皮肤：浅色
        // skin_url: '/tinymce/skins/ui/oxide-dark',//皮肤：暗色
        content_css: false,//解决/static/js/skins/content/default/content.css 打包后加载bug报错问题
        plugins: this.plugins, // 插件
        toolbar: this.toolbar,// 工具栏
        toolbar_location: '/',
        lineheight_formats: '0.5 0.8 1 1.2 1.5 1.75 2 2.5 3 4 5', // 行高配置，也可配置成"12px 14px 16px 20px"这种形式
        fontsize_formats:'12px 14px 16px 18px 20px 22px 24px 28px 32px 36px 48px 56px 72px', // 字体大小
        font_formats: fonts.join(';'),
        height: 350, // 高度
        placeholder: '在这里输入文字',
        branding: false, // 隐藏右下角技术支持
        elementpath: false, // 元素路径是否显示
        paste_data_images: true, // 图片是否可粘贴
        // 图片上传
        images_upload_handler: function(blobInfo, success, failure) {
          // 文件上传的formData传递
          // 可以限制图片大小
          // if (blobInfo.blob().size / 1024 / 1024 > 2) {
          //   failure('上传失败，图片大小请控制在 2M 以内')
          // } else {}
          const params = new FormData()
          params.append('file', blobInfo.blob())
          const config = {
            headers: {
                'Content-Type': 'multipart/form-data',
                'Authorization': 'JWT '+token,  // 可选参数(服务器上传验证需要) 如果需要token验证，假设你的token有存放在sessionStorage
            }
          }
          const uploadurl = url + 'platformsettings/uploadplatformimg/'
              // 图片上传
              axios.post(uploadurl, params, config).then(res => {
                if (res.data.code == 2000) {
                    //这里很重要，你图片上传成功后，img的src需要在这里添加，res.path就是你服务器返回的图片链接。
                      let imgpath=''
                      if (res.data.data.data[0].indexOf("://")>=0){
                          imgpath = res.data.data.data[0]

                      }else{
                          imgpath = url.split('/api')[0]+res.data.data.data[0]
                      }
                     success(imgpath) // 上传成功，在成功函数里填入图片路径
                     // console.log('[文件上传]', res.data)
                } else {
                  failure('上传失败')
                }
              }).catch(() => {
                failure('上传出错，服务器开小差了呢')
              })
        }
      }
    }
  },
  watch: {
    // 监听内容变化
    value(newValue) {
      this.myValue = newValue == null ? '' : newValue
    },
    myValue(newValue) {
      if (this.triggerChange) {
        this.$emit('change', newValue)
      } else {
        this.$emit('input', newValue)
      }
    }
  },
  mounted() {
    tinymce.init({})
  },
  methods: {
    onClick(e) {
      this.$emit('onClick', e, tinymce)
    },
    // 可以添加一些自己的自定义事件，如清空内容
    clear() {
      this.myValue = ''
    }
  }
}
</script>
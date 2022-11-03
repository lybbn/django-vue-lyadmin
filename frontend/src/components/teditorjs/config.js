//  导入插件
const buttonPlugins = 'emoticons preview searchreplace autolink directionality visualblocks visualchars fullscreen image link media code codesample table charmap hr pagebreak nonbreaking anchor insertdatetime advlist lists wordcount textpattern autosave '

// 导入工具栏
const toolbar = 'fullscreen undo redo restoredraft | cut copy paste pastetext | forecolor backcolor bold italic underline strikethrough link anchor \ table image | alignleft aligncenter alignright alignjustify outdent indent | \ styleselect formatselect fontselect fontsizeselect | bullist numlist | blockquote subscript superscript removeformat | media charmap emoticons hr pagebreak insertdatetime print preview | code selectall searchreplace visualblocks | indent2em lineheight formatpainter axupimgs'

// 初始化配置
export const init = {
  //readonly: false, //只读模式
  // auto_focus: true,//自动聚焦
  relative_urls : false,
  convert_urls: false,//url如图片地址使用绝对路径
  draggable_modal: true,//模态窗口允许拖动
  inline: false,//内联模式
  cleanup: true,
  language_url: 'static/tinymce/langs/zh_CN.js', // 引入语言包文件
  language: 'zh_CN', // 语言类型
  // content_css: true,
  skin_url: 'static/tinymce/skins/ui/oxide', // 皮肤：浅色
  // skin_url: 'static/tinymce/skins/ui/oxide-dark',//皮肤：暗色

  plugins: buttonPlugins, // 插件配置
  toolbar: toolbar, // 工具栏配置，设为false则隐藏

  // menubar: false, // 菜单栏配置，设为false则隐藏，不配置则默认显示全部菜单，也可自定义配置--查看 http://tinymce.ax-z.cn/configure/editor-appearance.php --搜索“自定义菜单”
  emoticons_database_url: 'static/tinymce/plugins/emoticons/js/emojis.js',
  fontsize_formats: '12px 14px 16px 18px 20px 22px 24px 28px 32px 36px 48px 56px 72px', // 字体大小
  font_formats: '微软雅黑=Microsoft YaHei,Helvetica Neue,PingFang SC,sans-serif;苹果苹方=PingFang SC,Microsoft YaHei,sans-serif;宋体=simsun,serif;仿宋体=FangSong,serif;黑体=SimHei,sans-serif;Arial=arial,helvetica,sans-serif;Arial Black=arial black,avant garde;Book Antiqua=book antiqua,palatino;', // 字体样式 微软雅黑=Microsoft YaHei,Helvetica Neue,PingFang SC,sans-serif, 宋体=simsun,serif,仿宋体=FangSong,黑体=SimHei,Arial=arial,
  lineheight_formats: '0.5 0.8 1 1.2 1.5 1.75 2 2.5 3 4 5', // 行高配置，也可配置成"12px 14px 16px 20px"这种形式
  branding: false, // tiny技术支持信息是否显示
  resize: false, // 编辑器宽高是否可变，false-否,true-高可变，'both'-宽高均可，注意引号
  // statusbar: false,  //最下方的元素路径和字数统计那一栏是否显示
  elementpath: false, // 元素路径是否显示

  // content_style: 'p {margin-block-start: 0; margin-block-end: 0; color: #606D81; font-size: 14px;}; table { border: 1px}', // 直接自定义可编辑区域的css样式
  content_css: false,

  paste_data_images: true, // 图片是否可粘贴
  images_upload_handler: (blobInfo, success, failure) => {
  // 需要在setup里面重新写,传入 url
  }
}
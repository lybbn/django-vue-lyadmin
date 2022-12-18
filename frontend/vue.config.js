//以下是webpack配置
const webpack = require('webpack');
const path = require('path');
// 导入compression-webpack-plugin
const CompressionWebpackPlugin = require('compression-webpack-plugin');
// 定义压缩文件类型
const productionGzipExtensions = ['js', 'css'];

function resolve(dir) {
  return path.join(__dirname, dir)
}

module.exports = {
	assetsDir:'static',//表示打包后，静态资源生成到static文件夹中
	publicPath:'./',
	runtimeCompiler: true, /* 开启vue运行时模板编译功能！！ */
	productionSourceMap: false, //打包后是否生成map文件
	// /* 指定node_modules目录中需要做babel转译的依赖库 */
	// transpileDependencies: [
	// 'element-ui', 'vuedraggable',
	// ],
	devServer: {//开发环境
		port:8080,
		host:'0.0.0.0',
		open: true, //配置自动启动浏览器
		// disableHostCheck: process.env.NODE_ENV === 'development', // 关闭 hostcheck
		disableHostCheck:true,
	},
	//gzip配置
	configureWebpack(config){
		config.devtool = 'source-map'
    	config.output.libraryExport = 'default'  /* 解决import UMD打包文件时, 组件install方法执行报错的问题！！ */
		if (process.env.NODE_ENV === 'production') {
			config.plugins.push(new CompressionWebpackPlugin({
				algorithm: 'gzip',
				test: new RegExp('\\.(' + productionGzipExtensions.join('|') + ')$'),
				threshold: 10240,
				minRatio: 0.8
			}))
		}
	},
	//解决富文本编辑器报错imports失败
    chainWebpack(config){
        config.plugin('provide').use(webpack.ProvidePlugin, [
        	{
            	'window.Quill': 'quill'
        	}
        ])
		 config.module
			 .rule('svg')
			 .exclude.add(resolve('src/icons'))
			 .end()
		 config.module
			.rule('icons')
			.test(/\.svg$/)
			.include.add(resolve('src/icons'))
			.end()
			.use('svg-sprite-loader')
			.loader('svg-sprite-loader')
			.options({
				symbolId: 'icon-[name]'
			})
			.end()
    },
}
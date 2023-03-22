//以下是webpack配置
const webpack = require('webpack');
const path = require('path');
// 导入compression-webpack-plugin
const CompressionWebpackPlugin = require('compression-webpack-plugin');
// 定义压缩文件类型
const productionGzipExtensions = ['js', 'css'];

// 拼接路径
const resolve = dir => path.join(__dirname, dir)

const appConfig = require("./src/config/index.js")

module.exports = {
	assetsDir:'static',//表示打包后，静态资源生成到static文件夹中
	publicPath:'./',
	runtimeCompiler: true, /* 开启vue运行时模板编译功能！！ */
	productionSourceMap: false, //打包后是否生成map文件
	lintOnSave:false, // eslint-loader 是否在保存时候检查代码
	devServer: {//开发环境
		port:8080,
		host:'0.0.0.0',
		open: true, //配置自动启动浏览器
		client: {
        	// 当有错误的时候在客户端进行覆盖显示
            overlay: false,
        },
		allowedHosts: 'all'
	},
	//gzip配置
	configureWebpack:config => {
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
    chainWebpack: config => {
		config.plugins.delete('prefetch').delete('preload')
		config.resolve.alias.set('vue-i18n', 'vue-i18n/dist/vue-i18n.cjs.js');
		// 解决 cli3 热更新失效 https://github.com/vuejs/vue-cli/issues/1559
		config.resolve.symlinks(true)
        config.plugin('provide').use(webpack.ProvidePlugin, [
        	{
            	'window.Quill': 'quill'
        	}
        ])
		config.plugin("html").tap((args) => {
			args[0].title = appConfig.APP_TITLE;
			return args;
		})

    },

	// resolve: {
	// 	extensions: ['.ts', '.js', '.mjs', '.json'],
	// },
	// module: {
	// 	rules: [
	// 		{
	// 			test: /\.mjs$/i,
	// 			resolve: { byDependency: { esm: { fullySpecified: false } } },
	// 		},
	// 	],
	// },
}
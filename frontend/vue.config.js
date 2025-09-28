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
	lintOnSave:false, // 是否开启eslint保存检测
	devServer: {//开发环境
		port:8080,
		host:'127.0.0.1',
		open: true, //配置自动启动浏览器
		hot:true, //启用热更新
		client: {
        	// 当有错误的时候在客户端进行覆盖显示
            overlay: false,
        },
		allowedHosts: 'all',
		// 添加代理配置解决CORS问题
		proxy: {
			'/api': {
				target: 'http://127.0.0.1:8000',
				changeOrigin: true,
				secure: false,
				pathRewrite: {
					'^/api': '/api'
				}
			}
		}
	},
	//gzip配置
	configureWebpack:config => {
		//性能提示
		config["performance"] = {
			hints: false,
		}
		if (process.env.NODE_ENV === 'production') {
			config.plugins.push(new CompressionWebpackPlugin({
				algorithm: 'gzip',
				test: new RegExp('\\.(' + productionGzipExtensions.join('|') + ')$'),
				threshold: 10240,
				minRatio: 0.8
			}))

			config['optimization'] = {
				splitChunks:{
					chunks: "all",
					automaticNameDelimiter: '~',
					name: "lyadminChunks",
					cacheGroups: {
						//第三方库抽离
						vendor: {
							name: "modules",
							test: /[\\/]node_modules[\\/]/,
							priority: -10
						},
						elicons: {
							name: "elicons",
							test: /[\\/]node_modules[\\/]@element-plus[\\/]icons-vue[\\/]/
						},
						tinymce: {
							name: "tinymce",
							test: /[\\/]node_modules[\\/]tinymce[\\/]/
						},
						echarts: {
							name: "echarts",
							test: /[\\/]node_modules[\\/]echarts[\\/]/
						},
					}
				}
			}
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
		config.plugin('define').tap((args) => {
			args[0]['__VUE_OPTIONS_API__'] = JSON.stringify(true);
			args[0]['__VUE_PROD_DEVTOOLS__'] = JSON.stringify(false);
			args[0]['__VUE_PROD_HYDRATION_MISMATCH_DETAILS__'] = JSON.stringify(false);
			return args;
		});
    },
}
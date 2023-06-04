import { defineConfig } from 'vite'
import legacyPlugin from '@vitejs/plugin-legacy';
import { resolve } from 'path';
import vuePlugin from '@vitejs/plugin-vue';
import vueJsx from '@vitejs/plugin-vue-jsx';
import vueSetupExtend from 'vite-plugin-vue-setup-extend';
import { createHtmlPlugin } from 'vite-plugin-html'

import appConfig from "./src/config/index.js"

const pathResolve = (dir) => {
	return resolve(__dirname, '.', dir);
};

export default defineConfig(({command,mode,ssrBuild }) => {
  let rollupOptions = {
    output: {
      entryFileNames: `assets/[name].[hash].js`,
      chunkFileNames: `assets/[name].[hash].js`,
      assetFileNames: `assets/[name].[hash].[ext]`,
      compact: true,
      manualChunks: {
        vue: ['vue', 'vue-router', 'pinia'],
        echarts: ['echarts'],
      },
    },
  };

  let optimizeDeps = {};

  let alias = {
    '/@': pathResolve('./src/'),
    '@views': pathResolve('./src/views'),
	  '@/utils': pathResolve('./src/utils'),
    '@/config': pathResolve('./src/config'),
    '@/api': pathResolve('./src/api'),
    '@/store': pathResolve('./src/store'),
    '@/locales': pathResolve('./src/locales'),
    '@/components': pathResolve('./src/components'),
    '@/mixins': pathResolve('./src/mixins'),
    '@/assets': pathResolve('./src/assets'),
	  'vue-i18n': 'vue-i18n/dist/vue-i18n.cjs.js',
  }

  let proxy = {}

  
  let define = {
    'process.env.NODE_ENV': command === 'serve' ? '"development"' : '"production"',
  }

  let esbuild = {}

  return {
    base: './', // index.html文件所在位置
    root: './', // js导入的资源路径，src
    minify: true, // 是否压缩代码
    resolve: {
      alias,
    },
    define: define,
    server: {
      /** 是否开启 HTTPS */
      https: false,
      /** 设置 host: true 才可以使用 Network 的形式，以 IP 访问项目 */
      host: true, // host: "0.0.0.0"
      /** 端口号 */
      port: 8080,
      /** 是否自动打开浏览器 */
      open: false,
      /** 跨域设置允许 */
      cors: true,
      /** 端口被占用时，是否直接退出 */
      strictPort: false,
      // 代理
      proxy:proxy
    },
    build: {
      target: 'es2015',
      minify: 'terser', // 是否进行压缩,boolean | 'terser' | 'esbuild',默认使用terser
      manifest: false, // 是否产出maifest.json
      sourcemap: false, // 是否产出soucemap.json
      outDir: 'dist', // 产出目录
      chunkSizeWarningLimit: 2000,
      rollupOptions,
    },
    esbuild,
    optimizeDeps,
    plugins: [
      legacyPlugin({
        targets: ['defaults','Android > 39', 'Chrome >= 60', 'Safari >= 10.1', 'iOS >= 10.3', 'Firefox >= 54', 'Edge >= 15'],
        polyfills: ['es.promise.finally', 'es/map', 'es/set'],
        modernPolyfills: ['es.promise.finally'],
        renderLegacyChunks: true,
      }), vuePlugin(),vueJsx(),vueSetupExtend(),createHtmlPlugin({
        inject: {
          data: {
            title: appConfig.APP_TITLE,
          },
        },
      }),
    ],
    css: {
      preprocessorOptions: {
        css: { 
          charset: false
        } 
      },
    },
    json: {
      //是否支持从 .json 文件中进行按名导入
      namedExports: true,
      //若设置为 true 导入的json会被转为 export default JSON.parse("..") 会比转译成对象字面量性能更好
      stringify:false
    },
  };
})
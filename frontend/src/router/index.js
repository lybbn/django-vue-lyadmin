import { createRouter, createWebHistory ,createWebHashHistory } from 'vue-router'
import store from '../store'
// 进度条
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'
import '../assets/css/nprogress.scss'//自定义样式
// 简单配置
NProgress.inc(0.4)
NProgress.configure({ easing: 'ease', speed: 500, showSpinner: true })

const routes = [
  {
    path: '/',
    name: '',
    component: () => import('../views/login.vue'),
    hidden: true,
    meta: {
      requireAuth: false,
      index: '/',
    }
  },
    {
    path: '/login',
    name: 'login',
    component: () => import('../views/login.vue'),
    hidden: true,
    meta: {
      requireAuth: false,
      index: '/login',
    }
  },
    {
    path: '/lyterminal',
    name: 'lyterminal',
    component: () => import('../views/lyterminal.vue'),
    hidden: true,
    meta: {
      requireAuth: true,
      index: '/lyterminal',
    }
  },
  {
    path: '/index',
    name: '首页',
    component: () => import('../views/index.vue'),
    iconCls: 'el-icon-tickets',
    meta: {
      requireAuth: false,
      index: '/index',
    },
    children: [
      // 超管
      {
        path: '/adminManage',
        name: 'adminManage',
        component: () => import('../views/adminManage/adminManage.vue'),
        meta: {
          requireAuth: true,
          index: '/adminManage',
        }
      },
      {
        path: '/userManage',
        name: 'userManage',
        component: () => import('../views/userManage/userManage.vue'),
        meta: {
          requireAuth: true,
          index: '/userManage',
        }
      },
        {
        path: '/userManageCrud',
        name: 'userManageCrud',
        component: () => import('../views/userManage/userManageCrud.vue'),
        meta: {
          requireAuth: true,
          index: '/userManageCrud',
        }
      },
        {
            path: '/carouselSettingsimg',
            name: 'carouselSettingsimg',
            component: () => import('../views/platformSettings/carouselSettingsimg.vue'),
            meta: {
                requireAuth: true,
                index: '/carouselSettingsimg',
            }
        },
        {
            path: '/platformSettingsother',
            name: 'platformSettingsother',
            component: () => import('../views/platformSettings/platformSettingsother.vue'),
            meta: {
                requireAuth: true,
                index: '/platformSettingsother',
            }
        },

      {
        path: '/userFeekback',
        name: 'userFeekback',
        component: () => import('../views/userFeekback/userFeekback.vue'),
        meta: {
          requireAuth: true,
          index: '/userFeekback',
        }
      },
      // 系统管理
      {
        path: '/departmentManage',
        name: 'departmentManage',
        component: () => import('../views/systemManage/departmentManage/departmentManage.vue'),
        meta: {
          requireAuth: true,
          index: '/departmentManage',
        }
      },
      {
        path: '/menuManage',
        name: 'menuManage',
        component: () => import('../views/systemManage/menuManage/menuManage.vue'),
        meta: {
          requireAuth: true,
          index: '/menuManage',
        }
      },

      {
        path: '/roleManage',
        name: 'roleManage',
        component: () => import('../views/systemManage/roleManage/roleManage.vue'),
        meta: {
          requireAuth: true,
          index: '/roleManage',
        }
      },


      {
        path: '/authorityManage',
        name: 'authorityManage',
        component: () => import('../views/systemManage/authorityManage/authorityManage.vue'),
        meta: {
          requireAuth: true,
          index: '/authorityManage',
        }
      },
      {
        path: 'buttonConfig/:id/:name',
        name: 'buttonConfig',
        component: () => import('../views/systemManage/buttonConfig/buttonConfig.vue'),
        meta: {
          requireAuth: true,
          index: '/buttonConfig',
        }
      },
        {
        path: '/buttonManage',
        name: 'buttonManage',
        component: () => import('../views/systemManage/button/buttonManage.vue'),
        meta: {
          requireAuth: true,
          index: '/buttonManage',
        }
      },
      {
        path: '/messagTemplate',
        name: 'messagTemplate',
        component: () => import('../views/messageCenter/messagTemplate.vue'),
        meta: {
          requireAuth: true,
          index: '/messagTemplate',
        }
      },
      {
        path: '/messagNotice',
        name: 'messagNotice',
        component: () => import('../views/messageCenter/messagNotice.vue'),
        meta: {
          requireAuth: true,
          index: '/messagNotice',
        }
      },
      {
        path: '/personalCenter',
        name: 'personalCenter',
        component: () => import('../views/personalCenter/personalCenter.vue'),
        meta: {
          requireAuth: true,
          index: '/personalCenter',
        }
      },
      {
        path: '/journalManage',
        name: 'journalManage',
        component: () => import('../views/journalManage/journalManage.vue'),
        meta: {
          requireAuth: true,
          index: '/journalManage',
        }
      },

    ]
  }
]

// 路由自动化注册（默认注册到index的children里面）(静态路由优先级高于动态自动路由)
const requireComponent = require.context('../views', true, /\.vue$/) // 找到 modules 路径下的所有文件
const names = requireComponent.keys()
const autoRouters = getAutoRouterList(names)
function getAutoRouterList(names) {
    const routerList = [];
    names.forEach((name, index) => {
        if(name.indexOf("/components/")==-1 && name !='./index.vue' &&  name !='./login.vue' &&  name !='./lyterminal.vue'){
            let isSame = false
            const componentConfig = requireComponent(name)
            const componentName = name.split('/').pop()?.split('.')[0]//根据路径截取name文件名（去除后缀和前面目录）
            for(var i=0;i<routes.length;i++){
                if(routes[i].path=="/"||routes[i].path=="/login" ||routes[i].path=="/lyterminal"){
                    continue
                }
                if(routes[i].name === componentName){
                    isSame = true
                    break
                }
                if(routes[i].path === '/index' && routes[i].children.length>0){
                    for(var s=0;s<routes[i].children.length;s++){
                          if(routes[i].children[s].name === componentName){
                              isSame = true
                              break
                          }
                    }
                }
            }
            if(!isSame){
                const path = "/"+componentName
                routerList.push({
                    path: path,
                    name: componentName,
                    component:componentConfig.default,
                    meta: {
                        requireAuth: true,
                        index: path,
                    }
                });
            }
        }

    });
    for(var t=0;t<routes.length;t++){
        if(routes[t].path == '/index'){
            routerList.forEach(drouter=>{
                routes[t].children.push(drouter)
            })
            break
        }
    }
    return routerList;
}

const router = createRouter({
  //history模式
  // history: createWebHistory(process.env.BASE_URL),
  //hash模式
  history: createWebHashHistory(),
  routes: routes
})

/**
 * 路由拦截
 * 权限验证
 */
let to={},from={}
router.beforeEach((to, from, next) => {
  // 进度条
  NProgress.start()
  let userId = store.getters.getUserId ? store.getters.getUserId : ''
  if (to.meta.requireAuth) { // 判断该路由是否需要登录权限
    if (userId) { // 通过vuex state获取当前的token是否存在
      let menuList = JSON.parse(localStorage.getItem('menuList'))
      if(menuList.filter(item=>item.url == to.name).length > 0 || (to.name =='buttonConfig' &&  menuList.filter(item=>item.url=='menuManage').length >0) || (to.name =='lyterminal' &&  menuList.filter(item=>item.url=='menuManage').length >0) || (to.name =='buttonManage' &&  menuList.filter(item=>item.url=='menuManage').length >0)) {
        next()
      } else {
        next({
          path: '/login'
        })
      }
    } else {
        next({
          path: '/login'
        })
    }
  } else {
    if(to.path=="/login" ||to.path=="/"){
      if(userId){
        let tabsPage = JSON.parse(localStorage.getItem("tabsPage"))
        if (tabsPage) {
          store.commit("switchtab",tabsPage[0].name)
        }
      }else{
        next()
      }
    }else{
      next()
    }
  }
})
//在路由跳转后用NProgress.done()标记下结束
router.afterEach(() => {
  NProgress.done()
})
export default router

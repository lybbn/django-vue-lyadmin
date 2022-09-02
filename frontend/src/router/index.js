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
    name: 'root',
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
    path: '/404',
    name: '404',
    component: () => import('../views/error/404.vue'),
    hidden: true,
    meta: {
      requireAuth: false,
      index: '/404',
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
    name: 'index',
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

//判断访问路径路由name是否存在
function isRouterNameExist(name){
    let isExist = false
    if(name){
        if(routes.some(item=> name == item.name)){
            return true
        }
        for(var t=0;t<routes.length;t++){
            if(routes[t].children && routes[t].children.length>0){
                if(routes[t].children.some(item=> name == item.name)){
                    isExist = true
                    break
                }
            }
        }
    }else{
        return false
    }
    return isExist
}
//判断访问路径路由path是否存在
function isRouterPathExist(path){
    let isExist = false
    if(path){
        if(routes.some(item=>path == item.path)){
            return true
        }
        for(var t=0;t<routes.length;t++){
            if(routes[t].children && routes[t].children.length>0){
                if(routes[t].children.some(item=> path == item.path)){
                    isExist = true
                    break
                }
            }
        }
    }else{
        return false
    }
    return isExist
}

/**
 * 路由拦截
 * 权限验证
 */
let to={},from={}
router.beforeEach((to, from, next) => {
   // 白名单
  const whiteList = ['buttonConfig', 'menuManage', 'lyterminal', 'buttonManage', 'menuManage']
  // 进度条
  NProgress.start()
  let userId = store.getters.getUserId ? store.getters.getUserId : ''
  if (to.meta.requireAuth) { // 判断该路由是否需要登录权限
    if (userId) { // 通过vuex state获取当前的token是否存在
      let menuList = JSON.parse(localStorage.getItem('menuList'))
      if(menuList && (menuList.filter(item=>item.url == to.name).length > 0 || (whiteList.indexOf(to.name) !== -1))) {
          if(to.name){
              next()
          }else if(isRouterPathExist(to.path)){
              next()
          }else{
              next({
                  path: '/404'
              })
          }
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
        let tabsValue = localStorage.getItem("TabsValue")
        if(tabsValue){
            if(isRouterNameExist(tabsValue)){
                  store.commit("switchtab",tabsValue)
            }else{
                  next({
                      path: '/404'
                  })
            }
        }else{
            let tabsPage = JSON.parse(localStorage.getItem("tabsPage"))
            if (tabsPage) {
                if(isRouterNameExist(tabsPage[0].name)){
                  store.commit("switchtab",tabsPage[0].name)
                }else{
                  next({
                      path: '/404'
                  })
                }

            }else{
                next({
                    path:'/404'
                })
            }
        }
      }else{
        if(to.name){
            next()
        }else if(isRouterPathExist(to.path)){
            next()
        }
        else{
            next({
                path: '/404'
            })
        }
      }
    }else{
      if(to.name){
          next()
      }else if(isRouterPathExist(to.path)){
          next()
      }else{
          next({
              path: '/404'
          })
      }
    }
  }
})
//在路由跳转后用NProgress.done()标记下结束
router.afterEach(() => {
  NProgress.done()
})
export default router
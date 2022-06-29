import Vue from 'vue'
import VueRouter from 'vue-router'
// 解决路由访问重复时报错问题：
const originalPush = VueRouter.prototype.push
VueRouter.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => err)
}
Vue.use(VueRouter)
//静态路由
const routes = [
      {
    path: '/',
    name: '',
    component: resolve => require(['../views/login.vue'], resolve),
    hidden: true,
    meta: {
      requireAuth: false,
      index: '/',
    }
  },
    {
    path: '/login',
    name: '登录',
    component: resolve => require(['../views/login.vue'], resolve),
    hidden: true,
    meta: {
      requireAuth: false,
      index: '/login',
    }
  }, {
    path: '/index',
    name: '首页',
    component: resolve => require(['../views/index.vue'], resolve),
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
        component: resolve => require(['../views/adminManage/adminManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/adminManage',
        }
      },
      {
        path: '/userManage',
        name: 'userManage',
        component: resolve => require(['../views/userManage/userManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/userManage',
        }
      },
        //平台设置
        {
            path: '/carouselSettingsimg',
            name: 'carouselSettingsimg',
            component: resolve => require(['../views/platformSettings/carouselSettingsimg.vue'], resolve),
            meta: {
                requireAuth: true,
                index: '/carouselSettingsimg',
            }
        },
        {
            path: '/platformSettingsother',
            name: 'platformSettingsother',
            component: resolve => require(['../views/platformSettings/platformSettingsother.vue'], resolve),
            meta: {
                requireAuth: true,
                index: '/platformSettingsother',
            }
        },
      {
        path: '/userFeekback',
        name: 'userFeekback',
        component: resolve => require(['../views/userFeekback/userFeekback.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/userFeekback',
        }
      },
        //营销管理
        {
        path: '/couponManage',
        name: 'couponManage',
        component: resolve => require(['../views/marketManage/couponManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/couponManage',
        }
      },
      //商城管理
        {
        path: '/goodsManage',
        name: 'goodsManage',
        component: resolve => require(['../views/mallManage/goodsManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/goodsManage',
        }
      },
        {
        path: '/goodsType',
        name: 'goodsType',
        component: resolve => require(['../views/mallManage/goodsType.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/goodsType',
        }
      },
      //订单管理
        {
        path: '/mallOrderManage',
        name: 'mallOrderManage',
        component: resolve => require(['../views/orderManage/mallOrderManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/mallOrderManage',
        }
      },
        //财务管理
        {
        path: '/financeStatisticsGoods',
        name: 'financeStatisticsGoods',
        component: resolve => require(['../views/financeManage/financeStatisticsGoods.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/financeStatisticsGoods',
        }
      },
      // 系统管理
      {
        path: '/departmentManage',
        name: 'departmentManage',
        component: resolve => require(['../views/systemManage/departmentManage/departmentManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/departmentManage',
        }
      },
        {
        path: '/areaManage',
        name: 'areaManage',
        component: resolve => require(['../views/systemManage/areaManage/areaManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/areaManage',
        }
      },
      {
        path: '/menuManage',
        name: 'menuManage',
        component: resolve => require(['../views/systemManage/menuManage/menuManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/menuManage',
        }
      },

      {
        path: '/roleManage',
        name: 'roleManage',
        component: resolve => require(['../views/systemManage/roleManage/roleManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/roleManage',
        }
      },
      {
        path: '/authorityManage',
        name: 'authorityManage',
        component: resolve => require(['../views/systemManage/authorityManage/authorityManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/authorityManage',
        }
      },
      {
        path: '/buttonConfig',
        name: 'buttonConfig',
        component: resolve => require(['../views/systemManage/buttonConfig/buttonConfig.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/buttonConfig',
        }
      },
        {
        path: '/buttonManage',
        name: 'buttonManage',
        component: resolve => require(['../views/systemManage/button/buttonManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/buttonManage',
        }
      },
      {
        path: '/messagTemplate',
        name: 'messagTemplate',
        component: resolve => require(['../views/messageCenter/messagTemplate.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/messagTemplate',
        }
      },
      {
        path: '/messagNotice',
        name: 'messagNotice',
        component: resolve => require(['../views/messageCenter/messagNotice.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/messagNotice',
        }
      },
      {
        path: '/personalCenter',
        name: 'personalCenter',
        component: resolve => require(['../views/personalCenter/personalCenter.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/personalCenter',
        }
      },
      {
        path: '/journalManage',
        name: 'journalManage',
        component: resolve => require(['../views/journalManage/journalManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/journalManage',
        }
      },

      // 自定义

    ]
  }]

// 路由自动化注册（默认注册到index的children里面）(静态路由优先级高于动态自动路由)
const requireComponent = require.context('../views', true, /\.vue$/) // 找到 modules 路径下的所有文件
const names = requireComponent.keys()
const autoRouters = getAutoRouterList(names)
function getAutoRouterList(names) {
    const routerList = [];
    names.forEach((name, index) => {
        if(name.indexOf("/components/")==-1 && name !='./index.vue' &&  name !='./login.vue'){
            let isSame = false
            const componentConfig = requireComponent(name)
            const componentName = name.split('/').pop()?.split('.')[0]//根据路径截取name文件名（去除后缀和前面目录）
            for(var i=0;i<routes.length;i++){
                if(routes[i].path=="/"||routes[i].path=="/login"){
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

export default new VueRouter({
  routes: routes
})

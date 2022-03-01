import Vue from 'vue'
import VueRouter from 'vue-router'
// 解决路由访问重复时报错问题：
const originalPush = VueRouter.prototype.push
const userType = sessionStorage.getItem("userType") ? sessionStorage.getItem("userType") : '';
VueRouter.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => err)
}
Vue.use(VueRouter)

export default new VueRouter({
  routes: [
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
        path: 'buttonConfig/:id/:name',
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

      // 代理商


    ]
  }]
})

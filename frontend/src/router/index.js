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
        path: '/agentManage',
        name: 'agentManage',
        component: resolve => require(['../views/agentManage/agentManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/agentManage',
        }
      },
      {
        path: '/agentApply',
        name: 'agentApply',
        component: resolve => require(['../views/agentManage/agentApply.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/agentApply',
        }
      },
      {
        path: '/recyclerManage',
        name: 'recyclerManage',
        component: resolve => require(['../views/recyclerManage/recyclerManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/recyclerManage',
        }
      },
      {
        path: '/recyclCategoryParent',
        name: 'recyclCategoryParent',
        component: resolve => require(['../views/recyclCategoryManage/recyclCategoryParent.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/recyclCategoryParent',
        }
      },
      {
        path: '/recyclCategoryChild',
        name: 'recyclCategoryChild',
        component: resolve => require(['../views/recyclCategoryManage/recyclCategoryChild.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/recyclCategoryChild',
        }
      },

      {
        path: '/shoppingMallGoodsManage',
        name: 'shoppingMallGoodsManage',
        component: resolve => require(['../views/shoppingMallManage/shoppingMallGoodsManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/shoppingMallGoodsManage',
        }
      },
      {
        path: '/goodsClass',
        name: 'goodsClass',
        component: resolve => require(['../views/shoppingMallManage/goodsClass.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/goodsClass',
        }
      },
      {
        path: '/goodsSpu',
        name: 'goodsSpu',
        component: resolve => require(['../views/shoppingMallManage/goodsSpu.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/goodsSpu',
        }
      },
      {
        path: '/recoveryOrderManage',
        name: 'recoveryOrderManage',
        component: resolve => require(['../views/orderManage/recoveryOrderManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/recoveryOrderManage',
        }
      },
      {
        path: '/shoppingMallOrderManage',
        name: 'shoppingMallOrderManage',
        component: resolve => require(['../views/orderManage/shoppingMallOrderManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/shoppingMallOrderManage',
        }
      },
      {
        path: '/actRegionalAudit',
        name: 'actRegionalAudit',
        component: resolve => require(['../views/actRegionalAudit/actRegionalAudit.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/actRegionalAudit',
        }
      },

      {
        path: '/recyclSiteManage',
        name: 'recyclSiteManage',
        component: resolve => require(['../views/recyclSiteManage/recyclSiteManage.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/recyclSiteManage',
        }
      },

      {
        path: '/applyQuotaRecycl',
        name: 'applyQuotaRecycl',
        component: resolve => require(['../views/applyQuotaManage/applyQuotaRecycl.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/applyQuotaRecycl',
        }
      },

      {
        path: '/applyQuotaAgent',
        name: 'applyQuotaAgent',
        component: resolve => require(['../views/applyQuotaManage/applyQuotaAgent.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/applyQuotaAgent',
        }
      },
      {
        path: '/dynamicsInfo',
        name: 'dynamicsInfo',
        component: resolve => require(['../views/dynamicsInfo/dynamicsInfo.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/dynamicsInfo',
        }
      },
      {
        path: '/platformSettingsImg',
        name: 'platformSettingsImg',
        component: resolve => require(['../views/platformSettings/platformSettingsImg.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/platformSettingsImg',
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
        path: '/labelSetting',
        name: 'labelSetting',
        component: resolve => require(['../views/platformSettings/labelSetting.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/labelSetting',
        }
      },


      {
        path: '/customerServiceSettings',
        name: 'customerServiceSettings',
        component: resolve => require(['../views/customerServiceSettings/customerServiceSettings.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/customerServiceSettings',
        }
      },

      {
        path: '/distributionSettings',
        name: 'distributionSettings',
        component: resolve => require(['../views/distributionSettings/distributionSettings.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/distributionSettings',
        }
      },
      {
        path: '/financeStatisticsAgent',
        name: 'financeStatisticsAgent',
        component: resolve => require(['../views/financeManage/financeStatisticsAgent.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/financeStatisticsAgent',
        }
      },

      {
        path: '/financeStatisticsRecycl',
        name: 'financeStatisticsRecycl',
        component: resolve => require(['../views/financeManage/financeStatisticsRecycl.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/financeStatisticsRecycl',
        }
      },

      {
        path: '/withdrawalStatisticsUser',
        name: 'withdrawalStatisticsUser',
        component: resolve => require(['../views/financeManage/withdrawalStatisticsUser.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/withdrawalStatisticsUser',
        }
      },
        {
        path: '/applyJifenCashOutUser',
        name: 'applyJifenCashOutUser',
        component: resolve => require(['../views/financeManage/applyJifenCashOutUser.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/applyJifenCashOutUser',
        }
      },

      {
        path: '/recyclerApply',
        name: 'recyclerApply',
        component: resolve => require(['../views/recyclerApply/recyclerApply.vue'], resolve),
        meta: {
          requireAuth: true,
          index: '/recyclerApply',
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

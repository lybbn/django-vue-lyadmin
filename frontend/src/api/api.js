import axios from 'axios';
import {reqExpost,ajaxGet,ajaxPost,ajaxDelete,ajaxPut,ajaxPatch,uploadImg,ajaxGetDetailByID} from './request';
import {url} from './url';

// 获取登录页的信息
export const login = params => ajaxPost({url: `token/`,params})
// 获取菜单
export const apiSystemWebRouter = params => ajaxGet({url: `system/web_router/`,params})

/**
*系统管理
 * */
// 部门管理列表
export const apiSystemDept = params => ajaxGet({url: `system/dept/`,params})
// 部门管理列表 -- 新增部门
export const apiSystemDeptAdd = params => ajaxPost({url: `system/dept/`,params})
// 部门管理列表 -- 编辑部门
export const apiSystemDeptEdit = params => ajaxPut({url: `system/dept/`,params})
// 部门管理列表 -- 删除部门
export const apiSystemDeptDelete = params => ajaxDelete({url: `system/dept/`,params})


// 菜单管理列表
export const apiSystemMenu = params => ajaxGet({url: `system/menu/`,params})
// 菜单管理列表 -- 新增菜单
export const apiSystemMenuAdd = params => ajaxPost({url: `system/menu/`,params})
// 菜单管理列表 -- 编辑菜单
export const apiSystemMenuEdit = params => ajaxPut({url: `system/menu/`,params})
// 菜单管理列表 -- 删除菜单
export const apiSystemMenuDelete = params => ajaxDelete({url: `system/menu/`,params})
//获取部门数据,获取菜单树
export const systemMenuTree = params => ajaxGet({url: `system/menu_tree/`,params})
// 菜单管理 》 按钮列表(全部)
export const systemButton = params => ajaxGet({url:`system/button/`,params})
// 菜单管理 》 按钮 编辑
export const systemButtonEdit = params => ajaxPut({url:`system/button/`,params})
// 菜单管理 》 按钮 新增
export const systemButtonAdd = params => ajaxPost({url:`system/button/`,params})
// 菜单管理 》 按钮 删除
export const systemButtonDelete = params => ajaxDelete({url:`system/button/`,params})
// 菜单管理 》 按钮配置列表（针对单个菜单）
export const systemMenuButton = params => ajaxGet({url:`system/menu_button/`,params})
// 菜单管理 》 按钮配置列表（针对单个菜单） 新增
export const systemMenuButtonAdd = params => ajaxPost({url:`system/menu_button/`,params})
// 菜单管理 》 按钮配置列表（针对单个菜单） 编辑
export const systemMenuButtonEdit = params => ajaxPut({url:`system/menu_button/`,params})
// 菜单管理 》 按钮配置列表（针对单个菜单） 删除
export const systemMenuButtonDelete = params => ajaxDelete({url:`system/menu_button/`,params})



// 角色管理列表
export const apiSystemRole = params => ajaxGet({url: `system/role/`,params})
// 角色管理列表-修改
export const apiSystemRoleEdit = params => ajaxPut({url: `system/role/`,params})
// 角色管理列表 -- 新增角色
export const apiSystemRoleAdd = params => ajaxPost({url: `system/role/`,params})
// 角色管理列表 -- 新增角色
export const apiSystemRoleDelete = params => ajaxDelete({url: `system/role/`,params})
//获取部门数据,用于角色授权
export const apiSystemDeptTree = params => ajaxGet({url: `system/dept_tree/`,params})
//通过角色id,获取菜单数据
export const apiSystemRoleIdToMenu = params => ajaxGet({url: `system/role_id_to_menu/`,params})
export const apiSystemRoleIdToMenuid = (id) => ajaxGet({url: `system/role_id_to_menu/`+id+'/'})

//管理员管理
export const apiSystemUser = params => ajaxGet({url: `system/user/`,params})
//管理员管理-新增
export const apiSystemUserAdd = params => ajaxPost({url: `system/user/`,params})
//管理员管理-修改
export const apiSystemUserEdit = params => ajaxPut({url: `system/user/`,params})
//管理员管理-删除
export const apiSystemUserDelte = params => ajaxDelete({url: `system/user/`,params})

/**
 *日志管理
 * */
// 日志管理 查询
export const systemOperationlog= params => ajaxGet({url: `system/operation_log/`,params})
// 日志管理 删除
export const systemOperationlogDelete= params => ajaxDelete({url: `system/operation_log/`,params})
// 日志管理 清空全部日志
export const systemOperationlogDeletealllogsDelete= params => ajaxDelete({url: `system/operation_log/deletealllogs/`,params})

/**
 *个人中心
 * */
// 获取当前个人用户信息
export const systemUserUserInfo= params => ajaxGet({url: `system/user/user_info/`,params})
// 更新修改当前个人用户信息
export const systemUserUserInfoEdit= params => ajaxPut({url: `system/user/user_info/`,params})
// 用户重置个人密码
export const systemUserChangePassword= params => ajaxPut({url: `system/user/change_password/`,params})


/**
 *消息中心
 * */
//消息模板
export const RetrieveMessagetemplate = params => ajaxGet({url: `retrieve/messagetemplate/`,params})
//消息模板-新增
export const RetrieveMessagetemplateAdd = params => ajaxPost({url: `retrieve/messagetemplate/`,params})
//消息模板-修改
export const RetrieveMessagetemplateEdit = params => ajaxPut({url: `retrieve/messagetemplate/`,params})
//消息模板-删除
export const RetrieveMessagetemplateDelete = params => ajaxDelete({url: `retrieve/messagetemplate/`,params})

//消息模板
export const RetrieveMessagenotice = params => ajaxGet({url: `retrieve/messagenotice/`,params})
//消息模板-新增
export const RetrieveMessagenoticeAdd = params => ajaxPost({url: `retrieve/messagenotice/`,params})
//消息模板-修改
export const RetrieveMessagenoticeEdit = params => ajaxPut({url: `retrieve/messagenotice/`,params})
//消息模板-删除
export const RetrieveMessagenoticeDelete = params => ajaxDelete({url: `retrieve/messagenotice/`,params})



/**
 *省市区选择
 * */
// 省市区选择  获取省
export const getProvince= params => ajaxGet({url: `areas/`,params})
// 省市区选择  获取市/区
export const getCityDistrictByID= params => ajaxGetDetailByID({url: `areas/`,params})

// 省市区选择  根据详细地址获取经纬度
export const getAddressaccuracy= params => ajaxGet({url: `getaddressaccuracy/`,params})


/**
 *意见反馈
 * */

// 意见反馈 列表
export const retrieveUserfeeckback= params => ajaxGet({url: `retrieve/userfeeckback/`,params})
// 意见反馈 新增
export const retrieveUserfeeckbackAdd= params => ajaxPost({url: `retrieve/userfeeckback/`,params})
// 意见反馈 编辑
export const retrieveUserfeeckbackEdit= params => ajaxPut({url: `retrieve/userfeeckback/`,params})
// 意见反馈 删除
export const retrieveUserfeeckbackDelete= params => ajaxDelete({url: `retrieve/userfeeckback/`,params})








/**
 *资讯动态
 * */

// 资讯动态 列表
export const retrieveInfodynamics= params => ajaxGet({url: `retrieve/infodynamics/`,params})
// 资讯动态 新增
export const retrieveInfodynamicsAdd= params => ajaxPost({url: `retrieve/infodynamics/`,params})
// 资讯动态 编辑
export const retrieveInfodynamicsEdit= params => ajaxPut({url: `retrieve/infodynamics/`,params})
// 资讯动态 删除
export const retrieveInfodynamicsDelete= params => ajaxDelete({url: `retrieve/infodynamics/`,params})


/**
 *商城管理
 * */

// 商城管理分类列表
export const mallGoodscategory= params => ajaxGet({url: `mall/goodscategory/`,params})
// 商城管理分类 新增
export const mallGoodscategoryAdd= params => ajaxPost({url: `mall/goodscategory/`,params})
// 商城管理分类 编辑
export const mallGoodscategoryEdit= params => ajaxPut({url: `mall/goodscategory/`,params})
// 商城管理分类 删除
export const mallGoodscategoryDelete= params => ajaxDelete({url: `mall/goodscategory/`,params})

// 商城管理分类 上下架
export const mallGoodsislaunched= params => ajaxPut({url: `mall/goods/islaunched/`,params})


// 商城管理商品SPU  列表
export const mallGoodspu= params => ajaxGet({url: `mall/goodspu/`,params})
// 商城管理商品SPU  添加
export const mallGoodspuAdd= params => ajaxPost({url: `mall/goodspu/`,params})
// 商城管理商品SPU  更新（部分更新）
export const mallGoodspuEdit= params => ajaxPut({url: `mall/goodspu/`,params})
// 商城管理分类 删除
export const mallGoodspuDelete= params => ajaxDelete({url: `mall/goodspu/`,params})
// 商城管理商品SPU规格  列表
export const mallGoodspuallspecbyid= params => ajaxGet({url: `mall/getspuallspecbyid/`,params})
// 商城管理商品SPU规格名  添加
export const mallgoodspuspec= params => ajaxPost({url: `mall/goodspuspec/`,params})
// 商城管理商品SPU规格值  添加
export const mallgoodspuspecoptionAdd= params => ajaxPost({url: `mall/goodspuspecoption/`,params})
// 商城管理商品SPU规格  批量添加规格
export const mallCreatespuspecandpotionsAdd= params => ajaxPost({url: `mall/createspuspecandpotions/`,params})

// 商城管理商品上传图片
export const mallUploadgoodsimg= params => uploadImg({url: `mall/uploadgoodsimg/`,params})
// 商城管理商品》添加商品
export const mallgoodskuAdd= params => ajaxPost({url: `mall/goodsku/`,params})
// 商城管理商品》商品列表
export const mallgoodsku= params => ajaxGet({url: `mall/goodsku/`,params})
// 商城管理商品》商品编辑
export const mallgoodskuEdit= params => ajaxPut({url: `mall/goodsku/`,params})
// 商城管理商品》商品删除
export const mallgoodskuDelete= params => ajaxDelete({url: `mall/goodsku/`,params})



/**
 *回收类目管理
 * */
// 回收类目管理一级分类 列表
export const retrieveRetrievecategory1= params => ajaxGet({url: `retrieve/retrievecategory1/`,params})
// 回收类目管理一级分类 新增
export const retrieveRetrievecategory1Add= params => ajaxPost({url: `retrieve/retrievecategory1/`,params})
// 回收类目管理一级分类 编辑
export const retrieveRetrievecategory1Edit= params => ajaxPut({url: `retrieve/retrievecategory1/`,params})
// 回收类目管理一级分类 删除
export const retrieveRetrievecategory1Delete= params => ajaxDelete({url: `retrieve/retrievecategory1/`,params})

// 上传图片
export const retrieveUploadretrievecategoryimg= params => uploadImg({url: `retrieve/uploadretrievecategoryimg/`,params})

// 回收类目管理二级分类 列表
export const retrieveRetrievecategory2= params => ajaxGet({url: `retrieve/retrievecategory2/`,params})
// 回收类目管理二级分类 新增
export const retrieveRetrievecategory2Add= params => ajaxPost({url: `retrieve/retrievecategory2/`,params})
// 回收类目管理二级分类 编辑
export const retrieveRetrievecategory2Edit= params => ajaxPut({url: `retrieve/retrievecategory2/`,params})
// 回收类目管理二级分类 删除
export const retrieveRetrievecategory2Delete= params => ajaxDelete({url: `retrieve/retrievecategory2/`,params})



/**
 *分销设置
 * */
// 分销设置 列表
export const retrieveFenxiao= params => ajaxGet({url: `retrieve/fenxiao/`,params})
// 分销设置 新增
export const retrieveFenxiaoAdd= params => ajaxPost({url: `retrieve/fenxiao/`,params})
// 分销设置 编辑
export const retrieveFenxiaoEdit= params => ajaxPut({url: `retrieve/fenxiao/`,params})
// 分销设置 删除
export const retrieveFenxiaoDelete= params => ajaxDelete({url: `retrieve/fenxiao/`,params})


/**
 *用户管理
 * */

// 用户管理 列表
export const retrieveUsers= params => ajaxGet({url: `retrieve/users/`,params})
// 用户管理 新增
export const retrieveUsersAdd= params => ajaxPost({url: `retrieve/users/`,params})
// 用户管理 编辑
export const retrieveUsersEdit= params => ajaxPut({url: `retrieve/users/`,params})
// 用户管理 删除
export const retrieveUsersDelete= params => ajaxDelete({url: `retrieve/users/`,params})
// 用户管理 禁用用户
export const retrieveUsersdisableEdit= params => ajaxPut({url: `retrieve/users/disableuser/`,params})

/**
 *代理商管理
 * */

// 代理商管理 列表
export const retrieveAgentusers= params => ajaxGet({url: `retrieve/agentusers/`,params})
// 代理商管理 新增
export const retrieveAgentusersAdd= params => ajaxPost({url: `retrieve/agentusers/`,params})
// 代理商管理 编辑
export const retrieveAgentusersEdit= params => ajaxPut({url: `retrieve/agentusers/`,params})
// 代理商管理 删除
export const retrieveAgentusersDelete= params => ajaxDelete({url: `retrieve/agentusers/`,params})

// 代理商申请 列表
export const retrieveAgentaudit= params => ajaxGet({url: `retrieve/agentaudit/`,params})
// 代理商申请 新增
export const retrieveAgentauditAdd= params => ajaxPost({url: `retrieve/agentaudit/`,params})
// 代理商申请 编辑
export const retrieveAgentauditEdit= params => ajaxPut({url: `retrieve/agentaudit/`,params})
// 代理商申请 删除
export const retrieveAgentauditDelete= params => ajaxDelete({url: `retrieve/agentaudit/`,params})
// 代理商申请 审核
export const retrieveAgentpassdeny= params => ajaxPost({url: `retrieve/agent/pass_deny/`,params})

// 代理商管理 资金明细列表
export const retrieveFinancestatisticsGetamountrecord= params => ajaxGet({url: `retrieve/financestatistics/getamountrecord/`,params})

/**
 *代理区域申请
 * */

// 代理区域申请 列表
export const retrieveAgentareaaudit= params => ajaxGet({url: `retrieve/agentareaaudit/`,params})
// 代理区域申请 新增
export const retrieveAgentareaauditAdd= params => ajaxPost({url: `retrieve/agentareaaudit/`,params})
// 代理区域申请 编辑
export const retrieveAgentareaauditEdit= params => ajaxPut({url: `retrieve/agentareaaudit/`,params})
// 代理区域申请 删除
export const retrieveAgentareaauditDelete= params => ajaxDelete({url: `retrieve/agentareaaudit/`,params})

// 代理区域申请 审核
export const retrieveAgentareapassdeny= params => ajaxPost({url: `retrieve/agentarea/pass_deny/`,params})


/**
 *回收员管理
 * */

// 回收员管理 列表
export const retrieveRecyclerusers= params => ajaxGet({url: `retrieve/recyclerusers/`,params})
// 回收员管理 新增
export const retrieveRecyclerusersAdd= params => ajaxPost({url: `retrieve/recyclerusers/`,params})
// 回收员管理 编辑
export const retrieveRecyclerusersEdit= params => ajaxPut({url: `retrieve/recyclerusers/`,params})
// 回收员管理 删除
export const retrieveRecyclerusersDelete= params => ajaxDelete({url: `retrieve/recyclerusers/`,params})

// 回收员管理 充值
export const retrieveRecyclerecharge= params => ajaxPost({url: `retrieve/recycler/recharge/`,params})

// 回收员申请 列表
export const retrieveRecycleraudit= params => ajaxGet({url: `retrieve/recycleraudit/`,params})
// 回收员申请 新增
export const retrieveRecyclerauditAdd= params => ajaxPost({url: `retrieve/recycleraudit/`,params})
// 回收员申请 编辑
export const retrieveRecyclerauditEdit= params => ajaxPut({url: `retrieve/recycleraudit/`,params})
// 回收员申请 删除
export const retrieveRecyclerauditDelete= params => ajaxDelete({url: `retrieve/recycleraudit/`,params})
// 回收员申请 审核
export const retrieveRecyclerpassdeny= params => ajaxPost({url: `retrieve/recycler/pass_deny/`,params})

/**
 *回收站点管理
 * */
// 回收站点管理 列表
export const retrieveRecyclingsite= params => ajaxGet({url: `retrieve/recyclingsite/`,params})
// 回收站点管理 新增
export const retrieveRecyclingsiteAdd= params => ajaxPost({url: `retrieve/recyclingsite/`,params})
// 回收站点管理 编辑
export const retrieveRecyclingsiteEdit= params => ajaxPut({url: `retrieve/recyclingsite/`,params})
// 回收站点管理 删除
export const retrieveRecyclingsiteDelete= params => ajaxDelete({url: `retrieve/recyclingsite/`,params})

// 回收站点管理 冻结
export const retrieveSiteDisablesiter= params => ajaxPut({url: `retrieve/site/disablesiter/`,params})

// 回收站点管理 获取回收区域列表
export const retrieveGetagentareaaddresslist= params => ajaxGet({url: `retrieve/getagentareaaddresslist/`,params})

// 回收站点管理 根据代理区域id获取回收员列表
export const retrieveGetrecyclerusersbyarealist= params => ajaxGet({url: `retrieve/getrecyclerusersbyarealist/`,params})

/**
 *订单管理
 * */

// 回收订单管理 列表
export const retrieveRetrieveorder= params => ajaxGet({url: `retrieve/retrieveorder/`,params})
// 回收站点管理 新增
export const retrieveRetrieveorderAdd= params => ajaxPost({url: `retrieve/retrieveorder/`,params})
// 回收站点管理 编辑
export const retrieveRetrieveorderEdit= params => ajaxPut({url: `retrieve/retrieveorder/`,params})
// 回收站点管理 删除
export const retrieveRetrieveorderDelete= params => ajaxDelete({url: `retrieve/retrieveorder/`,params})
// 回收订单管理 详情
export const retrieveGetsiterandagent= params => ajaxGet({url: `retrieve/getsiterandagent/`,params})
// 回收站点管理 指派回收员
export const retrieveAssignrecycler= params => ajaxPost({url: `retrieve/assignrecycler/`,params})

// 回收订单管理 订单统计
export const retrieveOrderstatistics= params => ajaxGet({url: `retrieve/orderstatistics/`,params})


// 商城订单 列表
export const mallGoodsOrder= params => ajaxGet({url: `mall/goodsorder/`,params})
// 商城订单 新增
export const mallGoodsOrderAdd= params => ajaxPost({url: `mall/goodsorder/`,params})
// 商城订单 编辑
export const mallGoodsOrderEdit= params => ajaxPut({url: `mall/goodsorder/`,params})
// 商城订单 删除
export const mallGoodsOrderDelete= params => ajaxDelete({url: `mall/goodsorder/`,params})

// 商城订单 发货
export const mallGoodsSendoutgoods= params => ajaxPost({url: `mall/goods/sendoutgoods/`,params})


/**
 *申请额度
 * */

// 代理商申请额度 列表
export const retrieveAgentapplyquotaaudit= params => ajaxGet({url: `retrieve/agentapplyquotaaudit/`,params})
// 代理商申请额度 删除
export const retrieveAgentapplyquotaauditDelete= params => ajaxDelete({url: `retrieve/agentapplyquotaaudit/`,params})

// 代理商申请额度 新增
export const retrieveQuotaauditagentapplymoneyAdd= params => ajaxPost({url: `retrieve/quotaaudit/agentapplymoneyadd/`,params})

// 代理商申请额度 审核
export const retrieveQuotaauditagentpassdeny= params => ajaxPost({url: `retrieve/quotaaudit/agent/pass_deny/`,params})


// 回收员申请额度 列表
export const retrieveRecyclerapplyquotaaudit= params => ajaxGet({url: `retrieve/recyclerapplyquotaaudit/`,params})
// 回收员申请额度 删除
export const retrieveRecyclerapplyquotaauditDelete= params => ajaxDelete({url: `retrieve/recyclerapplyquotaaudit/`,params})
// 回收员申请额度 审核
export const retrieveQuotaauditrecyclerpassdeny= params => ajaxPost({url: `retrieve/quotaaudit/recycler/pass_deny/`,params})


/**
 *财务管理
 * */

export const retrieveFinancestatisticsgetuserFinancial= params => ajaxGet({url: `retrieve/financestatistics/getuserFinancial/`,params})

export const retrieveFinancestatisticsExport= params => ajaxGet({url: `retrieve/financestatistics/export/`,params})
export const retrieveFinancestatisticsamountrecordExport= params => ajaxGet({url: `retrieve/financestatistics/amountrecordexport/`,params})


export const retrieveFinancestatisticsGetintegralrecord= params => ajaxGet({url: `retrieve/financestatistics/getintegralrecord/`,params})

//用户积分提现审核
export const retrievejifencashout= params => ajaxGet({url: `retrieve/jifencashout/`,params})
export const retrievejifencashoutAdd= params => ajaxPost({url: `retrieve/jifencashout/`,params})
export const retrievejifencashoutEdit= params => ajaxPut({url: `retrieve/jifencashout/`,params})
export const retrievejifencashoutDelete= params => ajaxDelete({url: `retrieve/jifencashout/`,params})
export const retrieveusercashoutpassdeny= params => ajaxGet({url: `retrieve/usercashout/pass_deny/`,params})

/**
*平台设置
*/
//轮播图列表
export const retrieveLunboimg= params => ajaxGet({url: `retrieve/lunboimg/`,params})
// 轮播图列表 新增
export const retrieveLunboimgAdd= params => ajaxPost({url: `retrieve/lunboimg/`,params})
// 轮播图列表 编辑
export const retrieveLunboimgEdit= params => ajaxPut({url: `retrieve/lunboimg/`,params})
// 轮播图列表 删除
export const retrieveLunboimgDelete= params => ajaxDelete({url: `retrieve/lunboimg/`,params})

// 平台图片列表
export const retrievePlatformimg= params => ajaxGet({url: `retrieve/platformimg/`,params})
// 平台图片列表 新增
export const retrievePlatformimgAdd= params => ajaxPost({url: `retrieve/platformimg/`,params})
// 平台图片列表 编辑
export const retrievePlatformimgEdit= params => ajaxPut({url: `retrieve/platformimg/`,params})
// 平台图片列表 删除
export const retrievePlatformimgDelete= params => ajaxDelete({url: `retrieve/platformimg/`,params})

// 平台设置上传图片
export const retrieveUploadPlatformImg= params => uploadImg({url: `retrieve/uploadplatformimg/`,params})


// 回收类别图片 列表
export const retrieveRecyclingcategory= params => ajaxGet({url: `retrieve/recyclingcategory/`,params})
// 回收类别图片 新增
export const retrieveRecyclingcategoryAdd= params => ajaxPost({url: `retrieve/recyclingcategory/`,params})
// 回收类别图片 编辑
export const retrieveRecyclingcategoryEdit= params => ajaxPut({url: `retrieve/recyclingcategory/`,params})
// 回收类别图片 删除
export const retrieveRecyclingcategoryDelete= params => ajaxDelete({url: `retrieve/recyclingcategory/`,params})

//标签列表
export const retrieveLabel= params => ajaxGet({url: `retrieve/label/`,params})
// 标签列表 新增
export const retrieveLabelAdd= params => ajaxPost({url: `retrieve/label/`,params})
// 标签列表 编辑
export const retrieveLabelEdit= params => ajaxPut({url: `retrieve/label/`,params})
// 标签列表 删除
export const retrieveLabelDelete= params => ajaxDelete({url: `retrieve/label/`,params})

//其他设置
export const retrieveOther= params => ajaxGet({url: `retrieve/other/`,params})
// 其他设置 新增
export const retrieveOtherAdd= params => ajaxPost({url: `retrieve/other/`,params})
// 其他设置 编辑
export const retrieveOtherEdit= params => ajaxPut({url: `retrieve/other/`,params})
// 其他设置 删除
export const retrieveOtherDelete= params => ajaxDelete({url: `retrieve/other/`,params})




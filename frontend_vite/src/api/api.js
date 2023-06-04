import axios from 'axios';
import {reqExpost,ajaxGet,ajaxPost,ajaxDelete,ajaxPut,ajaxPatch,uploadImg,ajaxGetDetailByID} from './request';
import {url} from './url';

// 获取登录页的信息
export const login = params => ajaxPost({url: `token/`,params})
// 获取验证码
export const getCaptcha = params => ajaxGet({url: `captcha/`,params})
// 获取菜单
export const apiSystemWebRouter = params => ajaxGet({url: `system/menu/web_router/`,params})
//系统监控
export const monitorGetSystemInfo = params => ajaxGet({url: `monitor/getsysteminfo/`,params})
// 获取系统所有api列表
export const getSystemLyapiList = params => ajaxGet({url: `lyapi.json`,params})

/**
*系统配置
 * */

// 系统配置
export const platformsettingsSysconfig = params => ajaxGet({url: `platformsettings/sysconfig/`,params})
// 系统配置 -- 新增
export const platformsettingsSysconfigAdd = params => ajaxPost({url: `platformsettings/sysconfig/`,params})
// 系统配置 -- 编辑
export const platformsettingsSysconfigEdit = params => ajaxPut({url: `platformsettings/sysconfig/`,params})
// 系统配置 -- 删除
export const platformsettingsSysconfigDelete = params => ajaxDelete({url: `platformsettings/sysconfig/`,params})
// 系统配置 -- 保存子项
export const platformsettingsSysconfigSavecontent = params => ajaxPut({url: `platformsettings/sysconfig/save_content/`,params})

/**
*计划任务
 * */

// 计划任务
export const crontabPeriodictask = params => ajaxGet({url: `crontab/periodictask/`,params})
// 计划任务 -- 新增
export const crontabPeriodictaskAdd = params => ajaxPost({url: `crontab/periodictask/`,params})
// 计划任务 -- 编辑
export const crontabPeriodictaskEdit = params => ajaxPut({url: `crontab/periodictask/`,params})
// 计划任务 -- 删除
export const crontabPeriodictaskDelete = params => ajaxDelete({url: `crontab/periodictask/`,params})
// 计划任务 -- 开始/暂停
export const crontabPeriodictaskEnabled = params => ajaxPut({url: `crontab/periodictask/enabled/`,params})
// 计划任务 获取本地所有tasks文件中的task任务方法
export const crontabPeriodictaskMethodlist = params => ajaxGet({url: `crontab/periodictask/tasklist/`,params})

// 计划任务 获取任务执行结果
export const crontabTaskresult = params => ajaxGet({url: `crontab/taskresult/`,params})


/**
*终端服务
 * */

// 终端服务
export const apiTerminal = params => ajaxGet({url: `terminal/terminal/`,params})
// 终端服务 -- 新增
export const apiTerminalAdd = params => ajaxPost({url: `terminal/terminal/`,params})
// 终端服务 -- 编辑
export const apiTerminalEdit = params => ajaxPut({url: `terminal/terminal/`,params})
// 终端服务 -- 删除
export const apiTerminalDelete = params => ajaxDelete({url: `terminal/terminal/`,params})

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

//权限管理
// 权限管理 -- 保存
export const apiPermissionSave = params => ajaxPut({url: `system/permission/`,params})

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
export const messagesMessagetemplate = params => ajaxGet({url: `messages/messagetemplate/`,params})
//消息模板-新增
export const messagesMessagetemplateAdd = params => ajaxPost({url: `messages/messagetemplate/`,params})
//消息模板-修改
export const messagesMessagetemplateEdit = params => ajaxPut({url: `messages/messagetemplate/`,params})
//消息模板-删除
export const messagesMessagetemplateDelete = params => ajaxDelete({url: `messages/messagetemplate/`,params})

//消息公告
export const messagesMessagenotice = params => ajaxGet({url: `messages/messagenotice/`,params})
//消息公告-新增
export const messagesMessagenoticeAdd = params => ajaxPost({url: `messages/messagenotice/`,params})
//消息公告-修改
export const messagesMessagenoticeEdit = params => ajaxPut({url: `messages/messagenotice/`,params})
//消息公告-删除
export const messagesMessagenoticeDelete = params => ajaxDelete({url: `messages/messagenotice/`,params})



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
export const PlatformsettingsUserfeeckback= params => ajaxGet({url: `platformsettings/userfeeckback/`,params})
// 意见反馈 新增
export const PlatformsettingsUserfeeckbackAdd= params => ajaxPost({url: `platformsettings/userfeeckback/`,params})
// 意见反馈 编辑
export const PlatformsettingsUserfeeckbackEdit= params => ajaxPut({url: `platformsettings/userfeeckback/`,params})
// 意见反馈 删除
export const PlatformsettingsUserfeeckbackDelete= params => ajaxDelete({url: `platformsettings/userfeeckback/`,params})

/**
 *地区管理
 * */

// 地区管理列表
export const addressArea = params => ajaxGet({url: `address/area/`,params})
// 地区管理列表 获取根地区
export const addressAreaRoot = params => ajaxGet({url: `address/area/area_root/`,params})
// 地区管理列表 -- 新增
export const addressAreaAdd = params => ajaxPost({url: `address/area/`,params})
// 地区管理列表 -- 编辑
export const addressAreaEdit = params => ajaxPut({url: `address/area/`,params})
// 地区管理列表 -- 删除
export const addressAreaDelete = params => ajaxDelete({url: `address/area/`,params})

/**
 *商城管理
 * */

// 商品分类 列表
export const mallGoodstype= params => ajaxGet({url: `mall/goodstype/`,params})
// 商品分类 新增
export const mallGoodstypeAdd= params => ajaxPost({url: `mall/goodstype/`,params})
// 商品分类 编辑
export const mallGoodstypeEdit= params => ajaxPut({url: `mall/goodstype/`,params})
// 商品分类 删除
export const mallGoodstypeDelete= params => ajaxDelete({url: `mall/goodstype/`,params})

// 商品管理 列表
export const mallGoodsspu= params => ajaxGet({url: `mall/goodsspu/`,params})
// 商品管理 新增
export const mallGoodsspuAdd= params => ajaxPost({url: `mall/goodsspu/`,params})
// 商品管理 编辑
export const mallGoodsspuEdit= params => ajaxPut({url: `mall/goodsspu/`,params})
// 商品管理 删除
export const mallGoodsspuDelete= params => ajaxDelete({url: `mall/goodsspu/`,params})

// 商品管理 上下架
export const mallGoodsspuIslaunched= params => ajaxPut({url: `mall/goodsspu/islaunched/`,params})

// 商品管理 修改商品SKU价格
export const mallGoodsspueEditskups= params => ajaxPut({url: `mall/goodsspu/editskups/`,params})

// 商城订单 列表
export const mallGoodsOrder= params => ajaxGet({url: `mall/goodsorder/`,params})
// 商城订单 新增
export const mallGoodsOrderAdd= params => ajaxPost({url: `mall/goodsorder/`,params})
// 商城订单 编辑
export const mallGoodsOrderEdit= params => ajaxPut({url: `mall/goodsorder/`,params})
// 商城订单 删除
export const mallGoodsOrderDelete= params => ajaxDelete({url: `mall/goodsorder/`,params})

// 商城订单 发货
export const mallGoodsSendoutgoods= params => ajaxPost({url: `mall/goodsorder/sendoutgoods/`,params})

// 商城订单 订单价格 订单量统计
export const mallGoodsOrderstatistics= params => ajaxGet({url: `mall/goodsorder/orderstatistics/`,params})

//营销管理

// 优惠券管理 列表
export const mallGoodscoupon= params => ajaxGet({url: `mall/goodscoupon/`,params})
// 优惠券管理 新增
export const mallGoodscouponAdd= params => ajaxPost({url: `mall/goodscoupon/`,params})
// 优惠券管理 编辑
export const mallGoodscouponEdit= params => ajaxPut({url: `mall/goodscoupon/`,params})
// 优惠券管理 删除
export const mallGoodscouponDelete= params => ajaxDelete({url: `mall/goodscoupon/`,params})

// 优惠券记录 列表
export const mallCouponrecord= params => ajaxGet({url: `mall/couponrecord/`,params})
// 优惠券记录 新增
export const mallCouponrecordAdd= params => ajaxPost({url: `mall/couponrecord/`,params})
// 优惠券记录 编辑
export const mallCouponrecordEdit= params => ajaxPut({url: `mall/couponrecord/`,params})
// 优惠券记录 删除
export const mallCouponrecordDelete= params => ajaxDelete({url: `mall/couponrecord/`,params})

/**
 * 财务统计
 * **/

//商品订单统计
export const mallGoodsforderinfo= params => ajaxGet({url: `mall/goodsforderinfo/`,params})
// 商品订单统计 新增
export const mallGoodsforderinfoAdd= params => ajaxPost({url: `mall/goodsforderinfo/`,params})
// 商品订单统计 编辑
export const mallGoodsforderinfoEdit= params => ajaxPut({url: `mall/goodsforderinfo/`,params})
// 商品订单统计 删除
export const mallGoodsforderinfoDelete= params => ajaxDelete({url: `mall/goodsforderinfo/`,params})
// 商品订单统计 总金额统计
export const mallGoodsforderinfoOrderstatistics= params => ajaxGet({url: `mall/goodsforderinfo/orderstatistics/`,params})



/**
 *用户管理
 * */

// 用户管理 列表
export const UsersUsers= params => ajaxGet({url: `users/users/`,params})
// 用户管理 新增
export const UsersUsersAdd= params => ajaxPost({url: `users/users/`,params})
// 用户管理 编辑
export const UsersUsersEdit= params => ajaxPut({url: `users/users/`,params})
// 用户管理 删除
export const UsersUsersDelete= params => ajaxDelete({url: `users/users/`,params})
// 用户管理 禁用用户
export const UsersUsersdisableEdit= params => ajaxPut({url: `users/users/disableuser/`,params})
// 用户管理 导出
export const UsersUsersExportexecl= params => ajaxGet({url: `users/users/exportexecl/`,params})

/**
*平台设置
*/
//轮播图列表
export const platformsettingsLunboimg= params => ajaxGet({url: `platformsettings/lunboimg/`,params})
// 轮播图列表 新增
export const platformsettingsLunboimgAdd= params => ajaxPost({url: `platformsettings/lunboimg/`,params})
// 轮播图列表 编辑
export const platformsettingsLunboimgEdit= params => ajaxPut({url: `platformsettings/lunboimg/`,params})
// 轮播图列表 删除
export const platformsettingsLunboimgDelete= params => ajaxDelete({url: `platformsettings/lunboimg/`,params})


//其他设置
export const platformsettingsOther= params => ajaxGet({url: `platformsettings/other/`,params})
// 其他设置 新增
export const platformsettingsOtherAdd= params => ajaxPost({url: `platformsettings/other/`,params})
// 其他设置 编辑
export const platformsettingsOtherEdit= params => ajaxPut({url: `platformsettings/other/`,params})
// 其他设置 删除
export const platformsettingsOtherDelete= params => ajaxDelete({url: `platformsettings/other/`,params})

// 平台设置 图片上传
export const platformsettingsUploadPlatformImg= params => uploadImg({url: `platformsettings/uploadplatformimg/`,params})

//前端访问操作 获取
export const superOerateGet= params => ajaxGet({url: `super/operate/`,params})
//前端访问操作 设置
export const superOerateSet= params => ajaxPost({url: `super/operate/`,params})
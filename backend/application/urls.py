"""application URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path,include, re_path
from django.views.static import serve
from django.conf import settings
from drf_yasg import openapi
from drf_yasg.views import get_schema_view
from rest_framework import permissions
from django.views.generic.base import RedirectView
from rest_framework_simplejwt.views import (
    TokenRefreshView,
)

from mysystem.views.login import LoginView,CaptchaView
from utils.swagger import CustomOpenAPISchemaGenerator

#前端接口view
from apps.oauth.views import WeChatXCXLoginAPIView,XCXWeChatUserInfoUpdateAPIView,WeChatXCXMobileLoginAPIView,WeChatGZHLoginAPIView,WeChatGZHBindAPIView,GetXCXShareQrcodeView,TTXCXLoginAPIView,WeChatGZHH5LoginAPIView,CheckWeChatGZHH5APIView,GetWeChatGZHH5JSSDKTempSignAPIView
from apps.address.views import *
from apps.logins.views import APPMobilePasswordLoginView,SendSmsCodeView,APPMobileSMSLoginView,ForgetPasswdResetView,RegisterView
from apps.lyusers.views import SetUserNicknameView,ChangeAvatarView,uploadImagesView,DestroyUserView
from apps.lymessages.views import UserMessagesView,UserMessagesNoticeView,GetUnreadMessageNumView
from apps.platformsettings.views import *
from apps.mall.views import *

#app下载页
from apps.lyusers.views import downloadapp
#媒体文件流式响应
from utils.streamingmedia_response import streamingmedia_serve
#部署vue
from django.views.generic import TemplateView
#是否允许前端接口访问
from utils.middleware import OperateAllowFrontendView

schema_view = get_schema_view(
    openapi.Info(
        title="django-vue-lyadmin API",
        default_version='v1',
        # description="Test description",
        # terms_of_service="https://www.google.com/policies/terms/",
        # contact=openapi.Contact(email="contact@snippets.local"),
        # license=openapi.License(name="BSD License"),
    ),
    # public 表示文档完全公开, 无需针对用户鉴权
    public=True,
    permission_classes=(permissions.AllowAny,),
    generator_class=CustomOpenAPISchemaGenerator,
)

urlpatterns = [
    path('static/<path:path>', serve, {'document_root': settings.STATIC_ROOT},),  # 处理静态文件
    # path('media/<path:path>', serve, {'document_root': settings.MEDIA_ROOT},),  # 处理媒体文件
    path('media/<path:path>', streamingmedia_serve, {'document_root': settings.MEDIA_ROOT}, ),  # 处理媒体文件
    # path('admin/', admin.site.urls),
    #api文档地址(正式上线需要注释掉)
    re_path(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    re_path(r'^swagger(?P<format>\.json|\.yaml)$', schema_view.without_ui(cache_timeout=0), name='schema-json'),
    path('lyapi/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path(r'lyredoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    #管理后台的标准接口
    path('api/system/', include('mysystem.urls')),
    path('api/monitor/', include('lymonitor.urls')),
    path('api/terminal/', include('lywebsocket.urls')),
    path('api/token/', LoginView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/captcha/', CaptchaView.as_view()),

    #管理后台其他自定义接口
    path('api/platformsettings/', include('apps.platformsettings.urls')),
    path('api/address/', include('apps.address.urls')),
    path('api/messages/', include('apps.lymessages.urls')),
    path('api/users/', include('apps.lyusers.urls')),
    path('api/mall/', include('apps.mall.urls')),
    path('api/crontab/', include('apps.lycrontab.urls')),

    # ========================================================================================= #
    # ********************************** 前端微服务API用户接口************************************ #
    # ========================================================================================= #
    #登录
    path('api/app/register/', RegisterView.as_view(), name='app端手机号注册'),
    path('api/h5/ttlogin/', TTXCXLoginAPIView.as_view(), name='字节跳动小程序登录认证'),
    path('api/h5/wxh5logincheck/', CheckWeChatGZHH5APIView.as_view(), name='微信服务器校验服务器'),
    path('api/h5/wxh5login/', WeChatGZHH5LoginAPIView.as_view(), name='微信公众号H5网页授权登录'),
    path('api/h5/wxh5sign/', GetWeChatGZHH5JSSDKTempSignAPIView.as_view(), name='微信公众号H5网页获取js sdk的临时签名信息'),
    path('api/app/login/', APPMobilePasswordLoginView.as_view(), name='app端手机号密码登录认证'),
    path('api/app/wxlogin/', WeChatGZHLoginAPIView.as_view(), name='app端手机号微信登录认证'),
    path('api/app/wxbindlogin/', WeChatGZHBindAPIView.as_view(), name='app端手机号微信登录认证绑定微信'),
    path('api/app/sendsms/', SendSmsCodeView.as_view(), name='app端手机号发送短信验证码'),
    path('api/app/moilelogin/', APPMobileSMSLoginView.as_view(), name='app端手机号短信登录认证'),
    path('api/xcx/login/', WeChatXCXLoginAPIView.as_view(), name='微信小程序登录认证'),
    path('api/xcx/mobilelogin/', WeChatXCXMobileLoginAPIView.as_view(), name='微信小程序手机号授权绑定登录认证'),
    path('api/app/destoryuser/', DestroyUserView.as_view(), name='app端用户注销账户'),

    #用户信息
    path('api/app/restpassword/', ForgetPasswdResetView.as_view(), name='app端手机号重置密码'),
    path('api/app/setnickname/', SetUserNicknameView.as_view(), name='app端修改昵称'),
    path('api/app/changeavatar/', ChangeAvatarView.as_view(), name='app端回收员修改头像'),
    path('api/app/uploadimage/', uploadImagesView.as_view(), name='app端上传图片'),
    path('api/xcx/getuserinfo/', XCXWeChatUserInfoUpdateAPIView.as_view(), name='微信小程序获取用户信息'),
    path('api/xcx/getshareqrcode/', GetXCXShareQrcodeView.as_view(), name='微信小程序用户获取推广小程序二维码'),
    path('api/app/usermessages/', UserMessagesView.as_view(), name='app端获取系统消息和平台公告通知（包含已读，未读）/操作修改为已读/删除'),
    path('api/app/usermessagesnotice/', UserMessagesNoticeView.as_view(), name='app端获取平台公告列表'),
    path('api/app/getunreadmessagenums/', GetUnreadMessageNumView.as_view(), name='app端获取未读消息的数量'),
    path('api/app/feeckback/', APPUserLeavingMessageView.as_view(), name='app端意见反馈'),

    #用户地址管理API
    path('api/app/getaddress/', GetAssressesListView.as_view(), name='app用户获取地址'),
    path('api/app/addeditaddress/', CreateUpdateAssressesView.as_view(), name='app用户新增编辑地址'),
    path('api/app/deladdress/', DeleteAssressesView.as_view(), name='app用户删除地址'),
    path('api/app/setdefaultaddress/', SetDefaultAssressesView.as_view(), name='app用户设置默认地址'),

    #商城API
    path('api/app/getgoodstypelist/', GoodsTypeView.as_view(), name='app用户端商城-获取分类标签'),
    path('api/app/getgoodslist/', GoodsListView.as_view(), name='app用户端商城-获取商品列表'),
    path('api/app/getgoodsdetail/', GoodsDetailView.as_view(), name='app用户端商城-获取商品详情'),
    path('api/app/cartoperate/', CartsView.as_view(), name='app用户端商城-购物车操作'),
    path('api/app/cartselectall/', CartsSelectAllView.as_view(), name='app用户端商城-购物车全选\取消全选'),
    path('api/app/mycoupon/', MyCouponView.as_view(), name='app用户端-我的优惠券'),
    path('api/app/goodsordercancel/', GoodsOrderCancleView.as_view(), name='app用户端-取消商城订单'),
    path('api/app/goodsordercommit/', OrdersCommitView.as_view(), name='app用户端-商城订单生成'),
    path('api/app/goodsorderconfirmrev/', GoodsOrderConfirmReceiveView.as_view(), name='app用户端-商城订单生成'),
    path('api/app/goodsorderlist/', GoodsOrdersListView.as_view(), name='app用户端-商城订单列表'),
    path('api/app/goodsorderdetail/', GoodsOrdersDetailView.as_view(), name='app用户端-商城订单详情'),

    #支付API
    path('api/app/payment/', PaymentView.as_view(), name='app端购买接口'),
    path('api/app/ali_notify/', alipay_notify.as_view(), name='支付宝异步通知回调接口'),
    path('api/app/wechatpay_notify/', wechatpay_notify.as_view(), name='微信支付异步通知回调接口'),

    #获取平台信息
    path('api/getothersettings/', GetOtherManageDetailView.as_view(), name='前端用户获取平台其他设置'),
    path('api/getrotationimgs/', GetLunboManageListView.as_view(), name='前端用户获取平台轮播图设置'),
    re_path(r'^api/areas/$', ProvinceAreasView.as_view(),name='省市区三级联动获取省'),
    re_path(r'^api/areas/(?P<pk>[1-9]\d*)/$', SubAreasView.as_view(),name='省市区三级联动获取市/区'),
    path('api/getallareaslist/', GetProvinceAreasListView.as_view(), name='递归获取所有省市区数据'),
    path('api/getaddressaccuracy/', GetAddressAccuracyView.as_view(), name='后台根据详细地址获取经纬度'),

    #是否允许前端接口访问(临时操作，重启后无效)
    path('api/super/operate/', OperateAllowFrontendView.as_view(), name='超级管理员动态操作是否允许前端api接口访问'),

    #集成部署后端管理页面
    path('downloadapp/',downloadapp ,name='前端APP下载页'),
    path('favicon.ico',RedirectView.as_view(url=r'static/favicon.ico')),
    path('', TemplateView.as_view(template_name="index.html"),name='后台管理默认页面'),
]


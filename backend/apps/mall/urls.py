# -*- coding: utf-8 -*-

"""
@Remark: 商城路由文件
"""
from django.urls import path, re_path
from rest_framework import routers

from apps.mall.views import GoodsCategoryManageViewSet,GoodsCouponManageViewSet,CouponRecordManageViewSet
from apps.mall.views import GoodsSPUViewSet,FinanceOrderInfoViewSet,GoodsOrderManageViewSet

system_url = routers.SimpleRouter()
system_url.register(r'goodstype', GoodsCategoryManageViewSet)
system_url.register(r'goodscoupon', GoodsCouponManageViewSet)
system_url.register(r'couponrecord', CouponRecordManageViewSet)
system_url.register(r'goodsspu', GoodsSPUViewSet)
system_url.register(r'goodsforderinfo', FinanceOrderInfoViewSet)
system_url.register(r'goodsorder', GoodsOrderManageViewSet,basename='goodsorder')


urlpatterns = [
    re_path('goodsspu/islaunched/(?P<pk>.*?)/', GoodsSPUViewSet.as_view({'put':'islaunched'}), name='后台根据sku_id上下架商品'),
    re_path('goodsspu/editskups/(?P<pk>.*?)/', GoodsSPUViewSet.as_view({'put':'editsku_price_stock'}), name='后台根据sku_id上下架商品'),
    path('goodsforderinfo/orderstatistics/',FinanceOrderInfoViewSet.as_view({'get':'orderstatistics'}), name='后台商品类订单金额统计'),
    path('goodsorder/sendoutgoods/', GoodsOrderManageViewSet.as_view({'post':'sendoutgoods'}), name='后台根据商品订单id发货'),
    path('goodsorder/orderstatistics/',GoodsOrderManageViewSet.as_view({'get':'orderstatistics'}), name='后台商品订单金额订单量统计'),
]
urlpatterns += system_url.urls
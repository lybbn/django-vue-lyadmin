from rest_framework.views import APIView
from mysystem.models import Users,Role,Dept
from apps.oauth.models import OAuthWXUser
from apps.mall.models import GoodsCategory,GoodsCoupon,CouponRecord,SPU,SKU,SKUImage,SKUSpecification,SPUSpecification,SPUSpecificationOption,OrderInfo,OrderGoods,CouponRecord,GoodsCoupon,OrderRefunds
from apps.address.models import Address
from utils.jsonResponse import SuccessResponse,ErrorResponse
from rest_framework import serializers
from utils.common import formatdatetime,float2dot,REGEX_MOBILE,get_parameter_dic,renameuploadimg,getminrandomodernum,geturlpath,ismoney,ast_convert,getrandomodernum,format_wechat_gmt_8_to_normal
import re
from django.db.models import Q,F,Sum, Avg, Max, Min, Count
from rest_framework.serializers import ModelSerializer
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework.permissions import IsAuthenticated
from utils.filters import FinanceOrderInfoTimeFilter
from django.db import transaction
from django_redis import get_redis_connection
import datetime
import os
import json
from django.contrib.auth.hashers import make_password
from decimal import Decimal
from utils.export_excel import export_excel
from utils.pagination import CustomPagination
from utils.wexinpay_cashout import Pay,get_client_ip,random_str
from utils.weixinpay import WxAppPay
from utils.alipay import initalipay,alipay_trade_app,alipay_trade_refund
from config import DOMAIN_HOST
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from django.http import HttpResponse
import logging
logger = logging.getLogger(__name__)

# Create your views here.
# ================================================= #
# ************** 后端商城管理 view  ************** #
# ================================================= #

class GoodsCategoryManageSerializer(CustomModelSerializer):
    """
    商品分类管理-序列化器
    """

    class Meta:
        model = GoodsCategory
        read_only_fields = ["id"]
        fields = '__all__'

class GoodsCategoryManageViewSet(CustomModelViewSet):
    """
    后台商品分类管理 接口
    """
    queryset = GoodsCategory.objects.all().order_by("sort")
    serializer_class = GoodsCategoryManageSerializer
    search_fields = ('name',)

class GoodsCouponManageSerializer(CustomModelSerializer):
    """
    商品分类管理-序列化器
    """
    coupon_type_name = serializers.SerializerMethodField(read_only=True)
    menkan = serializers.SerializerMethodField(read_only=True)
    sendto = serializers.SerializerMethodField(read_only=True)

    def get_sendto(self,obj):
        if obj.receive_type in [1,2,4]:
            return "全部用户"


    def get_menkan(self,obj):
        if obj.is_condition:#有门槛
            return float2dot(obj.use_min_price)+"元"
        else:
            return "无门槛"


    def get_coupon_type_name(self,obj):
        return obj.get_coupon_type_display()

    class Meta:
        model = GoodsCoupon
        read_only_fields = ["id"]
        fields = '__all__'

class GoodsCouponManageViewSet(CustomModelViewSet):
    """
    后台优惠券管理 接口
    """
    queryset = GoodsCoupon.objects.all().order_by("-create_datetime")
    serializer_class = GoodsCouponManageSerializer
    search_fields = ('name',)

class CouponRecordManageSerializer(CustomModelSerializer):
    """
    用户优惠券持有记录-序列化器
    """
    status_name = serializers.SerializerMethodField(read_only=True)
    coupon_name = serializers.SerializerMethodField(read_only=True)
    coupon_type_name = serializers.SerializerMethodField(read_only=True)
    used_time = serializers.SerializerMethodField(read_only=True)

    def get_used_time(self,obj):
        return formatdatetime(obj.used_time)

    def get_coupon_name(self,obj):
        return obj.coupon.name

    def get_coupon_type_name(self,obj):
        return obj.coupon.get_coupon_type_display()

    def get_status_name(self,obj):
        return obj.get_status_display()

    class Meta:
        model = CouponRecord
        read_only_fields = ["id"]
        fields = '__all__'

class CouponRecordManageViewSet(CustomModelViewSet):
    """
    用户优惠券持有记录 接口
    """
    queryset = CouponRecord.objects.filter(is_delete=False).order_by("-create_datetime")
    serializer_class = CouponRecordManageSerializer
    # search_fields = ('name',)
    filterset_fields = ('user_id','status')

class SPUSpecificationOptionSerializer(CustomModelSerializer):
    """
    商品SPU规格选项值 简单序列化器
    """

    class Meta:
        model = SPUSpecificationOption
        read_only_fields = ["id"]
        # fields = '__all__'
        exclude = ['dept_belong_id', 'description', 'modifier', 'creator']
        extra_kwargs = {
            'spec': {'required': False},
        }

class SPUSpecModelSerializer(CustomModelSerializer):
    """
    商品SPU规格名 简单序列化器
    """
    # spu = serializers.StringRelatedField()
    # spu_id = serializers.CharField()
    options = SPUSpecificationOptionSerializer(many=True,required=False)

    class Meta:
        model = SPUSpecification
        read_only_fields = ["id"]
        # fields = '__all__'
        exclude = ['dept_belong_id', 'description', 'modifier', 'creator']
        extra_kwargs = {
            'spu': {'required': False},
        }

class SKUSpecificationSerialzier(CustomModelSerializer):
    """
    SKU规格表 简单序列化器
    """
    # spec_id = serializers.CharField()
    # option_id = serializers.CharField()
    # spec = serializers.StringRelatedField()
    # option = serializers.StringRelatedField()
    spec = serializers.CharField()
    option = serializers.CharField()

    class Meta:
        model = SKUSpecification  # SKUSpecification中sku外键关联了SKU表
        # fields = "__all__"
        # fields = ('id', 'spec', 'option')
        exclude = ['dept_belong_id', 'description', 'modifier', 'creator']
        extra_kwargs = {
            'sku': {'required': False},
            'spec': {'required': False},
            'option': {'required': False},
        }

class GoodsSPUImageSerialzier(CustomModelSerializer):
    """
    SPU商品图片 简单序列化器
    """

    class Meta:
        model = SKUImage
        fields = ('image',)

class GoodsSKUSerializer(CustomModelSerializer):
    """
    SKU 简单序列化器
    """
    specs = SKUSpecificationSerialzier(many=True,required=False)

    class Meta:
        model = SKU
        # fields = "__all__"
        exclude = ['dept_belong_id', 'description', 'modifier', 'creator']
        extra_kwargs = {
            'spu': {'required': False},
        }



class GoodsSPUSerializer(CustomModelSerializer):
    """
    商品管理 SPU 简单序列化器
    """
    spu_specs = SPUSpecModelSerializer(many=True,required=False)
    skus = GoodsSKUSerializer(many=True,required=False)

    category1_name = serializers.SerializerMethodField(read_only=True)

    stock = serializers.SerializerMethodField(read_only=True)#默认多规格选择为所有sku库存的合计

    def get_stock(self,obj):
        if obj.spec_type:#多规格
            allskus = obj.skus.all().aggregate(sumstock=Sum('stock'))
            return allskus['sumstock']
        else:#单规格
            return obj.skus.first().stock

    def get_category1_name(self,obj):
        if obj.category1:
            return obj.category1.name

    def to_representation(self, instance):  # 序列化
        ret = super().to_representation(instance)
        ret['image_list'] = ast_convert(ret['image_list'])  # 可以保存的修改字段值的方法
        return ret

    def to_internal_value(self, data):
        # 进提取所需要的数据，对其进行反序列化，data代表未验证的数据
        data['image_list'] = str(data['image_list'])
        return super().to_internal_value(data)

    def create(self, validated_data):
        """
        重写create方法，来手动插入中间表(SKUSpecification)数据记录新增sku拥有的规格和选项信息和轮播图
        :param validated_data:有效数据
        :return:新建的SPU对象
        """
        # specs记录的是中间表数据，无法用于新建SKU，所以先从有效数据中移除
        # specs = [{spec_id:1, option_id:2}, {...}...]
        # 获取规格信息,并从validated_data数据中,删除规格信息数据
        spec_type = validated_data['spec_type']
        spu_sepcs = validated_data.pop('spu_specs',[])  # 商品的spu规格字典数组形式[ { "name": "颜色", "options": [ { "value": "白色" }, { "value": "黑色" } ] }, { "name": "大小", "options": [ { "value": "X" }, { "value": "S" } ] } ]
        skus = validated_data.pop('skus',[])
        with transaction.atomic():  # 开启事务
            try:
                savepoint = transaction.savepoint()
                spu = SPU.objects.create(**validated_data)
                if spec_type:#多规格
                    if len(spu_sepcs) <=0 or len(skus) <=0:
                        # 回滚到保存点
                        transaction.savepoint_rollback(savepoint)
                        raise serializers.ValidationError("spu_sepcs或skus不能为空",400)
                        return
                    for spu_sepc in spu_sepcs:
                        new_spu_spec = SPUSpecification.objects.create(spu_id=spu.id,name=spu_sepc['name'])
                        for spu_sepc_option in spu_sepc['options']:
                            new_spu_spec_option = SPUSpecificationOption.objects.create(spec_id=new_spu_spec.id,value=spu_sepc_option['value'])
                    for sk in skus:
                        if 'default_image' not in sk.keys():
                            sk['default_image']=""
                        sku_instance = SKU.objects.create(spu_id=spu.id,price=sk['price'],stock=sk['stock'],default_image=sk['default_image'])
                        for sp in sk['specs']:
                            spuspec_instance = SPUSpecification.objects.filter(spu_id=spu.id,name=sp['spec']).first()
                            spuspec_option_instance = SPUSpecificationOption.objects.filter(spec_id=spuspec_instance.id, value=sp['option']).first()
                            SKUSpecification.objects.create(sku_id=sku_instance.id,spec_id=spuspec_instance.id,option_id=spuspec_option_instance.id)
                    # 获取价格最低的sku保存到spu的price中
                    minpricesku = SKU.objects.filter(spu=spu).order_by('price').first()
                    spu.price = minpricesku.price
                    spu.save()

                else:#单规格
                    if len(skus)<=0:
                        # 回滚到保存点
                        transaction.savepoint_rollback(savepoint)
                        raise serializers.ValidationError("skus不能为空", 400)
                        return
                    SKU.objects.create(spu=spu,price=skus[0]['price'],stock=skus[0]['stock'],default_image=skus[0]['default_image'])

            except Exception as e:
                # 回滚到保存点
                transaction.savepoint_rollback(savepoint)
                return e

            # 清除保存点
            transaction.savepoint_commit(savepoint)
            #返回spu
            return spu

    class Meta:
        model = SPU
        #fields = "__all__"
        exclude = ['dept_belong_id','description','modifier','creator','unit','brand','comments','desc_pack','desc_service']
        read_only_fields = ["id"]
        extra_kwargs = {
            'spu_specs': {'required': False},
        }

class SKUSpecificationSPUUpdateSerialzier(CustomModelSerializer):
    """
    SKU规格表 简单序列化器
    """
    spec = serializers.CharField()
    option = serializers.CharField()

    id = serializers.CharField()

    def validate_id(self, value):
        return value

    class Meta:
        model = SKUSpecification  # SKUSpecification中sku外键关联了SKU表
        # fields = "__all__"
        # fields = ('id', 'spec', 'option')
        exclude = ['dept_belong_id', 'description', 'modifier', 'creator']
        extra_kwargs = {
            'sku': {'required': False},
            'spec': {'required': False},
            'option': {'required': False},
        }

class GoodsSKUSPUUpdateSerializer(CustomModelSerializer):
    """
    SKU 简单序列化器
    """
    id = serializers.CharField()
    specs = SKUSpecificationSPUUpdateSerialzier(many=True,required=False)

    def validate_id(self, value):
        return value


    class Meta:
        model = SKU
        # fields = "__all__"
        exclude = ['dept_belong_id', 'description', 'modifier', 'creator']
        extra_kwargs = {
            'spu': {'required': False},
        }


class GoodsSPUUpdateSerializer(CustomModelSerializer):

    # skus = serializers.ListField(required=True)
    skus = GoodsSKUSPUUpdateSerializer(many=True, required=True)

    # spu_specs = serializers.ListField(required=False)

    def to_internal_value(self, data):
        # 进提取所需要的数据，对其进行反序列化，data代表未验证的数据
        data['image_list'] = str(data['image_list'])
        return super().to_internal_value(data)

    def update(self, instance, validated_data):
        # 获取规格信息,并从validated_data数据中,删除规格信息数据
        spec_type = validated_data['spec_type']
        if instance.spec_type != spec_type:
            raise serializers.ValidationError("商品规格类型不能更改", 400)
            return
        skus = validated_data.pop('skus',[])
        # spu_sepcs = validated_data.pop('spu_specs')
        if len(skus) <= 0:
            raise serializers.ValidationError("skus不能为空", 400)
            return
        with transaction.atomic():  # 开启事务
            try:
                savepoint = transaction.savepoint()
                # 方案一： 调用父类 ，去实现没有问题的数据更新
                instance = super().update(instance, validated_data)

                if spec_type:  # 多规格（只能修改现有规格库存和价格，不能添加和减少规格）前端直接修改，不通过本接口修改
                    pass
                else:#单规格
                    SKU.objects.filter(spu_id=instance.id,id=skus[0]['id']).update(price=skus[0]['price'],stock=skus[0]['stock'],default_image=skus[0]['default_image'])
            except Exception as e:
                # 回滚到保存点
                transaction.savepoint_rollback(savepoint)
                return e
            # 清除保存点
            transaction.savepoint_commit(savepoint)
            return instance

    class Meta:
        model = SPU
        #fields = "__all__"
        exclude = ['dept_belong_id','description','modifier','creator']
        read_only_fields = ["id"]

class GoodsSPUViewSet(CustomModelViewSet):
    queryset = SPU.objects.all().order_by("sort")
    serializer_class = GoodsSPUSerializer
    create_serializer_class = GoodsSPUSerializer
    update_serializer_class =GoodsSPUUpdateSerializer
    search_fields = ('name',)
    filterset_fields = ('is_launched','category1')

    def islaunched(self, request, *args, **kwargs):
        """上下架商品"""
        queryset = self.filter_queryset(self.get_queryset())
        pk = kwargs.get('pk')
        if ',' in kwargs.get('pk'):  # 批量
            ids = pk.split(',')
            instance = queryset.filter(id__in=ids)
            if instance:
                instance.update(is_launched=True)
                return SuccessResponse(data=None, msg="修改成功")
            else:
                return ErrorResponse(msg="未获取到该商品")
        else:
            instance = SPU.objects.filter(id=kwargs.get('pk')).first()
            if instance:
                if instance.is_launched:
                    instance.is_launched = False
                else:
                    instance.is_launched = True
                instance.save()
                return SuccessResponse(data=None, msg="修改成功")
            else:
                return ErrorResponse(msg="未获取到该商品")

    def editsku_price_stock(self, request, *args, **kwargs):
        """多规格情况下修改商品的库存和价格和默认图片"""
        pk = kwargs.get('pk')
        instance = SKU.objects.filter(id=pk).first()
        if instance:
            price = get_parameter_dic(request)['price']
            stock = get_parameter_dic(request)['stock']
            default_image = get_parameter_dic(request)['default_image']
            instance.price = price
            instance.stock = stock
            instance.default_image = default_image
            instance.save()
            #修改spu的最低price价格
            skus = SKU.objects.filter(spu=instance.spu).order_by('price').first()
            SPU.objects.filter(id=instance.spu.id).update(price=skus.price)
            return SuccessResponse(data=None, msg="修改成功")
        else:
            return ErrorResponse(msg="未获取到该商品")

class FinanceOrderInfoSerializer(CustomModelSerializer):
    """
    商品类财务流水-序列化器
    """
    userinfo = serializers.SerializerMethodField()
    pay_method = serializers.SerializerMethodField()
    gname = serializers.SerializerMethodField()

    def get_gname(self,obj):
        allgoods = obj.ordergoodsskus.all().first()
        return allgoods.sku.spu.name


    def get_pay_method(self,obj):
        return obj.get_pay_method_display()

    def get_userinfo(self, obj):
        return {
            'id': obj.user.id,
            'nickname': obj.user.nickname,
            'avatar': obj.user.avatar
        }

    class Meta:
        model = OrderInfo
        read_only_fields = ["id"]
        fields = '__all__'

class FinanceOrderInfoViewSet(CustomModelViewSet):
    """
    后台会商品类财务流水 接口
    """
    queryset = OrderInfo.objects.filter(pay_status=1).order_by("-create_datetime")
    serializer_class = FinanceOrderInfoSerializer
    # search_fields = ('name',)
    filterset_class = FinanceOrderInfoTimeFilter

    def orderstatistics(self,request):
        """
        订单金额 收益总金额统计
        :param request:
        :return:
        """
        #按照原来的过滤查询
        queryset = self.filter_queryset(self.get_queryset())
        totalmoney = 0
        if queryset:
            totalmoney = queryset.aggregate(price = Sum('total_amount'))['price']
        else:
            totalmoney = 0

        data = {
            "totalmoney": float2dot(totalmoney),
        }

        return SuccessResponse(data=data,msg='success')

class OrderInfoSerializer(CustomModelSerializer):

    address = serializers.SerializerMethodField(read_only=True)
    userinfo = serializers.SerializerMethodField(read_only=True)
    goodsinfo = serializers.SerializerMethodField(read_only=True)
    pay_time = serializers.SerializerMethodField(read_only=True)
    pay_method_name = serializers.SerializerMethodField(read_only=True)

    def get_pay_time(self,obj):
        return formatdatetime(obj.pay_time)

    def get_pay_method_name(self,obj):
        return obj.get_pay_method_display()

    def get_goodsinfo(self,obj):
        data=[]
        goods = OrderGoods.objects.filter(order_id=obj.id)
        if not goods:
            return None
        for good in goods:
            datasku={}
            if good.sku.spu.spec_type == 1:#多规格
                sku_spec = ""
                temp_sepcs = good.sku.specs.all()
                for temp_sepc in temp_sepcs:
                    if len(temp_sepcs) > 1:
                        sku_spec = sku_spec + temp_sepc.option.value + ';'
                    else:
                        sku_spec = temp_sepc.option.value

            else:
                sku_spec = good.sku.spu.name
            datasku['sku_name'] = good.sku.name
            datasku['sku_spec'] = sku_spec
            datasku['sku_default_image'] = good.sku.default_image
            datasku['count'] = good.count
            datasku['price'] = good.price
            datasku['comment'] = good.comment
            datasku['score'] = good.score
            data.append(datasku)
        return data

    def get_address(self,obj):
        data={}
        data['areas'] = obj.address.get_region_format()+ (obj.address.street if obj.address.street else "")  + obj.address.place
        data['receiver'] = obj.address.receiver
        data['mobile'] = obj.address.mobile
        return data

    def get_userinfo(self, obj):
        return {
            'id': obj.user.id,
            'nickname': obj.user.nickname,
            'name':obj.user.name,
            'avatar': obj.user.avatar,
            'mobile':obj.user.mobile,
        }

    class Meta:
        model = OrderInfo
        fields = "__all__"
        read_only_fields = ["id"]

class GoodsOrderManageViewSet(CustomModelViewSet):
    """
    商品订单管理:
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = OrderInfo.objects.all().order_by('-create_datetime')
    serializer_class = OrderInfoSerializer
    filterset_class = FinanceOrderInfoTimeFilter

    def closeorder(self,request):
        # 按照原来的过滤查询
        queryset = self.filter_queryset(self.get_queryset())
        # 接收的参数
        id = get_parameter_dic(request)['id']  # 商品订单id
        if not id:
            return ErrorResponse(msg="提交的参数不能为空")
        order = queryset.filter(id=id, status=2).first()
        if not order:
            return ErrorResponse(msg='不存在此商品订单信息,或该状态订单不支持关闭')

        with transaction.atomic():
            order.status = 6
            order.save()
            # 订单退款逻辑
            orderrefund()

            return SuccessResponse(msg='订单已关闭')


    def orderstatistics(self,request):
        """
        订单金额 订单量统计
        :param request:
        :return:
        """
        #按照原来的过滤查询
        queryset = self.filter_queryset(self.get_queryset())
        totalmoney = 0
        totalcount = 0
        if queryset:
            totalmoney = queryset.aggregate(price = Sum('total_amount'))['price']
            totalcount = queryset.count()

        data = {
            "totalmoney": float2dot(totalmoney),
            "totalcount": totalcount,
        }

        return SuccessResponse(data=data,msg='success')

    def sendoutgoods(self,request):
        # 按照原来的过滤查询
        queryset = self.filter_queryset(self.get_queryset())
        #接收的参数
        id = get_parameter_dic(request)['id']  # 商品订单id
        orderNo = get_parameter_dic(request)['orderNo']  # 商品物流单号
        logistics_company = get_parameter_dic(request)['logistics_company']  # 商品物流公司
        if not all([id,orderNo,logistics_company]):
            return ErrorResponse(msg="提交的参数不能为空")
        order = queryset.filter(id=id,status=2).first()
        if not order:
            return ErrorResponse(msg='不存在此商品订单信息,或该状态订单不支持发货')
        order.logistics_id = orderNo
        order.logistics_company = logistics_company
        order.send_time = datetime.datetime.now()
        order.status = 3
        order.save()
        return SuccessResponse(msg='修改成功')

def orderrefund(orderid,type=1):
    """
    orderid为要退款的订单id
    type：1：商城订单退款 2服务订单退款
    """
    if type == 1:#商城订单
        order = OrderInfo.objects.get(id=orderid)
        paymethod = order.pay_method
        transaction_id = order.trade_id
        money = order.total_amount
        reason = "订单退款"
        orderno = getrandomodernum()
        refundsorder = OrderRefunds.objects.create(order_no=orderno,order=order,amount=money,reason=reason)
    else:#其他订单
        pass
    # 支付类型判断
    if paymethod == 2:#微信
        wxapppay = WxAppPay()
        data = wxapppay.refundsorder(orderno, transaction_id,reason, money*100,money*100,notify_url="%s/api/app/wechatpay_notify_refund/" % DOMAIN_HOST)
    elif paymethod == 3:#支付宝
        data = alipay_trade_refund(transaction_id, float(money), notify_url="%s/api/app/ali_notify_refund/" % DOMAIN_HOST)

    #判断是否成功



# ================================================= #
# ************** 前端商城接口 view  ************** #
# ================================================= #

class GoodsTypeView(APIView):
    """
    get:
    获取商城分类
    【参数】type = all 所有 、 tabs 标签 、  icons 图标
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self,request):
        type = get_parameter_dic(request)['type']
        if type == "all":
            queryset = GoodsCategory.objects.filter(is_delete=False).order_by('sort')
        elif type == "tabs":
            queryset = GoodsCategory.objects.filter(default_image__isnull=True,is_delete=False).order_by('sort')
        elif type == "icons":
            queryset = GoodsCategory.objects.filter(default_image__isnull=False,is_delete=False).order_by('sort')
        else:
            return ErrorResponse(msg='type类型错误')
        data = []
        if queryset:
            for q in queryset:
                data.append({
                    'id': q.id,
                    'name': q.name,
                    'default_image': q.default_image,
                })
        return SuccessResponse(data=data,msg="success")

class GoodsListView(APIView):
    """
    get:
    获取商城商品列表
    【参数】
    search：搜索（非必须）
    is_tuijian: 0非推荐、1推荐、2所有 （必须，默认为2获取说有）
    order_by:排序 sort 商品默认顺序 、price 正序 、-price 倒叙、sales 正序、-sales倒叙 （默认为sort）(非必须)
    category:商品分类id（非必须），默认为所有分类
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self,request):
        search = get_parameter_dic(request).get('search')  # 搜索
        is_tuijian = int(get_parameter_dic(request)['is_tuijian'])  # 是否获取推荐商品
        order_by = get_parameter_dic(request).get('order_by')  # 排序
        category = get_parameter_dic(request).get('category')  # 分类
        if is_tuijian not in [0,1,2]:
            return ErrorResponse("is_tuijian error")
        if order_by and order_by not in ['sort','price','-price','-sales','sales']:
            return ErrorResponse("order_by error")
        else:
            order_by = "sort"
        if search:
            if is_tuijian == 2:
                if category:
                    queryset = SPU.objects.filter(name__contains=search,category1_id=category,is_launched=True).order_by(order_by)
                else:
                    queryset = SPU.objects.filter(name__contains=search, is_launched=True).order_by(order_by)
            else:
                queryset = SPU.objects.filter(name__contains=search,is_tuijian=is_tuijian,is_launched=True).order_by(order_by)
        else:
            if is_tuijian == 2:
                if category:
                    queryset = SPU.objects.filter(category1_id=category,is_launched=True).order_by(order_by)
                else:
                    queryset = SPU.objects.filter(is_launched=True).order_by(order_by)
            else:
                queryset = SPU.objects.filter(is_tuijian=is_tuijian,is_launched=True).order_by(order_by)

        # # 1. 实例化分页器对象
        page_obj = CustomPagination()
        # # 2. 使用自己配置的分页器调用分页方法进行分页
        page_data = page_obj.paginate_queryset(queryset, request)
        data = []
        if queryset:
            for m in page_data:
                data.append({
                    'spu_id':m.id,
                    'price':m.price,
                    'default_image':m.default_image,
                    'name':m.name,
                    'sales':m.sales,
                    'spec_type':m.spec_type
                })

        return page_obj.get_paginated_response(data=data)



class GoodsDetailView(APIView):
    """
    get:
    获取商城商品列表
    【参数】
    spu_id：商品id
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self,request):
        spu_id = get_parameter_dic(request).get('spu_id')  # 商品id
        if not spu_id:
            return ErrorResponse(msg="参数spu_id不能为空")
        spu = SPU.objects.filter(id=spu_id,is_launched=True).first()
        if not spu:
            return ErrorResponse(msg='该商品不存在或已下架')
        skus = SKU.objects.filter(spu=spu).order_by("create_datetime")
        sum_stock = skus.aggregate(sumstock=Sum('stock'))
        stock=sum_stock['sumstock']
        myspecs = []#规格
        if spu.spec_type == 1:#多规格
            spusepcs = SPUSpecification.objects.filter(spu=spu).order_by('create_datetime')
            for spusepc in spusepcs:
                spuspecvalues = spusepc.options.all()
                spu_options = {'values': []}
                spu_options['id'] = spusepc.id
                spu_options['spec_key'] = spusepc.name
                for temps in spuspecvalues:
                    spu_options['values'].append({
                        'id':temps.id,
                        'spec_value':temps.value
                    })
                myspecs.append(spu_options)
        skus_list = []#skus
        for temp_sku in skus:
            # temp_sku:每一个sku商品对象
            sku_spec_options = SKUSpecification.objects.filter(sku=temp_sku).order_by('spec_id')
            sku_options = {'spec': []}
            sku_options['sku_id'] = temp_sku.id
            sku_options['stock'] = temp_sku.stock
            sku_options['price'] = temp_sku.price
            sku_options['default_image'] = temp_sku.default_image
            if spu.spec_type == 1:#多规格
                for temp in sku_spec_options:
                    sku_options['spec'].append({'spec_key': temp.spec.name, 'spec_value': temp.option.value, 'spec_key_id': temp.spec_id,'spec_value_id': temp.option_id})
            skus_list.append(sku_options)
        data = {
            'spu_id': spu.id,
            'price': spu.price,
            'default_image': spu.default_image,
            'goods_imagelist': SKUImage.objects.filter(spu=spu).values_list('image', flat=True).order_by('sort'),
            'name': spu.name,
            'sales': spu.sales,
            'spec_type': spu.spec_type,
            'desc_detail':spu.desc_detail,
            'stock':stock,
            'skus':skus_list,
            'specs': myspecs
        }
        return SuccessResponse(data=data, msg='success')

class CartsView(APIView):
    """
    get:
    前端用户获取购物车列表
    post：
    更新购物车信息
    【参数】：type为需要操作购物车的功能类型，del表示删除、edit表示编辑，add表示新增
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self, request):
        user = request.user
        client = get_redis_connection('carts')
        sku_id_count = client.hgetall('carts_%s' % user.id)
        sku_id_selected = client.smembers('carts_selected_%s' % user.id)
        data_dict = {}
        for sku_id,count in sku_id_count.items():
            data_dict[sku_id] = {
                'count': int(count),
                'selected': sku_id in sku_id_selected
            }
        sku_keys = data_dict.keys()
        skus = SKU.objects.filter(id__in=sku_keys)
        cart_skus = []
        for sku in skus:
            spec_name = ""
            if sku.spu.spec_type == 1:#多规格
                spec_names = sku.specs.all()
                for temp_spec_name in spec_names:
                    if len(spec_names)>1:
                        spec_name =spec_name + temp_spec_name.option.value+';'
                    else:
                        spec_name = temp_spec_name.option.value
            cart_skus.append({
                'spu_id': sku.spu.id,
                'sku_id': sku.id,
                'name': sku.spu.name,
                'price': float2dot(sku.price),
                'count': data_dict[sku.id]['count'],
                'stock':sku.stock,
                'spec_name':spec_name,
                'default_image': sku.spu.default_image,
                'selected': str(data_dict[sku.id]['selected']),
            })
        return SuccessResponse(data=cart_skus,msg="success")

    def post(self, request):
        sku_id  = get_parameter_dic(request)['sku_id']#商品id
        type = get_parameter_dic(request)['type']#购物车操作类型
        # 验证商品是否存在
        sku = SKU.objects.filter(id=sku_id).first()
        if not sku:
            return ErrorResponse(msg='商品不存在')
        user = request.user

        if type=="add":#添加购物车,在redis中保存用户的购物车记录
            count = int(get_parameter_dic(request)['count'])  # 购物车该商品的数量
            selected = int(get_parameter_dic(request)['selected'])  # 购物车操作类型 1勾选 0 不勾选
            if selected not in [0, 1]:
                return ErrorResponse(msg="selected error")
            if sku_id is None or count is None:
                return ErrorResponse(msg='sku_id/count不能为空')
            if not isinstance(count,int):
                return ErrorResponse(msg='count类型错误')
            selected = True
            if int(count) > sku.stock:
                return ErrorResponse(msg='库存不足')
            # 登陆过则存入redis
            client = get_redis_connection('carts')
            # 保存用户购物车添加的商品id和对应数量count,如果redis购物车已添加该商品，数量需要进行累加
            client.hincrby('carts_%s' % user.id, sku_id, count)
            if selected:
                client.sadd('carts_selected_%s' % user.id, sku_id)
            return SuccessResponse(msg='success')
        elif type == "edit":#购物车记录更新
            count = int(get_parameter_dic(request)['count'])  # 购物车该商品的数量
            selected = int(get_parameter_dic(request)['selected'])  # 是否选中
            if selected not in [0, 1]:
                return ErrorResponse(msg="selected error")
            if sku_id is None or count is None:
                return ErrorResponse(msg='sku_id/count不能为空')
            if not isinstance(count,int):
                return ErrorResponse(msg='count类型错误')

            if int(count) > sku.stock:
                return ErrorResponse(msg='库存不足')
            # 登陆过对redis进行操作
            client = get_redis_connection('carts')
            client.hset('carts_%s' % user.id, sku_id, count)

            if selected:# 勾选：将sku_id加入的set中
                client.sadd('carts_selected_%s' % user.id, sku_id)
            else:# 不勾选：将sku_id从set中移除
                client.srem('carts_selected_%s' % user.id, sku_id)

            cart_sku = {
                'spu_id': sku.spu.id,
                'sku_id': sku.id,
                'name': sku.spu.name,
                'price': float2dot(sku.price),
                'count': count,
                'default_image': sku.spu.default_image,
                'amount': sku.price * count,
                'selected': str(selected)
            }
            return SuccessResponse(data=cart_sku,msg='success')

        elif type == "del":#购物车记录删除
            if sku_id is None:
                return ErrorResponse(msg='sku_id参数不能为空')
            client = get_redis_connection('carts')
            # (1)、删除商品和数量
            client.hdel('carts_%s' % user.id, sku_id)
            # (2)、删除选中状态
            client.srem('carts_selected_%s' % user.id, sku_id)
            return SuccessResponse(msg='success')

        else:
            return ErrorResponse(msg='type类型错误')

class CartsSelectAllView(APIView):
    """
    post：
    购物车记录全选和取消全选
    【参数】：selected：true、false选中/不选中购物车中的所有商品，（全选）
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def post(self, request):
        selected = int(get_parameter_dic(request)['selected'])
        if selected is None:
            return ErrorResponse(msg='selected参数不能为空')
        if selected not in [0,1]:
            return ErrorResponse(msg='selected类型错误')
        user = request.user
        client = get_redis_connection('carts')
        # 获取redis中用户所有商品
        sku_id_count = client.hgetall('carts_%s' % user.id)
        # 购物车中所有的商品的id值
        sku_ids = sku_id_count.keys()
        if selected:
            client.sadd('carts_selected_%s' % user.id, *sku_ids)
        else:
            client.srem('carts_selected_%s' % user.id, *sku_ids)

        return SuccessResponse(msg='success')

class MyCouponView(APIView):
    """
    get：
    我的优惠券列表
    【参数】：type ((0, '通用'),(1, '商城类'), (2, '服务类'), (10, '通用、商城'), (20, '通用、服务'))
    【参数】：status ((0, '未领取'),(1, '未使用'), (2, '已使用'), (3, '已过期'), (4, '已撤回'))
    post:
    立即领取优惠券
    【参数】：
    coupon_id 优惠券ID
    type:del删除、get领取
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self, request):
        user = request.user
        if user.identity != 1:
            return ErrorResponse(msg="用户类型错误")
        status = int(get_parameter_dic(request)['status'])
        if status not in [0, 1, 2, 3, 4, 10]:
            return ErrorResponse(msg="status error")
        type = get_parameter_dic(request).get('type')
        if type:
            type = int(type)
            if type not in [0, 1, 2, 10, 20]:
                return ErrorResponse(msg="type error")
        # 判断优惠券中是否有手动领取的劵，有的话则需要创建到用户优惠券表，并设置状态为未领取(手动领取的劵针对的是全部用户)
        coupon_res = GoodsCoupon.objects.filter(receive_type=1, is_delete=False, status=True).order_by(
            'create_datetime')
        if coupon_res:
            for c in coupon_res:
                obj, created = CouponRecord.objects.get_or_create(user=user, coupon=c)
        # 检查自己的未使用的优惠券是否过期
        queryset_isexpire = CouponRecord.objects.filter(user=user, status=1)
        nowtime = datetime.datetime.now()
        if queryset_isexpire:
            for e in queryset_isexpire:
                receive_time = e.receive_time
                expiretime = receive_time + datetime.timedelta(days=e.coupon.coupon_expiretime)  # 领取后的过期时间
                if expiretime < nowtime:
                    e.status = 3
                    e.save()

        if type:
            if type == 10:
                if status == 10:
                    queryset = CouponRecord.objects.filter(user=user, status__in=[0, 1], coupon__coupon_type__in=[0, 1],is_delete=False).order_by('-create_datetime')
                else:
                    queryset = CouponRecord.objects.filter(user=user, status=status, coupon__coupon_type__in=[0, 1],is_delete=False).order_by('-create_datetime')
            elif type == 20:
                if status == 10:
                    queryset = CouponRecord.objects.filter(user=user, status__in=[0, 1], coupon__coupon_type__in=[0, 2],is_delete=False).order_by('-create_datetime')
                else:
                    queryset = CouponRecord.objects.filter(user=user, status=status, coupon__coupon_type__in=[0, 2],is_delete=False).order_by('-create_datetime')
            else:
                if status == 10:
                    queryset = CouponRecord.objects.filter(user=user, status__in=[0, 1], coupon__coupon_type=type,is_delete=False).order_by('-create_datetime')
                else:
                    queryset = CouponRecord.objects.filter(user=user, status=status, coupon__coupon_type=type,is_delete=False).order_by('-create_datetime')
        else:
            if status == 10:
                queryset = CouponRecord.objects.filter(user=user, status__in=[0, 1], is_delete=False).order_by('-create_datetime')
            else:
                queryset = CouponRecord.objects.filter(user=user, status=status, is_delete=False).order_by('-create_datetime')
        data = []
        if queryset:
            for m in queryset:
                desc = '无门槛'
                if m.coupon.is_condition:  # 有门槛
                    desc = "满" + str(int(m.coupon.use_min_price)) + "减" + str(int(m.coupon.price))
                data.append({
                    'id': m.id,
                    'name': m.coupon.name,
                    'price': m.coupon.price,
                    'coupon_expiretime': m.coupon.coupon_expiretime,
                    'create_datetime': formatdatetime(m.create_datetime),
                    'receive_time': formatdatetime(m.receive_time),
                    'is_condition': m.coupon.is_condition,
                    'condition_price': m.coupon.use_min_price,
                    'condition': desc,
                    'coupon_type': m.coupon.get_coupon_type_display(),
                    'type': m.coupon.coupon_type,
                    'status': m.status,
                    'status_name': m.get_status_display()
                })
        return SuccessResponse(data=data, msg="success")

    def post(self, request):
        user = request.user
        if user.identity != 1:
            return ErrorResponse(msg="用户类型错误")
        coupon_id = get_parameter_dic(request)['coupon_id']
        type = get_parameter_dic(request)['type']
        if type not in ['del','get']:
            return ErrorResponse(msg='type error')
        if not coupon_id:
            return ErrorResponse(msg='coupon_id error')
        if type == 'get':
            res = CouponRecord.objects.filter(id=coupon_id, is_delete=False, user=user, status=0).first()
            if not res:
                return ErrorResponse(msg='无此优惠券')
            res.status = 1
            res.receive_time = datetime.datetime.now()
            res.save()
        else:
            res = CouponRecord.objects.filter(id=coupon_id, is_delete=False, user=user, status__in=[2,3]).first()
            if not res:
                return ErrorResponse(msg='无此优惠券或该状态不支持删除')
            res.is_delete = 1
            res.save()
        return SuccessResponse(msg='success')

class OrdersCommitView(APIView):
    """
    post:
    购物车订单提交
    【参数】：
    address_id用户的收货地址id
    remark:订单备注
    type：1 购物车订单提交  2 商品直接购买订单提交
    coupon_id:使用的优惠券id（非必须）
    count:购买数量（type=2时该参数为必须）
    sku_id:要购买的商品sku_id（type=2时该参数为必须）
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def post(self, request):
        address_id = get_parameter_dic(request)['address_id']
        remark = get_parameter_dic(request)['remark']
        type = int(get_parameter_dic(request)['type'])
        coupon_id = get_parameter_dic(request).get('coupon_id')
        addresses = Address.objects.filter(id=address_id,is_deleted=False).first()
        if not addresses:
            return ErrorResponse(msg='地址不存在')
        if not remark:
            remark = ""
        user = request.user
        # 生成订单编号
        order_id = getrandomodernum()
        #运费
        freight = Decimal(0)
        #优惠券判断
        coupon = ""
        if coupon_id:
            coupon = CouponRecord.objects.filter(id=coupon_id,status=1,coupon__coupon_type__in=[0,1],user=user,is_delete=False).first()
            if not coupon:
                return ErrorResponse("coupon_id error")
        if type == 1:#购物车订单提交
            # 开启事物
            with transaction.atomic():
                try:
                    # 设置保存点
                    save_point = transaction.savepoint()
                    # 生成订单的基本信息
                    order = OrderInfo.objects.create(
                        order_id=order_id,
                        user=user,
                        remark=remark,
                        address=addresses,
                        total_count=0,
                        total_amount=Decimal(0),
                        freight=Decimal(0),#运费
                        status=1,
                        pay_status=0,
                    )
                    # 从redis获取选中状态的商品
                    client = get_redis_connection('carts')
                    sku_id_count = client.hgetall('carts_%s' % user.id)
                    sku_count = {}
                    for sku_id, count in sku_id_count.items():
                        sku_count[sku_id] = int(count)
                    # 获取选中的sku_id
                    sku_ids = client.smembers('carts_selected_%s' % user.id)
                    if not sku_ids:
                        # 回滚到保存点
                        transaction.savepoint_rollback(save_point)
                        return ErrorResponse(msg="购物车没有选中的商品")
                    # 遍历商品订单商品表
                    for sku_id in sku_ids:
                        # 每遍历出一个sku_id，就需要往OrderGoods表中插入一条数据
                        for i in range(5):
                            #  (1)乐观锁step1：获取旧库存和销量
                            sku = SKU.objects.get(id=sku_id)
                            stock_old = sku.stock
                            # 选中数量
                            count = sku_count[sku.id]

                            sales_old = sku.sales
                            if count > stock_old:
                                # 回滚到保存点
                                transaction.savepoint_rollback(save_point)
                                return ErrorResponse(msg='库存不足')
                            # (2)、乐观锁step2：根据旧数据计算新库存和销量 —— 耗时操作
                            stock_new = sku.stock - count
                            sales_new = sku.sales + count
                            # 乐观锁step3: 基于旧库存和销量过滤查找模型类对象，然后更新
                            # 查询集批量修改函数update有整数返回值 —— 表示被修改了的对象有几个再次按照旧的库存获取商品,获取到更新,获取不到返回再次操作(乐观锁)
                            res = SKU.objects.filter(id=sku_id, stock=stock_old,sales=sales_old).update(stock=stock_new, sales=sales_new)
                            if res == 0:
                                # (3.2)、说明没有数据被成功修改，继而说明filter过滤出空查询集，进一步说明"根据旧库存找不到原有的sku，有别的事务介入"
                                continue
                            else:# (3.1)、res返回值不为0，说明，没有别的事务介入，成功修改了
                                break
                        if res ==0:#重试了6此结果都没有操作成功
                            # 回滚到保存点
                            transaction.savepoint_rollback(save_point)
                            return ErrorResponse(msg='服务器繁忙，请稍后再试')
                        # 修改spu表中的总销量
                        sku.spu.sales += count
                        sku.spu.save()

                        # 统计订单中的商品总数和订单总价格
                        order.total_count += count
                        order.total_amount += sku.price * count
                        # 新建订单商品数据，关联sku和订单
                        OrderGoods.objects.create(
                            order=order,
                            sku=sku,
                            count=count,
                            price=sku.price
                        )

                    #order.total_amount += order.freight
                    # 优惠券判断
                    if coupon:  # 如果用了优惠券
                        if couponisexpire(coupon):
                            # 回滚
                            transaction.savepoint_rollback(save_point)
                            return ErrorResponse(msg='优惠券已过期')
                        if coupon.coupon.is_condition:  # 有门槛
                            if float(sku.price) * count < float(coupon.coupon.use_min_price):
                                # 回滚
                                transaction.savepoint_rollback(save_point)
                                return ErrorResponse(msg='优惠券不符合使用规则')
                        coupon_price = coupon.coupon.price
                        order.total_amount_pay = order.total_amount
                        order.total_amount = order.total_amount - coupon_price
                        order.couponrecord_id = coupon_id
                        order.couponrecord_price = coupon_price

                        coupon.status = 2
                        coupon.used_time = datetime.datetime.now()
                        coupon.save()
                    else:
                        order.total_amount_pay = order.total_amount
                    order.save()
                except:
                    # 回滚到保存点
                    transaction.savepoint_rollback(save_point)
                    return ErrorResponse(msg='请稍后再试')
                else:
                    # 事物结束提交数据
                    transaction.savepoint_commit(save_point)
                    # 删除购物车选中状态的商品
                    client.hdel('carts_%s' % user.id, *sku_ids)
                    client.srem('carts_selected_%s' % user.id, *sku_ids)

                return SuccessResponse(data={'id': order.id,'order_id': order.order_id,'total_amount':order.total_amount},msg='success')
        else:#直接购买
            sku_id = get_parameter_dic(request)['sku_id']
            count = int(get_parameter_dic(request)['count'])
            if not sku_id:
                return ErrorResponse(msg='要购买的商品不能为空')
            if count <= 0:
                return ErrorResponse(msg='要购买商品数量错误')
            sku = SKU.objects.filter(id=sku_id, spu__is_launched=True).first()
            if not sku:
                return ErrorResponse(msg='不存在该商品，或该商品暂不支持购买')
            if sku.stock < count:
                return ErrorResponse(msg='该商品库存不足')
            # 开启事物
            with transaction.atomic():
                # 设置保存点
                save_point = transaction.savepoint()
                try:
                    # 生成订单的基本信息
                    order = OrderInfo.objects.create(
                        order_id=order_id,
                        user=user,
                        address=addresses,
                        total_count=0,
                        total_amount=Decimal(0),
                        freight=Decimal(0),  # 运费
                        remark=remark,
                        status=1,
                        pay_status=0,
                    )

                    #  获取当前商品的库存
                    stock_old = sku.stock
                    # 修改sku商品库存和销量
                    stock_new = sku.stock - count
                    sales_new = sku.sales + count
                    # 再次按照旧的库存获取商品,获取到更新,获取不到返回再次操作(乐观锁)
                    for i in range(3):
                        res = SKU.objects.filter(id=sku_id, stock=stock_old).update(stock=stock_new, sales=sales_new)
                        if res == 0:
                            if i == 2:  # 如果连续3次都是更新失败，则回滚
                                # 回滚
                                transaction.savepoint_rollback(save_point)
                                return ErrorResponse(msg='请稍后再试')
                            continue
                        else:
                            break
                    # 修改spu表中的总销量
                    sku.spu.sales += count
                    sku.spu.save()

                    # 优惠券判断
                    if coupon:  # 如果用了优惠券
                        if couponisexpire(coupon):
                            # 回滚
                            transaction.savepoint_rollback(save_point)
                            return ErrorResponse(msg='优惠券已过期')
                        if coupon.coupon.is_condition:  # 有门槛
                            if float(sku.price) * count < float(coupon.coupon.use_min_price):
                                # 回滚
                                transaction.savepoint_rollback(save_point)
                                return ErrorResponse(msg='优惠券不符合使用规则')
                        coupon_price = coupon.coupon.price
                        order.total_count = count
                        order.total_amount_pay = sku.price * count
                        order.total_amount = sku.price * count - coupon_price
                        order.couponrecord_id = coupon_id
                        order.couponrecord_price = coupon_price

                        coupon.status = 2
                        coupon.used_time = datetime.datetime.now()
                        coupon.save()
                    else:#没有优惠券
                        order.total_count = count
                        order.total_amount = sku.price * count
                        order.total_amount_pay = sku.price * count
                    # 保存订单商品数据
                    OrderGoods.objects.create(
                        order=order,
                        sku=sku,
                        count=count,
                        price=sku.price
                    )

                    order.save()
                except:
                    # 回滚到保存点
                    transaction.savepoint_rollback(save_point)
                    return ErrorResponse(msg='请稍后再试')
                else:
                    # 事物结束提交数据
                    transaction.savepoint_commit(save_point)

                return SuccessResponse(data={'id':order.id,'order_id':order.order_id,'total_amount':order.total_amount}, msg='success')

def couponisexpire(coupon):
    """
    coupon:CouponRecord的实例
    return:True 过期，False未过期
    """
    receive_time = coupon.receive_time
    expire_days = coupon.coupon.coupon_expiretime
    expire_time = receive_time + datetime.timedelta(days=expire_days)
    now = datetime.datetime.now()
    if now > expire_time:
        return True

    return False


class GoodsOrderCancleView(APIView):
    """
    get:
    商城订单取消
    【参数】id，订单的id
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self,request):
        user = request.user
        id = get_parameter_dic(request)['id']
        if not id:
            return ErrorResponse(msg='id参数错误')
        order = OrderInfo.objects.filter(id=id,user=user,status__in=[1,2]).first()
        if not order:
            return ErrorResponse(msg='该订单不存在,或该状态不支持取消')
        with transaction.atomic():
            savepoint = transaction.savepoint()
            #把取消的库存增加回去
            skus = order.ordergoodsskus.all()
            for s in skus:
                # 每遍历出一个sku_id，就还原一次库存和销量
                for i in range(5):
                    #  (1)乐观锁step1：获取旧库存和销量
                    sku = SKU.objects.get(id=s.sku.id)
                    stock_old = sku.stock

                    count = s.count # 购买数量
                    sales_old = sku.sales # sku原销量
                    sales_spu_old = sku.spu.sales # spu原销量
                    # (2)、乐观锁step2：根据旧数据计算新库存和销量 —— 耗时操作
                    stock_new = stock_old + count
                    sales_new = sales_old - count
                    sales_spu_new = sales_spu_old - count
                    # 乐观锁step3: 基于旧库存和销量过滤查找模型类对象，然后更新
                    # 查询集批量修改函数update有整数返回值 —— 表示被修改了的对象有几个再次按照旧的库存获取商品,获取到更新,获取不到返回再次操作(乐观锁)
                    res = SKU.objects.filter(id=s.sku.id, stock=stock_old, sales=sales_old).update(stock=stock_new,sales=sales_new)
                    if res == 0:
                        # (3.2)、说明没有数据被成功修改，继而说明filter过滤出空查询集，进一步说明"根据旧库存找不到原有的sku，有别的事务介入"
                        continue
                    else:  # (3.1)、res返回值不为0，说明，没有别的事务介入，成功修改了
                        for n in range(5):
                            res2 = SPU.objects.filter(id=s.sku.spu.id,sales=sales_spu_old).update(sales=sales_spu_old)
                            if res2 ==0:
                                continue
                            else:
                                break
                        break
                if res == 0 or res2==0:  # 重试了6此结果都没有操作成功
                    # 回滚到保存点
                    transaction.savepoint_rollback(savepoint)
                    return ErrorResponse(msg='服务器繁忙，请稍后再试')
            # 退款逻辑
            if order.status == 2:
                orderrefund(order.id)
            order.status = 6
            order.save()
            # 清除保存点
            transaction.savepoint_commit(savepoint)
            return SuccessResponse(msg="订单取消成功")

class GoodsOrderConfirmReceiveView(APIView):
    """
    get:
    商城订单确认收货
    【参数】id，订单的id
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    #@method_decorator(ly_api_security)
    def get(self,request):
        user=request.user
        id = get_parameter_dic(request)['id']
        if not id:
            return ErrorResponse(msg='id参数错误')
        order = OrderInfo.objects.filter(id=id,status=3,user=user).first()
        if not order:
            return ErrorResponse(msg='该订单不存在,或该状态不支持确认收货操作')
        order.status = 5
        order.save()
        return SuccessResponse(msg="订单已完成")

class GoodsOrdersListView(APIView):
    """
    get:
    前端用户获取商品订单列表
    【参数】
    status:获取订单的过滤状态 为空则默认返回全部、ORDER_STATUS_CHOICES = (
        (1, "待支付"),
        (2, "待发货"),
        (3, "待收货"),
        (4, "待评价"),
        (5, "已完成"),
        (6, "已取消"),
    )
    search:搜索订单号（非必须）
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self,request):
        user = request.user
        status = get_parameter_dic(request).get('status')
        search = get_parameter_dic(request).get('search')
        if search:
            if status:
                status = int(status)
                queryset = OrderInfo.objects.filter(order_id__contains=search,user=user,is_delete=False,status=status).order_by('-create_datetime')
            else:
                queryset = OrderInfo.objects.filter(order_id__contains=search,user=user, is_delete=False).order_by('-create_datetime')
        else:
            if status:
                status = int(status)
                queryset = OrderInfo.objects.filter(user=user,is_delete=False,status=status).order_by('-create_datetime')
            else:
                queryset = OrderInfo.objects.filter(user=user, is_delete=False).order_by('-create_datetime')
        # # 1. 实例化分页器对象
        page_obj = CustomPagination()
        # # 2. 使用自己配置的分页器调用分页方法进行分页
        page_data = page_obj.paginate_queryset(queryset, request)
        data = []
        if queryset:
            for m in page_data:
                goods_list = []
                querysets = m.ordergoodsskus.all()
                if querysets:
                    for g in querysets:
                        spec_name = ""
                        if g.sku.spu.spec_type == 1:  # 多规格
                            spec_names = g.sku.specs.all()
                            for temp_spec_name in spec_names:
                                if len(spec_names) > 1:
                                    spec_name = spec_name + temp_spec_name.option.value + ';'
                                else:
                                    spec_name = temp_spec_name.option.value
                        goods_list.append({
                            'id': g.sku_id,
                            'price': g.price,
                            'name': g.sku.spu.name,
                            'count': g.count,
                            'spec_name':spec_name,
                            'default_image': g.sku.spu.default_image
                        })

                data.append({
                    'id': m.id,
                    'order_id': m.order_id,
                    'total_count':m.total_count,
                    'total_amount': m.total_amount,
                    'status': m.status,
                    'status_name':m.get_status_display(),
                    'couponrecord_price':m.couponrecord_price,
                    'create_datetime':formatdatetime(m.create_datetime),
                    'goods_list':goods_list,
                })

        return page_obj.get_paginated_response(data=data)

class UserAddressSerializer(serializers.ModelSerializer):
    """
    用户收货地址序列化
    """
    class Meta:
        model = Address
        read_only_fields = ["id"]
        # fields = '__all__'
        exclude = ['is_deleted','user']

class GoodsOrdersDetailView(APIView):
    """
    get:
    前端用户获取商品订单详情
    【参数】
    id:订单id
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self,request):
        user = request.user
        id = get_parameter_dic(request)['id']
        if not id:
            return ErrorResponse(msg='id参数错误')

        m = OrderInfo.objects.filter(id=id,user=user, is_delete=False).first()
        data = {}
        if m:
            addresses = Address.objects.filter(id=m.address_id).first()
            address = UserAddressSerializer(addresses)
            goods_list = []
            querysets = m.ordergoodsskus.all()
            if querysets:
                for g in querysets:
                    spec_name = ""
                    if g.sku.spu.spec_type == 1:  # 多规格
                        spec_names = g.sku.specs.all()
                        for temp_spec_name in spec_names:
                            if len(spec_names) > 1:
                                spec_name = spec_name + temp_spec_name.option.value + ';'
                            else:
                                spec_name = temp_spec_name.option.value
                    goods_list.append({
                        'id': g.sku_id,
                        'price': g.price,
                        'name': g.sku.spu.name,
                        'count': g.count,
                        'spec_name':spec_name,
                        'default_image': g.sku.spu.default_image
                    })

            data={
                'id': m.id,
                'order_id': m.order_id,
                'addresses': address.data,
                'total_count':m.total_count,
                'total_amount': m.total_amount,
                'total_amount_pay':m.total_amount_pay,
                'status': m.status,
                'status_name':m.get_status_display(),
                'couponrecord_price':m.couponrecord_price,
                'create_datetime':formatdatetime(m.create_datetime),
                'pay_method':m.get_pay_method_display(),
                'pay_status':m.get_pay_status_display(),
                'pay_time':m.pay_time,
                'goods_list':goods_list,
                'logistics_id': m.logistics_id,  # 物流单号
                'remark': m.remark,
            }

        return SuccessResponse(data=data, msg='success')

class PaymentView(APIView):
    """
    平台支付接口
    post:
    平台支付接口
    【参数】
    paymethod: 2 微信支付  3 支付宝支付
    platform:支付者平台： app 、xcx
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def post(self, request):
        user = request.user
        if user.identity !=1:
            return ErrorResponse(msg="用户类型错误")
        paymethod = int(get_parameter_dic(request)['pay_method'])
        platform = get_parameter_dic(request).get('platform')
        paytype = get_parameter_dic(request)['pay_type']
        if platform and platform not in ['app','xcx']:
            return ErrorResponse(msg="platform类型错误")
        if not platform:
            platform = 'app'
        if paymethod not in [2,3]:
            return ErrorResponse(msg="paymethod类型错误")

        money = 0
        #业务逻辑
        with transaction.atomic():
            # 设置保存点
            save_point = transaction.savepoint()
            try:
                orderno = getminrandomodernum()
                #其他业务逻辑
                id = get_parameter_dic(request)['id']
                if not id:
                    return ErrorResponse(msg='id error1')
                order = OrderInfo.objects.filter(id=id,user=user,pay_status=0).first()
                if not order:
                    return ErrorResponse(msg='id error2')
                money = order.total_amount
                orderno = order.order_id
                order.pay_method = paymethod
                order.save()

                #支付类型判断
                if paymethod == 2:
                    wxapppay = WxAppPay()
                    if platform == 'app':#app支付
                        data = wxapppay.payorder(orderno, money * 100, orderno,paytype,notify_url="%s/api/app/wechatpay_notify/" % DOMAIN_HOST)  # 要填写回调地址
                    else:
                        openid = OAuthWXUser.objects.filter(user=user).values_list('xcx_openid', flat=True).first()
                        if not openid:
                            # 回滚到保存点
                            transaction.savepoint_rollback(save_point)
                        data = wxapppay.payorder_jsapi(orderno, money * 100, orderno,paytype,openid,notify_url="%s/api/app/wechatpay_notify/" % DOMAIN_HOST)  # 要填写回调地址
                    # 事物结束提交数据
                    transaction.savepoint_commit(save_point)
                    return SuccessResponse(data={'id': order.id, 'order_no': order.order_id, 'paymethod': 2, 'paystatus': order.pay_status,'wechataydata': data}, msg="success")
                elif paymethod == 3:
                    data = alipay_trade_app(orderno, float(money),notify_url="%s/api/app/alipay_notify/" % DOMAIN_HOST)
                    # 事物结束提交数据
                    transaction.savepoint_commit(save_point)
                    return SuccessResponse(data={'order_no':order.order_id,'alipaydata':data}, msg="success")
                return ErrorResponse(msg="paytype类型错误")
            except Exception as e:
                transaction.savepoint_rollback(save_point)
                return ErrorResponse(msg=str(e))

class wechatpay_notify(APIView):
    """
    支付成功后，微信服务器异步通知回调（用于修改订单状态）
    """
    def post(self,request):
        wxpay = WxAppPay()
        result = wxpay.decrypt_callback(request)
        logger.info("收到微信支付回调通知:%s" % (result))
        if result:
            """
            {"mchid":"1617830805","appid":"wx023a7d62457e3803","out_trade_no":"20220112163528260904706","transaction_id":"4200001335202201122963662545","trade_type":"JSAPI","trade_state":"SUCCESS","trade_state_desc":"支付成功","bank_type":"CMBC_DEBIT","attach":"","success_time":"2022-01-12T16:35:42+08:00","payer":{"openid":"ocBnz4pg2G05LaUFpNE9bxR2B88w"},"amount":{"total":1,"payer_total":1,"currency":"CNY","payer_currency":"CNY"}}
            """
            resp = json.loads(result)
            appid = resp.get('appid')
            mchid = resp.get('mchid')
            out_trade_no = resp.get('out_trade_no')
            transaction_id = resp.get('transaction_id')
            trade_type = resp.get('trade_type')
            trade_state = resp.get('trade_state')
            trade_state_desc = resp.get('trade_state_desc')
            bank_type = resp.get('bank_type')
            attach = resp.get('attach')#自定义数据
            success_time = format_wechat_gmt_8_to_normal(resp.get('success_time'))
            payer = resp.get('payer')
            amount = (resp.get('amount').get('total'))/100
            # TODO: 根据返回参数进行必要的业务处理，处理完后返回200或204
            if trade_state == "SUCCESS":  # 支付成功
                # 查询数据库中存在的订单
                order = OrderInfo.objects.filter(order_id=out_trade_no, pay_status=0, pay_method=2).first()
                if not order:
                    logger.info("处理收到微信支付回调通知:%s，没有找到该订单" % (result))
                    return HttpResponse('fail')
                order.trade_id = transaction_id
                order.pay_status = 1
                order.pay_time = success_time
                order.save()
                # 其他逻辑处理
                orderpaysuccess(order.id)
                return HttpResponse('success')
            else:
                return HttpResponse('fail')
        else:
            return HttpResponse('fail')

class alipay_notify(APIView):
    """
    支付成功后，支付宝服务器异步通知回调（用于修改订单状态）
    返回fail之后，支付宝会再回调一次，也就是失败的回调一共回调2次
    """
    def post(self,request):
        # 1. 先将sign剔除掉
        processed_dict = {}
        for key, value in request.POST.items():
            processed_dict[key] = value
        # 异步通知data参数转换字典后示例如下：
        """
        {'gmt_create': '2021-11-22 08:53:05', 'charset': 'utf-8', 'seller_email': 'taijizhilu@126.com', 'subject': '20211122085257269506402001', 'sign': 'dAUOnG1u8/Fap+aDCSa+P2AXFv4vqr3BK4vKTxevai4F3sdN4X6an8GulmKjk3cx1Z9OMp05JAcBCPi+1CXJoy6opybYqr+M/uDUiAYH+MA4ilazSskS/WC22iZhS4oAVjwouGp+Wbu6pmNMM/gFNCxnlf3K+bCa/gzDDPTCTEoZT3IoeQdZ4ERmuNi7WdCCIm8jNaS8nRXS8bEkk7r7PvYs1kO3H9uZhViSKmlx+Qfklm+mRa1xheNd2UJ1pYcVGK4snlUJL4tKO/VEzPb2trFxYfI3y4q2EPBPCHcI24L1IZeZXrugx6mFJm02SntCrTA+/ysb7e59zoNrBmu+gQ==', 'buyer_id': '2088312606228550', 'invoice_amount': '0.01', 'notify_id': '2021112200222085305028551438751992', 'fund_bill_list': '[{"amount":"0.01","fundChannel":"PCREDIT"}]', 'notify_type': 'trade_status_sync', 'trade_status': 'TRADE_SUCCESS', 'receipt_amount': '0.01', 'app_id': '2021002194665673', 'buyer_pay_amount': '0.01', 'sign_type': 'RSA2', 'seller_id': '2088341077382474', 'gmt_payment': '2021-11-22 08:53:05', 'notify_time': '2021-11-22 08:56:13', 'version': '1.0', 'out_trade_no': '20211122085257269506402001', 'total_amount': '0.01', 'trade_no': '2021112222001428551424684280', 'auth_app_id': '2021002194665673', 'buyer_logon_id': '159****7057', 'point_amount': '0.00'}
        """
        logger.error("收到支付宝回调通知:%s" % (processed_dict))
        sign = processed_dict.pop("sign", None)
        # 2. 生成一个Alipay对象
        alipay = initalipay()
        # 3. 进行验签，确保这是支付宝给我们的
        verify_re = alipay.verify(processed_dict, sign)
        # 如果验签成功
        if verify_re is True:
            order_sn = processed_dict.get('out_trade_no', None)#自己平台的订单号
            trade_no = processed_dict.get('trade_no', None)#支付宝的订单号
            trade_status = processed_dict.get('trade_status', None)
            pay_time =  processed_dict.get('gmt_payment', None)#用户支付时间
            if trade_status == "TRADE_SUCCESS":#支付成功
                # 查询数据库中存在的订单
                order = OrderInfo.objects.filter(order_id=order_sn, pay_status=0, pay_method=3).first()
                if not order:
                    logger.info("处理收到支付宝支付回调通知:%s，没有找到该订单" % (processed_dict))
                    return HttpResponse('fail')
                order.trade_id = trade_no
                order.pay_status = 1
                order.pay_time = pay_time
                order.save()
                #其他逻辑处理
                orderpaysuccess(order.id)
                return HttpResponse('success')
            else:
                return HttpResponse('fail')
        else:
            return HttpResponse('fail')

#用户支付成功处理对应逻辑
def orderpaysuccess(order_id):
    """
    order：订单order的id(内部订单编号)
    """
    order = OrderInfo.objects.get(id=order_id)
    order.status = 2
    order.save()
    #支付成功其他业务处理
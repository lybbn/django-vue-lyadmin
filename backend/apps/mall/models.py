from django.db import models
from utils.modles import CoreModel,BaseModel
from apps.address.models import Address
from mysystem.models import Users
# Create your models here.


# ================================================= #
# ************** 商品分类 model  ************** #
# ================================================= #

class GoodsCategory(CoreModel):
    """商品类别"""
    name = models.CharField(max_length=20, verbose_name='名称')
    desc = models.CharField(max_length=255, null=True, blank=True,verbose_name='描述')
    # level = models.SmallIntegerField(default=1, verbose_name="分类层级(1：一级 2：二级)", help_text="分类层级(1：一级 2：二级)")
    default_image = models.CharField(max_length=255, null=True, blank=True, verbose_name='默认图片')  # 类别图片（单个图片）
    sort = models.PositiveSmallIntegerField(default=0, verbose_name="排序", help_text="显示顺序")
    status = models.BooleanField(default=True, verbose_name="商品类别状态", help_text="商品类别状态")
    is_delete = models.BooleanField(default=False, verbose_name="是否逻辑删除", help_text="是否逻辑删除")
    parent = models.ForeignKey('self', related_name='goodscategorysubs', null=True, blank=True, on_delete=models.CASCADE, verbose_name='父类别')

    class Meta:
        db_table = 'tb_goods_category'
        verbose_name = '商品类别'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name

# ================================================= #
# ************** 优惠券 model  ************** #
# ================================================= #
GOODSCOUPON_RECEIVE_TYPE = (
        (0, ""),
        (1, "手动领取"),
        (2, "新人劵"),
        (3, "后台发放"),
        (4, "邀请劵"),
    )
GOODSCOUPON_COUPONTYPE = (
        (0, "通用券"),
        (1, "商城类通用券"),
        (2, "服务类通用券"),
    )
# 通用：服务类商品+商城类商品
# 服务：仅能用于服务类商品
# 商城：仅能用于商城内商品
class GoodsCoupon(CoreModel):
    """商品优惠券(管理员创建)"""
    name = models.CharField(max_length=50, verbose_name='优惠券名称')
    caption = models.CharField(max_length=256, verbose_name='优惠券副标题', null=True, blank=True)  # 副标题
    desc = models.CharField(max_length=150, null=True, blank=True, verbose_name='描述')
    sort = models.IntegerField(default=0, verbose_name="排序", help_text="显示顺序")
    total_num = models.IntegerField(default=0, verbose_name="优惠券总数量", help_text="优惠券总数量")
    received_num = models.IntegerField(default=0, verbose_name="优惠券已领取数量", help_text="优惠券已领取数量")
    used_num = models.IntegerField(default=0, verbose_name="已被使用的数量", help_text="已被使用的数量")
    is_permanent = models.BooleanField(default=True, verbose_name="是否无限张数", help_text="是否无限张数")
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='优惠券面值',default=0)
    is_condition = models.BooleanField(default=False, verbose_name="有无门槛", help_text="有无门槛")#0无门槛 1有门槛
    use_min_price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='最低消费多少金额可用优惠券',default=0)#有无门槛,0表示无门槛
    start_time = models.DateField(null=True, blank=True, help_text="优惠券领取开启时间", verbose_name="优惠券领取开启时间")
    end_time = models.DateField(null=True, blank=True, help_text="优惠券领取结束时间",verbose_name="优惠券领取结束时间")
    valid_begin_date = models.DateField(verbose_name="有效期开始时间", blank=True, null=True)
    valid_end_date = models.DateField(verbose_name="有效结束时间", blank=True, null=True)
    coupon_expiretime = models.IntegerField(default=0, verbose_name="优惠券有效期限（单位：天）", help_text="优惠券有效期限（单位：天）")#领取后几天有效，自券被领时开始算起
    receive_type = models.SmallIntegerField(choices=GOODSCOUPON_RECEIVE_TYPE, default=0, verbose_name="优惠券发送方式",help_text="优惠券发送方式")
    coupon_type = models.SmallIntegerField(choices=GOODSCOUPON_COUPONTYPE,default=0, verbose_name="优惠券类型（2）", help_text="优惠券类型（2）")
    is_delete = models.BooleanField(default=False, verbose_name="是否逻辑删除", help_text="是否逻辑删除")
    status = models.BooleanField(default=True, verbose_name="状态", help_text="状态")#0关闭 1正常

    class Meta:
        db_table = 'tb_goods_coupon'
        verbose_name = '商品优惠券'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name

class CouponRecord(CoreModel):
    """优惠券发放、消费纪录 - 面向用户（用户领取卷）"""
    # 跟优惠券生成规则是一对多的关系 - 一种优惠券有30张，则发放记录就有30条
    coupon = models.ForeignKey("GoodsCoupon", on_delete=models.CASCADE,verbose_name="关联优惠券")
    number = models.CharField(max_length=64,verbose_name="用来计数",null=True,blank=True)
    # 一对多,一个用户有多张优惠券,一张优惠券只能给一个用户
    user = models.ForeignKey(Users,verbose_name="拥有者", on_delete=models.CASCADE,related_name='couponuser1')
    status_choices = ((0, '未领取'),(1, '未使用'), (2, '已使用'), (3, '已过期'), (4, '已撤回'))
    status = models.SmallIntegerField(choices=status_choices, default=0)
    used_time = models.DateTimeField(blank=True, null=True, verbose_name="使用时间")
    receive_time = models.DateTimeField(blank=True, null=True, verbose_name="领取时间")
    is_delete = models.BooleanField(default=False, verbose_name="是否逻辑删除", help_text="是否逻辑删除")

    class Meta:
        db_table = 'tb_goods_coupon_record'
        verbose_name = '用户持券表'
        verbose_name_plural = verbose_name

    def __str__(self):
        return '%s-%s-%s'%(self.user,self.coupon,self.get_status_display())

# ================================================= #
# ************** 商品品牌 model  ************** #
# ================================================= #
class GoodsBrand(CoreModel):
    """ 商品所属品牌 """
    category = models.ForeignKey(GoodsCategory, on_delete=models.CASCADE,related_name="brands", verbose_name="所属分类", help_text="所属分类")
    name = models.CharField(max_length=30, verbose_name="品牌名", help_text="品牌名")
    desc = models.TextField(blank=True, max_length=200,default="",  verbose_name="品牌描述", help_text="品牌描述")
    default_image = models.CharField(max_length=255, null=True, blank=True, verbose_name='品牌logo')  #（单个图片）
    sort = models.PositiveSmallIntegerField(default=0, verbose_name="排序")

    class Meta:
        db_table = "tb_goods_brand"
        ordering = ["-sort"]
        verbose_name = "商品品牌"
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name
# ================================================= #
# ************** 商品 model  ************** #
# ================================================= #
class SPU(CoreModel):
    """商品SPU"""
    SPU_SPEC_TYPE = (
        (0, "单规格"),
        (1, "多规格")
    )
    name = models.CharField(max_length=60, verbose_name='标题')
    sub_name = models.CharField(max_length=60, blank=True,null=True, default="", verbose_name="副标题")#副标题
    category1 = models.ForeignKey(GoodsCategory, on_delete=models.PROTECT, related_name='cat1_spu', verbose_name='一级类别')
    # category2 = models.ForeignKey(GoodsCategory, on_delete=models.PROTECT, related_name='cat2_spu',null=True, blank=True, verbose_name='二级类别')
    # category3 = models.ForeignKey(GoodsCategory, on_delete=models.PROTECT, related_name='cat3_spu', null=True, blank=True, verbose_name='三级类别')
    brand = models.ForeignKey(GoodsBrand, on_delete=models.PROTECT, related_name="brands", blank=True, null=True,verbose_name="品牌")
    spec_type = models.PositiveIntegerField(choices=SPU_SPEC_TYPE, default=0, verbose_name="规格类型")#默认单规格
    default_image = models.CharField(max_length=255, null=True, blank=True, verbose_name='商品主图')  #（单个图片）
    price = models.DecimalField(max_digits=10, decimal_places=2,default=0, verbose_name="售价")#sku中选择一个最低的售价写入
    # market_price = models.DecimalField(max_digits=10, decimal_places=2,default=0, verbose_name="市场价")
    # cost_price = models.DecimalField(max_digits=10, decimal_places=2,default=0, verbose_name="成本价")
    sales = models.IntegerField(default=0, verbose_name='销量')
    # stock = models.IntegerField(default=0, verbose_name="库存")
    # unit = models.CharField(max_length=30, default="", blank=True,null=True,verbose_name="商品单位")
    comments = models.IntegerField(default=0, verbose_name='评论量',null=True, blank=True)
    desc_detail = models.TextField(default='', verbose_name='详细介绍',null=True, blank=True)#商品详情
    desc_pack = models.TextField(default='', verbose_name='包装信息',null=True, blank=True)
    desc_service = models.TextField(default='', verbose_name='售后服务',null=True, blank=True)
    is_launched = models.BooleanField(default=True, verbose_name='是否上架销售')
    is_tuijian = models.BooleanField(default=False, verbose_name='是否推荐')#自定义字段，可删掉
    sort = models.PositiveSmallIntegerField(default=0, verbose_name="排序")
    is_delete = models.BooleanField(default=False, verbose_name="是否逻辑删除", help_text="是否逻辑删除")

    class Meta:
        db_table = 'tb_goods_spu'
        verbose_name = '商品SPU'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name

class SKU(CoreModel):
    """商品SKU"""
    name = models.CharField(max_length=60, verbose_name='标题',null=True, blank=True)
    spu = models.ForeignKey(SPU, on_delete=models.CASCADE, verbose_name='商品SPU',related_name='skus')
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='商品单价')
    shop_price = models.DecimalField(max_digits=10, decimal_places=2, default=0,null=True, blank=True, verbose_name="售价")
    market_price = models.DecimalField(max_digits=10, decimal_places=2, default=0,null=True, blank=True, verbose_name="市场价")
    cost_price = models.DecimalField(max_digits=10, decimal_places=2, default=0,null=True, blank=True, verbose_name="成本价")
    stock = models.IntegerField(default=0, verbose_name='商品库存')
    unite = models.CharField(max_length=20, verbose_name='商品单位',null=True, blank=True)
    sales = models.IntegerField(default=0, verbose_name='商品销量',null=True, blank=True)
    default_image = models.CharField(max_length=255, null=True, blank=True, verbose_name='默认图片')#商品主图(单张)
    is_delete = models.BooleanField(default=False, verbose_name="是否逻辑删除", help_text="是否逻辑删除")

    class Meta:
        db_table = 'tb_goods_sku'
        verbose_name = '商品SKU'
        verbose_name_plural = verbose_name

    def __str__(self):
        return f'{self.spu.name}的SKU'


class SPUImage(CoreModel):
    """SPU图片"""
    spu = models.ForeignKey(SPU, on_delete=models.CASCADE, verbose_name='商品sku',related_name='goods_imagelist')
    image = models.CharField(max_length=255,verbose_name='图片')
    sort = models.PositiveSmallIntegerField(default=0, verbose_name="排序")

    class Meta:
        ordering=  ["sort"]
        db_table = 'tb_goods_spu_image'
        verbose_name = 'SPU图片'
        verbose_name_plural = verbose_name

    def __str__(self):
        return f'{self.spu.title} {self.id}'

class SPUSpecification(CoreModel):
    """商品SPU规格名"""
    spu = models.ForeignKey(SPU, on_delete=models.CASCADE, related_name='spu_specs', verbose_name='商品SPU')
    name = models.CharField(max_length=20, verbose_name='规格名称')

    class Meta:
        db_table = 'tb_goods_spu_specification'
        verbose_name = '商品SPU规格'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name

class SPUSpecificationOption(CoreModel):
    """商品SPU规格选项值"""
    spec = models.ForeignKey(SPUSpecification, related_name='options', on_delete=models.CASCADE, verbose_name='规格')
    value = models.CharField(max_length=20, verbose_name='选项值')

    class Meta:
        db_table = 'tb_goods_spu_specification_option'
        verbose_name = '规格选项'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.value

class SKUSpecification(CoreModel):
    """SKU具体规格"""
    sku = models.ForeignKey(SKU, related_name='specs', on_delete=models.CASCADE, verbose_name='sku')
    spec = models.ForeignKey(SPUSpecification, on_delete=models.CASCADE, verbose_name='规格名称')
    option = models.ForeignKey(SPUSpecificationOption, on_delete=models.CASCADE, verbose_name='规格值')

    class Meta:
        db_table = 'tb_goods_sku_specification'
        verbose_name = 'SKU规格'
        verbose_name_plural = verbose_name

    def __str__(self):
        return '%s: %s - %s' % (self.sku, self.spec.name, self.option.value)

class GoodsSpecTemplate(CoreModel):
    """商品规格模板(供添加商品时选择使用)"""
    spec = models.CharField(max_length=100,  verbose_name='规格名称')
    option = models.CharField(max_length=255, verbose_name='规格值')

    class Meta:
        db_table = 'tb_goods_spec_template'
        verbose_name = '商品规格模板'
        verbose_name_plural = verbose_name

# ================================================= #
# ************** 商品订单model  ************** #
# ================================================= #
class OrderInfo(CoreModel):
    """订单信息"""
    PAY_METHOD_CHOICES = (
        (0, ""),
        (1, "货到付款"),
        (2, "微信"),
        (3, "支付宝"),

    )
    ORDER_STATUS_CHOICES = (
        (1, "待支付"),
        (2, "待发货"),
        (3, "待收货"),
        (4, "待评价"),
        (5, "已完成"),
        (6, "已取消"),
    )
    ORDER_PAY_STATUS_CHOICES = (
        (0, "待支付"),
        (1, "已支付"),
        (2, "退款中"),
        (3, "退款失败"),
        (4, "已退款"),
    )
    order_id = models.CharField(max_length=64, verbose_name="订单号",unique=True)#内部
    trade_id = models.CharField(max_length=100, unique=True, null=True, blank=True, verbose_name="支付编号")#外部
    user = models.ForeignKey(Users, on_delete=models.PROTECT,related_name='createorderuser1' ,verbose_name="下单用户")
    address = models.ForeignKey(Address, on_delete=models.PROTECT, verbose_name="收货地址")
    couponrecord_id = models.CharField(max_length=60, unique=True, null=True, blank=True, verbose_name="用户优惠券id")
    couponrecord_price = models.DecimalField(max_digits=10, decimal_places=2, default=0,null=True, blank=True, verbose_name="优惠券面值")
    total_count = models.IntegerField(default=1, verbose_name="商品总数")
    total_amount = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="实付商品总金额",default=0)
    total_amount_pay = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="订单总金额",default=0)
    freight = models.DecimalField(max_digits=10, decimal_places=2,null=True, blank=True,verbose_name="运费",default=0)
    logistics_id = models.CharField(max_length=100, verbose_name="物流单号",null=True, blank=True)#该商城项目特有，其他项目可去掉
    send_time = models.DateTimeField(null=True, blank=True, help_text="发货时间", verbose_name="发货时间")#该商城项目特有，其他项目可去掉
    logistics_company = models.CharField(max_length=90, verbose_name="物流公司", null=True, blank=True)#该商城项目特有，其他项目可去掉
    pay_method = models.SmallIntegerField(choices=PAY_METHOD_CHOICES, default=0, verbose_name="支付方式")
    pay_time = models.CharField(max_length=64,null=True, blank=True, verbose_name="支付时间", help_text="支付时间")
    remark = models.CharField(max_length=100, verbose_name="订单备注",null=True,blank=True)
    cancel_reason = models.CharField(max_length=100, verbose_name="订单取消原因", null=True, blank=True)
    status = models.SmallIntegerField(choices=ORDER_STATUS_CHOICES, default=1, verbose_name="订单状态")
    pay_status = models.SmallIntegerField(choices=ORDER_PAY_STATUS_CHOICES, default=0, verbose_name="支付状态")
    is_delete = models.BooleanField(default=False, verbose_name="是否逻辑删除", help_text="是否逻辑删除")

    class Meta:
        db_table = "tb_mall_order_info"
        verbose_name = '订单基本信息'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.order_id

class OrderGoods(CoreModel):
    """订单商品"""
    SCORE_CHOICES = (
        (0, '0分'),
        (1, '20分'),
        (2, '40分'),
        (3, '60分'),
        (4, '80分'),
        (5, '100分'),
    )
    order = models.ForeignKey(OrderInfo, related_name='ordergoodsskus', on_delete=models.CASCADE, verbose_name="订单")
    spu = models.ForeignKey(SPU, on_delete=models.PROTECT,blank=True, null=True, verbose_name="订单商品")
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT,blank=True, null=True, verbose_name="订单规格")
    count = models.IntegerField(default=1, verbose_name="数量")
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="sku单价")
    comment = models.TextField(verbose_name="评价信息",null=True,blank=True)
    score = models.SmallIntegerField(choices=SCORE_CHOICES, default=5, verbose_name='满意度评分')
    is_anonymous = models.BooleanField(default=False, verbose_name='是否匿名评价')
    is_commented = models.BooleanField(default=False, verbose_name='是否评价了')

    class Meta:
        db_table = "tb_mall_order_goods"
        verbose_name = '订单商品'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.spu.name


class OrderRefunds(CoreModel):
    """订单退款"""
    ORDER_STATUS_CHOICES = (
        (0, "待支付"),
        (1, "已支付"),
        (2, "退款中"),
        (3, "退款失败"),
        (4, "已退款"),
    )
    order_no= models.CharField(max_length=64, verbose_name="订单号", unique=True)  # 内部
    order = models.ForeignKey(OrderInfo, related_name='orderrefunds', on_delete=models.CASCADE, verbose_name="要退款的订单")
    refund_id = models.CharField(max_length=64, verbose_name="退款单号", unique=True)  # 外部返回
    amount = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="退款金额")
    reason = models.CharField(max_length=64, verbose_name="退款失败原因", null=True,blank=True)  # 失败原因
    status = models.SmallIntegerField(choices=ORDER_STATUS_CHOICES, default=2, verbose_name="退款状态")

    class Meta:
        db_table = "tb_mall_order_refunds"
        verbose_name = '商城订单退款'
        verbose_name_plural = verbose_name
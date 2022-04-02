# -*- coding: utf-8 -*-

"""
@Remark: 用户地址管理
"""
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from apps.address.models import Area,Address
from utils.jsonResponse import SuccessResponse,ErrorResponse
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.common import get_parameter_dic,REGEX_MOBILE
from django.core.cache import cache
from utils.locationanalysis import gettecentlnglat
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework import serializers
from rest_framework.serializers import ModelSerializer
import re
from django.db.models import Q,F

# ================================================= #
# ************** 省市区后台管理 view  ************** #
# ================================================= #
class AreaSerializer(CustomModelSerializer):
    """
    地区-序列化器
    """
    child_count = serializers.SerializerMethodField(read_only=True)

    def get_child_count(self, instance: Area):
        return Area.objects.filter(parent=instance).count()

    class Meta:
        model = Area
        fields = "__all__"
        read_only_fields = ["id"]


class AreaCreateUpdateSerializer(CustomModelSerializer):
    """
    地区管理 创建/更新时的列化器
    """

    class Meta:
        model = Area
        fields = '__all__'


class AreaViewSet(CustomModelViewSet):
    """
    地区管理接口:
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = Area.objects.all().order_by('id')
    serializer_class = AreaSerializer
    filter_fields = ['status','id','parent']
    search_fields = ('name',)

    def area_root(self, request):
        queryset = self.filter_queryset(self.get_queryset())
        queryset = queryset.filter(parent__isnull=True).order_by('id')
        serializer = AreaSerializer(queryset, many=True)
        return SuccessResponse(data=serializer.data, msg="获取成功")

# ================================================= #
# ************** 省市区查询自己接口管理 view  ************** #
# ================================================= #

class ProvinceAreasView(APIView):
    """
    查询省数据
    get:
    查询省数据，补充缓存逻辑
    请求方式： GET /areas/
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self, request):
        #补充缓存逻辑
        province_list = cache.get('province_list')
        if not province_list:
            try:
                province_model_list = Area.objects.filter(parent__isnull=True).order_by('id')
                province_list = []
                for province_model in province_model_list:
                    province_list.append({'id': province_model.id,'name': province_model.name})
                # 增加: 缓存省级数据
                cache.set('province_list', province_list, 3600)
            except Exception as e:
                return ErrorResponse(msg='省份数据错误')
        return SuccessResponse(data=province_list,msg='success')

class SubAreasView(APIView):
    """
    查询市或区数据
    get:
    子级地区：市和区县
    请求方式： GET /areas/(?P<pk>[1-9]\d+)/
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self, request, pk):
        """提供市或区地区数据
        1.查询市或区数据
        2.序列化市或区数据
        3.响应市或区数据
        4.补充缓存数据
        """
        # 判断是否有缓存
        sub_data = cache.get('sub_area_' + pk)

        if not sub_data:

            # 1.查询市或区数据
            try:
                sub_model_list = Area.objects.filter(parent=pk).order_by('id')
                # 查询市或区的父级
                parent_model = Area.objects.get(id=pk)


                # 2.序列化市或区数据
                sub_list = []
                for sub_model in sub_model_list:
                    sub_list.append({'id': sub_model.id, 'name': sub_model.name})

                sub_data = {
                    'id':parent_model.id, # pk
                    'name':parent_model.name,
                    'subs': sub_list
                }

                # 缓存市或区数据
                cache.set('sub_area_' + pk, sub_data, 3600)
            except Exception as e:
                return ErrorResponse(msg='城市或区县数据错误')

        # 3.响应市或区数据
        return SuccessResponse(data=sub_data,msg="success")

def CommentTree(datas):
    """
    获取结构树
    :param datas:
    :return:
    """
    lists=[]
    tree={}
    parent_id=''
    for s in datas:
       item=s
       tree[item['id']]=item
    root=None
    for i in datas:
       obj=i
       if not obj['pid']:#判断根评论
           root=tree[obj['id']]
           lists.append(root)#添加到列表
           # if 'childlist' not in tree[obj['id']]:
           #     tree[obj['id']]['childlist'] = []
       else:
           parent_id=obj['pid']
           if 'childlist' not in tree[parent_id]:
               tree[parent_id]['childlist']=[]
           tree[parent_id]['childlist'].append(tree[obj['id']])
    return lists
class Area2Serializer(CustomModelSerializer):
    """
    省市区 -序列化器
    """
    pid = serializers.CharField(source="parent_id")

    class Meta:
        model = Area
        read_only_fields = ["id"]
        fields = ['id','name','pid']
        # exclude = ['password']
        # extra_kwargs = {
        #     'post': {'required': False},
        # }

class GetProvinceAreasListView(APIView):
    """
    递归获取所有省市区
    get:
    递归获取所有省市区
    """
    permission_classes = []
    authentication_classes = []
    # permission_classes = [IsAuthenticated]
    # authentication_classes = [JWTAuthentication]

    def get(self, request):
        queryset_ser  = Area2Serializer(Area.objects.filter(status=True).order_by('create_datetime'),many=True)
        queryset_list = CommentTree(queryset_ser.data)
        return SuccessResponse(data=queryset_list, msg='success')
# ================================================= #
# ************** 根据详细地址获取经纬度信息 view  ************** #
# ================================================= #
class GetAddressAccuracyView(APIView):
    """
    get:
    根据详细地址信息获取经纬度
    【参数】：address 为要查询的详细地址
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self, request):
        address = get_parameter_dic(request)['address']
        if address is None:
            return ErrorResponse(msg="要查询的地址不能为空")
        data = gettecentlnglat(address)
        return  SuccessResponse(data=data,msg="success")

# ================================================= #
# ************** 前端用户地址操作 view  ************** #
# ================================================= #
class AddressSerializer(ModelSerializer):
    """
    用户地址 简单序列化器
    """


    class Meta:
        model = Address
        fields = "__all__"
        read_only_fields = ["id"]

    def create(self, validated_data):#有外键的新增数据时要自定义create添加外键数据
        return Address.objects.create(user=self.context["user"], **validated_data)

class GetAssressesListView(APIView):
    """
    用户查询地址列表/获取默认地址接口
    get:
    【参数】type=default 获取默认地址，不传type默认获取地址列表
    【参数】type=detail 获取单个地址详情，后面需跟上地址的id
    【参数】type=all 获取地址列表
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    serializer_class = AddressSerializer

    def get(self, request):
        type = get_parameter_dic(request)['type']
        user = request.user
        if type == "default":
            # queryset = Address.objects.filter(id=user.default_address_id).first()
            queryset = Address.objects.filter(user=user, is_deleted=False,is_default=True).first()
            serializer = self.serializer_class(queryset,many=False)
            return SuccessResponse(data=serializer.data, msg="success")
        elif type == "detail":
            id = get_parameter_dic(request)['id']
            if id is None:
                return ErrorResponse(msg="id不能为空")
            queryset = Address.objects.filter(id=id,user=user,is_deleted=False).first()
            serializer = self.serializer_class(queryset, many=False)
            return SuccessResponse(data=serializer.data, msg="success")
        else:
            queryset = Address.objects.filter(user=user, is_deleted=False)
            serializer = self.serializer_class(queryset,many=True)
            return SuccessResponse(data=serializer.data,msg="success")

class CreateUpdateAssressesView(APIView):
    """
    用户地址新增/修改管理接口
    post:
    【参数】提交的参数名，与获取地址列表名保持一致
    receiver 收货人姓名
    province 省
    city 市
    district 区
    street 街道
    place 详细地址
    mobile 手机号
    参数中有id字段表示修改，没有id则表示新增
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    serializer_class = AddressSerializer

    def post(self, request):
        mobile = get_parameter_dic(request)['mobile']
        if not re.match(REGEX_MOBILE, mobile):
            return ErrorResponse(msg="手机号不正确")
        user = request.user
        type = get_parameter_dic(request)['type']
        receiver = get_parameter_dic(request)['receiver']
        province = get_parameter_dic(request)['province']
        city = get_parameter_dic(request)['city']
        district = get_parameter_dic(request)['district']
        street = get_parameter_dic(request)['street']
        place = get_parameter_dic(request)['place']
        latitude=get_parameter_dic(request)['latitude']
        longitude=get_parameter_dic(request)['longitude']
        is_default = int(get_parameter_dic(request)['is_default'])

        if is_default not in [0,1]:
            return ErrorResponse(msg="is_default类型错误")

        if type=="add":#新增
            queryset = Address.objects.filter(user=user,is_deleted=False,is_default=True)
            if queryset:
                if is_default:
                    queryset.update(is_default=False)

            myaddress = Address.objects.create(user=user,receiver=receiver,province=province,city=city,district=district,street=street,place=place,mobile=mobile,latitude=latitude,longitude=longitude,is_default=is_default)
            return SuccessResponse(data={'addressid':myaddress.id},msg='success')
        elif type=='edit':
            id = get_parameter_dic(request)['id']
            queryset = Address.objects.filter(id=id,user=user).first()
            if queryset:#有这个地址数据
                otheraddresslist = Address.objects.filter(user=user,is_deleted=False).exclude(id=id)
                if is_default:  # 设置默认
                    if otheraddresslist:  # 取消其他地址的默认
                        otheraddresslist.update(is_default=False)
                    queryset.is_default = True
                else:  # 取消默认
                    queryset.is_default = False

                queryset.receiver = receiver
                queryset.province = province
                queryset.city = city
                queryset.district = district
                queryset.receiver = receiver
                queryset.street = street
                queryset.place = place
                queryset.mobile = mobile
                queryset.longitude = longitude
                queryset.latitude = latitude
                queryset.save()
                return SuccessResponse(msg='修改成功')
            else:
                return ErrorResponse(msg="修改失败")
        else:
            return ErrorResponse(msg="type类型错误")
class DeleteAssressesView(APIView):
    """
    用户地址删除接口
    get:
    【参数】id:需要删除的地址id
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    serializer_class = AddressSerializer

    def get(self, request):
        id = get_parameter_dic(request)['id']
        if id is None:
            return ErrorResponse(msg="id不能为空")
        user = request.user
        queryset = Address.objects.filter(Q(id=id)&Q(user=user)&Q(is_deleted=False))
        if queryset:
            queryset.update(is_deleted=True)
            return SuccessResponse(msg='success')
        return ErrorResponse(msg="删除失败")

class SetDefaultAssressesView(APIView):
    """
    用户设置默认地址接口
    post:
    【参数】id:设置默认的地址id,is_default:0非默认地址，1默认地址
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    serializer_class = AddressSerializer

    def post(self, request):
        id = get_parameter_dic(request)['id']
        is_default = get_parameter_dic(request)['is_default']
        if id is None:
            return ErrorResponse(msg="id不能为空")
        user = request.user
        otheraddresslist = Address.objects.filter(user=user).exclude(id=id)
        currentaddress = Address.objects.filter(id=id,user=user).first()
        if not currentaddress:
            return ErrorResponse(msg="设置失败")
        if is_default:#设置默认
            currentaddress.is_default = True
            currentaddress.save()
            if otheraddresslist:#取消其他地址的默认
                otheraddresslist.update(is_default=False)
            return SuccessResponse(msg='success')
        else:#取消默认
            currentaddress.is_default = False
            currentaddress.save()
            return SuccessResponse(msg='success')
# -*- coding: utf-8 -*-

"""
@Remark: 用户地址管理
"""
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from apps.address.models import Area
from utils.jsonResponse import SuccessResponse,ErrorResponse
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.common import get_parameter_dic
from django.core.cache import cache
from utils.locationanalysis import gettecentlnglat
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework import serializers

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



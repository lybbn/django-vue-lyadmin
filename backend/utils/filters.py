# -*- coding: utf-8 -*-

"""
@Remark: 自定义过滤器
"""
from rest_framework.filters import BaseFilterBackend

from mysystem.models import Dept

from django_filters.rest_framework import DjangoFilterBackend
from django.db.models.constants import LOOKUP_SEP
from django_filters import utils
import six
from django_filters.filters import CharFilter
import operator
from functools import reduce
from django.db.models import Q

#ly自定义部分
import django_filters
from mysystem.models import Users,OperationLog
from apps.platformsettings.models import UserLeavingMessage
from apps.mall.models import OrderInfo


def get_dept(dept_id, dept_all_list=None, dept_list=None):
    """
    递归获取部门的所有下级部门
    :param dept_id: 需要获取的部门id
    :param dept_all_list: 所有部门列表
    :param dept_list: 递归部门list
    :return:
    """
    if not dept_all_list:
        dept_all_list = Dept.objects.all().values('id', 'parent')
    if dept_list is None:
        dept_list = [dept_id]
    for ele in dept_all_list:
        if ele.get('parent') == dept_id:
            dept_list.append(ele.get('id'))
            get_dept(ele.get('id'), dept_all_list, dept_list)
    return list(set(dept_list))


class DataLevelPermissionsFilter(BaseFilterBackend):
    """
    数据 级权限过滤器
    0. 获取用户的部门id，没有部门则返回空
    1. 判断过滤的数据是否有创建人所在部门 "creator" 字段,没有则返回全部
    2. 如果用户没有关联角色则返回本部门数据
    3. 根据角色的最大权限进行数据过滤(会有多个角色，进行去重取最大权限)
    3.1 判断用户是否为超级管理员角色/如果有1(所有数据) 则返回所有数据

    4. 只为仅本人数据权限时只返回过滤本人数据，并且部门为自己本部门(考虑到用户会变部门，只能看当前用户所在的部门数据)
    5. 自定数据权限 获取部门，根据部门过滤
    """

    def filter_queryset(self, request, queryset, view):
        """
        判断是否为超级管理员:
        如果不是超级管理员,则进入下一步权限判断
        """
        if request.user.is_superuser == 0:
            # 0. 获取用户的部门id，没有部门则返回空
            user_dept_id = getattr(request.user, 'dept_id', None)
            if not user_dept_id:
                return queryset.none()

            # 1. 判断过滤的数据是否有创建人所在部门 "dept_belong_id" 字段
            if not getattr(queryset.model, 'dept_belong_id', None):
                return queryset

            # 2. 如果用户没有关联角色则返回本部门数据
            if not hasattr(request.user, 'role'):
                return queryset.filter(dept_belong_id=user_dept_id)

            # 3. 根据所有角色 获取所有权限范围
            role_list = request.user.role.filter(status=1).values('admin', 'data_range')
            dataScope_list = []
            for ele in role_list:
                # 3.1 判断用户是否为超级管理员角色/如果有1(所有数据) 则返回所有数据
                if 3 == ele.get('data_range') or ele.get('admin') == True:
                    return queryset
                dataScope_list.append(ele.get('data_range'))
            dataScope_list = list(set(dataScope_list))

            # 4. 只为仅本人数据权限时只返回过滤本人数据，并且部门为自己本部门(考虑到用户会变部门，只能看当前用户所在的部门数据)
            if 0 in dataScope_list:
                return queryset.filter(creator=request.user, dept_belong_id=user_dept_id)

            # 5. 自定数据权限 获取部门，根据部门过滤
            dept_list = []
            for ele in dataScope_list:
                if ele == 4:#自定义数据权限会读取role里面的dept部门
                    dept_list.extend(request.user.role.filter(status=1).values_list('dept__id', flat=True))
                elif ele == 2:#"本部门及以下数据权限"
                    dept_list.extend(get_dept(user_dept_id, ))
                elif ele == 1:#"本部门数据权限"
                    dept_list.append(user_dept_id)
            return queryset.filter(dept_belong_id__in=list(set(dept_list)))
        else:
            return queryset


class CustomDjangoFilterBackend(DjangoFilterBackend):
    lookup_prefixes = {
        '^': 'istartswith',
        '=': 'iexact',
        '@': 'search',
        '$': 'iregex',
        '~': 'icontains'
    }

    def construct_search(self, field_name):
        lookup = self.lookup_prefixes.get(field_name[0])
        if lookup:
            field_name = field_name[1:]
        else:
            lookup = 'icontains'
        return LOOKUP_SEP.join([field_name, lookup])

    def find_filter_lookups(self, orm_lookups, search_term_key):
        for lookup in orm_lookups:
            if lookup.find(search_term_key) >= 0:
                return lookup
        return None

    def filter_queryset(self, request, queryset, view):
        filterset = self.get_filterset(request, queryset, view)
        if filterset is None:
            return queryset
        if filterset.__class__.__name__ == 'AutoFilterSet':
            queryset = filterset.queryset
            orm_lookups = []
            for search_field in filterset.filters:
                if isinstance(filterset.filters[search_field],CharFilter):
                    orm_lookups.append(self.construct_search(six.text_type(search_field)))
                else:
                    orm_lookups.append(search_field)
            conditions = []
            queries = []
            for search_term_key in filterset.data.keys():
                orm_lookup = self.find_filter_lookups(orm_lookups, search_term_key)
                if not orm_lookup:
                    continue
                query = Q(**{orm_lookup: filterset.data[search_term_key]})
                queries.append(query)
            if len(queries) > 0:
                conditions.append(reduce(operator.and_, queries))
                queryset = queryset.filter(reduce(operator.and_, conditions))
                return queryset
            else:
                return queryset

        if not filterset.is_valid() and self.raise_exception:
            raise utils.translate_validation(filterset.errors)
        return filterset.qs

# ================================================= #
# ******************** ly项目自定义 ******************** #
# ================================================= #
# class OldManDateTimeFilter(django_filters.rest_framework.FilterSet):
#     """
#     老人管理 简单过滤器
#     URL格式：http://127.0.0.1:8000/?start_time=2020-12-02 12:00:00&end_time=2021-12-13 12:00:00
#     field_name: 过滤字段名，一般应该对应模型中字段名
#     lookup_expr: 查询时所要进行的操作，和ORM中运算符一致,iexact表示精确匹配, 并且忽略大小写
#     fields：指明过滤字段，可以是列表，列表中字典可以过滤，默认是判等；也可以字典，字典可以自定义操作
#     exclude = ['password'] 排除字段，不允许使用列表中字典进行过滤
#     自定义字段名可以和模型中不一致，但一定要用参数field_name指明对应模型中的字段名
#     """
#     #开始时间
#     start_time = django_filters.DateTimeFilter(field_name='create_datetime', lookup_expr='gte')  # 指定过滤的字段
#     #结束时间
#     end_time = django_filters.DateTimeFilter(field_name='create_datetime', lookup_expr='lte')
#     # 模糊搜索
#     name = django_filters.CharFilter(field_name='name', lookup_expr='icontains')  # icontains表示该字段模糊搜索
#     #外键关键词搜索
#     zhanzhang = django_filters.CharFilter(field_name='zhanzhang__name',label="站长名称",lookup_expr='icontains')
#     # 精确搜索
#     zhanzhang_id = django_filters.CharFilter(field_name='zhanzhang')  # 精确搜索
#     #外键关键词搜索
#     agent = django_filters.CharFilter(method='my_filter')# 自定义过滤

#     def my_filter(self, queryset, field_name, value):
#         myres = Dept.objects.filter(name__contains=value).values_list('id',flat=True)
#         if not myres:
#             return myres
#         my_dept_belong_ids = Dept.objects.filter(parent_id__in=myres).values_list('id',flat=True)
#         if not my_dept_belong_ids:
#             return my_dept_belong_ids
#         return queryset.filter(dept_belong_id__in=my_dept_belong_ids)
#     class Meta:
#         model = OldManManage
#         fields = ['start_time', 'end_time','name', 'age', 'gender', 'mobile','group','zhanzhang','zhanzhang_id','agent']

class UsersManageTimeFilter(django_filters.rest_framework.FilterSet):
    """
    用户管理 简单过滤器
    URL格式：http://127.0.0.1:8000/?start_time=2020-12-02 12:00:00&end_time=2021-12-13 12:00:00
    field_name: 过滤字段名，一般应该对应模型中字段名
    lookup_expr: 查询时所要进行的操作，和ORM中运算符一致
    fields：指明过滤字段，可以是列表，列表中字典可以过滤，默认是判等；也可以字典，字典可以自定义操作
    exclude = ['password'] 排除字段，不允许使用列表中字典进行过滤
    自定义字段名可以和模型中不一致，但一定要用参数field_name指明对应模型中的字段名
    """
    #开始时间
    beginAt = django_filters.DateTimeFilter(field_name='create_datetime', lookup_expr='gte')  # 指定过滤的字段
    #结束时间
    endAt = django_filters.DateTimeFilter(field_name='create_datetime', lookup_expr='lte')
    # 模糊搜索
    username = django_filters.CharFilter(field_name='username', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    # 模糊搜索
    nickname = django_filters.CharFilter(field_name='nickname', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    # 模糊搜索
    mobile = django_filters.CharFilter(field_name='mobile', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    is_active = django_filters.CharFilter(field_name='is_active')  # icontains表示该字段模糊搜索

    class Meta:
        model = Users
        fields = ['beginAt', 'endAt','username','mobile','is_active','nickname']


class OperationLogTimeFilter(django_filters.rest_framework.FilterSet):
    """
    日志管理 简单过滤器
    URL格式：http://127.0.0.1:8000/?start_time=2020-12-02 12:00:00&end_time=2021-12-13 12:00:00
    field_name: 过滤字段名，一般应该对应模型中字段名
    lookup_expr: 查询时所要进行的操作，和ORM中运算符一致
    fields：指明过滤字段，可以是列表，列表中字典可以过滤，默认是判等；也可以字典，字典可以自定义操作
    exclude = ['password'] 排除字段，不允许使用列表中字典进行过滤
    自定义字段名可以和模型中不一致，但一定要用参数field_name指明对应模型中的字段名
    """
    #开始时间
    beginAt = django_filters.DateTimeFilter(field_name='create_datetime', lookup_expr='gte')  # 指定过滤的字段
    #结束时间
    endAt = django_filters.DateTimeFilter(field_name='create_datetime', lookup_expr='lte')
    # 模糊搜索
    request_modular = django_filters.CharFilter(field_name='request_modular', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    # 模糊搜索
    request_path = django_filters.CharFilter(field_name='request_path', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    # 模糊搜索
    request_ip = django_filters.CharFilter(field_name='request_ip', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    request_os = django_filters.CharFilter(field_name='request_os', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    request_body = django_filters.CharFilter(field_name='request_body', lookup_expr='icontains')  # icontains表示该字段模糊搜索

    class Meta:
        model = OperationLog
        fields = ['beginAt', 'endAt','request_modular','request_path','request_ip','request_os','request_body']



class UserLeavingMessageTimeFilter(django_filters.rest_framework.FilterSet):
    """
    意见反馈 简单过滤器
    URL格式：http://127.0.0.1:8000/?start_time=2020-12-02 12:00:00&end_time=2021-12-13 12:00:00
    field_name: 过滤字段名，一般应该对应模型中字段名
    lookup_expr: 查询时所要进行的操作，和ORM中运算符一致
    fields：指明过滤字段，可以是列表，列表中字典可以过滤，默认是判等；也可以字典，字典可以自定义操作
    exclude = ['password'] 排除字段，不允许使用列表中字典进行过滤
    自定义字段名可以和模型中不一致，但一定要用参数field_name指明对应模型中的字段名
    """
    #开始时间
    beginAt = django_filters.DateTimeFilter(field_name='create_datetime', lookup_expr='gte')  # 指定过滤的字段
    #结束时间
    endAt = django_filters.DateTimeFilter(field_name='create_datetime', lookup_expr='lte')
    # 模糊搜索
    nickname = django_filters.CharFilter(field_name='user__nickname', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    # 模糊搜索
    mobile = django_filters.CharFilter(field_name='user__mobile', lookup_expr='icontains')  # icontains表示该字段模糊搜索

    class Meta:
        model = UserLeavingMessage
        fields = ['beginAt', 'endAt','nickname','mobile']

class FinanceOrderInfoTimeFilter(django_filters.rest_framework.FilterSet):
    """
    商城商品订单信息 简单过滤器
    URL格式：http://127.0.0.1:8000/?start_time=2020-12-02 12:00:00&end_time=2021-12-13 12:00:00
    field_name: 过滤字段名，一般应该对应模型中字段名
    lookup_expr: 查询时所要进行的操作，和ORM中运算符一致
    fields：指明过滤字段，可以是列表，列表中字典可以过滤，默认是判等；也可以字典，字典可以自定义操作
    exclude = ['password'] 排除字段，不允许使用列表中字典进行过滤
    自定义字段名可以和模型中不一致，但一定要用参数field_name指明对应模型中的字段名
    """
    #开始时间
    beginAt = django_filters.DateTimeFilter(field_name='pay_time', lookup_expr='gte')  # 指定过滤的字段
    #结束时间
    endAt = django_filters.DateTimeFilter(field_name='pay_time', lookup_expr='lte')
    # 模糊搜索
    nickname = django_filters.CharFilter(field_name='user__nickname', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    # 模糊搜索
    order_id = django_filters.CharFilter(field_name='order_id', lookup_expr='icontains')  # icontains表示该字段模糊搜索
    # 自定义
    gname = django_filters.CharFilter(method='my_filter')  # 自定义过滤
    # 精确搜索
    status = django_filters.CharFilter(field_name='status')  # 自定义过滤

    def my_filter(self, queryset, field_name, value):
        return queryset.filter(ordergoods__sku__spu__name__contains=value)

    class Meta:
        model = OrderInfo
        fields = ['beginAt', 'endAt','nickname','order_id','gname','status']
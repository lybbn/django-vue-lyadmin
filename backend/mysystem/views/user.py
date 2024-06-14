# -*- coding: utf-8 -*-

"""
@Remark: 用户管理
"""
from django.contrib.auth.hashers import make_password
from rest_framework import serializers

from mysystem.models import Users,Role
from utils.jsonResponse import SuccessResponse, ErrorResponse
from utils.permission import CustomPermission
from utils.serializers import CustomModelSerializer
from utils.validator import CustomUniqueValidator
from utils.viewset import CustomModelViewSet
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q
from utils.filters import UsersManageTimeFilter

class UserSerializer(CustomModelSerializer):
    """
    用户管理-序列化器
    """
    rolekey = serializers.SerializerMethodField(read_only=True)  # 新增自定义字段

    def get_rolekey(self,obj):
        return list(obj.role.values_list('key', flat=True))

    class Meta:
        model = Users
        read_only_fields = ["id"]
        exclude = ['password','user_permissions','groups']
        extra_kwargs = {
            'post': {'required': False},
        }


class UserCreateSerializer(CustomModelSerializer):
    """
    管理员用户新增-序列化器
    """
    username = serializers.CharField(max_length=50,validators=[CustomUniqueValidator(queryset=Users.objects.all(), message="账号必须唯一")])
    password = serializers.CharField(required=False, default=make_password("123456"))

    is_staff = serializers.BooleanField(required=False,default=True)#是否允许登录后台

    def create(self, validated_data):
        if "password" in validated_data.keys():
            if validated_data['password']:
                validated_data['password'] = make_password(validated_data['password'])
        validated_data['identity'] = 1
        return super().create(validated_data)

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.post.set(self.initial_data.get('post', []))
        return data

    class Meta:
        model = Users
        fields = "__all__"
        read_only_fields = ["id"]
        extra_kwargs = {
            'post': {'required': False},
        }


class UserUpdateSerializer(CustomModelSerializer):
    """
    用户修改-序列化器
    """
    username = serializers.CharField(max_length=50,validators=[CustomUniqueValidator(queryset=Users.objects.all(), message="账号必须唯一")])
    password = serializers.CharField(required=False, allow_blank=True)

    def update(self, instance, validated_data):
        if "password" in validated_data.keys():
            if validated_data['password']:
                validated_data['password'] = make_password(validated_data['password'])
        return super().update(instance,validated_data)

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.post.set(self.initial_data.get('post', []))
        return data

    class Meta:
        model = Users
        read_only_fields = ["id"]
        fields = "__all__"
        extra_kwargs = {
            'post': {'required': False, 'read_only': True},
        }


class UserViewSet(CustomModelViewSet):
    """
    后台管理员用户接口:
    """
    queryset = Users.objects.filter(identity=1,is_delete=False).order_by('-create_datetime')
    serializer_class = UserSerializer
    create_serializer_class = UserCreateSerializer
    update_serializer_class = UserUpdateSerializer
    # filterset_fields = ('name','is_active','username')
    filterset_class = UsersManageTimeFilter

    def user_info(self,request):
        """获取当前用户信息"""
        user = request.user
        result = {
            "name":user.name,
            "mobile":user.mobile,
            "gender":user.gender,
            "email":user.email
        }
        return SuccessResponse(data=result,msg="获取成功")

    def update_user_info(self,request):
        """修改当前用户信息"""
        user = request.user
        Users.objects.filter(id=user.id).update(**request.data)
        return SuccessResponse(data=None, msg="修改成功")


    def change_password(self,request,*args, **kwargs):
        """密码修改"""
        user = request.user
        instance = Users.objects.filter(id=user.id,identity__in=[0,1]).first()
        data = request.data
        old_pwd = data.get('oldPassword')
        new_pwd = data.get('newPassword')
        new_pwd2 = data.get('newPassword2')
        if instance:
            if new_pwd != new_pwd2:
                return ErrorResponse(msg="2次密码不匹配")
            elif instance.check_password(old_pwd):
                instance.password = make_password(new_pwd)
                instance.save()
                return SuccessResponse(data=None, msg="修改成功")
            else:
                return ErrorResponse(msg="旧密码不正确")
        else:
            return ErrorResponse(msg="未获取到用户")

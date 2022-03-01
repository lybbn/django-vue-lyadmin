from rest_framework.views import APIView
from apps.lymessages.models import MyMessageTemplate,MyMessage,MyMessageUser
from utils.jsonResponse import SuccessResponse,ErrorResponse
from utils.common import get_parameter_dic,formatdatetime
from django.db.models import Q,F
from rest_framework import serializers
from rest_framework_simplejwt.authentication import JWTAuthentication
from utils.serializers import CustomModelSerializer
from utils.viewset import CustomModelViewSet
from rest_framework.permissions import IsAuthenticated
from utils.pagination import CustomPagination

# ================================================= #
# ************** 后台消息中心 view  ************** #
# ================================================= #

class MyMessageTemplateSerializer(CustomModelSerializer):
    """
    消息模板 -序列化器
    """

    class Meta:
        model = MyMessageTemplate
        read_only_fields = ["id"]
        fields = '__all__'
        # exclude = ['password']
        # extra_kwargs = {
        #     'post': {'required': False},
        # }

class MyMessageTemplateViewSet(CustomModelViewSet):
    """
    后台消息模板 接口:
    """
    queryset = MyMessageTemplate.objects.all().order_by('create_datetime')
    serializer_class = MyMessageTemplateSerializer
    filter_fields = ('title',)

class MyMessageSerializer(CustomModelSerializer):
    """
    消息公告 -序列化器
    """

    class Meta:
        model = MyMessage
        read_only_fields = ["id"]
        fields = '__all__'
        # exclude = ['password']
        extra_kwargs = {
            'msg_type': {'required': False,'read_only': True},
        }

class MyMessageCreateUpdateSerializer(CustomModelSerializer):
    """
    消息公告 -序列化器
    """
    public = serializers.BooleanField(required=False,default=True)
    msg_chanel = serializers.IntegerField(required=False, default=2)
    class Meta:
        model = MyMessage
        read_only_fields = ["id"]
        fields = '__all__'
        # exclude = ['password']
        extra_kwargs = {
            'msg_type': {'required': False,'read_only': True},
        }

class MyMessageViewSet(CustomModelViewSet):
    """
    后台消息公告 接口:
    """
    queryset = MyMessage.objects.filter(msg_chanel=2)
    serializer_class = MyMessageSerializer
    create_serializer_class = MyMessageCreateUpdateSerializer
    update_serializer_class = MyMessageCreateUpdateSerializer
    filter_fields = ('msg_title',)

def send_sys_template_message(revuser,code):
    """
    发送系统模板消息给用户，一对一
    :param revuser: 接收消息的用户id
    :param code: 消息模板code
    :return:True成功，False失败
    """
    template = MyMessageTemplate.objects.filter(code=code).first()
    if not template:
        return False

    messageuser = MyMessageUser()
    instance = MyMessage.objects.create(msg_chanel=1,msg_type=template,public=False,msg_title=template.title,msg_content=template.content,status=True)
    # MyMessageUser.objects.create(messageid_id=instance.id,revuserid=revuser)
    messageuser.messageid_id = instance.id
    messageuser.revuserid_id = revuser
    messageuser.save()
    return True


# ================================================= #
# ************** 前端消息中心 view  ************** #
# ================================================= #

class UserMessagesView(APIView):
    """
    get:
    用户获取系统消息通知
    【参数】
    is_read 是否已读False，True ，获取已读或未读取的通知
    post:
    消息修改为已读
    【参数】
    id 为消息的id
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    serializer_class = MyMessageSerializer
    pagination_class = CustomPagination  # 自定义分页会覆盖settings全局配置的

    def get(self, request, *args, **kwargs):  # 分页必须为get请求
        """
        获取用户自己消息列表
        """

        user = request.user
        # 检查消息表是否有更新（主要是系统通知），有的话则插入到用户消息中间表中
        notices = MyMessage.objects.filter(msg_chanel=1, status=True)
        if notices:  # 存在系统通知
            for notice in notices:  # 检查该用户消息中间表是否存在该消息id
                MyMessageUser.objects.get_or_create(messageid_id=notice.id, revuserid=user)

        queryset = MyMessage.objects.filter(status=True, mymessageuser__revuserid=user).order_by("-update_datetime")
        is_read = get_parameter_dic(request).get('is_read')
        if is_read:
            if int(is_read) == 1:
                queryset = queryset.exclude(Q(mymessageuser__is_read=True), Q(mymessageuser__revuserid=user)).order_by(
                    "-update_datetime")
            elif int(is_read) == 0:
                queryset = queryset.filter(mymessageuser__is_read=True, mymessageuser__revuserid=user).order_by(
                    "-update_datetime")
            else:
                return ErrorResponse(msg="is_read类型错误")
        # # 1. 实例化分页器对象
        page_obj = CustomPagination()
        # # 2. 使用自己配置的分页器调用分页方法进行分页
        page_data = page_obj.paginate_queryset(queryset, request)
        data = []
        if queryset:
            for q in page_data:
                data.append({
                    'id': q.id,
                    'msg_chanel': q.msg_chanel,
                    'msg_type': q.msg_type,
                    'public': q.public,
                    'msg_title': q.msg_title,
                    'msg_content': q.msg_content,
                    'create_datetime': formatdatetime(q.create_datetime),
                    'update_datetime': formatdatetime(q.update_datetime),
                })
        if not is_read and not is_read == 0:
            MyMessageUser.objects.filter(revuserid=user).update(is_read=True)
        return page_obj.get_paginated_response(data)

    def post(self, request, *args, **kwargs):
        """
        消息修改为已读
        """
        id = get_parameter_dic(request)['id']
        if id is None:
            return ErrorResponse(msg="id不能为空")
        instance = MyMessageUser.objects.get_or_create(messageid_id=id, revuserid=request.user)
        instance.is_read = True
        instance.save()
        return SuccessResponse(msg='success')
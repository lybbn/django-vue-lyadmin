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
import datetime

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
    filterset_fields = ('title',)

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
    filterset_fields = ('msg_title',)
    search_fields = ('msg_title',)

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

class GetUnreadMessageNumView(APIView):
    """
    get:
    用户获取未读消息的数量
    【参数】无
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def get(self,request):
        user = request.user
        identity = user.identity
        if not identity == 2:
            return ErrorResponse(msg="用户类型错误")
        # 检查消息表是否有更新（主要是平台公告（系统通知针对单个用户的已经有写入）），有的话则插入到用户消息中间表中
        notices = MyMessage.objects.filter(status=True,public=True)
        if notices:  # 存在消息
            for notice in notices:  # 检查该用户消息中间表是否存在该消息id
                MyMessageUser.objects.get_or_create(messageid_id=notice.id, revuserid=user)

        nums = MyMessageUser.objects.filter(revuserid=user, is_delete=False,is_read=False).count()
        data={
            'nums':nums
        }
        return DetailResponse(data=data,msg='success')

class UserMessagesNoticeView(APIView):
    """
    get:
    用户获取平台公告列表
    【参数】无
    """
    permission_classes = []
    authentication_classes = []
    serializer_class = MyMessageSerializer
    pagination_class = CustomPagination  # 自定义分页会覆盖settings全局配置的

    def get(self, request, *args, **kwargs):  # 分页必须为get请求
        """
        用户获取平台公告列表
        """
        # 检查消息表是否有更新（主要是系统通知），有的话则插入到用户消息中间表中
        queryset = MyMessage.objects.filter(msg_chanel=2,status=True,public=True).order_by("-create_datetime")
        # # 1. 实例化分页器对象
        page_obj = CustomPagination()
        # # 2. 使用自己配置的分页器调用分页方法进行分页
        page_data = page_obj.paginate_queryset(queryset, request)
        data = []
        if queryset:
            for q in page_data:
                data.append({
                    'id': q.id,
                    'msg_title': q.msg_title,
                    'msg_content': q.msg_content,
                    'create_datetime': formatdatetime(q.create_datetime),
                    'update_datetime': formatdatetime(q.update_datetime),
                })
        return page_obj.get_paginated_response(data)

class UserMessagesView(APIView):
    """
    get:
    用户获取系统消息和平台公告通知（包含已读，未读）
    【参数】
    type: 1 系统通知，2 平台公告 ，0或None不传 获取全部（系统通知+平台公告）
    post:
    消息修改为已读
    【参数】
    id 为消息的id
    type：isread 已读 ，del 删除
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    serializer_class = MyMessageSerializer
    pagination_class = CustomPagination  # 自定义分页会覆盖settings全局配置的

    def get(self, request, *args, **kwargs):
        """
        用户获取系统消息和平台公告通知（包含已读，未读）
        """
        user = request.user
        type = get_parameter_dic(request).get('type',None)
        if type and str(type) in ['1','2']:
            # 检查消息表是否有更新（主要是系统通知或平台公告），有的话则插入到用户消息中间表中
            notices = MyMessage.objects.filter(msg_chanel=int(type), status=True).order_by("create_datetime")
        else:
            # 检查消息表是否有更新（系统消息+平台公告），有的话则插入到用户消息中间表中
            notices = MyMessage.objects.filter(status=True).order_by("create_datetime")
        if notices:  # 存在消息
            for notice in notices:  # 检查该用户消息中间表是否存在该消息id
                MyMessageUser.objects.get_or_create(messageid_id=notice.id,revuserid=user)

        queryset = MyMessageUser.objects.filter(revuserid=user,is_delete=False).order_by("-create_datetime")
        # # 1. 实例化分页器对象
        page_obj = CustomPagination()
        # # 2. 使用自己配置的分页器调用分页方法进行分页
        page_data = page_obj.paginate_queryset(queryset, request)
        data = []
        if queryset:
            for q in page_data:
                data.append({
                    'id': q.id,
                    'msg_title': q.messageid.msg_title,
                    'msg_content': q.messageid.msg_content,
                    'is_read':q.is_read,
                    'create_datetime': formatdatetime(q.create_datetime),
                    'update_datetime': formatdatetime(q.update_datetime),
                })
        return page_obj.get_paginated_response(data)

    def post(self, request, *args, **kwargs):
        """
        消息修改为已读/删除

        """
        id = get_parameter_dic(request)['id']
        type = get_parameter_dic(request)['type']
        if id is None or type is None:
            return ErrorResponse(msg="提交参数不能为空")
        instance = MyMessageUser.objects.filter(id=id, revuserid=request.user,is_delete=False).first()
        if instance:
            if type == "isread":
                instance.is_read = True
                instance.read_at = datetime.datetime.now()
            elif type == "del":
                instance.is_delete = True
            else:
                return ErrorResponse(msg="type类型错误")
            instance.save()
            return SuccessResponse(msg='success')
        else:
            return ErrorResponse(msg="操作错误")
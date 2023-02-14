from rest_framework.views import APIView
from mysystem.models import Users
from utils.jsonResponse import SuccessResponse,ErrorResponse,DetailResponse
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from django.utils.translation import gettext_lazy as _
from rest_framework import serializers
from utils.common import REGEX_MOBILE,get_parameter_dic,ast_convert
import re
from random import choice
from django.db.models import Q,F
from django_redis import get_redis_connection
from utils.yunpian import YunPian
from utils.uniappsms import UniCloudSms
from django.contrib.auth.hashers import make_password, check_password
import uuid
from config import ALIYUN_SMS_SIGN,ALIYUM_SMS_TEMPLATE
from utils.aliyunsms import send_sms
from utils.tencentsms import tencentsms
import json
# ================================================= #
# ************** 前端用户登录 view  ************** #
# ================================================= #

"""
手机号密码登录
"""

class AppMoliePasswordLoginSerializer(TokenObtainPairSerializer):
    """
    前端登录的序列化器:
    重写djangorestframework-simplejwt的序列化器
    """

    default_error_messages = {
        'no_active_account': _('该账号已被禁用,请联系管理员')
    }

    def validate(self, attrs):
        mobile = attrs['username']
        # 验证手机号是否合法
        if not re.match(REGEX_MOBILE, mobile):
            result = {
                "code": 4000,
                "msg": "请输入正确的手机号",
                "data": None
            }
            return result
        password = attrs['password']
        user = Users.objects.filter(username=mobile + "app", mobile=mobile, identity__contains="1").first()
        if user and not user.is_active:
            result = {
                "code": 4000,
                "msg": "该账号已被禁用,请联系管理员",
                "data": None
            }
            return result
        if user and user.check_password(password):  # check_password() 对明文进行加密,并验证
            # data = super().validate(attrs)
            data={}
            refresh = self.get_token(user)
            data['identity'] = ast_convert(user.identity)
            data['userId'] = user.id
            data['refresh'] = str(refresh)
            data['access'] = str(refresh.access_token)
            result = {
                "code": 2000,
                "msg": "登录成功",
                "data": {
                    "page": 1,
                    "limit": 1,
                    "total": 1,
                    "data": data
                },
            }
        else:
            result = {
                "code": 4000,
                "msg": "账号/密码不正确",
                "data": None
            }
        return result


class APPMobilePasswordLoginView(TokenObtainPairView):
    """
    手机号密码登录接口（此种方式传参需要formdata方式）
    """
    serializer_class = AppMoliePasswordLoginSerializer
    permission_classes = []

class UsernamePassWordLoginView(APIView):
    """
    post:
    账号密码登录(手机号)此种方式传参通用
    【功能描述】账号密码登录</br>
    【参数说明】username 账号</br>
    【参数说明】password 密码</br>
    """
    authentication_classes = []
    permission_classes = []

    def post(self,request):
        username = get_parameter_dic(request)['mobile']
        password = get_parameter_dic(request)['password']
        # 验证手机号是否合法
        if not re.match(REGEX_MOBILE, username):
            return ErrorResponse(msg="请输入正确的手机号")
        user = Users.objects.filter(username=username, identity=2).first()
        if user and not user.is_active:
            return ErrorResponse(msg="该账号已被禁用,请联系管理员")
        if user and user.check_password(password):  # check_password() 对明文进行加密,并验证
            resdata = APPMobileSMSLoginSerializer.get_token(user)
            return DetailResponse(data=resdata, msg="登录成功")
        return ErrorResponse(msg="账号/密码错误")

#发送短信序列化器
class SmsSerializer(serializers.Serializer):
    mobile = serializers.CharField(max_length=11,required=True,help_text="手机号")
    smstype=serializers.CharField(max_length=10,required=True,help_text="请求类型：login/register/restpass/rebind")

    # 函数名必须：validate + 验证字段名
    def validate_mobile(self, mobile):
        """
        手机号码验证
        """
        # 是否合法手机号
        if not re.match(REGEX_MOBILE, mobile):
            raise serializers.ValidationError("手机号码非法", 400)

        if self.context['smstype']== "register":#用户注册
            # 是否已经注册
            if Users.objects.filter(mobile=mobile).count():
                raise serializers.ValidationError("该手机号已注册",400)

        if self.context['smstype']== "restpass" or self.context['smstype']== "login":#重置密码/用户登录
            #该手机号是否已注册
            if not Users.objects.filter(username=mobile+"app",mobile=mobile,identity__contains="1",is_active=True).count():
                raise serializers.ValidationError("没有找到该用户",400)

        if self.context['smstype']== "wxbind":#微信绑定
            #该手机号是否已注册
            if not Users.objects.filter(username=mobile+"app",mobile=mobile,identity__contains="1",is_active=True,oauthwxuser__isnull=True).count():
                raise serializers.ValidationError("没有找到该用户或该用户已绑定微信",400)

        if self.context['smstype'] == "rebind":#换绑手机号，前提用户已经登录
            #是否跟原来绑定过的号码一致
            mqueryset = Users.objects.filter(id = self.context['request'].user.id)
            if not mqueryset:
                raise serializers.ValidationError("该用户不存在", 400)
            if mqueryset[0].mobile == mobile:
                raise serializers.ValidationError("请使用新的手机号绑定", 400)
            if Users.objects.filter(mobile=mobile).count():
                raise serializers.ValidationError("该手机号已被其他用户绑定",400)

        return mobile

#发送短信验证码(不需要登录验证就可以调用)
#注册，登录，忘记密码时使用
class SendSmsCodeView(APIView):
    """
    post:
    发送手机验证码
    【参数说明】使用"application/json"编码传输，参数如下</br>
    mobile 必要 手机号</br>
    smstype 必要 短信类型：register/restpass/login</br>
    """
    authentication_classes = ()#不需要身份认证
    permission_classes = ()#不需要权限分配
    serializer_class = SmsSerializer

    def generate_code(self):
        """
        生成四位数字的验证码
        """
        seeds = "1234567890"
        random_str = []
        for i in range(6):
            random_str.append(choice(seeds))

        return "".join(random_str)

    def post(self, request, *args, **kwargs):

        mobile = get_parameter_dic(request)['mobile']
        smstype = get_parameter_dic(request)['smstype']
        if smstype == "login" or smstype == "restpass" or smstype == "wxbind":
            # 创建序列化器
            serializer = SmsSerializer(data=request.data, context={"request": request, "smstype": smstype})
            # 验证是否有效
            serializer.is_valid(raise_exception=True)
            # 判断该手机号60s内是否已经发送过短信
            redis_conn = get_redis_connection('verify_codes')
            send_flag = redis_conn.get('send_flag_%s' % mobile)
            if send_flag:  # 如果取到了标记，说明该手机号60s内发送过短信验证码
                return ErrorResponse(msg="请一分钟后再获取验证码")
            # 验证码过期时间
            codeexpire = 300  # 300秒，默认5分钟
            # 生成验证码
            code = self.generate_code()

            # 云片网api短信接口调用-----------开始
            # yun_pian = YunPian(SMS_API_KEY)
            # sms_status = yun_pian.send_sms(code=code, mobile=mobile)
            #
            # if sms_status["code"] != 0:
            #     mydata = {}
            #     mydata["mobile"] = mobile
            #     return Response(ly_api_res(400,mydata,sms_status["msg"]), status=status.HTTP_400_BAD_REQUEST)
            # else:
            #     #存储短信验证码到redis
            #     redis_conn.setex('sms_%s'%mobile,codeexpire,code)#默认300秒5分钟过期时间
            #     #存储一个标记，表示此手机号已发送过短信，标记有效期为60s
            #     redis_conn.setex('send_flag_%s'%mobile,60,1)
            #     mydata = {}
            #     mydata["mobile"] = mobile
            #     return Response(ly_api_res(200,mydata,"短信验证码发送成功"), status=status.HTTP_200_OK)
            # 云片网api短信接口调用-----------结束
            # unicloud短信接口api调用-----------开始
            # unicloudsms = UniCloudSms()
            # sms_status = unicloudsms.send_sms(code=code, mobile=mobile,expminute=codeexpire)
            # #返回内容
            # #{"msg":"sendSms参数phone值不可为空"}
            # #{"code":0,"errCode":0,"success":true}
            # if 'code' in sms_status: #判断返回内容是否存在code的key，错误时不返回code
            #     if sms_status["code"] == 0:
            #         # 存储短信验证码到redis
            #         redis_conn.setex('sms_%s' % mobile, codeexpire, code)  # 默认300秒5分钟过期时间
            #         # 存储一个标记，表示此手机号已发送过短信，标记有效期为60s
            #         redis_conn.setex('send_flag_%s' % mobile, 60, 1)
            #         mydata = {}
            #         mydata["mobile"] = mobile
            #         return SuccessResponse(data=mydata, msg="短信验证码发送成功")
            #     else:
            #         mydata = {}
            #         mydata["mobile"] = mobile
            #         return ErrorResponse(data=mydata, msg=sms_status['msg'])
            # else:
            #     mydata = {}
            #     mydata["mobile"] = mobile
            #     return ErrorResponse(data=mydata, msg=sms_status['msg'])
            # unicloud短信接口api调用-----------结束
            # 阿里云短信-----------开始
            # __business_id = uuid.uuid1()
            # # 一个验证码发送的例子
            # params = '{\"code\":\"'+code+'\"}'  # 模板参数
            # sms_status= send_sms(__business_id,mobile,ALIYUN_SMS_SIGN,ALIYUM_SMS_TEMPLATE,params)
            # # 返回内容byte类型
            # # {
            # #     "Message": "OK",
            # #     "RequestId": "F655A8D5-B967-440B-8683-DAD6FF8DE990",
            # #     "Code": "OK",
            # #     "BizId": "900619746936498440^0"
            # # }
            # sms_status_str = sms_status.decode()
            # sms_status_json = json.loads(sms_status)
            # if 'Code' in sms_status_str:  # 判断返回内容是否存在code的key，错误时不返回code
            #     if sms_status_json["Code"] == 'OK':
            #         # 存储短信验证码到redis
            #         redis_conn.setex('sms_%s' % mobile, codeexpire, code)  # 默认300秒5分钟过期时间
            #         # 存储一个标记，表示此手机号已发送过短信，标记有效期为60s
            #         redis_conn.setex('send_flag_%s' % mobile, 60, 1)
            #         mydata = {}
            #         mydata["mobile"] = mobile
            #         return SuccessResponse(data=mydata, msg="短信验证码发送成功")
            #     else:
            #         return ErrorResponse(data=sms_status_json, msg='发送失败')
            # else:
            #     return ErrorResponse(data=sms_status_json, msg='发送失败')
            # 阿里云短信-----------结束
            # 腾讯云短信-----------开始
            sms_status_json = tencentsms("+" + str(86) + str(mobile), code)
            # sms_status_json = 'Ok'
            if 'Ok' in sms_status_json:  #
                # 存储短信验证码到redis
                redis_conn.setex('sms_%s' % mobile, codeexpire, code)  # 默认300秒5分钟过期时间
                # 存储一个标记，表示此手机号已发送过短信，标记有效期为60s
                redis_conn.setex('send_flag_%s' % mobile, 60, 1)
                mydata = {}
                mydata["mobile"] = mobile
                return SuccessResponse(data=mydata, msg="success")
            else:
                return ErrorResponse(data=sms_status_json, msg='error')
            # 腾讯云短信-----------结束

        else:
            return ErrorResponse(msg="smstype短信验证码类型错误")



class APPMobileSMSLoginSerializer(TokenObtainPairSerializer):
    """
    登录的序列化器:
    重写djangorestframework-simplejwt的序列化器
    """

    @classmethod
    def get_token(cls, user):
        refresh = super(APPMobileSMSLoginSerializer,cls).get_token(user)
        data = {}
        data['identity'] = ast_convert(user.identity)
        data['userId'] = user.id
        data['refresh'] = str(refresh)
        data['access'] = str(refresh.access_token)
        return data

class APPMobileSMSLoginView(APIView):
    """
    post:
    手机号短信登录接口
    【功能描述】用户手机号短信验证码登录</br>
    【参数说明】mobile为手机号</br>
    【参数说明】code短信验证码</br>
    """
    authentication_classes = []
    permission_classes = []

    def post(self,request):
        mobile = get_parameter_dic(request)['mobile']
        code = get_parameter_dic(request)['code']
        # 验证手机号是否合法
        if not re.match(REGEX_MOBILE, mobile):
            return ErrorResponse(msg="请输入正确手机号")
        # 判断短信验证码是否正确
        redis_conn = get_redis_connection('verify_codes')
        send_flag = redis_conn.get('sms_%s' % mobile)  # send_flag的值为bytes，需要转换成str ,send_flag.decode()
        if not send_flag:  # 如果取不到标记，则说明验证码过期
            return ErrorResponse(msg="短信验证码已过期")
        else:
            if str(send_flag.decode()) != str(code):
                return ErrorResponse(msg="验证码错误")
            #开始登录
            user = Users.objects.filter(username=mobile+"app",mobile=mobile,identity__contains="1",is_active=True).first()
            if not user:
                return ErrorResponse(msg="用户不存在")

            resdata = APPMobileSMSLoginSerializer.get_token(user)
            return SuccessResponse(data=resdata, msg="登录成功")


#用户忘记密码重置密码
class ForgetPasswdResetView(APIView):
    '''
    post:
    【功能描述】重置用户密码</br>
    【参数说明】mobile为手机号</br>
    【参数说明】code短信验证码</br>
    【参数说明】password为密码</br>
    '''
    authentication_classes = []
    permission_classes = []
    def post(self, request, *args, **kwargs):

        mobile = get_parameter_dic(request)['mobile']
        code = get_parameter_dic(request)['code']
        password = get_parameter_dic(request)['password']
        if len(password) < 6:
            return ErrorResponse(msg="密码长度至少6位")

        # 验证手机号是否合法
        if not re.match(REGEX_MOBILE, mobile):
            return ErrorResponse(msg="请输入正确手机号")
        # 判断短信验证码是否正确
        redis_conn = get_redis_connection('verify_codes')
        send_flag = redis_conn.get('sms_%s'%mobile)#send_flag的值为bytes，需要转换成str ,,send_flag.decode()
        if not send_flag:  # 如果取不到标记，则说明验证码过期
            return ErrorResponse(msg="短信验证码已过期")
        else:
            if str(send_flag.decode()) != str(code):
                return ErrorResponse(msg="验证码错误")
            #开始更换手机号
            user = Users.objects.filter(username=mobile+"app",mobile=mobile,identity__contains="1",is_active=True).first()
            if not user:
                return ErrorResponse(msg="用户不存在")
            # 重置密码
            user.password = make_password(password)
            user.save()
            return SuccessResponse(msg="success")

class RegisterView(APIView):
    '''
    前端用户注册
    post:
    【功能描述】前端用户注册</br>
    【参数说明】mobile为手机号</br>
    【参数说明】code短信验证码</br>
    【参数说明】password为密码</br>
    【参数说明】password2为确认输入的密码</br>
    '''
    authentication_classes = []
    permission_classes = []

    def post(self, request, *args, **kwargs):
        mobile = get_parameter_dic(request)['mobile']
        code = get_parameter_dic(request)['code']
        password = get_parameter_dic(request)['password']
        password2 = get_parameter_dic(request)['password2']
        if mobile is None or code is None or password is None or password2 is None:
            return ErrorResponse(msg="提交的参数不能为空")

        # 判断密码是否合法
        if len(password) < 6:
            return ErrorResponse(msg="密码长度至少6位")

        if not re.match(r'^[a-zA_Z0-9]{6,20}$', password):
            return ErrorResponse(msg="密码格式不正确(大小写字母、数字组合)")

        if password != password2:
            return ErrorResponse(msg="两次密码输入不一致")

        # 验证手机号是否合法
        if not re.match(REGEX_MOBILE, mobile):
            return ErrorResponse(msg="请输入正确手机号")

        # 判断短信验证码是否正确
        if not re.match(r'^\d{6}$', code):
            return ErrorResponse(msg="验证码格式错误")
        redis_conn = get_redis_connection('verify_codes')
        send_flag = redis_conn.get('sms_%s' % mobile)  # send_flag的值为bytes，需要转换成str ,,send_flag.decode()
        if not send_flag:  # 如果取不到标记，则说明验证码过期
            return ErrorResponse(msg="短信验证码已过期")
        else:
            if str(send_flag.decode()) != str(code):
                return ErrorResponse(msg="验证码错误")
            # 开始注册
            Users.objects.create(username=mobile,password=make_password(password),mobile=mobile,is_staff=False,viptype=1)
            return SuccessResponse(msg="注册成功")
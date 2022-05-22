from rest_framework.views import APIView
from mysystem.models import Users
from apps.oauth.models import OAuthWXUser
from utils.jsonResponse import SuccessResponse,ErrorResponse
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from utils.common import get_parameter_dic,REGEX_MOBILE
from config import WX_XCX_APPID,WX_XCX_APPSECRET,WX_GZH_APPID,WX_GZH_APPSECRET,WX_GZPT_APPSECRET,WX_GZPT_APPID,TT_XCX_APPID,TT_XCX_APPSECRET
import requests
import base64
import json
from Crypto.Cipher import AES
from django.utils.translation import gettext_lazy as _
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated
import re
import uuid
from django.db import transaction
from django.db.models import F
from django.core.cache import cache
import logging
from django_redis import get_redis_connection
import base64
import os
import datetime
from  django.conf import settings
from config import DOMAIN_HOST
from utils.common import renameuploadimg

logger = logging.getLogger(__name__)
# Create your views here.
# ================================================= #
# ************** 微信小程序登录 view  ************** #
# ================================================= #
class XCXLoginSerializer(TokenObtainPairSerializer):
    """
    登录的序列化器:
    重写djangorestframework-simplejwt的序列化器
    """

    @classmethod
    def get_token(cls, user):
        refresh = super(XCXLoginSerializer,cls).get_token(user)
        data = {}
        data['openid'] = user.oauthwxuser.xcx_openid
        data['userId'] = user.id
        data['refresh'] = str(refresh)
        data['access'] = str(refresh.access_token)
        return data

'''
WeChat Crypt
'''
class WeChatCrypt:
    def __init__(self, appId, sessionKey):
        self.appId = appId
        self.sessionKey = sessionKey

    def decrypt(self, encryptedData, iv):
        # base64 decode
        sessionKey = base64.b64decode(self.sessionKey)
        encryptedData = base64.b64decode(encryptedData)
        iv = base64.b64decode(iv)
        cipher = AES.new(sessionKey, AES.MODE_CBC, iv)
        decrypted = json.loads(self._unpad(cipher.decrypt(encryptedData)))

        if decrypted['watermark']['appid'] != self.appId:
            raise Exception('Invalid Buffer')

        return decrypted

    def _unpad(self, s):
        return s[:-ord(s[len(s)-1:])]

#获取微信用户的openid等用户信息

def get_wechat_login_code_url(jscode):
    api_url = 'https://api.weixin.qq.com/sns/jscode2session?appid={0}&secret={1}&js_code={2}&grant_type=authorization_code'
    get_url = api_url.format(WX_XCX_APPID,WX_XCX_APPSECRET,jscode)
    r = requests.get(get_url)
    return r


#微信小程序登录接口
class WeChatXCXLoginAPIView(APIView):
    """
    post:
    微信小程序登录接口
    微信小程序code获取openid
    """
    permission_classes = []
    authentication_classes = []

    @transaction.atomic  # 开启事务,当方法执行完成以后，自动提交事务
    def post(self, request):
        jscode = get_parameter_dic(request)['code']
        inviter = get_parameter_dic(request).get('inviter')#为推广者的userid
        if not jscode:
            return ErrorResponse(msg="code不能为空")
        resp = get_wechat_login_code_url(jscode)
        openid = None
        session_key = None
        unionid = None
        if resp.status_code != 200:
            return ErrorResponse(msg="服务器到微信网络连接失败，请重试")
        # json_data = {'errcode':0,'openid':'111','session_key':'test'}
        json_data =json.loads(resp.content)
        if 'errcode' in json_data:#如果获取失败返回失败信息
            return ErrorResponse(msg=json_data['errmsg'])

        openid = json_data['openid']
        session_key = json_data['session_key']

        if "unionid" in json_data:
            unionid = json_data['unionid']

        # 判断用户是否存在
        try:
            wxuser = Users.objects.get(username=openid)
            wxuser.oauthwxuser.session_key = session_key  # 小写oauthwxuser 表示关联的外键
            wxuser.oauthwxuser.xcx_openid = openid
            wxuser.oauthwxuser.unionId = unionid
            wxuser.oauthwxuser.save()
            resdata = XCXLoginSerializer.get_token(wxuser)
            return SuccessResponse(data=resdata, msg="success")
        except Exception as e:
            with transaction.atomic():
                savepoint = transaction.savepoint()
                user = Users()
                user.username = openid
                user.password = uuid.uuid4()  # 先随机生成一个密码，防止别人获取openid直接被登录情况
                user.identity = [0]  # 用户身份0表示普通用户
                user.save()
                OAuthWXUser.objects.create(user=user,session_key=session_key,xcx_openid=openid,unionid=unionid)
                # if inviter:  # 如果存在邀请码
                #     integral = FenXiaoManage.objects.filter(type=1, status=True).values_list('content', flat=True).first()
                #     if integral:  # 如果推广积分活动还存在
                #         Users.objects.filter(id=inviter).update(integral=F('integral') + int(integral))
                #         InviteRecord.objects.create(inv_user_id=inviter, invitee_user=user, get_integral=integral)
                #         IntegralRecord.objects.create(user_id=inviter,type=4,income=1,integral=integral)
                # 清除保存点
                transaction.savepoint_commit(savepoint)
                resdata = XCXLoginSerializer.get_token(user)
                return SuccessResponse(data=resdata, msg="success")


def filter_emoji(desstr, restr=''):
    # 过滤表情
    try:
        res = re.compile(u'[\U00010000-\U0010ffff]')
    except re.error:
        res = re.compile(u'[\uD800-\uDBFF][\uDC00-\uDFFF]')
    return res.sub(restr, desstr)

#微信小程序手机号授权登录接口
class WeChatXCXMobileLoginAPIView(APIView):
    """
    post:
    微信小程序手机号授权登录接口
    微信小程序code获取openid，并解密前端传的手机号encryptedData加密数据
    """
    permission_classes = []
    authentication_classes = []

    def post(self, request):
        inviter = get_parameter_dic(request).get('inviter')#邀请码#为推广者的userid
        jscode = get_parameter_dic(request)['code']
        iv = get_parameter_dic(request)['iv']
        encryptedData = get_parameter_dic(request)['encryptedData']
        nickname = get_parameter_dic(request)['nickname']
        avatar_url = get_parameter_dic(request)['avatar_url']
        gender = get_parameter_dic(request)['gender']
        nickname = filter_emoji(nickname, '')
        if jscode is None:
            return ErrorResponse(msg="code不能为空")
        if iv is None:
            return ErrorResponse(msg="iv不能为空")
        if encryptedData is None:
            return ErrorResponse(msg="encryptedData不能为空")
        if avatar_url is None:
            return ErrorResponse(msg="avatar_url不能为空")

        resp = get_wechat_login_code_url(jscode)
        openid = None
        session_key = None
        unionid = ""
        if resp.status_code != 200:
            return ErrorResponse(msg="服务器到微信网络连接失败，请重试")
        # json_data = {'errcode':0,'openid':'111','session_key':'test'}
        json_data =json.loads(resp.content)
        if 'errcode' in json_data:#如果获取失败返回失败信息
            return ErrorResponse(msg=json_data['errmsg'])

        openid = json_data['openid']
        session_key = json_data['session_key']

        if "unionid" in json_data:
            unionid = json_data['unionid']

        wxdc = WeChatCrypt(WX_XCX_APPID, session_key)

        pResult = wxdc.decrypt(encryptedData, iv)

        #判断用户是否存在
        try:
            wxuser = Users.objects.get(username = openid)
            if not wxuser.is_active:
                return ErrorResponse(msg="该用户已禁用，请联系管理员")
            wxuser.oauthwxuser.session_key = session_key#小写oauthwxuser 表示关联的外键
            wxuser.oauthwxuser.xcx_openid = openid
            wxuser.oauthwxuser.unionId = unionid
            wxuser.oauthwxuser.avatarUrl=avatar_url
            wxuser.oauthwxuser.sex = gender
            wxuser.oauthwxuser.mobilePhoneNumber = pResult['phoneNumber']
            wxuser.oauthwxuser.nick = nickname
            wxuser.oauthwxuser.save()
            wxuser.nickname = nickname
            wxuser.avatar = avatar_url
            wxuser.gender = gender
            wxuser.save()
            resdata  = XCXLoginSerializer.get_token(wxuser)
            return SuccessResponse(data=resdata,msg="success")
        except Exception as e:#新用户
            with transaction.atomic():
                try:
                    savepoint = transaction.savepoint()
                    user = Users()
                    user.username = openid
                    user.password = uuid.uuid4() #先随机生成一个密码，防止别人获取openid直接被登录情况
                    user.identity=[0]#用户身份0表示普通用户
                    user.nickname = nickname
                    user.name = nickname
                    user.avatar = avatar_url
                    user.mobile = pResult['phoneNumber']
                    user.save()
                    OAuthWXUser.objects.create(user=user,session_key=session_key,xcx_openid=openid,avatarUrl=avatar_url,sex=gender,mobilePhoneNumber=pResult['phoneNumber'],nick=nickname)
                    # if inviter:#如果存在邀请码
                    #     integral = FenXiaoManage.objects.filter(type=1,status=True).values_list('content',flat=True).first()
                    #     if integral:#如果推广积分活动还存在
                    #         Users.objects.filter(id=inviter).update(integral=F('integral')+int(integral))
                    #         InviteRecord.objects.create(inv_user_id=inviter,invitee_user=user,get_integral=integral)
                    #         IntegralRecord.objects.create(user_id=inviter, type=4, income=1, integral=integral)
                except Exception as e:
                    transaction.savepoint_rollback(savepoint)
                    return ErrorResponse(msg=str(e))
                # 清除保存点
                transaction.savepoint_commit(savepoint)
                resdata = XCXLoginSerializer.get_token(user)
                return SuccessResponse(data=resdata, msg="success")





#微信小程序更新（获取）用户信息wx.getUserInfo,用户解密获取的用户信息
class XCXWeChatUserInfoUpdateAPIView(APIView):
    """
    post:
    微信小程序更新用户信息
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def post(self, request):
        encryptedData = get_parameter_dic(request)['encryptedData']
        iv = get_parameter_dic(request)['iv']

        if not encryptedData:
            return ErrorResponse(msg="encryptedData不能为空")

        if not iv:
            return ErrorResponse(msg="iv不能为空")

        wechat_user = OAuthWXUser.objects.filter(user=request.user).first()
        if not wechat_user:
            return ErrorResponse(msg="无此用户")

        pc = WeChatCrypt(WX_XCX_APPID, wechat_user.session_key)

        user = pc.decrypt(encryptedData, iv)
        wechat_user.nick = user['nickName']
        wechat_user.sex = user['gender']
        wechat_user.city = user['city']
        wechat_user.avatarUrl = user['avatarUrl']
        wechat_user.save()
        myuser = request.user
        myuser.nickname = user['nickName']
        myuser.avatar = user['avatarUrl']


        return SuccessResponse(data=user,msg="success")


# ================================================= #
# ************** 微信小程序生成推广小程序码view  ************** #
# ================================================= #
#获取小程序的access_token
"""
正常返回，access_token 的有效期目前为 2 个小时，重复获取将导致上次获取的 access_token 失效
{"access_token":"ACCESS_TOKEN","expires_in":7200}
错误返回
{"errcode":40013,"errmsg":"invalid appid"}
"""
def get_wechat_xcx_access_token_url():
    api_url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid={0}&secret={1}"
    get_url = api_url.format(WX_XCX_APPID,WX_XCX_APPSECRET)
    r = requests.get(get_url)
    return r

#这个url生成二维码是无限个,返回的二维码是buffer类型(正式版小程序才能生成，体验版不行)
"""
正常返回
{
 "errcode": 0,
 "errmsg": "ok",
 "contentType": "image/jpeg",
 "buffer": Buffer
}
"""
def get_wechat_qrcode_url(access_token,scene,page,width=430,auto_color=True,is_hyaline=False):
    if not page:
        page = "pages/index/index"
    api_url = 'https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token={0}'
    get_url = api_url.format(access_token)
    headers = {"Content-type":"application/json"}
    data = dict(scene=scene,page=page,width=width,auto_color=auto_color,is_hyaline=is_hyaline)
    r = requests.post(url=get_url,data=json.dumps(data),headers=headers)
    return r

class GetXCXShareQrcodeView(APIView):
    """
    post:
    微信小程序获取推广二维码
    scene 分享用户的userid
    page 要跳转的页面
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    def post(self,request):
        scene = get_parameter_dic(request)['scene']#分享用户的userid
        page = get_parameter_dic(request)['page']
        if scene is None or page is None:
            return ErrorResponse("提交参数不能为空")
        restoken = get_wechat_xcx_access_token_url()
        if restoken.status_code != 200:
            return ErrorResponse(msg="服务器到微信网络连接失败，请重试1")
        json_data = json.loads(restoken.content)
        if 'errcode' in json_data and json_data['errcode'] !=0:  # 如果获取失败返回失败信息
            return ErrorResponse(msg=json_data['errmsg'])
        access_token = json_data['access_token']
        res = get_wechat_qrcode_url(access_token,scene,page)
        if res.status_code != 200:
            return ErrorResponse(msg="服务器到微信网络连接失败，请重试2")
        curr_time = datetime.datetime.now()
        time_path = curr_time.strftime("%Y-%m-%d")
        img_task_dir = "xcxqrcode"
        image_name = renameuploadimg('_QRcode.png')
        sub_path = os.path.join(settings.MEDIA_ROOT, img_task_dir, time_path)
        if not os.path.exists(sub_path):
            os.makedirs(sub_path)
        image_path = os.path.join(sub_path, image_name)
        web_img_url = DOMAIN_HOST + settings.MEDIA_URL + img_task_dir + "/" + time_path + "/" + image_name  # 绝对路径http://xxx.xxx.com/media/xxx/xxxx/xxx.png
        with open(image_path, 'wb') as f:
            f.write(res.content)
        json_data2 = web_img_url
        return SuccessResponse(data=json_data2,msg="success")


# ================================================= #
# ************** 微信小程序发送服务通知消息 view  ************** #
# ================================================= #
"""
1、form_id提交表单的id（支付时用）
2、data 提交的请求体
push_data={
    "keyword1":{
        "value":obj.order_sn
    },
    "keyword2":{
        "value":obj.time
    },
}
"""
def send_wx_xcx_message(access_token,openid,template_id,form_id,push_data):
    api_url = "https://api.weixin.qq.com/cgi-bin/message/subscribe/send?access_token={0}"
    get_url = api_url.format(access_token)
    payload={
        "touser": openid, #这里为用户的openid
        "template_id": template_id, #模板id
        "form_id": form_id, #表单id或者prepay_id
        "data": push_data
    }
    r = requests.post(get_url,json=payload)
    return r

def send_wx_xcx_message_cache(openid,template_id,form_id,push_data):
    access_token = cache.get('xcx_access_token')
    if access_token:#有缓存
        res = send_wx_xcx_message(access_token,openid,template_id,form_id,push_data)
        json_data = json.loads(res.content)
        if 'errcode' in json_data:  # 如果获取失败返回失败信息
            if json_data['errcode'] == 40001:
                restoken = get_wechat_xcx_access_token_url()
                json_data1 = json.loads(restoken.content)
                access_token1 = json_data1['access_token']
                res1 = send_wx_xcx_message(access_token1, openid, template_id, form_id, push_data)
                json_data2 = json.loads(res1.content)
                if 'errcode' in json_data2 and json_data2['errcode'] !=0:
                    logger.error("微信小程序发送消息服务错误，用户openid:%s，template_id:%s，form_id:%s，data:%s，微信返回错误信息：%s"%(openid,template_id,form_id,push_data,json_data2))
                    return False
                cache.set('xcx_access_token', access_token,7000)
                return True
    else:#无缓存
        restoken = get_wechat_xcx_access_token_url()
        json_data1 = json.loads(restoken.content)
        access_token1 = json_data1['access_token']
        res1 = send_wx_xcx_message(access_token1, openid, template_id, form_id, push_data)
        json_data2 = json.loads(res1.content)
        if 'errcode' in json_data2 and json_data2['errcode'] !=0:
            logger.error("微信小程序发送消息服务错误，用户openid:%s，template_id:%s，form_id:%s，data:%s，微信返回错误信息：%s" % (
            openid, template_id, form_id, push_data, json_data2))
            return False
        cache.set('xcx_access_token', access_token,7000)
        return True
# ================================================= #
# ************** 微信公众号app授权登录 view  ************** #
# ================================================= #

#通过 code 换取 access_token 和 openid,code为前端获取后传过来得
"""
正确返回
{
  "access_token": "ACCESS_TOKEN", 有效期2小时
  "expires_in": 7200,
  "refresh_token": "REFRESH_TOKEN",有效期30天
  "openid": "OPENID",
  "scope": "SCOPE",
  "unionid": "o6_bmasdasdsad6_2sgVt7hMZOPfL"
}
错误返回
{
  "errcode": 40029,
  "errmsg": "invalid code"
}
"""
def get_wechat_access_token_url(code):
    api_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid={0}&secret={1}&code={2}&grant_type=authorization_code"
    get_url = api_url.format(WX_GZPT_APPID,WX_GZPT_APPSECRET,code)
    r = requests.get(get_url)
    return r

#获取微信用户公开个人信息
"""
正确返回
{
  "openid": "OPENID",
  "nickname": "NICKNAME",
  "sex": 1,
  "province": "PROVINCE",
  "city": "CITY",
  "country": "COUNTRY",
  "headimgurl": "https://thirdwx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0",
  "privilege": ["PRIVILEGE1", "PRIVILEGE2"],
  "unionid": " o6_bmasdasdsad6_2sgVt7hMZOPfL"
}
错误返回
{
  "errcode": 40003,
  "errmsg": "invalid openid"
}
"""
def getWxUserInfo(access_token,openid):
    api_url = "https://api.weixin.qq.com/sns/userinfo?access_token={0}&openid={1}"
    get_url = api_url.format(access_token,openid)
    r = requests.get(get_url)
    return r

#检验授权凭证access_token 是否有效
"""
有效返回
{
  "errcode": 0,
  "errmsg": "ok"
}
"""
def is_access_token_valid(access_token, openid):
    api_url = "https://api.weixin.qq.com/sns/auth?access_token={0}&openid={1}"
    get_url = api_url.format(access_token, openid)
    r = requests.get(get_url)
    return r
#通过refresh_token刷新过期的access_token
"""
有效返回
{
  "access_token": "ACCESS_TOKEN",
  "expires_in": 7200,
  "refresh_token": "REFRESH_TOKEN",
  "openid": "OPENID",
  "scope": "SCOPE"
}
错误返回
{
  "errcode": 40030,
  "errmsg": "invalid refresh_token"
}
"""
def refresh_access_token(refresh_token):
    api_url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid={0}&grant_type=refresh_token&refresh_token={1}"
    get_url = api_url.format(WX_GZPT_APPID,refresh_token)
    r = requests.get(get_url)
    return r

#微信公众号app登录接口
class WeChatGZHLoginAPIView(APIView):
    """
    post:
    微信公众号登录接口
    微信公众号code获取openid和access_token
    """
    permission_classes = []
    authentication_classes = []

    def post(self, request):
        jscode = get_parameter_dic(request)['code']
        if not jscode:
            return ErrorResponse(msg="code不能为空")
        resp = get_wechat_access_token_url(jscode)
        openid = ""
        unionid = ""
        access_token = ""
        refresh_token = ""
        scope = None
        if resp.status_code != 200:
            return ErrorResponse(msg="服务器到微信网络连接失败，请重试")
        json_data =json.loads(resp.content)
        if 'errcode' in json_data and json_data['errcode'] !=0:#如果获取失败返回失败信息
            logger.error("微信app登录服务错误，用户提交code:%s，微信返回错误信息：%s" % (jscode, json_data))
            return ErrorResponse(msg=json_data['errmsg'])

        openid = json_data['openid']
        access_token = json_data['access_token']
        refresh_token = json_data['refresh_token']
        scope = json_data['scope']
        if "unionid" in json_data:
            unionid = json_data['unionid']

        #判断用户是否存在(根据openID判断用户是否是第一次登陆)
        user = Users.objects.filter(is_active=True,oauthwxuser__gzh_openid=openid).first()
        if not user:#如果不存在则提示绑定用户关系
            return ErrorResponse(code=301,data={'openid':openid,'is_bind':False},msg="无此用户，请先绑定")

        #返回token
        resdata  = XCXLoginSerializer.get_token(user)
        return SuccessResponse(data=resdata,msg="success")


class WeChatGZHBindAPIView(APIView):
    """
    绑定微信用户
    post:
    绑定微信用户
    微信公众号openid、mobile（绑定手机号）、code（验证码）
    """
    permission_classes = []
    authentication_classes = []

    def post(self,request):
        openid = get_parameter_dic(request)['openid']
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

        user = Users.objects.filter(is_active=True,username=mobile+"app",identity__contains="1",oauthwxuser__isnull=True).first()
        if not user:#如果不存在
            return ErrorResponse(msg="无法绑定，无此用户或已绑定")
        OAuthWXUser.objects.create(user=user,gzh_openid=openid)
        resdata = XCXLoginSerializer.get_token(user)
        return SuccessResponse(data=resdata,msg="success")

# ================================================= #
# ************** 字节跳动小程序登录 view  ************** #
# ================================================= #
#接口调用凭证getAccessToken，获取的access_token有效期2 小时，重复获取 access_token 会导致上次 access_token 失效。为了平滑过渡，新老 access_token 在 5 分钟内都可使用
def get_tt_access_token():
    """
    正确返回信息：
    {
      "err_no": 0,
      "err_tips": "success",
      "data": {
        "access_token": "0801121***********",
        "expires_in": 7200
      }
    }
    """
    api_url = "https://developer.toutiao.com/api/apps/v2/token"
    headers = {'Content-Type': 'application/json'}
    data = {'appid':TT_XCX_APPID,'secret':TT_XCX_APPSECRET,'grant_type':'client_credential'}
    r = requests.post(url=api_url,data=json.dumps(data),headers=headers)
    return r
#获取字节跳动code2Session（返回值有openid）
def get_tt_code2Session(code):
    """
    code：为前端小程序通过tt.login传过来的code
    小程序正确返回信息：
    {
      "err_no": 0,
      "err_tips": "success",
      "data": {
        "session_key": "hZy6t19VPjFqm********",
        "openid": "V3WvSshYq9******",
        "anonymous_openid": "",
        "unionid": "f7510d9ab***********"
      }
    }
    """
    api_url = 'https://developer.toutiao.com/api/apps/v2/jscode2session'
    headers = {'Content-Type': 'application/json'}
    data = {'appid': TT_XCX_APPID, 'secret': TT_XCX_APPSECRET, 'code': code}
    r = requests.post(url=api_url, data=json.dumps(data), headers=headers)
    return r

#字节跳动小程序登录接口
class TTXCXLoginAPIView(APIView):
    """
    post:
    字节跳动小程序登录接口
    字节跳动小程序code获取openid
    """
    permission_classes = []
    authentication_classes = []

    @transaction.atomic  # 开启事务,当方法执行完成以后，自动提交事务
    def post(self, request):
        jscode = get_parameter_dic(request)['code']
        nickname = get_parameter_dic(request)['nickname']
        avatar_url = get_parameter_dic(request)['avatar_url']
        gender = get_parameter_dic(request)['gender']
        if not jscode:
            return ErrorResponse(msg="code不能为空")
        resp = get_tt_code2Session(jscode)
        openid = None
        session_key = None
        unionid = None
        if resp.status_code != 200:
            return ErrorResponse(msg="服务器到微信网络连接失败，请重试")
        # json_data = {'errcode':0,'openid':'111','session_key':'test'}
        json_data =json.loads(resp.content)
        if not int(json_data['err_no']) ==0:#如果获取失败返回失败信息
            print(json_data)
            return ErrorResponse(msg=json_data['err_tips'])

        openid = json_data['data']['openid']
        session_key = json_data['data']['session_key']

        if "unionid" in json_data:
            unionid = json_data['data']['unionid']

        # 判断用户是否存在
        try:
            wxuser = Users.objects.get(username=openid)
            if not wxuser.is_active:
                return ErrorResponse(msg="该用户已禁用，请联系管理员")
            wxuser.oauthwxuser.session_key = session_key  # 小写oauthwxuser 表示关联的外键
            wxuser.oauthwxuser.xcx_openid = openid
            wxuser.oauthwxuser.unionId = unionid
            wxuser.oauthwxuser.avatarUrl = avatar_url
            wxuser.oauthwxuser.sex = gender
            wxuser.oauthwxuser.nick = nickname
            wxuser.oauthwxuser.save()
            wxuser.nickname = nickname
            wxuser.avatar = avatar_url
            wxuser.gender = gender
            wxuser.save()
            resdata = XCXLoginSerializer.get_token(wxuser)
            return SuccessResponse(data=resdata, msg="success")
        except Exception as e:  # 新用户
            with transaction.atomic():
                try:
                    savepoint = transaction.savepoint()
                    user = Users()
                    user.username = openid
                    user.password = uuid.uuid4()  # 先随机生成一个密码，防止别人获取openid直接被登录情况
                    user.identity = 3 # 用户身份3表示前端普通用户
                    user.nickname = nickname
                    user.name = nickname
                    user.avatar = avatar_url
                    user.save()
                    OAuthWXUser.objects.create(user=user, session_key=session_key, xcx_openid=openid,avatarUrl=avatar_url, sex=gender, nick=nickname)
                except Exception as e:
                    transaction.savepoint_rollback(savepoint)
                    return ErrorResponse(msg=str(e))
                # 清除保存点
                transaction.savepoint_commit(savepoint)
                resdata = XCXLoginSerializer.get_token(user)
                return SuccessResponse(data=resdata, msg="success")
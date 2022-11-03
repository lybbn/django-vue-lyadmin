import os
from application.settings import BASE_DIR
# BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ================================================= #
# ************** mysql数据库 配置  ************** #
# ================================================= #
# 数据库地址
DATABASE_ENGINE = "django.db.backends.mysql"
# 数据库地址
DATABASE_HOST = "127.0.0.1"
# 数据库端口
DATABASE_PORT = 3306
# 数据库用户名
DATABASE_USER = "root"
# 数据库密码
DATABASE_PASSWORD = "root"
# 数据库名
DATABASE_NAME = "lyadmin_db"
#数据库编码
DATABASE_CHARSET = "utf8mb4"
# 数据库长连接时间（默认为0，单位秒）即每次请求都重新连接,debug模式下该值应该写为0 ，mysql默认长连接超时时间为8小时
DATABASE_CONN_MAX_AGE = 0 #推荐120（2分钟），使用 None 则是无限的持久连接（不推荐）。

# ================================================= #
# ************** 服务器基本 配置  ************** #
# ================================================= #

IS_DEMO = False #是否演示模式（演示模式只能查看无法保存、编辑、删除、新增）
IS_SINGLE_TOKEN = False #是否只允许单用户单一地点登录(只有一个人在线上)(默认多地点登录),只针对后台用户生效
ALLOW_FRONTEND = True#是否关闭前端API访问
FRONTEND_API_LIST = ['/api/app/','/api/xcx/','/api/h5/']#微服务前端接口前缀
DOMAIN_HOST = "http://127.0.0.1:8000"
EXEC_LOG_PATH =  os.path.join(BASE_DIR, 'logs','lybbnexec.log')
TEMP_EXEC_PATH =  os.path.join(BASE_DIR, 'logs')

# ================================================= #
# ************** 极光推送 配置  ************** #
# ================================================= #

JIGUANG_APPKEY = "141990xxxx"
JIGUANG_SECRET = "b26b91xxxxxxxxxxxxxxxx"

# ================================================= #
# ************** 快递100 配置  ************** #
# ================================================= #

KUAIDI100_KEY = "xxx" # 客户授权key
KUAIDI100_CUSTOMER = "xxx" #查询公司编号

# ================================================= #
# ************** 字节跳动（抖音）小程序 配置  ************** #
# ================================================= #
#小程序appid
TT_XCX_APPID = "xxxxxxxxxxxxx"
#小程序秘钥
TT_XCX_APPSECRET = "xxxxxxxxxxxxxxxxxx"

# ================================================= #
# ************** 微信小程序 配置  ************** #
# ================================================= #
#小程序appid
WX_XCX_APPID = "xxxxxxxxxxxxxxxxxx"
#小程序秘钥
WX_XCX_APPSECRET = "xxxxxxxxxxxxxxxxxxxxxx"

# ================================================= #
# ************** 微信开放平台（服务号） 配置  ************** #
# ================================================= #

#微信公众平台申请的appid
WX_GZPT_APPID = "XXXXXXXXXXXXXX"
#微信公众平台申请的appsecret
WX_GZPT_APPSECRET = "XXXXXXXXXXXXXXXXXXXXXXXX"

# ================================================= #
# ************** 微信公众号（服务号） 配置  ************** #
# ================================================= #
#微信官网测试公众号申请：http://mp.weixin.qq.com/debug/cgi-bin/sandbox?t=sandbox/login
#微信公众号appid
WX_GZH_APPID = "xxxxxxxxxxxxxxxxx"
#微信公众号秘钥
WX_GZH_APPSECRET = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#微信公众号--服务器配置：服务器域名
WX_GZH_DOMAIN = "http://django-vue-lyadmin.lybbn.cn/"
#微信公众号--服务器配置：TOKEN
WX_GZH_TOKEN = "django-vue-lyadmin"
# #微信公众号——证书路径
# # WX_GZH_KEYSPATH = os.path.join(BASE_DIR, 'keys')
# # WX_GZH_MCH_CERT= os.path.join(WX_GZH_KEYSPATH, r"apiclient_cert.pem"),
# # WX_GZH_MCH_KEY= os.path.join(WX_GZH_KEYSPATH, r"apiclient_key.pem"),

# ================================================= #
# ************** 阿里云发送短信 配置  ************** #
# ================================================= #
# ACCESS_KEY_ID/ACCESS_KEY_SECRET 根据实际申请的账号信息进行替换
ALIYUN_SMS_ACCESS_KEY_ID = "xxxxxxxxxxxxx"
ALIYUN_SMS_ACCESS_KEY_SECRET = "xxxxxxxxxxxxxxxxxxxxxxx"
ALIYUN_SMS_SIGN='xxx'#短信签名名称
ALIYUM_SMS_TEMPLATE='SMS_221xxxxx'#模板code

# ================================================= #
# ************** 腾讯云发送短信 配置  ************** #
# ================================================= #
# SECRETID/SECRETKEY 根据实际申请的账号信息进行替换
TENCENT_SMS_SECRETID = "xxxxxxxxxxxxxxxxxxxxxxxx"#CAM ID
TENCENT_SMS_SECRETKEY = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"#CAM密匙
TENCENT_SMS_APPID = "14003xxxxx"#SdkAppId
TENCENT_SMS_SIGN='lybbn测试名称'#短信签名名称
TENCENT_SMS_TEMPLATE_ID='65xxxx'#模板id

# ================================================= #
# ************** 微信支付 配置  ************** #
# ================================================= #
"""
发起企业付款时需携带的证书
登录微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->证书下载
下载apiclient_cert.p12
python无法使用双向证书，使用openssl导出：(从微信下载的证书已经有pem，无需再使用openssl导出操作)
    openssl pkcs12 -clcerts -nokeys -in apiclient_cert.p12 -out apiclient_cert.pem
    openssl pkcs12 -nocerts -in apiclient_cert.p12 -out apiclient_key.pem
导出apiclient_key.pem时需输入PEM phrase, 此后每次发起请求均要输入，可使用openssl解除：
    openssl rsa -in apiclient_key.pem -out apiclient_key.pem.unsecure
"""

# 微信支付相关
WXPAY_APPID = 'wx023axxxxxx'#微信小程序支付（'微信分配的公众账号ID'\申请商户号的appid或商户号绑定的appid）
WXPAY_APPID_APP = 'wxc5155xxxxx'#'微信app支付（app支付为开放平台申请的appid）
WXPAY_MCHID = 'xxxxxxxxxxxx'#'商户号'
WXPAY_APIKEY = 'C1098Dxxxxxxxxx0978A8F4B291C1'#v3
WXPAY_SERIAL_NO = "7367035E134xxxxxxxxxFED20C5071E83341"#商户号证书序列号，登录商户平台【API安全】->【API证书】->【查看证书】，可查看商户API证书序列号

# 服务器存放证书路径（微信支付签发的）
WXPAY_CLIENT_CERT_PATH = os.path.join(BASE_DIR, 'key', 'apiclient_cert.pem')
WXPAY_CLIENT_KEY_PATH = os.path.join(BASE_DIR, 'key', 'apiclient_key.pem')

WXPAY_CERT_DIR = os.path.join(BASE_DIR, 'key')#微信支付证书缓存路径
WXPAY_CERT_DIR_RESPONSE = os.path.join(WXPAY_CERT_DIR, 'wechatpay_response_key')#微信支付证书缓存路径

# ================================================= #
# ************** 支付宝支付APP 配置  ************** #
# ================================================= #
"""
使用OpenSSL生成证书app_private_key.pem（私钥）、app_public_key.pem（公钥）
1. 生成私钥
genrsa -out app_private_key.pem 2048
2. 生成公钥
rsa -in app_private_key.pem -pubout -out app_public_key.pem

注意 1和2步骤也可以使用支付宝自己得签名工具（支付宝开放平台开发助手）生成签名来完成（签名工具秘钥长度选择-RSA2）

3.cat app_public_key.pem 查看公钥的内容

将-----BEGIN PUBLIC KEY-----和-----END PUBLIC KEY-----中间的内容保存在支付宝的用户配置中（沙箱或者正式）

https://openhome.alipay.com/platform/appDaily.htm?tab=info

4.配置好公钥后，支付宝会生成公钥，将公钥的内容复制保存到一个文本文件中(alipay_public_key.pem)，注意需要在文本的首尾添加标记位(-----BEGIN PUBLIC KEY-----和-----END PUBLIC KEY-----) 

5.将刚刚生成的私钥app_private_key.pem和支付宝公钥alipay_public_key.pem放到我们的项目目录中
"""

ALIPAY_APPID = 'xxxxxxxxxxxxxxxxxx'

# 服务器存放证书路径（支付宝支付签发的）
ALIPAY_PRIVATE_KEY_PATH = os.path.join(BASE_DIR, 'key', 'app_private_key.pem')
ALIPAY_PUBLIC_KEY_PATH = os.path.join(BASE_DIR, 'key', 'alipay_public_key.pem')
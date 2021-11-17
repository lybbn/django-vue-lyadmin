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
# 数据库长连接时间（默认为0）即每次请求都重新连接,debug模式下该值应该写为0 ，mysql默认长连接超时时间为8小时
DATABASE_CONN_MAX_AG = 0 #2小时

# ================================================= #
# ************** 服务器基本 配置  ************** #
# ================================================= #

DOMAIN_HOST = "http://127.0.0.1:8000"

# ================================================= #
# ************** 微信小程序 配置  ************** #
# ================================================= #
#小程序appid
WX_XCX_APPID = "xxxxxxxxxxxxxxxxxx"
#小程序秘钥
WX_XCX_APPSECRET = "xxxxxxxxxxxxxxxxxxxxxx"


# ================================================= #
# ************** 微信公众平台（服务号） 配置  ************** #
# ================================================= #

#微信公众平台申请的appid
WX_GZPT_APPID = "XXXXXXXXXXXXXX"
#微信公众平台申请的appsecret
WX_GZPT_APPSECRET = "XXXXXXXXXXXXXXXXXXXXXXXX"

# ================================================= #
# ************** 微信公众号（服务号） 配置  ************** #
# ================================================= #
#微信公众号appid
WX_GZH_APPID = "xxxxxxxxxxxxxxxxx"
#微信公众号秘钥
WX_GZH_APPSECRET = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#微信公众号——服务器域名
# WX_GZH_DOMAIN = "http://www.xxxx.com/"
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
WXPAY_APPID = 'xxxxxxxxxxxxxxxx'#'微信分配的公众账号ID'\申请商户号的appid或商户号绑定的appid
WXPAY_MCHID = 'xxxxxxxxxxxx'#'商户号'
WXPAY_APIKEY = '商户平台设置的密钥KEY'

# 服务器存放证书路径（微信支付签发的）
WXPAY_CLIENT_CERT_PATH = os.path.join(BASE_DIR, 'key', 'apiclient_cert.pem')
WXPAY_CLIENT_KEY_PATH = os.path.join(BASE_DIR, 'key', 'apiclient_key.pem')
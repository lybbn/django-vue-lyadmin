
from urllib import parse
import hashlib
import json
import math
from urllib.request  import urlopen
import requests
from math import radians, cos, sin, asin, sqrt, degrees, atan2
from django.db.models.expressions import RawSQL

# ================================================= #
# ******************** 根据经度纬度匹配最近的点 ******************** #
# ================================================= #
def validate_point(lat,lon):
    assert -90 <= lat <= 90, "bad latitude"
    assert -180 <= lon <= 180, "bad longitude"

# original formula from  http://www.movable-type.co.uk/scripts/latlong.html
def distance_haversine(lat1, lon1, lat2, lon2):
    """
    Calculate the great circle distance between two points
    on the earth (specified in decimal degrees)
    Haversine
    formula:
        a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
                        _   ____
        c = 2 ⋅ atan2( √a, √(1−a) )
        d = R ⋅ c

    where   φ is latitude, λ is longitude, R is earth’s radius (mean radius = 6,371km);
            note that angles need to be in radians to pass to trig functions!
    """

    validate_point(lat1, lon1)
    validate_point(lat2, lon2)


    R = 6371 # km - earths's radius

    # convert decimal degrees to radians
    lat1, lon1, lat2, lon2 = map(radians, [lat1, lon1, lat2, lon2])

    # haversine formula
    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a)) # 2 * atan2(sqrt(a), sqrt(1-a))
    d = R * c
    return d


#根据经纬度匹配最近的商家，按distance距离排序
def get_locations_nearby_queryset(queryset,latitude, longitude, max_distance=None):
    """
    Return objects sorted by distance to specified coordinates
    which distance is less than max_distance given in kilometers
    queryset 要查询的商家的查询集
    latitude 纬度
    longitude 经度
    max_distance 自定义的最大查询距离：自带单位km
    """
    # Great circle distance formula
    gcd_formula = "6371 * acos(least(greatest(\
    cos(radians(%s)) * cos(radians(latitude)) \
    * cos(radians(longitude) - radians(%s)) + \
    sin(radians(%s)) * sin(radians(latitude)) \
    , -1), 1))"
    distance_raw_sql = RawSQL(
        gcd_formula,
        (latitude, longitude, latitude)
    )
    qs = queryset.annotate(distance=distance_raw_sql).order_by('distance')
    if max_distance is not None:
        qs = qs.filter(distance__lt=max_distance)
    return qs

# ================================================= #
# ******************** 百度地图详细地址解析成经纬度 ******************** #
# ================================================= #

ak = 'LYGmcld2pgHXuocf4bqsyHABEfT9lf1B'
sk = 'gAaECvBKFjeuLzlwVKNp5r80MRA7zMMe'

# 百度地图根据详细地址获取经纬度
def getbaidulnglat(address):

    # 以get请求为例http://api.map.baidu.com/geocoder/v2/?address=百度大厦&output=json&ak=你的ak
    queryStr = '/geocoding/v3/?address=%s&output=json&ak=%s' % (address,ak)


    # 对queryStr进行转码，safe内的保留字符不转换
    encodedStr = parse.quote(queryStr, safe="/:=&?#+!$,;'@()*[]")

    # 在最后直接追加上yoursk
    rawStr = encodedStr + sk

    # 计算sn
    sn = (hashlib.md5(parse.quote_plus(rawStr).encode("utf8")).hexdigest())

    # 由于URL里面含有中文，所以需要用parse.quote进行处理，然后返回最终可调用的url
    uri = parse.quote("http://api.map.baidu.com" +queryStr +"&sn=" +sn, safe="/:=&?#+!$,;'@()*[]")

    # print(uri)
    try:
        req = urlopen(uri)
        res = req.read().decode()
        temp = json.loads(res)
        # print(temp)
        # 纬度
        lat = temp['result']['location']['lat']
        # 经度
        lng = temp['result']['location']['lng']
        # 地址查找失败
        if math.isclose(lat, 39.910925, rel_tol=1e-5):
            lat = None
        if math.isclose(lng, 116.413384, rel_tol=1e-5):
            lng = None
    except Exception as e:
        # print(e)
        lng = None
        lat = None

    return {'lng':lng,'lat':lat}


def computeMD5(message):
    m = hashlib.md5()
    m.update(message.encode(encoding='utf-8'))
    return m.hexdigest()
# ================================================================= #
# ******************** 腾讯地图详细地址解析成经纬度 ******************** #
# =================================================================#
#限制 10,000 次/日
#限制 并发 5 次/秒
key = "M4NBZ-STTK5-OARIA-Q7T4R-YO5OQ-MTB7O"
secretkey='uCUAQVJKvx5OgvHuOYK5uFzI0CdisBvm'
def gettecentlnglat(address):
    # url = 'https://apis.map.qq.com/ws/geocoder/v1/?address='+address+'&key='+key
    queryStr1 = '/ws/geocoder/v1/'
    queryStr2 = 'address='+address+'&key='+key
    # 计算sig
    sig = computeMD5(queryStr1+'?'+queryStr2+secretkey)
    url = 'https://apis.map.qq.com'+queryStr1+'?'+queryStr2+'&sig='+sig
    try:
        response = requests.get(url)
        res = response.json()
        # print(res)
        # 纬度
        lat = res['result']['location']['lat']
        # 经度
        lng = res['result']['location']['lng']
    except Exception as e:
        lng = None
        lat = None

    return {'lng': lng, 'lat': lat}

# {
#     "status": 0,
#     "message": "query ok",
#     "result": {
#         "title": "海淀西大街74号",
#         "location": {
#             "lng": 116.307015,
#             "lat": 39.982915
#         },
#         "ad_info": {
#             "adcode": "110108"
#         },
#         "address_components": {
#             "province": "北京市",
#             "city": "北京市",
#             "district": "海淀区",
#             "street": "海淀西大街",
#             "street_number": "74"
#         },
#         "similarity": 0.8,
#         "deviation": 1000,
#         "reliability": 7,
#         "level": 9
#     }
# }

# ========================================================================= #
# ******************** 腾讯地图逆地址解析-经纬度解析成地址信息 ******************** #
# =========================================================================#
def gettecentaddress(location):
    """
    location=lat<纬度>,lng<经度>
    例如：location= 39.984154,116.307490
    """
    # url = 'https://apis.map.qq.com/ws/geocoder/v1/?address='+address+'&key='+key
    queryStr1 = '/ws/geocoder/v1/'
    queryStr2 = 'key='+key+'&location='+location
    # 计算sig
    sig = computeMD5(queryStr1+'?'+queryStr2+secretkey)
    url = 'https://apis.map.qq.com'+queryStr1+'?'+queryStr2+'&sig='+sig
    try:
        response = requests.get(url)
        res = response.json()
        # print(res)
    except Exception as e:
        res=None

    return res
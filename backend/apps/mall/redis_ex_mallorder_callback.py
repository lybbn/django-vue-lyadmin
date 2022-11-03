"""
django使用redis的过期回调通知-商城订单过期取消
注意：uwsgi部署需要开启enable-threads=true支持多线程
"""
from django_redis import get_redis_connection
import time
from apps.mall.models import OrderInfo
import logging
logger = logging.getLogger(__name__)
import random
import threading

# 连接redis数据库
client = get_redis_connection('carts')
# 创建pubsub对象，该对象订阅一个频道并侦听新消息：
pubsub = client.pubsub()


# 定义触发事件
def event_handler(msg):
    # print('Handler', msg)
    # print(msg['data'].decode('utf-8'))
    logger.info("收到商城订单redis过期回调：%s"%msg)
    if msg:
        thedata = str(msg['data']).split("mallorderexpire_")
        if len(thedata) == 2:
            orderid = thedata[1]
            # 获取订单对象
            order = OrderInfo.objects.filter(id=orderid).first()
            if order:
                # 判断用户是否已经付款
                if str(order.status) == "1":#待付款状态

                    # 取消订单,更改订单状态
                    OrderInfo.objects.filter(id=orderid).update(status="6")

                    # 获取订单中的所有商品
                    goods = order.ordergoodsskus.all()

                    # 遍历商品
                    for good in goods:
                        # 获取订单中的商品数量
                        count = good.count
                        # print(count)
                        # 获取sku商品
                        sku = good.sku
                        # 将库存重新增加到sku的stock中去
                        sku.stock += count
                        # 从销量中减去已经取消的数量
                        sku.sales -= count
                        sku.save()
                        spu = goods.sku.spu
                        spu.sales -= count
                        spu.save()
        logger.info("已处理收到商城订单redis过期回调：%s"%msg)

#订阅redis键空间通知
pubsub.psubscribe(**{'__keyevent@3__:expired': event_handler})

def sub():
    # 死循环,不停的接收订阅的通知
    while True:
        message = pubsub.get_message()
        if message:
            # print(message)
            pass
        else:
            time.sleep(0.01)

t = threading.Thread(target=sub)  #一般把此代码放在 apps.py ready方法中 在django启动时自动启动
t.daemon = True  #设置为守护线程 因为django 在启动时会执行检查代码和启动程序，当主进程杀死时,该线程结束
t.start()

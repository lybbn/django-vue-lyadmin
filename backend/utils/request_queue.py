"""
@author:lybbn
Request 请求队列（celery+redis）
"""
from celery import result
from utils.jsonResponse import DetailResponse
import logging
logger = logging.getLogger(__name__)


def get_result_by_taskid(task_id):
    """
    根据任务ID获取执行结果
    Return：AsyncResult对象结果：
    """
    # 异步执行
    res = result.AsyncResult(task_id)
    return res

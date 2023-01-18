# 从仓库拉取 带有 python  Linux 环境
FROM registry.cn-beijing.aliyuncs.com/django-vue-lyadmin/dvlyadmin-python3.11
# 设置环境变量
RUN mkdir /backend
# 工作目录切换到backend目录下
WORKDIR /backend
COPY ./backend/requirements.txt /

RUN pip3 install -r /requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
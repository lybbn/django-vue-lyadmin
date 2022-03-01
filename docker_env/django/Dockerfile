# 从仓库拉取 带有 python  Linux 环境
FROM registry.cn-beijing.aliyuncs.com/django-vue-lyadmin/python3.9
# 设置环境变量
ENV PYTHONUNBUFFERED 1
RUN mkdir /backend
# 工作目录切换到backend目录下
WORKDIR /backend
COPY ./backend/requirements.txt /
# 升级pip
RUN python -m pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple/

RUN python -m pip install -r /requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
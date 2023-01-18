# 从仓库拉取 带有 python  Linux 环境
FROM registry.cn-beijing.aliyuncs.com/django-vue-lyadmin/dvlyadmin-python3.11:1.3
# 设置环境变量
RUN mkdir /backend
# 工作目录切换到backend目录下
WORKDIR /backend
COPY ./backend/ .
RUN /bin/bash -c 'source ~/.bashrc && python3 -m pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/'
CMD ["/backend/docker_start.sh"]
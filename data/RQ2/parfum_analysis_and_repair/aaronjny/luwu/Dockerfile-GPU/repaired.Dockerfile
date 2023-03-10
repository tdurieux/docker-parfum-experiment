# 基础镜像
FROM tensorflow/tensorflow:2.4.1-gpu
# 创建文件夹
RUN mkdir /data
# 工作目录
WORKDIR /app
# 复制代码到镜像
COPY . /app
# 安装依赖
RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean
RUN apt-get update \
    && apt-get install -y --no-install-recommends git wget unzip build-essential\
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*
# Python依赖
RUN python setup.py install
# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 内部使用的端口
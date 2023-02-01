# 拉取golang镜像
# FROM golang:1.14.2-stretch
FROM golang:1.14.2-alpine3.11

# 设置镜像作者
LABEL MAINTAINER="302804389@qq.com"

ENV GOPROXY="https://goproxy.cn,direct" \
    GO111MODULE=on

# 创建目录,保存代码
RUN mkdir -p /opt/workspace/gin-app-start \
  && mkdir -p /data/gin-app-start/logs \
  && mkdir -p /opt/conf/

# 指定RUN、CMD与ENTRYPOINT命令的工作目录
WORKDIR /opt/workspace/gin-app-start

COPY go.mod .
COPY go.sum .
RUN go mod download

# 复制所有文件到工作目录
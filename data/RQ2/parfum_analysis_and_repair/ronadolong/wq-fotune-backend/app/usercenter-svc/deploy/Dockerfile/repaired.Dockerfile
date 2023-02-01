# 启动编译环境
FROM golang:1.16 as builder
WORKDIR /usr/src/app
#配置编译环境
RUN go env -w GOPROXY=https://goproxy.cn,direct
ARG TARGET_PATH

# 拷贝源代码
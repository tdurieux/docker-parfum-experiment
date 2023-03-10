FROM golang:1.12.1-alpine3.9

# 更新安装源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

WORKDIR /go/src/app

RUN apk update && \
 apk add --no-cache --virtual build-dependencies \
build-base \
gcc \
git

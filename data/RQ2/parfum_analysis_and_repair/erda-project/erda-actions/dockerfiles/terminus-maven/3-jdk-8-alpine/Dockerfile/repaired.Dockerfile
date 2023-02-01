# 升级时的备份镜像 registry.erda.cloud/erda/terminus-maven:3-jdk-8-alpine-back
# registry.erda.cloud/erda/terminus-maven:3-jdk-8-alpine
FROM alpine:3.12

# set repository
# https://pkgs.alpinelinux.org/packages?name=openjdk8-jre-lib&branch=edge
RUN echo "http://mirrors.aliyun.com/alpine/v3.12/main/" > /etc/apk/repositories && echo "http://mirrors.aliyun.com/alpine/v3.12/community/" >> /etc/apk/repositories

# adjust timezone
RUN apk add --no-cache tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  date && \
  apk del tzdata

# add other pkgs
RUN apk add --no-cache bash python2 python3 curl

# add openjdk8
ENV JAVA_VERSION 8u275
ENV JAVA_ALPINE_VERSION 8.275.01-r0
RUN apk upgrade --no-cache && apk add --no-cache openjdk8

# add maven, ref: https://github.com/carlossg/docker-maven/blob/master/openjdk-8/Dockerfile
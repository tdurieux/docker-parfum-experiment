FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5

MAINTAINER "Zexi Li <lizexi@yunionyun.com>"

ENV TZ Asia/Shanghai

RUN mkdir -p /opt/yunion/bin

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >>/etc/apk/repositories

RUN apk add --no-cache bash bash-completion tzdata ca-certificates vim ipmitool kubectl ceph-common && \
    rm -rf /var/cache/apk/*

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV PATH="/opt/yunion/bin:${PATH}"

RUN mkdir -p /opt/yunion/bin
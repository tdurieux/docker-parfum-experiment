FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5-1

MAINTAINER "Zexi Li <zexi.li@icloud.com>"

# HACK: use v3.14 alpine mirror to upgrade qemu-img
RUN echo http://dl-cdn.alpinelinux.org/alpine/v3.14/main > /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/v3.14/community >> /etc/apk/repositories

RUN apk update && \
    apk add --no-cache qemu-img && \
    rm -rf /var/cache/apk/*

# add executable file torrent
# make cmd/torrent
RUN mkdir -p /opt/yunion/bin
ADD ./_output/alpine-build/bin/torrent /opt/yunion/bin/torrent
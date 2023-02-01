FROM registry.cn-beijing.aliyuncs.com/yunionio/alpine-build:1.0-5 as build
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN mkdir -p /root/go/src/yunion.io/x/onecloud
COPY . /root/go/src/yunion.io/x/onecloud
RUN cd /root/go/src/yunion.io/x/onecloud && make cmd/torrent

FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5

MAINTAINER "Zexi Li <zexi.li@icloud.com>"

# HACK: use v3.14 alpine mirror to upgrade qemu-img
RUN echo http://dl-cdn.alpinelinux.org/alpine/v3.14/main > /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/v3.14/community >> /etc/apk/repositories

RUN apk update && \
    apk add --no-cache qemu-img && \
    rm -rf /var/cache/apk/*

# TAG=20210815.0
# add executable file torrent
# make cmd/torrent
RUN mkdir -p /opt/yunion/bin
COPY --from=build /root/go/src/yunion.io/x/onecloud/_output/bin/torrent /opt/yunion/bin/torrent
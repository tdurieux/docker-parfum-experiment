#################################################
# SmartIDE Developer Container Image
# Licensed under GPL v3.0
# Copyright (C) leansoftX.com
#################################################

FROM registry.cn-hangzhou.aliyuncs.com/smartide/smartide-node-v2:latest

USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    g++ gcc libc6-dev make pkg-config; \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG BUILD_GOLANG_VERSION
ENV GOLANG_VERSION=$BUILD_GOLANG_VERSION
ENV GOPATH=/home/smartide/go
ENV GOROOT=/usr/local/go
# go get -v  安装包需要，路径不能使用变量配置
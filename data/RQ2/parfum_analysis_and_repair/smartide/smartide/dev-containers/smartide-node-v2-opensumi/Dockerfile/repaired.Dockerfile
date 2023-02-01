#################################################
# SmartIDE Developer Container Image
# Licensed under GPL v3.0
# Copyright (C) leansoftX.com
#################################################

FROM registry.cn-hangzhou.aliyuncs.com/smartide/smartide-node-v2:latest

USER root

WORKDIR /home

RUN mkdir -p /release \
    && mkdir -p /home/smartide/.sumi/extensions

#复制IDE文件
COPY opensumi-release /release

#复制Extension文件
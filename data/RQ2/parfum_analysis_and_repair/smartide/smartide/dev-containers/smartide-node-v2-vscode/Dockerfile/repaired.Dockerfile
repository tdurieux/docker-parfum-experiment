#################################################
# SmartIDE Developer Container Image
# Licensed under GPL v3.0
# Copyright (C) leansoftX.com
#################################################

FROM --platform=$TARGETPLATFORM registry.cn-hangzhou.aliyuncs.com/smartide/smartide-node-v2:latest
ARG TARGETPLATFORM 
USER root

WORKDIR /home
#复制IDE文件
COPY openvscode-images-arm64 opvscode-arm64
COPY openvscode-images-amd64 opvscode-amd64



#复制IDE文件
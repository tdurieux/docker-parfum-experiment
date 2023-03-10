# 不带字体
# docker tag isahl/openjdk17:amd64 registry.cn-hangzhou.aliyuncs.com/taotao-cloud-project/taotao-cloud-openjdk17:amd64

FROM registry.cn-hangzhou.aliyuncs.com/taotao-cloud-project/taotao-cloud-openjdk17:amd64

USER root

RUN mkdir /skywalking

COPY ./skywalking-agent /skywalking/agent

#docker build -t registry.cn-hangzhou.aliyuncs.com/taotao-cloud-project/taotao-cloud-skywalking:8.8.1 .



# jre17 带字体
# docker tag sunrdocker/jdk17-jre-font-openssl-alpine:latest registry.cn-hangzhou.aliyuncs.com/taotao-cloud-project/taotao-cloud-openjdk17:jre-font
# docker push registry.cn-hangzhou.aliyuncs.com/taotao-cloud-project/taotao-cloud-openjdk17:jre-font

FROM registry.cn-hangzhou.aliyuncs.com/taotao-cloud-project/taotao-cloud-openjdk17:jre-font

USER root

RUN mkdir /skywalking

COPY ./skywalking-agent /skywalking/agent

# docker build -t registry.cn-hangzhou.aliyuncs.com/taotao-cloud-project/taotao-cloud-skywalking:8.8.1-jre-font .
# docker push registry.cn-hangzhou.aliyuncs.com/taotao-cloud-project/taotao-cloud-skywalking:8.8.1-jre-font
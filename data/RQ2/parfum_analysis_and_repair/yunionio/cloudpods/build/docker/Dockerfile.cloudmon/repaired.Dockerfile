FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5-1

MAINTAINER "Zexi Li <lizexi@yunionyun.com>"

RUN mkdir -p /etc/yunion/data/

ADD   ./_output/alpine-build/bin/cloudmon \
      /opt/yunion/bin/
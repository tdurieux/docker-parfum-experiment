FROM registry.cn-beijing.aliyuncs.com/yunionio/openvswitch:2.10.5-1

MAINTAINER "Yousong Zhou <zhouyousong@yunion.cn>"

ENV TZ UTC
RUN apk add --no-cache iproute2


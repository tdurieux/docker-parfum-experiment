FROM registry.cn-beijing.aliyuncs.com/yunionio/openvswitch:2.10.5-1

MAINTAINER "Yousong Zhou <zhouyousong@yunion.cn>"

ENV TZ UTC
RUN mkdir -p /opt/yunion/bin
ADD ./_output/alpine-build/bin/vpcagent /opt/yunion/bin/vpcagent
FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5-1

COPY ./build/esxi-agent/root/opt/ /opt/

ADD ./_output/alpine-build/bin/esxi-agent /opt/yunion/bin/esxi-agent
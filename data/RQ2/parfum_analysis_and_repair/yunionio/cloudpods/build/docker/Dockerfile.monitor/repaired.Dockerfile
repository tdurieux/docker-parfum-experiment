FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5-1

COPY ./build/monitor/root/opt/ /opt/
ADD ./_output/alpine-build/bin/monitor /opt/yunion/bin/monitor
FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5-1

COPY ./build/region/root/opt/ /opt/
ADD ./_output/alpine-build/bin/region /opt/yunion/bin/region
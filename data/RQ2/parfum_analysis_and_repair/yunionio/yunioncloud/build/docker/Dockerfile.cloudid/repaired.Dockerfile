FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5-1

COPY ./build/cloudid/root/opt/ /opt/
ADD ./_output/alpine-build/bin/cloudid /opt/yunion/bin/cloudid
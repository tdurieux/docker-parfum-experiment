FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5-1

RUN mkdir -p /opt/yunion/bin
ADD ./_output/alpine-build/bin/region-dns /opt/yunion/bin/region-dns
FROM registry.cn-beijing.aliyuncs.com/yunionio/climc-base:20210901

ADD ./build/climc/root/opt /opt

RUN cat /opt/yunion/scripts/motd/climc.sh >> /root/.bashrc

ADD ./_output/alpine-build/bin/climc ./_output/alpine-build/bin/*cli /opt/yunion/bin/
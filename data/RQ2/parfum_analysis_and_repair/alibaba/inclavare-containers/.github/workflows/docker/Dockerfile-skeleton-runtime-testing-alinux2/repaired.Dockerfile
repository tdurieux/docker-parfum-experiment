FROM registry.cn-hangzhou.aliyuncs.com/alinux/aliyunlinux:latest

LABEL maintainer="Shirong Hao <shirong@linux.alibaba.com>"

# Install alinux-release-experimentals prior to others to work around
# the issue "Error: Package: glibc-2.17-323.1.al7.i686 (updates)"
RUN yum install -y alinux-release-experimentals && rm -rf /var/cache/yum

ENV ALINUX2_PROTOBUF_VERSION 2.5.0
ENV ALINUX2_PROTOBUF_C_VERSION 1.0.2

RUN yum install -y \
    yum-utils wget tar gcc iptables libseccomp-devel make \
    libprotoc-devel binutils-devel autoconf libtool gcc-c++ pkg-config \
    protobuf-compiler-$ALINUX2_PROTOBUF_VERSION protobuf-devel-$ALINUX2_PROTOBUF_VERSION \
    protobuf-c-$ALINUX2_PROTOBUF_C_VERSION protobuf-c-devel-$ALINUX2_PROTOBUF_C_VERSION && rm -rf /var/cache/yum

# install docker
RUN yum install -y iptables && \
    wget https://download.docker.com/linux/static/stable/x86_64/docker-19.03.8.tgz && \
    tar -zxvf docker-19.03.8.tgz && mv docker/* /usr/bin && rm -rf docker && rm -f docker-19.03.8.tgz && rm -rf /var/cache/yum

# configure the rune runtime of docker
RUN mkdir -p /etc/docker && \
    echo -e "{\n\t\"runtimes\": {\n\t\t\"rune\": {\n\t\t\t\"path\": \"/usr/local/bin/rune\",\n\t\t\t\"runtimeArgs\": []\n\t\t}\n\t}\n}" >> /etc/docker/daemon.json

# Configure Alibaba Cloud TEE SDK yum repo
RUN yum-config-manager --add-repo \
    https://enclave-cn-beijing.oss-cn-beijing.aliyuncs.com/repo/alinux/enclave-expr.repo

# Install SGX Runtime
RUN yum install --nogpgcheck -y \
    libsgx-dcap-default-qpl libsgx-dcap-quote-verify libsgx-epid && rm -rf /var/cache/yum

WORKDIR /root

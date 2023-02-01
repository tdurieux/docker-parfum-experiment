FROM centos:7
LABEL maintainer "Takuya Takeuchi <takuya.takeuchi.dev@gmail.com>"

RUN yum update -y && yum install -y \
    ca-certificates \
    wget && rm -rf /var/cache/yum

# install vulkan sdk
ENV VULKAN_SDK_VERSION 1.2.162.0
WORKDIR /usr/share/vulkan
RUN wget https://sdk.lunarg.com/sdk/download/${VULKAN_SDK_VERSION}/linux/vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz?Human=true -O vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz
RUN tar -xf vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz && rm vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz
RUN rm vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz
ENV VULKAN_SDK /usr/share/vulkan/${VULKAN_SDK_VERSION}/x86_64

ENV LD_LIBRARY_PATH=$VULKAN_SDK/lib:$LD_LIBRARY_PATH

# install package to build
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rm -rf /var/cache/yum
RUN yum update -y && yum install -y \
    libX11-devel \
 && yum clean all && rm -rf /var/cache/yum

WORKDIR /
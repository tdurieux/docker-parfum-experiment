FROM ubuntu:16.04
LABEL maintainer "Takuya Takeuchi <takuya.takeuchi.dev@gmail.com>"

# install vulkan sdk
RUN apt-get update && apt install --no-install-recommends -y wget apt-transport-https && rm -rf /var/lib/apt/lists/*;

# install vulkan sdk
ENV VULKAN_SDK_VERSION 1.2.162.0
WORKDIR /usr/share/vulkan
RUN wget https://sdk.lunarg.com/sdk/download/${VULKAN_SDK_VERSION}/linux/vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz?Human=true -O vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz
RUN tar -xf vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz && rm vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz
RUN rm vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz
ENV VULKAN_SDK /usr/share/vulkan/${VULKAN_SDK_VERSION}/x86_64

ENV LD_LIBRARY_PATH=$VULKAN_SDK/lib:$LD_LIBRARY_PATH

# install package to build
RUN apt-get update && apt-get install --no-install-recommends -y \
    libx11-6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /
# devicedevex.azurecr.io/internal/iot-device-cube:1.0.0-ubuntu-cross-toolchain-arm32
# Usage example:
# docker build -t devicedevex.azurecr.io/internal/iot-device-cube:1.0.0-ubuntu-cross-toolchain-arm32 .
FROM ubuntu:18.04
ARG linaro_package_uri=https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf.tar.xz
ARG linaro_package_name=gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf
ARG target_cross_triple=arm-linux-gnueabihf

RUN mkdir -p /usr/xcc
WORKDIR /usr/xcc

# Prepare Linaro toolchain
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates xz-utils && \
    wget ${linaro_package_uri} && \
    tar -xf ${linaro_package_name}.tar.xz && \
    mv ${linaro_package_name} ${target_cross_triple} && \
    rm ${linaro_package_name}.tar.xz  && \
    apt-get remove -y wget ca-certificates xz-utils && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

# Set ENV
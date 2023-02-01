# devicedevex.azurecr.io/internal/iot-device-cube:1.0.0-ubuntu-arm64
# Usage example:
# docker build -t devicedevex.azurecr.io/internal/iot-device-cube:1.0.0-ubuntu-arm32 . --build-arg linaro_package_uri=https://releases.linaro.org/components/toolchain/binaries/6.3-2017.02/arm-linux-gnueabi/gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabi.tar.xz --build-arg linaro_package_name=gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabi --build-arg target_cross_triple=arm-linux-gnueabi --build-arg cmake_system_processor=arm
FROM ubuntu:18.04
ARG linaro_package_uri=https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz
ARG linaro_package_name=gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu
ARG target_cross_triple=aarch64-linux-gnu
ARG cmake_system_processor=aarch64

# Download toolchain
RUN mkdir -p /usr/xcc
WORKDIR /usr/xcc
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates xz-utils && \
    wget ${linaro_package_uri} && \
    tar -xf ${linaro_package_name}.tar.xz && \
    mv ${linaro_package_name} ${target_cross_triple} && \
    rm ${linaro_package_name}.tar.xz && \
    apt-get remove -y wget ca-certificates xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt autoremove -y

# Set ENV
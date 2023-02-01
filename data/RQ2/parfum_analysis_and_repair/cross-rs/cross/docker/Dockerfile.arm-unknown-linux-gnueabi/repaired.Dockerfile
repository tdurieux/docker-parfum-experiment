FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends \
    g++-arm-linux-gnueabi \
    libc6-dev-armel-cross && rm -rf /var/lib/apt/lists/*;

COPY deny-debian-packages.sh /
RUN TARGET_ARCH=armel /deny-debian-packages.sh \
    binutils \
    binutils-arm-linux-gnueabi

COPY qemu.sh /
RUN /qemu.sh arm

COPY qemu-runner /

ENV CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABI_LINKER=arm-linux-gnueabi-gcc \
    CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABI_RUNNER="/qemu-runner arm" \
    CC_arm_unknown_linux_gnueabi=arm-linux-gnueabi-gcc \
    CXX_arm_unknown_linux_gnueabi=arm-linux-gnueabi-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_arm_unknown_linux_gnueabi="--sysroot=/usr/arm-linux-gnueabi" \
    QEMU_LD_PREFIX=/usr/arm-linux-gnueabi \
    RUST_TEST_THREADS=1 \
    PKG_CONFIG_PATH="/usr/lib/arm-linux-gnueabi/pkgconfig/:${PKG_CONFIG_PATH}"

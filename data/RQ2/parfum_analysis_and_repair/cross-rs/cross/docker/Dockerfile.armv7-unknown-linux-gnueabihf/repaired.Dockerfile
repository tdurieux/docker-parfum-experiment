FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends \
    g++-arm-linux-gnueabihf \
    libc6-dev-armhf-cross && rm -rf /var/lib/apt/lists/*;

COPY deny-debian-packages.sh /
RUN TARGET_ARCH=armhf /deny-debian-packages.sh \
    binutils \
    binutils-arm-linux-gnueabihf

COPY qemu.sh /
RUN /qemu.sh arm softmmu

COPY dropbear.sh /
RUN /dropbear.sh

COPY linux-image.sh /
RUN /linux-image.sh armv7

COPY linux-runner /

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc \
    CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_RUNNER="/linux-runner armv7" \
    CC_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-gcc \
    CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_armv7_unknown_linux_gnueabihf="--sysroot=/usr/arm-linux-gnueabihf" \
    QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf \
    RUST_TEST_THREADS=1 \
    PKG_CONFIG_PATH="/usr/lib/arm-linux-gnueabihf/pkgconfig/:${PKG_CONFIG_PATH}"

FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY qemu.sh /
RUN /qemu.sh arm

COPY musl.sh /
RUN /musl.sh \
    TARGET=arm-linux-musleabi \
    "COMMON_CONFIG += --with-arch=armv7-a \
                      --with-float=soft \
                      --with-mode=thumb \
                      --with-mode=arm"

ENV CROSS_MUSL_SYSROOT=/usr/local/arm-linux-musleabi
COPY musl-symlink.sh /
RUN /musl-symlink.sh $CROSS_MUSL_SYSROOT arm

COPY qemu-runner /

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABI_LINKER=arm-linux-musleabi-gcc \
    CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABI_RUNNER="/qemu-runner armv7" \
    CC_armv7_unknown_linux_musleabi=arm-linux-musleabi-gcc \
    CXX_armv7_unknown_linux_musleabi=arm-linux-musleabi-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_armv7_unknown_linux_musleabi="--sysroot=$CROSS_MUSL_SYSROOT" \
    QEMU_LD_PREFIX=$CROSS_MUSL_SYSROOT \
    RUST_TEST_THREADS=1
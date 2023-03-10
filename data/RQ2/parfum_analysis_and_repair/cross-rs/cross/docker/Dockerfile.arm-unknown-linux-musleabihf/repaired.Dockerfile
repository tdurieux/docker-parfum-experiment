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
    TARGET=arm-linux-musleabihf \
    "COMMON_CONFIG += --with-arch=armv6 \
                      --with-fpu=vfp \
                      --with-float=hard \
                      --with-mode=arm"

ENV CROSS_MUSL_SYSROOT=/usr/local/arm-linux-musleabihf
COPY musl-symlink.sh /
RUN /musl-symlink.sh $CROSS_MUSL_SYSROOT armhf

COPY qemu-runner /

ENV CARGO_TARGET_ARM_UNKNOWN_LINUX_MUSLEABIHF_LINKER=arm-linux-musleabihf-gcc \
    CARGO_TARGET_ARM_UNKNOWN_LINUX_MUSLEABIHF_RUNNER="/qemu-runner arm" \
    CC_arm_unknown_linux_musleabihf=arm-linux-musleabihf-gcc \
    CXX_arm_unknown_linux_musleabihf=arm-linux-musleabihf-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_arm_unknown_linux_musleabihf="--sysroot=$CROSS_MUSL_SYSROOT" \
    QEMU_LD_PREFIX=$CROSS_MUSL_SYSROOT \
    RUST_TEST_THREADS=1
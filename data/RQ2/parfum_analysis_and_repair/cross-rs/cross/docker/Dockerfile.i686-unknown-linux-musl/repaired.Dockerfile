FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY musl.sh /
RUN /musl.sh TARGET=i686-linux-musl

COPY qemu.sh /
RUN /qemu.sh i386

ENV CROSS_MUSL_SYSROOT=/usr/local/i686-linux-musl
COPY musl-symlink.sh /
RUN /musl-symlink.sh $CROSS_MUSL_SYSROOT i386

COPY qemu-runner /

ENV CARGO_TARGET_I686_UNKNOWN_LINUX_MUSL_LINKER=i686-linux-musl-gcc \
    CARGO_TARGET_I686_UNKNOWN_LINUX_MUSL_RUNNER="/qemu-runner i686" \
    CC_i686_unknown_linux_musl=i686-linux-musl-gcc \
    CXX_i686_unknown_linux_musl=i686-linux-musl-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_i686_unknown_linux_musl="--sysroot=$CROSS_MUSL_SYSROOT" \
    QEMU_LD_PREFIX=$CROSS_MUSL_SYSROOT
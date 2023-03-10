FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY musl.sh /
RUN /musl.sh TARGET=x86_64-linux-musl

COPY qemu.sh /
RUN /qemu.sh x86_64

ENV CROSS_MUSL_SYSROOT=/usr/local/x86_64-linux-musl
COPY musl-symlink.sh /
RUN /musl-symlink.sh $CROSS_MUSL_SYSROOT x86_64

COPY qemu-runner /

ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=x86_64-linux-musl-gcc \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUNNER="/qemu-runner x86_64" \
    CC_x86_64_unknown_linux_musl=x86_64-linux-musl-gcc \
    CXX_x86_64_unknown_linux_musl=x86_64-linux-musl-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_x86_64_unknown_linux_musl="--sysroot=$CROSS_MUSL_SYSROOT" \
    QEMU_LD_PREFIX=$CROSS_MUSL_SYSROOT
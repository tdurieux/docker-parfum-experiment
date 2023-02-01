FROM ubuntu:18.04

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY qemu.sh /
RUN /qemu.sh mips64

COPY musl.sh /
RUN /musl.sh \
    TARGET=mips64-linux-muslsf \
    "COMMON_CONFIG += -with-arch=mips64r2"

ENV CROSS_MUSL_SYSROOT=/usr/local/mips64-linux-muslsf
COPY musl-symlink.sh /
RUN /musl-symlink.sh $CROSS_MUSL_SYSROOT mips64-sf

COPY qemu-runner /

ENV CARGO_TARGET_MIPS64_UNKNOWN_LINUX_MUSLABI64_LINKER=mips64-linux-muslsf-gcc \
    CARGO_TARGET_MIPS64_UNKNOWN_LINUX_MUSLABI64_RUNNER="/qemu-runner mips64" \
    CC_mips64_unknown_linux_muslabi64=mips64-linux-muslsf-gcc \
    CXX_mips64_unknown_linux_muslabi64=mips64-linux-muslsf-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_mips64_unknown_linux_muslabi64="--sysroot=$CROSS_MUSL_SYSROOT" \
    QEMU_LD_PREFIX=$CROSS_MUSL_SYSROOT \
    RUST_TEST_THREADS=1
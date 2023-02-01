FROM ubuntu:18.04

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY qemu.sh /
RUN /qemu.sh mips64el

COPY musl.sh /
RUN /musl.sh \
    TARGET=mips64el-linux-muslsf \
    "COMMON_CONFIG += -with-arch=mips64"

ENV CROSS_MUSL_SYSROOT=/usr/local/mips64el-linux-muslsf
COPY musl-symlink.sh /
RUN /musl-symlink.sh $CROSS_MUSL_SYSROOT mips64el-sf

COPY qemu-runner /

ENV CARGO_TARGET_MIPS64EL_UNKNOWN_LINUX_MUSLABI64_LINKER=mips64el-linux-muslsf-gcc \
    CARGO_TARGET_MIPS64EL_UNKNOWN_LINUX_MUSLABI64_RUNNER="/qemu-runner mips64el" \
    CC_mips64el_unknown_linux_muslabi64=mips64el-linux-muslsf-gcc \
    CXX_mips64el_unknown_linux_muslabi64=mips64el-linux-muslsf-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_mips64el_unknown_linux_muslabi64="--sysroot=$CROSS_MUSL_SYSROOT" \
    QEMU_LD_PREFIX=$CROSS_MUSL_SYSROOT \
    RUST_TEST_THREADS=1
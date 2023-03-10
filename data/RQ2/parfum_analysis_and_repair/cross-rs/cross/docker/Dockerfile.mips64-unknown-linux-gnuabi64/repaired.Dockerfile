FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends \
    g++-mips64-linux-gnuabi64 \
    libc6-dev-mips64-cross && rm -rf /var/lib/apt/lists/*;

COPY deny-debian-packages.sh /
RUN TARGET_ARCH=mips64 /deny-debian-packages.sh \
    binutils \
    binutils-mips64-linux-gnuabi64

COPY qemu.sh /
RUN /qemu.sh mips64

COPY qemu-runner /

ENV CARGO_TARGET_MIPS64_UNKNOWN_LINUX_GNUABI64_LINKER=mips64-linux-gnuabi64-gcc \
    CARGO_TARGET_MIPS64_UNKNOWN_LINUX_GNUABI64_RUNNER="/qemu-runner mips64" \
    CC_mips64_unknown_linux_gnuabi64=mips64-linux-gnuabi64-gcc \
    CXX_mips64_unknown_linux_gnuabi64=mips64-linux-gnuabi64-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_mips64_unknown_linux_gnuabi64="--sysroot=/usr/mips64-linux-gnuabi64" \
    QEMU_LD_PREFIX=/usr/mips64-linux-gnuabi64 \
    RUST_TEST_THREADS=1 \
    PKG_CONFIG_PATH="/usr/lib/mips64-linux-gnuabi64/pkgconfig/:${PKG_CONFIG_PATH}"

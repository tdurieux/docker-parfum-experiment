FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

RUN apt-get install -y --assume-yes --no-install-recommends \
    g++-arm-linux-gnueabi \
    libc6-dev-armel-cross && rm -rf /var/lib/apt/lists/*;

COPY qemu.sh /
RUN /qemu.sh arm

COPY qemu-runner /

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABI_LINKER=arm-linux-gnueabi-gcc \
    CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABI_RUNNER="/qemu-runner armv7" \
    CC_armv7_unknown_linux_gnueabi=arm-linux-gnueabi-gcc \
    CXX_armv7_unknown_linux_gnueabi=arm-linux-gnueabi-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_armv7_unknown_linux_gnueabi="--sysroot=/usr/arm-linux-gnueabi" \
    QEMU_LD_PREFIX=/usr/arm-linux-gnueabi \
    RUST_TEST_THREADS=1 \
    PKG_CONFIG_PATH="/usr/lib/arm-linux-gnueabi/pkgconfig/:${PKG_CONFIG_PATH}"

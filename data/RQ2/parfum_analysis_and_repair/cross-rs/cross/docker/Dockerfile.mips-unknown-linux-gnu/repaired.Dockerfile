FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

RUN apt-get install -y --assume-yes --no-install-recommends \
    g++-mips-linux-gnu \
    libc6-dev-mips-cross && rm -rf /var/lib/apt/lists/*;

COPY qemu.sh /
RUN /qemu.sh mips softmmu

COPY dropbear.sh /
RUN /dropbear.sh

COPY linux-image.sh /
RUN /linux-image.sh mips

COPY linux-runner /

ENV CARGO_TARGET_MIPS_UNKNOWN_LINUX_GNU_LINKER=mips-linux-gnu-gcc \
    CARGO_TARGET_MIPS_UNKNOWN_LINUX_GNU_RUNNER="/linux-runner mips" \
    CC_mips_unknown_linux_gnu=mips-linux-gnu-gcc \
    CXX_mips_unknown_linux_gnu=mips-linux-gnu-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_mips_unknown_linux_gnu="--sysroot=/usr/mips-linux-gnu" \
    QEMU_LD_PREFIX=/usr/mips-linux-gnu \
    RUST_TEST_THREADS=1 \
    PKG_CONFIG_PATH="/usr/lib/mips-linux-gnu/pkgconfig/:${PKG_CONFIG_PATH}"

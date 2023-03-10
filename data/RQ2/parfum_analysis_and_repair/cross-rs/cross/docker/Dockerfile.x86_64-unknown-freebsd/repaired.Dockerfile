FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY freebsd-common.sh /
COPY freebsd.sh /
RUN /freebsd.sh x86_64

COPY freebsd-extras.sh /
RUN /freebsd-extras.sh x86_64

ENV CARGO_TARGET_X86_64_UNKNOWN_FREEBSD_LINKER=x86_64-unknown-freebsd12-gcc \
    CC_x86_64_unknown_freebsd=x86_64-unknown-freebsd12-gcc \
    CXX_x86_64_unknown_freebsd=x86_64-unknown-freebsd12-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_x86_64_unknown_freebsd="--sysroot=/usr/local/x86_64-unknown-freebsd12" \
    X86_64_UNKNOWN_FREEBSD_OPENSSL_DIR=/usr/local/x86_64-unknown-freebsd12/
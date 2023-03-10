FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY dragonfly.sh /
RUN /dragonfly.sh 5

ENV CARGO_TARGET_X86_64_UNKNOWN_DRAGONFLY_LINKER=x86_64-unknown-dragonfly-gcc \
    CC_x86_64_unknown_dragonfly=x86_64-unknown-dragonfly-gcc \
    CXX_x86_64_unknown_dragonfly=x86_64-unknown-dragonfly-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_x86_64_unknown_dragonfly="--sysroot=/usr/local/x86_64-unknown-dragonfly"
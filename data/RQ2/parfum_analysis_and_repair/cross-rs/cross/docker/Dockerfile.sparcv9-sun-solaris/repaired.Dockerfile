FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY solaris.sh /
RUN /solaris.sh sparcv9

ENV CARGO_TARGET_SPARCV9_SUN_SOLARIS_LINKER=sparcv9-sun-solaris2.10-gcc \
    CC_sparcv9_sun_solaris=sparcv9-sun-solaris2.10-gcc \
    CXX_sparcv9_sun_solaris=sparcv9-sun-solaris2.10-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_sparcv9_sun_solaris="--sysroot=/usr/local/sparcv9-sun-solaris2.10"
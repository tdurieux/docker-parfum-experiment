FROM ubuntu:20.04

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY illumos.sh /
RUN /illumos.sh x86_64

ENV PATH=$PATH:/usr/local/x86_64-unknown-illumos/bin/ \
    CARGO_TARGET_X86_64_UNKNOWN_ILLUMOS_LINKER=x86_64-unknown-illumos-gcc \
    AR_x86_64_unknown_illumos=x86_64-unknown-illumos-ar \
    CC_x86_64_unknown_illumos=x86_64-unknown-illumos-gcc \
    CXX_x86_64_unknown_illumos=x86_64-unknown-illumos-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_sparcv9_sun_solaris="--sysroot=/usr/local/x86_64-unknown-illumos/sysroot"
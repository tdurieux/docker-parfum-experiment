FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY android-ndk.sh /
RUN /android-ndk.sh arm64 28
ENV PATH=$PATH:/android-ndk/bin

COPY android-system.sh /
RUN /android-system.sh arm64

COPY qemu.sh /
RUN /qemu.sh aarch64

RUN cp /android-ndk/sysroot/usr/lib/aarch64-linux-android/28/libz.so /system/lib/

COPY android-runner /

# Libz is distributed in the android ndk, but for some unknown reason it is not
# found in the build process of some crates, so we explicit set the DEP_Z_ROOT
ENV CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=aarch64-linux-android-gcc \
    CARGO_TARGET_AARCH64_LINUX_ANDROID_RUNNER="/android-runner aarch64" \
    CC_aarch64_linux_android=aarch64-linux-android-gcc \
    CXX_aarch64_linux_android=aarch64-linux-android-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_aarch64_linux_android="--sysroot=/android-ndk/sysroot" \
    DEP_Z_INCLUDE=/android-ndk/sysroot/usr/include/ \
    RUST_TEST_THREADS=1 \
    HOME=/tmp/ \
    TMPDIR=/tmp/ \
    ANDROID_DATA=/ \
    ANDROID_DNS_MODE=local \
    ANDROID_ROOT=/system
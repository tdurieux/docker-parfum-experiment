FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY android-ndk.sh /
RUN /android-ndk.sh arm 28
ENV PATH=$PATH:/android-ndk/bin

COPY android-system.sh /
RUN /android-system.sh arm

COPY qemu.sh /
RUN /qemu.sh arm

RUN cp /android-ndk/sysroot/usr/lib/arm-linux-androideabi/28/libz.so /system/lib/

COPY android-runner /

# Libz is distributed in the android ndk, but for some unknown reason it is not
# found in the build process of some crates, so we explicit set the DEP_Z_ROOT
ENV CARGO_TARGET_ARM_LINUX_ANDROIDEABI_LINKER=arm-linux-androideabi-gcc \
    CARGO_TARGET_ARM_LINUX_ANDROIDEABI_RUNNER="/android-runner arm" \
    CC_arm_linux_androideabi=arm-linux-androideabi-gcc \
    CXX_arm_linux_androideabi=arm-linux-androideabi-g++ \
    BINDGEN_EXTRA_CLANG_ARGS_arm_linux_androideabi="--sysroot=/android-ndk/sysroot" \
    DEP_Z_INCLUDE=/android-ndk/sysroot/usr/include/ \
    RUST_TEST_THREADS=1 \
    HOME=/tmp/ \
    TMPDIR=/tmp/ \
    ANDROID_DATA=/ \
    ANDROID_DNS_MODE=local \
    ANDROID_ROOT=/system
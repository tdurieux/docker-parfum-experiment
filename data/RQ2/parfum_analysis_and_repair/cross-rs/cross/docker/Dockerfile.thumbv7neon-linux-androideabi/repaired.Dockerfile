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
# likewise, the toolchains expect the prefix `thumbv7neon-linux-androideabi`,
# which we don't have, so just export every possible variable, such as AR.
# Also export all target binutils just in case required.
ENV CARGO_TARGET_THUMBV7NEON_LINUX_ANDROIDEABI_LINKER=arm-linux-androideabi-gcc \
    CARGO_TARGET_THUMBV7NEON_LINUX_ANDROIDEABI_RUNNER="/android-runner arm" \
    AR_thumbv7neon_linux_androideabi=arm-linux-androideabi-ar \
    AS_thumbv7neon_linux_androideabi=arm-linux-androideabi-as \
    CC_thumbv7neon_linux_androideabi=arm-linux-androideabi-gcc \
    CXX_thumbv7neon_linux_androideabi=arm-linux-androideabi-g++ \
    LD_thumbv7neon_linux_androideabi=arm-linux-androideabi-ld \
    NM_thumbv7neon_linux_androideabi=arm-linux-androideabi-nm \
    OBJCOPY_thumbv7neon_linux_androideabi=arm-linux-androideabi-objcopy \
    OBJDUMP_thumbv7neon_linux_androideabi=arm-linux-androideabi-objdump \
    RANLIB_thumbv7neon_linux_androideabi=arm-linux-androideabi-ranlib \
    READELF_thumbv7neon_linux_androideabi=arm-linux-androideabi-readelf \
    SIZE_thumbv7neon_linux_androideabi=arm-linux-androideabi-size \
    STRINGS_thumbv7neon_linux_androideabi=arm-linux-androideabi-strings \
    STRIP_thumbv7neon_linux_androideabi=arm-linux-androideabi-strip \
    BINDGEN_EXTRA_CLANG_ARGS_thumbv7neon_linux_androideabi="--sysroot=/android-ndk/sysroot" \
    DEP_Z_INCLUDE=/android-ndk/sysroot/usr/include/ \
    RUST_TEST_THREADS=1 \
    HOME=/tmp/ \
    TMPDIR=/tmp/ \
    ANDROID_DATA=/ \
    ANDROID_DNS_MODE=local \
    ANDROID_ROOT=/system
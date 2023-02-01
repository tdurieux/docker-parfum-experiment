FROM ubuntu:18.04
USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    curl \
    gcc \
    libc6-dev \
    make \
    pkg-config

COPY ci/docker/scripts/sccache.sh /scripts/
RUN sh /scripts/sccache.sh

RUN apt-get install -y --no-install-recommends \
    unzip \
    python && \
    curl -O https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip && \
    unzip -q android-ndk-r13b-linux-x86_64.zip && \
    ./android-ndk-r13b/build/tools/make_standalone_toolchain.py \
        --install-dir /android-ndk/arm \
        --arch arm \
        --api 21 && \
    ./android-ndk-r13b/build/tools/make_standalone_toolchain.py \
        --install-dir /android-ndk/arm64 \
        --arch arm64 \
        --api 21 && \
    ./android-ndk-r13b/build/tools/make_standalone_toolchain.py \
        --install-dir /android-ndk/x86 \
        --arch x86 \
        --api 21 && \
    ./android-ndk-r13b/build/tools/make_standalone_toolchain.py \
        --install-dir /android-ndk/x86_64 \
        --arch x86_64 \
        --api 21 && \
    rm -rf ./android-ndk-r13b-linux-x86_64.zip ./android-ndk-r13b && \
    apt-get purge --auto-remove -y unzip python

ENV PATH=$PATH:/android-ndk/arm/bin
ENV PATH=$PATH:/android-ndk/arm64/bin
ENV PATH=$PATH:/android-ndk/x86/bin
ENV PATH=$PATH:/android-ndk/x86_64/bin

ENV CARGO_TARGET_ARM_LINUX_ANDROIDEABI_LINKER=arm-linux-androideabi-gcc
ENV CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER=arm-linux-androideabi-gcc
ENV CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=aarch64-linux-android-gcc
ENV CARGO_TARGET_I686_LINUX_ANDROID_LINKER=i686-linux-android-gcc
ENV CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER=x86_64-linux-android-gcc

WORKDIR /buildslave

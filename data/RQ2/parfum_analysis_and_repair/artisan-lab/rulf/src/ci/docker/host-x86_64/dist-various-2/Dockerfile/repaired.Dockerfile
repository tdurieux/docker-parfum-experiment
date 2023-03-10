FROM ubuntu:18.04

COPY scripts/cross-apt-packages.sh /scripts/
RUN sh /scripts/cross-apt-packages.sh

# Enable source repositories, which are disabled by default on Ubuntu >= 18.04
RUN sed -i 's/^# deb-src/deb-src/' /etc/apt/sources.list

RUN apt-get update && apt-get build-dep -y clang llvm && apt-get install -y --no-install-recommends \
  build-essential \
# gcc-multilib can not be installed together with gcc-arm-linux-gnueabi
  gcc-7-multilib \
  libedit-dev \
  libgmp-dev \
  libisl-dev \
  libmpc-dev \
  libmpfr-dev \
  ninja-build \
  nodejs \
  python3-dev \
  software-properties-common \
  unzip \
  # Needed for apt-key to work:
  dirmngr \
  gpg-agent \
  g++-7-arm-linux-gnueabi && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --batch --yes --keyserver keyserver.ubuntu.com --recv-keys 74DA7924C5513486
RUN add-apt-repository -y 'deb http://apt.dilos.org/dilos dilos2 main'

ENV \
    AR_x86_64_fuchsia=x86_64-fuchsia-ar \
    CC_x86_64_fuchsia=x86_64-fuchsia-clang \
    CXX_x86_64_fuchsia=x86_64-fuchsia-clang++ \
    AR_aarch64_fuchsia=aarch64-fuchsia-ar \
    CC_aarch64_fuchsia=aarch64-fuchsia-clang \
    CXX_aarch64_fuchsia=aarch64-fuchsia-clang++ \
    AR_sparcv9_sun_solaris=sparcv9-sun-solaris2.10-ar \
    CC_sparcv9_sun_solaris=sparcv9-sun-solaris2.10-gcc \
    CXX_sparcv9_sun_solaris=sparcv9-sun-solaris2.10-g++ \
    AR_x86_64_sun_solaris=x86_64-sun-solaris2.10-ar \
    CC_x86_64_sun_solaris=x86_64-sun-solaris2.10-gcc \
    CXX_x86_64_sun_solaris=x86_64-sun-solaris2.10-g++ \
    CC_armv7_unknown_linux_gnueabi=arm-linux-gnueabi-gcc-7 \
    CXX_armv7_unknown_linux_gnueabi=arm-linux-gnueabi-g++-7 \
    AR_x86_64_fortanix_unknown_sgx=ar \
    CC_x86_64_fortanix_unknown_sgx=x86_64-fortanix-unknown-sgx-clang-11 \
    CFLAGS_x86_64_fortanix_unknown_sgx="-mlvi-hardening -mllvm -x86-experimental-lvi-inline-asm-hardening" \
    CXX_x86_64_fortanix_unknown_sgx=x86_64-fortanix-unknown-sgx-clang++-11 \
    CXXFLAGS_x86_64_fortanix_unknown_sgx="-mlvi-hardening -mllvm -x86-experimental-lvi-inline-asm-hardening" \
    CC=gcc-7 \
    CXX=g++-7

WORKDIR /build
COPY scripts/musl.sh /build
RUN env \
    CC=arm-linux-gnueabi-gcc-7 CFLAGS="-march=armv7-a" \
    CXX=arm-linux-gnueabi-g++-7 CXXFLAGS="-march=armv7-a" \
    bash musl.sh armv7 && \
    rm -rf /build/*

WORKDIR /tmp
COPY host-x86_64/dist-various-2/shared.sh /tmp/
COPY host-x86_64/dist-various-2/build-cloudabi-toolchain.sh /tmp/
RUN /tmp/build-cloudabi-toolchain.sh x86_64-unknown-cloudabi
COPY host-x86_64/dist-various-2/build-fuchsia-toolchain.sh /tmp/
RUN /tmp/build-fuchsia-toolchain.sh
COPY host-x86_64/dist-various-2/build-solaris-toolchain.sh /tmp/
RUN /tmp/build-solaris-toolchain.sh x86_64  amd64   solaris-i386
RUN /tmp/build-solaris-toolchain.sh sparcv9 sparcv9 solaris-sparc
COPY host-x86_64/dist-various-2/build-x86_64-fortanix-unknown-sgx-toolchain.sh /tmp/
COPY host-x86_64/dist-various-2/x86_64-fortanix-unknown-sgx-clang-wrap.sh /usr/bin/x86_64-fortanix-unknown-sgx-clang-11
RUN ln -s /usr/bin/x86_64-fortanix-unknown-sgx-clang-11 /usr/bin/x86_64-fortanix-unknown-sgx-clang++-11
RUN /tmp/build-x86_64-fortanix-unknown-sgx-toolchain.sh

COPY host-x86_64/dist-various-2/build-wasi-toolchain.sh /tmp/
RUN /tmp/build-wasi-toolchain.sh

COPY scripts/sccache.sh /scripts/
RUN sh /scripts/sccache.sh

ENV CARGO_TARGET_X86_64_FUCHSIA_AR /usr/local/bin/llvm-ar
ENV CARGO_TARGET_X86_64_FUCHSIA_RUSTFLAGS \
-C link-arg=--sysroot=/usr/local/x86_64-fuchsia \
-C link-arg=-L/usr/local/x86_64-fuchsia/lib \
-C link-arg=-L/usr/local/lib/x86_64-fuchsia/lib
ENV CARGO_TARGET_AARCH64_FUCHSIA_AR /usr/local/bin/llvm-ar
ENV CARGO_TARGET_AARCH64_FUCHSIA_RUSTFLAGS \
-C link-arg=--sysroot=/usr/local/aarch64-fuchsia \
-C link-arg=-L/usr/local/aarch64-fuchsia/lib \
-C link-arg=-L/usr/local/lib/aarch64-fuchsia/lib

ENV TARGETS=x86_64-fuchsia
ENV TARGETS=$TARGETS,aarch64-fuchsia
ENV TARGETS=$TARGETS,wasm32-unknown-unknown
ENV TARGETS=$TARGETS,wasm32-wasi
ENV TARGETS=$TARGETS,sparcv9-sun-solaris
ENV TARGETS=$TARGETS,x86_64-sun-solaris
ENV TARGETS=$TARGETS,x86_64-unknown-linux-gnux32
ENV TARGETS=$TARGETS,x86_64-unknown-cloudabi
ENV TARGETS=$TARGETS,x86_64-fortanix-unknown-sgx
ENV TARGETS=$TARGETS,nvptx64-nvidia-cuda
ENV TARGETS=$TARGETS,armv7-unknown-linux-gnueabi
ENV TARGETS=$TARGETS,armv7-unknown-linux-musleabi

# As per https://bugs.launchpad.net/ubuntu/+source/gcc-defaults/+bug/1300211
# we need asm in the search path for gcc-7 (for gnux32) but not in the search path of the
# cross compilers.
# Luckily one of the folders is /usr/local/include so symlink /usr/include/asm-generic there
RUN ln -s /usr/include/asm-generic /usr/local/include/asm

ENV RUST_CONFIGURE_ARGS --enable-extended --enable-lld --disable-docs \
  --set target.wasm32-wasi.wasi-root=/wasm32-wasi \
  --musl-root-armv7=/musl-armv7

ENV SCRIPT python3 ../x.py dist --target $TARGETS

# We use Debian 6 (glibc 2.11, kernel 2.6.32) as a common base for other
# distros that still need Rust support: RHEL 6 (glibc 2.12, kernel 2.6.32) and
# SLES 11 SP4 (glibc 2.11, kernel 3.0).
FROM debian:6

WORKDIR /build

# Debian 6 is EOL and no longer available from the usual mirrors,
# so we'll need to switch to http://archive.debian.org/
RUN sed -i '/updates/d' /etc/apt/sources.list && \
    sed -i 's/httpredir/archive/' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --allow-unauthenticated -y --no-install-recommends \
      automake \
      bzip2 \
      ca-certificates \
      curl \
      file \
      g++ \
      g++-multilib \
      gcc \
      gcc-multilib \
      git \
      lib32z1-dev \
      libedit-dev \
      libncurses-dev \
      make \
      patch \
      perl \
      pkg-config \
      unzip \
      wget \
      xz-utils \
      zlib1g-dev && rm -rf /var/lib/apt/lists/*;

ENV PATH=/rustroot/bin:$PATH
ENV LD_LIBRARY_PATH=/rustroot/lib64:/rustroot/lib32:/rustroot/lib
ENV PKG_CONFIG_PATH=/rustroot/lib/pkgconfig
WORKDIR /tmp
RUN mkdir /home/user
COPY host-x86_64/dist-x86_64-linux/shared.sh /tmp/

# We need a build of openssl which supports SNI to download artifacts from
# static.rust-lang.org. This'll be used to link into libcurl below (and used
# later as well), so build a copy of OpenSSL with dynamic libraries into our
# generic root.
COPY host-x86_64/dist-x86_64-linux/build-openssl.sh /tmp/
RUN ./build-openssl.sh

# The `curl` binary on Debian 6 doesn't support SNI which is needed for fetching
# some https urls we have, so install a new version of libcurl + curl which is
# using the openssl we just built previously.
#
# Note that we also disable a bunch of optional features of curl that we don't
# really need.
COPY host-x86_64/dist-x86_64-linux/build-curl.sh /tmp/
RUN ./build-curl.sh && apt-get remove -y curl

# binutils < 2.22 has a bug where the 32-bit executables it generates
# immediately segfault in Rust, so we need to install our own binutils.
#
# See https://github.com/rust-lang/rust/issues/20440 for more info
COPY host-x86_64/dist-x86_64-linux/build-binutils.sh /tmp/
RUN ./build-binutils.sh

# Need at least GCC 5.1 to compile LLVM nowadays
COPY host-x86_64/dist-x86_64-linux/build-gcc.sh /tmp/
RUN ./build-gcc.sh && apt-get remove -y gcc g++

# Debian 6 has Python 2.6 by default, but LLVM needs 2.7+
COPY host-x86_64/dist-x86_64-linux/build-python.sh /tmp/
RUN ./build-python.sh

# LLVM needs cmake 3.4.3 or higher, and is planning to raise to 3.13.4.
COPY host-x86_64/dist-x86_64-linux/build-cmake.sh /tmp/
RUN ./build-cmake.sh

# Now build LLVM+Clang, afterwards configuring further compilations to use the
# clang/clang++ compilers.
COPY host-x86_64/dist-x86_64-linux/build-clang.sh /tmp/
RUN ./build-clang.sh
ENV CC=clang CXX=clang++

COPY scripts/sccache.sh /scripts/
RUN sh /scripts/sccache.sh

ENV HOSTS=x86_64-unknown-linux-gnu

ENV RUST_CONFIGURE_ARGS \
      --enable-full-tools \
      --enable-sanitizers \
      --enable-profiler \
      --enable-compiler-docs \
      --set target.x86_64-unknown-linux-gnu.linker=clang \
      --set target.x86_64-unknown-linux-gnu.ar=/rustroot/bin/llvm-ar \
      --set target.x86_64-unknown-linux-gnu.ranlib=/rustroot/bin/llvm-ranlib \
      --set llvm.thin-lto=true \
      --set llvm.ninja=false \
      --set rust.jemalloc
ENV SCRIPT python2.7 ../x.py dist --host $HOSTS --target $HOSTS
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=clang

# This is the only builder which will create source tarballs
ENV DIST_SRC 1

# When we build cargo in this container, we don't want it to use the system
# libcurl, instead it should compile its own.
ENV LIBCURL_NO_PKG_CONFIG 1

ENV DIST_REQUIRE_ALL_TOOLS 1

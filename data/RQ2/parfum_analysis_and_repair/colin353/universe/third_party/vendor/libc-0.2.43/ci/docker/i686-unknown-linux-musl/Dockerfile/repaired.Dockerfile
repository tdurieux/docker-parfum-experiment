FROM ubuntu:17.10

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc-multilib make libc6-dev git curl ca-certificates libc6:i386 && rm -rf /var/lib/apt/lists/*;
# Below we're cross-compiling musl for i686 using the system compiler on an
# x86_64 system. This is an awkward thing to be doing and so we have to jump
# through a couple hoops to get musl to be happy. In particular:
#
# * We specifically pass -m32 in CFLAGS and override CC when running ./configure,
#   since otherwise the script will fail to find a compiler.
# * We manually unset CROSS_COMPILE when running make; otherwise the makefile
#   will call the non-existent binary 'i686-ar'.
RUN curl -f https://www.musl-libc.org/releases/musl-1.1.19.tar.gz | \
    tar xzf - && \
    cd musl-1.1.19 && \
    CC=gcc CFLAGS=-m32 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/musl-i686 --disable-shared --target=i686 && \
    make CROSS_COMPILE= install -j4 && \
    cd .. && \
    rm -rf musl-1.1.19
# Install linux kernel headers sanitized for use with musl
RUN curl -f -L https://github.com/sabotage-linux/kernel-headers/archive/v3.12.6-6.tar.gz | \
    tar xzf - && \
    cd kernel-headers-3.12.6-6 && \
    make ARCH=i386 prefix=/musl-i686 install -j4 && \
    cd .. && \
    rm -rf kernel-headers-3.12.6-6

ENV PATH=$PATH:/musl-i686/bin:/rust/bin \
    CC_i686_unknown_linux_musl=musl-gcc

FROM scratch
MAINTAINER Peter Marheine <peter@taricorp.net>

FROM debian:bullseye-slim AS prereqs
RUN apt-get -qq update
RUN apt-get -y --no-install-recommends install build-essential libmpfr-dev libmpc-dev libgmp-dev libpng-dev ppl-dev curl git cmake texinfo && rm -rf /var/lib/apt/lists/*;

FROM prereqs AS binutils
WORKDIR /
RUN curl -f -L https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.bz2 | tar xj
RUN mkdir build-binutils
WORKDIR /build-binutils
RUN ../binutils-2.34/configure --target=sh3eb-elf --disable-nls \
        --with-sysroot
RUN make -j$(nproc)
RUN make install

FROM binutils AS gcc
WORKDIR /
RUN curl -f -L https://ftpmirror.gnu.org/gcc/gcc-10.1.0/gcc-10.1.0.tar.xz | tar xJ
RUN mkdir build-gcc
WORKDIR /build-gcc
RUN ../gcc-10.1.0/configure --target=sh3eb-elf --with-pkgversion=PrizmSDK \
        --without-headers --enable-languages=c,c++ \
        --disable-tls --disable-nls --disable-threads --disable-shared \
        --disable-libssp --disable-libvtv --disable-libada \
        --with-endian=big --with-multilib-list=
RUN make -j$(nproc) inhibit_libc=true all-gcc
RUN make install-gcc

RUN make -j$(nproc) inhibit_libc=true all-target-libgcc
RUN make install-target-libgcc

FROM debian:bullseye-slim
COPY --from=gcc /usr/local /usr/local
RUN apt-get -qq update && apt-get -qqy --no-install-recommends install make libmpc3 && apt-get -qqy clean && rm -rf /var/lib/apt/lists/*;

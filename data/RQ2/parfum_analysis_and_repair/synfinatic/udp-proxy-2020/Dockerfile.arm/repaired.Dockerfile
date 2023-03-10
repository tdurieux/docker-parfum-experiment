FROM ubuntu:20.04 as base
ENV DEBIAN_FRONTEND=noninteractive

# base applications
RUN apt-get update && apt-get install --no-install-recommends -y tzdata wget make git flex bison && rm -rf /var/lib/apt/lists/*;

# all our cross compile stuff
RUN apt-get install --no-install-recommends -y \
    binutils-arm-linux-gnueabihf \
    binutils-arm-linux-gnueabi \
    linux-libc-dev-armhf-cross \
    linux-libc-dev-armel-cross \
    gccgo-10-arm-linux-gnueabihf \
    gccgo-10-arm-linux-gnueabi \
    gcc-10-arm-linux-gnueabihf \
    gcc-10-arm-linux-gnueabi \
    golang-1.16-go \
    libgo16-armhf-cross \
    libgo16-armel-cross \
    libgcc-10-dev-armhf-cross \
    libgcc-10-dev-armel-cross \
    libc6-armhf-cross \
    libc6-armel-cross \
    libc6-dev-armhf-cross \
    libc6-dev-armel-cross \
    binutils-aarch64-linux-gnu \
    linux-libc-dev-arm64-cross \
    gccgo-10-aarch64-linux-gnu \
    gcc-10-aarch64-linux-gnu \
    libgo16-arm64-cross \
    libgcc-10-dev-arm64-cross \
    libc6-arm64-cross \
    libc6-dev-arm64-cross && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /buildhf/bin && cd /buildhf/bin && \
    ln -s /usr/bin/arm-linux-gnueabihf-gccgo-10 gccgo && \
    ln -s /usr/bin/arm-linux-gnueabihf-gcc-ar-10 ar && \
    ln -s /usr/bin/arm-linux-gnueabihf-gcc-ranlib-10 ranlib && \
    ln -s /usr/bin/arm-linux-gnueabihf-gcc-10 gcc

RUN mkdir -p /build/bin && cd /build/bin && \
    ln -s /usr/bin/arm-linux-gnueabi-gccgo-10 gccgo && \
    ln -s /usr/bin/arm-linux-gnueabi-gcc-ar-10 ar && \
    ln -s /usr/bin/arm-linux-gnueabi-gcc-ranlib-10 ranlib && \
    ln -s /usr/bin/arm-linux-gnueabi-gcc-10 gcc

RUN mkdir -p /build64/bin && cd /build64/bin && \
    ln -s /usr/bin/aarch64-linux-gnu-gccgo-10 gccgo && \
    ln -s /usr/bin/aarch64-linux-gnu-gcc-ar-10 ar && \
    ln -s /usr/bin/aarch64-linux-gnu-gcc-ranlib-10 ranlib && \
    ln -s /usr/bin/aarch64-linux-gnu-gcc-10 gcc

# build libpcap
FROM base as libpcap
ENV LIBPCAP_VERSION=1.9.1
WORKDIR /build
RUN wget -qO - https://www.tcpdump.org/release/libpcap-${LIBPCAP_VERSION}.tar.gz | tar zxf -
WORKDIR /build/libpcap-${LIBPCAP_VERSION}

# hardware float
RUN CC=/buildhf/bin/gcc BUILD_CC=gcc AR=/buildhf/bin/ar  RANLIB=/buildhf/bin/ranlib \
    ./configure --build i686-pc-linux-gnu \
    --host arm-linux-gnueabihf --prefix=/usr/arm-linux-gnueabihf && \
    make install

# software float
RUN make clean && \
    CC=/build/bin/gcc BUILD_CC=gcc AR=/build/bin/ar  RANLIB=/build/bin/ranlib \
    ./configure --build i686-pc-linux-gnu \
    --host arm-linux-gnueabi --prefix=/usr/arm-linux-gnueabi && \
    make install

# arm64
RUN make clean && \ 
    CC=/build64/bin/gcc BUILD_CC=gcc AR=/build64/bin/ar  RANLIB=/build64/bin/ranlib \
    ./configure --build i686-pc-linux-gnu \
    --host aarch64-linux-gnu --prefix=/usr/aarch64-linux-gnu && \
    make install

# build our app
FROM libpcap
WORKDIR /build/udp-proxy-2020
ENV GOROOT=/usr/lib/go-1.16
ENV PATH=/build/bin:${GOROOT}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENTRYPOINT make .linux-arm

FROM alpine:3.16 AS build

ARG ARCH=x86
ENV ARCH=$ARCH

ARG LOCAL_KERNEL_VERSION=4.18.0-348.23.1.el8_5

ENV _LIBC=static

# hadolint ignore=DL3018
RUN apk add --no-cache -U build-base autoconf automake coreutils pkgconfig \
                          bc elfutils-dev openssl-dev clang clang-dev llvm \
                          rsync bison flex tar xz bash rpm ssl_client linux-headers

# hadolint ignore=DL3003,SC3009
RUN mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS} && \
    echo "%_topdir %(echo $HOME)/rpmbuild" > ~/.rpmmacros && \
    wget -q https://repo.almalinux.org/almalinux/8.5/BaseOS/Source/Packages/kernel-${LOCAL_KERNEL_VERSION}.src.rpm && \
    rpm -i kernel-${LOCAL_KERNEL_VERSION}.src.rpm && \
    cd ~/rpmbuild/SOURCES && \
    tar -xf linux-${LOCAL_KERNEL_VERSION}.tar.xz && \
    mkdir -p /usr/src/kernels && \
    cd /usr/src && \
    ln -s ~/rpmbuild/SOURCES/linux-${LOCAL_KERNEL_VERSION} linux && rm -rf /usr/src/kernels

WORKDIR /kernel-collector

COPY .dockerfiles/build.sh /build.sh
COPY . .

CMD ["/build.sh"]

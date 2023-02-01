FROM ubuntu:bionic

ENV ARCH=x86_64

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        gcc g++ clang make cmake libxpm-dev git libcurl4-openssl-dev libssl-dev wget zlib1g-dev libc6-dev bsdmainutils pkgconf libgcrypt11-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://artifacts.assassinate-you.net/prebuilt-cmake/continuous/cmake-v3.19.1-ubuntu_xenial-x86_64.tar.gz -O- | \
        tar xz -C /usr/local --strip-components=1

COPY libgcrypt.pc /usr/lib/x86_64-linux-gnu/pkgconfig/libgcrypt.pc

ARG UID
RUN adduser --system --group --uid "$UID" build
USER build

ENV APPIMAGE_EXTRACT_AND_RUN=1

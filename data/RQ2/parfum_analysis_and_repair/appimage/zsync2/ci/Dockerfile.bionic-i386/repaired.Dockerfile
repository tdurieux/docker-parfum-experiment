FROM i386/ubuntu:bionic

ENV ARCH=i386

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        gcc g++ clang make cmake libxpm-dev git libcurl4-openssl-dev libssl-dev wget zlib1g-dev libc6-dev bsdmainutils pkgconf libgcrypt11-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://artifacts.assassinate-you.net/prebuilt-cmake/continuous/cmake-v3.19.1-ubuntu_xenial-i386.tar.gz -O- | \
        tar xz -C /usr/local --strip-components=1

COPY libgcrypt.pc /usr/lib/i386-linux-gnu/pkgconfig/libgcrypt.pc
RUN sed -i 's|x86_64|i386|g' /usr/lib/i386-linux-gnu/pkgconfig/libgcrypt.pc

ARG UID
RUN adduser --system --group --uid "$UID" build
USER build

ENV APPIMAGE_EXTRACT_AND_RUN=1

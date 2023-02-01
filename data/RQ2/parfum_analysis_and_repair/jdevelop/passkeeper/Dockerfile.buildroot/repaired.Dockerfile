FROM alpine:3.8 AS fetcher
RUN apk add --no-cache wget
WORKDIR /buildroot
RUN wget "https://buildroot.org/downloads/buildroot-2018.08.2.tar.gz" && tar -xvf buildroot-2018.08.2.tar.gz && rm buildroot-2018.08.2.tar.gz

FROM ubuntu:bionic AS builder
RUN apt-get update && apt-get -y install --no-install-recommends ca-certificates wget gcc make bash coreutils build-essential file perl python rsync bc g++ binutils patch gzip bzip2 tar cpio unzip linux-headers-generic && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates
COPY --from=fetcher /buildroot /buildroot
COPY buildroot/ /build
WORKDIR /build
RUN make O=/build PASSKEEPER=/build FORCE_UNSAFE_CONFIGURE=1 -C /buildroot/buildroot-2018.08.2

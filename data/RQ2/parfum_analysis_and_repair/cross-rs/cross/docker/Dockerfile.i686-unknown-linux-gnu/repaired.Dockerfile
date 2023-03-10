FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends \
    g++-multilib && rm -rf /var/lib/apt/lists/*;

COPY qemu.sh /
RUN /qemu.sh i386 softmmu

COPY dropbear.sh /
RUN /dropbear.sh

COPY linux-image.sh /
RUN /linux-image.sh i686

COPY linux-runner /

ENV CARGO_TARGET_I686_UNKNOWN_LINUX_GNU_RUNNER="/linux-runner i686" \
    PKG_CONFIG_PATH="/usr/lib/i386-linux-gnu/pkgconfig/:${PKG_CONFIG_PATH}"

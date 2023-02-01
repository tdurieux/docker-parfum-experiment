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
RUN /qemu.sh i386

COPY qemu-runner /

ENV CARGO_TARGET_I586_UNKNOWN_LINUX_GNU_RUNNER="/qemu-runner i586" \
    PKG_CONFIG_PATH="/usr/lib/i386-linux-gnu/pkgconfig/:${PKG_CONFIG_PATH}"

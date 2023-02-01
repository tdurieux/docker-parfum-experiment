FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY qemu.sh /
RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi && \
    /qemu.sh arm && rm -rf /var/lib/apt/lists/*;

ENV QEMU_CPU=cortex-m3 \
    CARGO_TARGET_THUMBV7M_NONE_EABI_RUNNER=qemu-arm

ARG BASE_IMAGE_ARCH=amd64
FROM --platform=linux/$BASE_IMAGE_ARCH ubuntu:focal

ARG ARCH

RUN apt-get update && \
    apt-get -y --no-install-recommends install iptables iproute2 && \
    rm -rf /var/lib/apt/lists/*

ADD /build/artifacts-linux-$ARCH/kumactl/kumactl /usr/bin

COPY /tools/releases/templates/LICENSE \
    /tools/releases/templates/README \
    /kuma/

COPY /tools/releases/templates/NOTICE-kumactl /kuma/NOTICE

RUN adduser --system --disabled-password --group kumactl --uid 5678

ENTRYPOINT ["/usr/bin/kumactl", "install", "transparent-proxy"]

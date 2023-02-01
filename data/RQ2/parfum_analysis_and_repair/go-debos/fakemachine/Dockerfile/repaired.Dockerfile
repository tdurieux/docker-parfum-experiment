FROM debian:stretch-slim

ARG DEBIAN_FRONTEND=noninteractive

ENV HOME=/scratch

# Always install procps in case the docker file gets used in jenkins
RUN apt update && apt-get install  --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;

# Bits needed to run fakemachine
RUN apt-get update && \
    apt-get install --no-install-recommends -y qemu-system-x86 \
                                               qemu-user-static \
                                               busybox \
                                               linux-image-amd64 \
                                               systemd \
                                               dbus && rm -rf /var/lib/apt/lists/*;

# Bits needed to build fakemachine
RUN apt-get update && \
    apt-get install --no-install-recommends -y golang-go git ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /scratch

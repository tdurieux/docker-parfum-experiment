FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive

# Docker for Jenkins really needs procps otherwise the Jenkins side fails
RUN apt-get update && apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;

ENV FORCE_UNSAFE_CONFIGURE=1

# SSL / HTTPS support
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

# Dependencies to run buildroot
RUN apt-get update && apt-get install --no-install-recommends -y \
    bc \
    bzip2 \
    cpio \
    file \
    gcc \
    g++ \
    git \
    make \
    rsync \
    patch \
    python3 \
    unzip \
    wget \
    xz-utils && rm -rf /var/lib/apt/lists/*;

# Extra packages needed by kernelCI
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3.9 \
    python3-requests \
    python3-yaml && rm -rf /var/lib/apt/lists/*;

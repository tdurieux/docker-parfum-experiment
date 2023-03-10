# GenericOS - Base Image
#
# Build steps:
# - `docker build -t dfinity/genericos-base:<tag> -f Dockerfile.base .`
# - `docker push/pull dfinity/genericos-base:<tag>`
#
# First build stage:
# - Download and cache minimal Ubuntu Server 20.04 LTS Docker image
# - Install and cache upstream packages from built-in Ubuntu repositories

# NOTE! If you edit this file, you will need to perform the following
# operations to get your changes deployed.
#
# 1. Get your MR approved and merged into master
# 2. On the next hourly master pipeline, click the "deploy-guest-os-baseimg" job
# 3. Note the sha256 and update the sha256 reference in the neighboring Dockerfiles.

FROM ubuntu:20.04

ENV SOURCE_DATE_EPOCH=0
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install \
    apt-transport-https \
    attr \
    build-essential \
    ca-certificates \
    checkpolicy \
    chrony \
    cryptsetup \
    curl \
    fdisk \
    gnupg2 \
    initramfs-tools \
    inotify-tools \
    iproute2 \
    iputils-ping \
    isc-dhcp-client \
    less \
    libffi-dev \
    libssl-dev \
    linux-image-virtual-hwe-20.04 \
    lshw \
    net-tools \
    nftables \
    opensc \
    openssh-client openssh-server \
    parted \
    pciutils \
    pcsc-tools pcscd \
    policycoreutils \
    python python3-dev \
    rsync \
    sudo \
    systemd systemd-sysv systemd-journal-remote \
    udev \
    usbutils \
    vim \
    zstd && rm -rf /var/lib/apt/lists/*;

RUN curl --retry 10 --fail https://nginx.org/keys/nginx_signing.key -L -o - | apt-key add - && \
    echo "deb [arch=amd64] https://nginx.org/packages/mainline/ubuntu/ focal nginx" >> /etc/apt/sources.list && \
    echo "deb-src https://nginx.org/packages/mainline/ubuntu/ focal nginx" >> /etc/apt/sources.list

RUN apt-get -y update && apt-get -y --no-install-recommends install \
    dirmngr \
    ssl-cert \
    haveged \
    nginx=1.21.3-1~focal \
    nginx-module-njs=1.21.3+0.7.0-1~focal && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && \
    BASE_URL="https://github.com/dfinity/nginx-module-cbor-input/releases/download/v0.0.9" && \
    curl --retry 10 --fail "$BASE_URL/libnginx-mod-http-ndk_0.3.1_amd64.deb" -LO && \
    echo "6a496d8c7f3357fda9e5adeb7a729e76c453f32c6d67bc0ec563b0f71e2a0aca  libnginx-mod-http-ndk_0.3.1_amd64.deb" | sha256sum -c - && \
    apt install --no-install-recommends -y ./libnginx-mod-http-ndk_0.3.1_amd64.deb && \
    rm -f libnginx-mod-http-ndk_0.3.1_amd64.deb && \
    curl --retry 10 --fail "$BASE_URL/libnginx-mod-http-cbor-input_0.0.9_amd64.deb" -LO && \
    echo "8dca8fb93a6645c4aee23f601e9d9f62a00638ff29f95ceafcd10f422a3126f0  libnginx-mod-http-cbor-input_0.0.9_amd64.deb" | sha256sum -c - && \
    apt install --no-install-recommends -y ./libnginx-mod-http-cbor-input_0.0.9_amd64.deb && \
    rm -f libnginx-mod-http-cbor-input_0.0.9_amd64.deb && \
    cd - && rm -rf /var/lib/apt/lists/*;

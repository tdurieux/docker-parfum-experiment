FROM ubuntu:18.04

ENV QAT_DRIVER_VERSION=1.7.l.4.12.0-00011
ENV QAT_DRIVER_DOWNLOAD_URL=https://01.org/sites/default/files/downloads/qat${QAT_DRIVER_VERSION}.tar.gz
ENV QAT_INSTALL_DIR_HOST=/opt/qat

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        bc \
        build-essential \
        curl \
        kmod \
        libelf-dev \
        libssl-dev \
        libudev-dev \
        pciutils \
        pkg-config \
        && \
    rm -rf /var/lib/apt/lists/*

COPY _common.sh /
COPY _qat-driver-installer.sh /
COPY entrypoint-qat-driver-installer.sh /entrypoint.sh

CMD /entrypoint.sh

FROM ubuntu:18.04

ENV IAVF_DRIVER_VERSION=4.0.2
ENV IAVF_DRIVER_DOWNLOAD_URL=https://downloadmirror.intel.com/30305/eng/iavf-${IAVF_DRIVER_VERSION}.tar.gz
ENV IAVF_INSTALL_DIR_HOST=/opt/iavf

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
COPY skb-frag-off.patch /
COPY entrypoint-iavf-driver-installer.sh /entrypoint.sh

CMD /entrypoint.sh

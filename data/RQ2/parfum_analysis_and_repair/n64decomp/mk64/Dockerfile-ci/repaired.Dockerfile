FROM ubuntu:18.04 as build

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        binutils-mips-linux-gnu \
        bsdmainutils \
        build-essential \
        libcapstone-dev \
        git \
        pkgconf \
        python3 \
				wget \
				libglib2.0-0 && rm -rf /var/lib/apt/lists/*;

RUN TEMP_DEB="$(mktemp)" && \
    wget -O "$TEMP_DEB" 'https://github.com/n64decomp/qemu-irix/releases/download/v2.11-deb/qemu-irix-2.11.0-2169-g32ab296eef_amd64.deb'  && \
    dpkg -i "$TEMP_DEB" && \
    rm -f "$TEMP_DEB"

RUN mkdir /opt/assets

COPY roms/ /opt/assets

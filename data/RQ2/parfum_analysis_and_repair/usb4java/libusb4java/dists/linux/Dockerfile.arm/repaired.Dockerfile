#
# Copyright (C) 2018 Klaus Reimer <k@ailis.de>
# See LICENSE.md for licensing information.
#

FROM debian:stretch

ENV LIBUSB_VERSION=1.0.24

# Install debian updates
RUN apt-get update && apt-get upgrade -y

# Install required debian packages
RUN apt-get install --no-install-recommends -y cmake curl gperf bzip2 gcj-6-jdk git && rm -rf /var/lib/apt/lists/*;

# Install Raspberry Pi tools
RUN cd /opt; \
    git clone --depth 1 https://github.com/raspberrypi/tools

# Install eudev
RUN mkdir -p /tmp/eudev; \
    cd /tmp/eudev; \
    curl -f -L https://dev.gentoo.org/~blueness/eudev/eudev-3.2.6.tar.gz | tar xvz --strip-components 1; \
    export PATH=/opt/tools/arm-bcm2708/arm-linux-gnueabihf/bin:$PATH; \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --host=arm-linux-gnueabihf \
        --disable-shared \
        --enable-static \
        --with-pic \
        --enable-split-usr \
        --disable-manpages \
        --disable-kmod \
        --disable-selinux \
        --disable-blkid \
        --prefix=/usr/local; \
    make install-strip; \
    rm -rf /tmp/eudev

# Install libusb
RUN mkdir -p /tmp/libusb; \
    cd /tmp/libusb; \
    curl -f -L https://github.com/libusb/libusb/releases/download/v$LIBUSB_VERSION/libusb-$LIBUSB_VERSION.tar.bz2 | tar xvj --strip-components 1; \
    export PATH=/opt/tools/arm-bcm2708/arm-linux-gnueabihf/bin:$PATH; \
    export CFLAGS=-I/usr/local/include; \
    export CPPFLAGS=-I/usr/local/include; \
    export LDFLAGS=-L/usr/local/lib; \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --host=arm-linux-gnueabihf \
        --disable-shared \
        --enable-static \
        --with-pic \
        --prefix=/usr/local; \
    make install-strip; \
    rm -rf /tmp/libusb

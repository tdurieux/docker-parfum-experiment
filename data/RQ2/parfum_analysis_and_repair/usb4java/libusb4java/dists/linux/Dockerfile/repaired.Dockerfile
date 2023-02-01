#
# Copyright (C) 2018 Klaus Reimer <k@ailis.de>
# See LICENSE.md for licensing information.
#

ARG DEBARCH
FROM $DEBARCH/debian:stretch

ENV LIBUSB_VERSION=1.0.24

# Copy optional qemu binaries
ARG ARCH
COPY target/build/linux-$ARCH/qemu* /usr/bin/

# Install debian updates
RUN apt-get update && apt-get upgrade -y

# Workaround for armhf architecture: This package can't be installed later as a
# dependency of gcj-6-jdk (Corrupt tarball error messages) but for some reason
# it works when it is installed beforehand
RUN apt-get install --no-install-recommends -y gnome-icon-theme && rm -rf /var/lib/apt/lists/*;

# Install required debian packages
RUN apt-get install --no-install-recommends -y gcc cmake curl gperf bzip2 gcj-6-jdk && rm -rf /var/lib/apt/lists/*;

# Install eudev
RUN mkdir -p /tmp/eudev; \
    cd /tmp/eudev; \
    curl -f -L https://dev.gentoo.org/~blueness/eudev/eudev-3.2.6.tar.gz | tar xvz --strip-components 1; \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
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
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --disable-shared \
        --enable-static \
        --with-pic \
        --prefix=/usr/local; \
    make install-strip; \
    rm -rf /tmp/libusb

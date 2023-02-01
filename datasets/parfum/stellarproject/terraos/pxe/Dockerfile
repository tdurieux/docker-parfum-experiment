# syntax=docker/dockerfile:experimental

# Copyright (c) 2019 Stellar Project

# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH
# THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

ARG KERNEL_VERSION
ARG VERSION
ARG REPO

# ------------------ imports ------------------------------ #
FROM $REPO/kernel:$KERNEL_VERSION as kernel

# ------------------ pxe build --------------------------- #

FROM ubuntu:18.10 as pxe

ARG KERNEL_VERSION

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	syslinux \
	curl \
	git \
	make \
	ca-certificates \
	xz-utils \
	syslinux-utils \
	open-iscsi \
	isc-dhcp-common \
	isc-dhcp-client \
	initramfs-tools \
	zfs-initramfs \
	build-essential \
	autoconf \
	automake \
	libtool \
	gawk \
	alien \
	zlib1g-dev \
	uuid-dev \
	libattr1-dev \
	libblkid-dev \
	libselinux-dev \
	libudev-dev \
	libacl1-dev \
	libaio-dev \
	libdevmapper-dev \
	libssl-dev \
	libelf-dev

RUN rm -r /lib/modules && mkdir /lib/modules

RUN --mount=type=bind,from=kernel,target=/tmp dpkg -i \
	/tmp/linux-headers-$KERNEL_VERSION-terra_$KERNEL_VERSION-terra-1_amd64.deb \
	/tmp/linux-libc-dev_$KERNEL_VERSION-terra-1_amd64.deb \
	/tmp/linux-image-$KERNEL_VERSION-terra_$KERNEL_VERSION-terra-1_amd64.deb

# install zfs module
RUN git clone https://github.com/zfsonlinux/zfs
WORKDIR /zfs
RUN ./autogen.sh && \
	./configure && \
	./scripts/make_gitrev.sh && \
	cd module && \
	make -s -j "$(getconf _NPROCESSORS_ONLN)" && \
	make install

RUN curl -sSL https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz -o /tmp/syslinux.tar.xz && \
	tar xf /tmp/syslinux.tar.xz -C /

RUN mkdir -p /tftp/syslinux /tftp/pxelinux.cfg

WORKDIR /syslinux-6.03

RUN cp -r bios/core/isolinux.bin \
	bios/mbr/mbr.bin \
	bios/com32/elflink/ldlinux/ldlinux.c32 \
	bios/com32/menu/vesamenu.c32  \
	bios/com32/menu/menu.c32 \
	bios/com32/chain/chain.c32 \
	bios/com32/libutil/libutil.c32 \
	bios/com32/lib/libcom32.c32 \
	bios/com32/modules/sanboot.c32 /tftp/syslinux/

ADD syslinux.cfg /tftp/syslinux/syslinux.cfg
ADD splash.png /tftp/syslinux/splash.png

RUN cp -r bios/core/pxelinux.0 \
	bios/com32/cmenu/libmenu/libmenu.c32 \
	bios/com32/menu/menu.c32 \
	bios/com32/modules/sanboot.c32 \
	bios/memdisk/memdisk \
	bios/com32/elflink/ldlinux/ldlinux.c32 \
	bios/com32/libutil/libutil.c32 /tftp/

WORKDIR /

ADD terra /etc/initramfs-tools/scripts/terra
ADD modules /etc/initramfs-tools/modules
RUN touch /etc/iscsi/iscsi.initramfs
ADD default /tftp/pxelinux.cfg/default
ADD 00_bonding_init /etc/initramfs-tools/scripts/local-top/
RUN chmod 0755 /etc/initramfs-tools/scripts/local-top/00_bonding_init

RUN update-initramfs -u

RUN mv /boot/vmlinuz-$KERNEL_VERSION-terra /tftp/vmlinuz && \
	mv /boot/initrd.img-$KERNEL_VERSION-terra /tftp/initrd.img

# ------------------------ output -----------------------------

FROM scratch

COPY --from=pxe /tftp/ /tftp/
COPY --from=pxe /lib/modules/ /lib/modules/
COPY --from=pxe /usr/src/ /usr/src/

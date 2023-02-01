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

ARG VERSION
ARG KERNEL_VERSION
ARG REPO

FROM $REPO/pxe:$VERSION as pxe
FROM ${REPO}/orbit:${VERSION} as orbit
FROM ${REPO}/containerd:${VERSION} as containerd
FROM ${REPO}/terracmd:${VERSION} as terra
FROM ${REPO}/node_exporter:${VERSION} as node_exporter
FROM ${REPO}/cni:${VERSION} as cni
FROM ${REPO}/wireguard:${VERSION} as wireguard

# main OS image
FROM docker.io/stellarproject/alpine:deboot
ARG KERNEL_VERSION

ADD repositories /etc/apk/

RUN apk update && apk upgrade && \
	apk add --no-cache \
	ca-certificates \
	curl \
	bash \
	pigz \
	htop \
	tmux \
	rsync \
	criu \
	apparmor \
	apparmor-profiles \
	bonding \
	vlan \
	openssh-server-pam \
	open-iscsi \
	eudev \
	sudo \
	nfs-utils \
	libvirt-daemon \
	qemu-img \
	qemu-system-x86_64 \
	dbus \
	polkit \
	virt-manager \
	zfs \
	iptables

RUN rm -rf /boot /lib/modules
COPY --from=pxe /tftp /boot
COPY --from=pxe /lib/modules/ /lib/modules/
COPY --from=pxe /usr/src/ /usr/src/
RUN rm -rf /boot/*.c32 /boot/pxelinux.0 /boot/pxelinux.cfg

RUN rm /etc/fstab

# add the default terra user
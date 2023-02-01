# Copyright 2018 Mikhail Klementev. All rights reserved.
# Use of this source code is governed by a AGPLv3 license
# (or later) that can be found in the LICENSE file.
#
# Usage:
#
#     $ docker build -t gen-ubuntu2004-image .
#     $ docker run --privileged -v $(pwd):/shared -t gen-ubuntu2004-image
#
# ubuntu2004.img will be created in current directory. You can change $(pwd) to
# different directory to use different destination for image.
#
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install --no-install-recommends -y debootstrap qemu-utils && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y linux-image-generic && rm -rf /var/lib/apt/lists/*;

ENV TMPDIR=/tmp/ubuntu
ENV IMAGEDIR=/tmp/image
ENV IMAGE=/shared/ubuntu2004.img
ENV REPOSITORY=http://archive.ubuntu.com/ubuntu
ENV RELEASE=focal

RUN mkdir $IMAGEDIR

# Must be executed with --privileged because of /dev/loop
CMD debootstrap --include=openssh-server,policykit-1 \
	$RELEASE $TMPDIR $REPOSITORY && \
	/shared/setup.sh $TMPDIR && \
	qemu-img create $IMAGE 2G && \
	mkfs.ext4 -F $IMAGE && \
	mount -o loop $IMAGE $IMAGEDIR && \
	cp -a $TMPDIR/* $IMAGEDIR/ && \
	umount $IMAGEDIR

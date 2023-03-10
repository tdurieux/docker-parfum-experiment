FROM ubuntu:18.04

MAINTAINER Hirochika Asai <panda@jar.jp>

## Install build-essentials and qemu
RUN apt-get update && apt-get install -y --no-install-recommends build-essential qemu-system vim-common isc-dhcp-server iproute2 bridge-utils tftpd-hpa && rm -rf /var/lib/apt/lists/*;

## Copy source to the workdir
COPY src /usr/src
WORKDIR /usr/src
RUN make
RUN mkdir -p /tftpboot
RUN chmod 0777 /tftpboot
RUN cp boot/pxeboot /tftpboot/pxeadvos
RUN cp kernel/kernel /tftpboot/kernel

## For qemu+bridge
RUN mkdir /etc/qemu
RUN echo "allow all" > /etc/qemu/bridge.conf

## Run the OS with qemu
CMD ["/pxe-cmd.sh"]


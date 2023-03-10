FROM ubuntu:16.04

MAINTAINER Hirochika Asai <panda@jar.jp>

## Install build-essentials and qemu
RUN apt-get update && apt-get install -y --no-install-recommends build-essential qemu-system vim-common && rm -rf /var/lib/apt/lists/*;

## Copy source to the workdir
COPY src /usr/src
WORKDIR /usr/src
RUN make clean all

## Run the OS with qemu
CMD ["qemu-system-x86_64", "-m", "1024", \
	"-smp", "cores=1,threads=1,sockets=1", \
	"-drive", "id=disk,format=raw,file=advos.img,if=none", \
	"-device", "ahci,id=ahci", \
	"-device", "ide-drive,drive=disk,bus=ahci.0", \
	"-boot", "a", "-display", "curses"]

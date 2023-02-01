FROM balenalib/raspberrypi3-64-golang:1.10.8

# Enable QEMU emulation
ENTRYPOINT [ "qemu-aarch64-static", "-execve" ]
SHELL      [ "qemu-aarch64-static", "-execve", "/bin/sh", "-c" ]

RUN apt-get update \
	&& apt-get install -y \
		btrfs-tools \
		libapparmor-dev \
		libdevmapper-dev \
		libnl-3-dev \
		libsystemd-dev \
		libudev-dev

COPY . /balena-engine

WORKDIR /balena-engine

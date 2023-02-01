FROM balenalib/raspberrypi3-golang:1.10.8

# Enable QEMU emulation
ENTRYPOINT [ "qemu-arm-static", "-execve" ]
SHELL      [ "qemu-arm-static", "-execve", "/bin/sh", "-c" ]

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

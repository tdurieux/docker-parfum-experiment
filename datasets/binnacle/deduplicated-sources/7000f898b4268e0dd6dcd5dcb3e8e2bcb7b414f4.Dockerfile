FROM balenalib/i386-golang:1.10.8

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

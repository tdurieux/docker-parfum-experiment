FROM ubuntu:impish

ARG BUILD_DATE

LABEL maintainer="Géry Casiez <gery.casiez@univ-lille.fr>" \
	  description="Docker for compiling Libpointing for Linux" \
	  version="1.0" \
	  org.label-schema.build-date=$BUILD_DATE

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
	sudo \
	apt-utils \
	apt-transport-https \
	ca-certificates \
	net-tools \
	systemd \
	apt-utils \
	python3 \
	python3-pip \
	cron \
	wget \
	ssh \
	vim \
	git \
	qtbase5-dev \
	libxrandr-dev \
	libudev-dev \
	dialog \
	libxi-dev \
	freeglut3-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 --no-cache-dir install cython



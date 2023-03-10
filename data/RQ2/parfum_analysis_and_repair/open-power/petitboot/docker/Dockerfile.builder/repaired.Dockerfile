# Image for compiling petitboot.

ARG DOCKER_FROM

FROM ${DOCKER_FROM}

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
	apt-utils \
	autoconf \
	autopoint \
	bison \
	clang \
	clang-tools \
	flex \
	gettext \
	gcc \
	git \
	libtool \
	libdevmapper-dev \
	libfdt-dev \
	libgpgme11-dev \
	libncurses-dev \
	libssl-dev \
	libuv-dev \
	libelf-dev \
	libdw-dev \
	pkg-config \
	strace \
	&& rm -rf /var/lib/apt/lists/*

CMD /bin/bash

FROM debian:unstable-slim
MAINTAINER Knot DNS <knot-dns@labs.nic.cz>
ENV DEBIAN_FRONTEND noninteractive
RUN sed -i 's/deb.debian.org/ftp.cz.debian.org/' /etc/apt/sources.list
RUN apt-get -y update && apt-get -y --no-install-recommends install \
	apt-utils \
	autoconf \
	automake \
	autotools-dev \
	build-essential \
	clang \
	libbpf-dev \
	libedit-dev \
	libfstrm-dev \
	libgnutls28-dev \
	libidn2-0-dev \
	liblmdb-dev \
	libmaxminddb-dev \
	libmnl-dev \
	libnghttp2-dev \
	libprotobuf-c-dev \
	libsystemd-dev \
	libtool \
	liburcu-dev \
	locales-all \
	pkg-config \
	protobuf-c-compiler && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y dist-upgrade
























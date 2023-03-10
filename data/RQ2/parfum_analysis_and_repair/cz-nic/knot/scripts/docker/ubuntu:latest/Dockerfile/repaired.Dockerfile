FROM ubuntu:latest
MAINTAINER Knot DNS <knot-dns@labs.nic.cz>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y --no-install-recommends install \
	autoconf \
	automake \
	autotools-dev \
	build-essential \
	curl \
	ghostscript \
	git \
	language-pack-en \
	latexmk \
	libedit-dev \
	libfstrm-dev \
	libgnutls28-dev \
	libidn2-0-dev \
	liblmdb-dev \
	libmaxminddb-dev \
	libprotobuf-c-dev \
	libsystemd-dev \
	libtool \
	liburcu-dev \
	pkg-config \
	protobuf-c-compiler \
	python3-sphinx \
	texinfo \
	texlive \
	texlive-font-utils \
	texlive-latex-extra \
	unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y dist-upgrade





























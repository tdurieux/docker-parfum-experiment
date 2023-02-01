FROM ubuntu:17.04
MAINTAINER Antergos Linux Project <dev@antergos.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& apt-get install --no-install-recommends -y \
		liblightdm-gobject-1-dev \
		libqt5webengine5 \
		python3-gi \
		python3-pyqt5 \
		python3-pip \
		zip \
		sudo \
	&& pip3 install --no-cache-dir whither && rm -rf /var/lib/apt/lists/*;

VOLUME /build
WORKDIR /build

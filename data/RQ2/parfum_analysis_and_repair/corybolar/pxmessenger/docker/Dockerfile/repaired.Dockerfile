FROM ubuntu:xenial

RUN apt-get update -q && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt-get update -q && apt-get install --no-install-recommends -y libqt5gui5 \
	qtbase5-dev \
	libqt5multimedia5 \
	qtmultimedia5-dev \
	libevent-2.0-5 \
	libevent-dev \
	g++-5 \
	make \
	git \
	qt5-default \
	g++ && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/cbpeckles/pxmessenger

ENTRYPOINT /bin/bash

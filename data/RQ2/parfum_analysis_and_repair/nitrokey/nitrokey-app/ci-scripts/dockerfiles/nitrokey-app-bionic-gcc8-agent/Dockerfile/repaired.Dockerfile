FROM ubuntu:18.04

ENV COMPILER_NAME=gcc CXX=g++-8 CC=gcc-8

RUN apt-get update && \
	apt-get install --no-install-recommends -y software-properties-common && \
	add-apt-repository ppa:ubuntu-toolchain-r/test && \
	apt-get update && \
	apt-get install --no-install-recommends -y build-essential cmake libhidapi-dev libusb-1.0-0-dev g++-8 python3 python3-pip python3-requests pkg-config qt5-default qttools5-dev-tools libqt5svg5-dev libqt5concurrent5 && rm -rf /var/lib/apt/lists/*;

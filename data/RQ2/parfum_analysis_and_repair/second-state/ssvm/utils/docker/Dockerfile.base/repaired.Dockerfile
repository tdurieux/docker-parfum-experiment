FROM ubuntu:20.04

MAINTAINER hydai hydai@secondstate.io
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
	&& apt install --no-install-recommends -y \
	software-properties-common \
	dpkg-dev \
	wget \
	cmake \
	ninja-build \
	curl \
	git \
	libboost-all-dev \
	llvm-12-dev \
	liblld-12-dev && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

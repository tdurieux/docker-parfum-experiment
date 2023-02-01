FROM ubuntu:16.04

ARG arch

RUN dpkg --add-architecture $arch && \
	apt-get update && \
	apt-get install --no-install-recommends -y \
		build-essential \
		git \
		g++-multilib \
		pkg-config:$arch \
		libfuse-dev:$arch \
		fuse:$arch && rm -rf /var/lib/apt/lists/*;

FROM debian:bullseye-slim

LABEL maintainer="Alice D. <alice@starwitch.productions>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		apt-utils \
		sudo \
		ca-certificates \
		pkg-config \
		curl \
		wget \
		bzip2 \
		xz-utils \
		make \
		git \
		libarchive-tools \
		doxygen \
		gnupg \
		build-essential \
		python3-docutils \
		python3-pip \
		gdebi-core \
		cmake && \
		apt-get clean && \
		rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
		meson==0.56.2 \
		ninja \
		zstandard \
		python-gnupg

RUN wget https://github.com/devkitPro/pacman/releases/latest/download/devkitpro-pacman.amd64.deb && \
	gdebi -n devkitpro-pacman.amd64.deb && \
	rm devkitpro-pacman.amd64.deb && \
	dkp-pacman -Scc --noconfirm

ENV DEVKITPRO=/opt/devkitpro
ENV PATH=${DEVKITPRO}/tools/bin:$PATH

RUN ln -s /proc/self/mounts /etc/mtab

RUN dkp-pacman -Syyu --noconfirm \
		switch-dev \
		switch-portlibs \
		dkp-toolchain-vars \
		switch-pkg-config && \
    dkp-pacman -S --needed --noconfirm `dkp-pacman -Slq dkp-libs | grep '^switch-'` && \
    dkp-pacman -Scc --noconfirm

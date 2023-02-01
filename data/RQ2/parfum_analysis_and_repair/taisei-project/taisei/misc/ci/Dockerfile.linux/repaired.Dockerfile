FROM ubuntu:focal

LABEL maintainer="Alice D. <alice@starwitch.productions>"

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
	apt install --no-install-recommends -y -qq \
	build-essential \
	libsdl2-dev \
	libogg-dev \
	libopusfile-dev \
	libpng-dev \
	libzip-dev \
	libx11-dev \
	libwayland-dev \
	python3-docutils \
	libwebp-dev \
	libfreetype6-dev \
	python3-pip \
	libzstd-dev \
	git && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir \
	meson==0.56.2 \
	ninja \
	zstandard

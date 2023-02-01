# Stage 1: Download all dependencies
FROM ubuntu:22.04 AS dependencies

RUN apt-get update && apt-get install -y --no-install-recommends cmake git \
	unzip build-essential ca-certificates curl zip unzip tar \
	pkg-config ninja-build autoconf automake libtool \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone https://github.com/microsoft/vcpkg --depth=1
RUN ./vcpkg/bootstrap-vcpkg.sh

WORKDIR /opt/vcpkg
COPY vcpkg.json /opt/vcpkg/
RUN /opt/vcpkg/vcpkg --feature-flags=binarycaching,manifests,versions install

# Stage 2: create build
FROM dependencies AS build

COPY . /srv/
WORKDIR /srv

RUN export VCPKG_ROOT=/opt/vcpkg/ && cmake --preset linux-release && cmake --build --preset linux-release

# Stage 3: load data and execute
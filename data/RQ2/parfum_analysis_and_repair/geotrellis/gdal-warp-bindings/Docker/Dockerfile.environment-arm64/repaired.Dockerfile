FROM buildpack-deps:buster-curl
LABEL maintainer="Azavea <info@azavea.com>"

# Install tools and libraries
RUN dpkg --add-architecture arm64                                                            \
 && apt-get update -y \
 && apt-get install --no-install-recommends -y -q \
        autoconf \
        automake \
        autotools-dev \
        bc \
        binfmt-support \
        libtool \
        patch \
        wget \
        xz-utils \
        cmake \
	software-properties-common \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main'

RUN apt update -y \
 && apt-get install --no-install-recommends -y -q \
    crossbuild-essential-arm64 \
    openjdk-8-jdk:arm64 \
    libgdal-dev:arm64 \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Boost
RUN wget 'https://boostorg.jfrog.io/artifactory/main/release/1.69.0/source/boost_1_69_0.tar.bz2' -O /tmp/boost.tar.bz2 && \
  mkdir -p /usr/local/include && \
  cd /usr/local/include && \
  tar axvf /tmp/boost.tar.bz2 && \
  rm /tmp/boost.tar.bz2

# docker build -f Dockerfile.environment-arm64 -t quay.io/geotrellis/gdal-warp-bindings-environment:arm64-2 .

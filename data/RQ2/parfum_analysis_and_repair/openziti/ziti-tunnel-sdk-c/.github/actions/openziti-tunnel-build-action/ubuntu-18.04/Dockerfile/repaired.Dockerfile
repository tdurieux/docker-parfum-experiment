ARG CMAKE_VERSION="3.22.3"

FROM ubuntu:bionic

ARG CMAKE_VERSION

LABEL org.opencontainers.image.authors="steven.broderick@netfoundry.io,kenneth.bingham@netfoundry.io"

ENV DEBIAN_FRONTEND=noninteractive
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=1
ENV TZ=UTC

USER root
WORKDIR /root/

ENV PATH="/usr/local/:${PATH}"

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
        build-essential \
        curl \
        doxygen \
        git \
        graphviz \
        iproute2 \
        pkg-config \
        python3 \
        libsystemd-dev \
        zlib1g-dev \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -f -L https://cmake.org/files/v${CMAKE_VERSION%.*}/cmake-${CMAKE_VERSION}-linux-x86_64.sh -o cmake.sh \
    && (bash cmake.sh --skip-license --prefix=/usr/local) \
    && rm cmake.sh

WORKDIR /github/workspace
COPY ./entrypoint.sh /root/
ENTRYPOINT [ "/root/entrypoint.sh" ]
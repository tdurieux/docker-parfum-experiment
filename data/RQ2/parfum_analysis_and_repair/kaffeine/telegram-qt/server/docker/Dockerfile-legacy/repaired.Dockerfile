FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN \
    apt update && \
    apt -y upgrade && \
    apt -y install --no-install-recommends \
        bash \
        build-essential \
        cmake \
        git \
        nano \
        qt5-default \
        ninja-build \
        libssl-dev \
        libz-dev \
        && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /work/build
COPY . /work/source

WORKDIR /work/build

RUN /work/source/server/docker/build.sh
RUN /work/source/server/docker/install.sh /work/install

ENTRYPOINT ["/bin/bash"]

RUN cp -rf /work/install /

RUN mkdir -p /data
WORKDIR /data
ENTRYPOINT ["/usr/bin/TelegramTestServer"]
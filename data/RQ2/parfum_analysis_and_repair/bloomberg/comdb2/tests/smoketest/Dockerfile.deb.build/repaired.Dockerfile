FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
    bc \
    bison \
    build-essential \
    cmake \
    file \
    flex \
    gawk \
    libevent-dev \
    liblz4-dev \
    liblz4-tool \
    libprotobuf-c-dev \
    libprotobuf-c1 \
    libreadline-dev \
    libsqlite3-0 \
    libsqlite3-dev \
    libssl-dev \
    libunwind-dev \
    libuuid1 \
    libz-dev \
    libz1 \
    libz1 \
    make \
    ncurses-dev \
    protobuf-c-compiler \
    tcl \
    tzdata \
    uuid-dev \
  && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
  dpkg-reconfigure --frontend noninteractive tzdata && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 5105

COPY . /comdb2/

WORKDIR /comdb2/smoketestbuild

RUN cmake .. && make package && dpkg -i comdb2*.deb

ENV PATH="/opt/bb/bin:${PATH}"

# Minimal dockerfile to run omorfi

FROM ubuntu:latest
MAINTAINER Flammie A Pirinen <flammie@iki.fi>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    build-essential automake autoconf git wget lsb-release libtool zip pkg-config && \
    wget https://apertium.projectjj.com/apt/install-nightly.sh -O - | bash && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install python3-hfst libhfst-dev cg3 -y && \
    git clone https://github.com/flammie/omorfi && \
    cd omorfi && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && rm -rf /var/lib/apt/lists/*;


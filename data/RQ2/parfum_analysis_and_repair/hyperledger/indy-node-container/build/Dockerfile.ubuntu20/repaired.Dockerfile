# This container is to run indy-node.
# This file is part of https://github.com/hyperledger/indy-node-container .
# Copyright 2021-2022 by all people listed in https://github.com/hyperledger/indy-node-container/blob/main/NOTICE , see
# https://github.com/hyperledger/indy-node-container/blob/main/LICENSE for the license information.
#
# author: Robin Klemens <klemens@intnernet-sicherheit.de>

FROM ubuntu:20.04

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    gnupg2 \

    libgflags-dev \
    libsnappy-dev \
    zlib1g-dev \
    libbz2-dev \
    liblz4-dev \
    libgflags-dev \
    python3-pip && rm -rf /var/lib/apt/lists/*;

# Bionic-security for libssl1.0.0
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32 \
    && echo "deb http://security.ubuntu.com/ubuntu bionic-security main"  >> /etc/apt/sources.list

# Sovrin
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CE7709D068DB5E88 \
    && bash -c 'echo "deb https://repo.sovrin.org/deb bionic master" >> /etc/apt/sources.list'

# Hyperledger Artifactory
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 9692C00E657DDE61 \
    && echo "deb https://hyperledger.jfrog.io/artifactory/indy focal rc" >> /etc/apt/sources.list \
    # Prioritize packages from hyperledger.jfrog.io
    && printf '%s\n%s\n%s\n' 'Package: *' 'Pin: origin hyperledger.jfrog.io' 'Pin-Priority: 1001' >> /etc/apt/preferences

RUN pip3 install --no-cache-dir -U \

    'setuptools==50.3.2'


RUN apt-get update -y && apt-get install --no-install-recommends -y \
    indy-node="1.13.1~rc2" \
    indy-plenum="1.13.1~rc2" \
    ursa="0.3.2-1" \
    python3-pyzmq="22.3.0" \
    rocksdb="5.8.8" \
    python3-importlib-metadata="3.10.1" \
    && rm -rf /var/lib/apt/lists/* \
    # fix path to libursa
    && ln -s /usr/lib/ursa/libursa.so /usr/lib/libursa.so


WORKDIR /home/indy

COPY init_and_run.sh ./

CMD ["./init_and_run.sh"]

# produces a docker image suitable to build pmacct

FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    bash \
    bison \
    cmake \
    default-libmysqlclient-dev \
    libnuma-dev \
    flex \
    gcc \
    git \
    libcurl4-openssl-dev \
    libjansson-dev \
    libjson-c-dev \
    libnetfilter-log-dev \
    libpcap-dev \
    libpq-dev \
    libsnappy-dev \
    libsqlite3-dev \
    libssl-dev \
    libgnutls28-dev \
    libstdc++-8-dev \
    libtool \
    make \
    pkg-config \
    sudo \
    wget \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

COPY ./ci/deps.sh .
RUN ./deps.sh

ENTRYPOINT ["/bin/bash"]

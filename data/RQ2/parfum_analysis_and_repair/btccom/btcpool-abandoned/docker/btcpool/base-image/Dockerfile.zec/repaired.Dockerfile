#
# Dockerfile
#
# @author hanjiang.yu@bitmain.com
# @copyright btc.com
# @since 2018-12-01
#
#
FROM ubuntu:18.04
LABEL maintainer="Hanjiang Yu <hanjiang.yu@bitmain.com>"

ARG APT_MIRROR_URL
ARG BUILD_JOBS=1

COPY update_apt_sources.sh /tmp
RUN /tmp/update_apt_sources.sh

# Install build dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    autotools-dev \
    bsdmainutils \
    build-essential \
    cmake \
    curl \
    git \
    libboost-all-dev \
    libconfig++-dev \
    libcurl4-openssl-dev \
    libgmp-dev \
    libgoogle-glog-dev \
    libhiredis-dev \
    libmysqlclient-dev \
    libprotobuf-dev \
    libssl-dev \
    libtool \
    libzmq3-dev \
    libzookeeper-mt-dev \
    openssl \
    pkg-config \
    protobuf-compiler \
    wget \
    yasm \
    zlib1g-dev \
    libsodium-dev \
    && apt-get autoremove && apt-get clean q && rm -rf /var/lib/apt/lists/*

# Build libevent static library
RUN cd /tmp && \
    wget https://github.com/libevent/libevent/releases/download/release-2.1.10-stable/libevent-2.1.10-stable.tar.gz && \
    [ $(sha256sum libevent-2.1.10-stable.tar.gz | cut -d " " -f 1) = "e864af41a336bb11dab1a23f32993afe963c1f69618bd9292b89ecf6904845b0" ] && \
    tar zxf libevent-2.1.10-stable.tar.gz && \
    cd libevent-2.1.10-stable && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-shared && \
    make -j${BUILD_JOBS} && \
    make install && \
    rm -rf /tmp/* && rm libevent-2.1.10-stable.tar.gz

# Build librdkafka static library
RUN cd /tmp && wget https://github.com/edenhill/librdkafka/archive/0.9.1.tar.gz && \
    [ $(sha256sum 0.9.1.tar.gz | cut -d " " -f 1) = "5ad57e0c9a4ec8121e19f13f05bacc41556489dfe8f46ff509af567fdee98d82" ] && \
    tar zxf 0.9.1.tar.gz && cd librdkafka-0.9.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j${BUILD_JOBS} && make install && rm -rf /tmp/* && rm 0.9.1.tar.gz

# Remove dynamic libraries of librdkafka
# In this way, the constructed deb package will
# not have dependencies that not from software sources.
RUN cd /usr/local/lib && \
    find . | grep 'rdkafka' | grep '.so' | xargs rm

# Build blockchain
RUN mkdir -p /work/blockchain && cd /work/blockchain && wget https://github.com/zcash/zcash/archive/v2.0.4.tar.gz && \
    [ $(sha256sum v2.0.4.tar.gz | cut -d " " -f 1) = "7353fdee034053fb4cd1a5588fc9476bd4094158d2edb6b8748e3bad1ffd2de4" ] && \
    tar zxf v2.0.4.tar.gz --strip 1 && rm v2.0.4.tar.gz && ./zcutil/build.sh -j${BUILD_JOBS}

# Used later by btcpool build
ENV CHAIN_TYPE=ZEC

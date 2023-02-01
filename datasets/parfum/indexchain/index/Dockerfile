# This is a Dockerfile for indexd.
FROM debian:bionic

# Install required system packages
RUN apt-get update && apt-get install -y \
    automake \
    bsdmainutils \
    curl \
    g++ \
    libboost-all-dev \
    libevent-dev \
    libssl-dev \
    libtool \
    libzmq3-dev \
    make \
    openjdk-8-jdk \
    pkg-config \
    zlib1g-dev

# Install Berkeley DB 4.8
RUN curl -L http://download.oracle.com/berkeley-db/db-4.8.30.tar.gz | tar -xz -C /tmp && \
    cd /tmp/db-4.8.30/build_unix && \
    ../dist/configure --enable-cxx --includedir=/usr/include/bdb4.8 --libdir=/usr/lib && \
    make -j$(nproc) && make install && \
    cd / && rm -rf /tmp/db-4.8.30

# Install minizip from source (unavailable from apt on Ubuntu 14.04)
RUN curl -L https://www.zlib.net/zlib-1.2.11.tar.gz | tar -xz -C /tmp && \
    cd /tmp/zlib-1.2.11/contrib/minizip && \
    autoreconf -fi && \
    ./configure --enable-shared=no --with-pic && \
    make -j$(nproc) install && \
    cd / && rm -rf /tmp/zlib-1.2.11

# Install zmq from source (outdated version from apt on Ubuntu 14.04)
RUN curl -L https://github.com/zeromq/libzmq/releases/download/v4.3.1/zeromq-4.3.1.tar.gz | tar -xz -C /tmp && \
    cd /tmp/zeromq-4.3.1/ && ./configure --disable-shared --without-libsodium --with-pic && \
    make -j$(nproc) install && \
    cd / && rm -rf /tmp/zeromq-4.3.1/

# Create user to run daemon
RUN useradd -m -U indexd

# Build Index
COPY . /tmp/index/

RUN cd /tmp/index && \
    ./autogen.sh && \
    ./configure --without-gui --prefix=/usr && \
    make -j$(nproc) && \
    make check && \
    make install && \
    cd / && rm -rf /tmp/index

# Remove unused packages
RUN apt-get remove -y \
    automake \
    bsdmainutils \
    curl \
    g++ \
    libboost-all-dev \
    libevent-dev \
    libssl-dev \
    libtool \
    libzmq3-dev \
    make

# Start Index Daemon
USER indexd

RUN mkdir /home/indexd/.IndexChain
VOLUME [ "/home/indexd/.IndexChain" ]

# Main network ports
EXPOSE 7082
EXPOSE 8888

# Test network ports
EXPOSE 18168
EXPOSE 18888

# Regression test network ports
EXPOSE 18444
EXPOSE 28888

ENTRYPOINT [ "/usr/bin/indexd" ]

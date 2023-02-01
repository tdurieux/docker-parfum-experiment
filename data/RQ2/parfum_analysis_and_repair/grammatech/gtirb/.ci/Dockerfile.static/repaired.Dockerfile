FROM ubuntu:20.04

ARG BOOST_VERSION=1.67

SHELL ["/bin/bash", "-c"]

# Install apt packages
RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install autoconf build-essential clang clang-format cmake curl \
        git libtool unzip wget software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install Protobuf
RUN curl -f -L https://github.com/protocolbuffers/protobuf/archive/v3.7.0.tar.gz -o protobuf.tar.gz \
    && gunzip protobuf.tar.gz \
    && tar xf protobuf.tar \
    && cd protobuf-3.7.0 \
    && ./autogen.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" "CFLAGS=-g" "CXXFLAGS=-g" \
    && make \
    && make install && rm protobuf.tar
RUN ldconfig /usr/local/lib

# Install boost
RUN add-apt-repository ppa:mhier/libboost-latest && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install libboost${BOOST_VERSION}-dev && rm -rf /var/lib/apt/lists/*;

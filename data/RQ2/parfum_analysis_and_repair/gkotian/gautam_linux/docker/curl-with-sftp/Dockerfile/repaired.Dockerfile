FROM ubuntu:18.04

ARG LIBSSH2_VERSION="1.8.2"
ARG CURL_VERSION="7.64.1"

WORKDIR /project

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        build-essential \
        libcurl4-openssl-dev \
        libssl-dev \
        wget && \
    wget https://www.libssh2.org/download/libssh2-${LIBSSH2_VERSION}.tar.gz && \
    tar zxf libssh2-${LIBSSH2_VERSION}.tar.gz && \
    rm /project/libssh2-${LIBSSH2_VERSION}.tar.gz && \
    wget https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz && \
    tar zxf curl-${CURL_VERSION}.tar.gz && \
    rm curl-${CURL_VERSION}.tar.gz && \
    cd /project/libssh2-${LIBSSH2_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && \
    cd /project/curl-${CURL_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-libssh2=/usr/local && \
    make && \
    make install && \
    cd /project && rm -rf /var/lib/apt/lists/*;

CMD [ "/bin/bash" ]

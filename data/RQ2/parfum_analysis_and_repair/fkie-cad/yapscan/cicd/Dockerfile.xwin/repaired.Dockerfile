FROM golang:buster

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt

RUN apt-get clean
RUN apt-get update && apt-get install --no-install-recommends -y build-essential pkg-config \
    git gcc-multilib gcc-mingw-w64 autoconf automake \
    libtool libjansson-dev libmagic-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /opt/cicd

ARG BUILD_THREADS=4
ENV BUILD_THREADS=$BUILD_THREADS

COPY determineBuildEnvironment.sh /opt/cicd

ARG OPENSSL_VERSION
RUN git clone --depth=1 --branch=$OPENSSL_VERSION https://github.com/openssl/openssl.git /opt/openssl
COPY buildOpenssl.sh /opt/cicd
RUN /opt/cicd/buildOpenssl.sh /opt/openssl /opt/yapscan-deps

ARG YARA_VERSION
RUN git clone --depth=1 --branch=$YARA_VERSION https://github.com/VirusTotal/yara.git /opt/yara
COPY buildYara.sh /opt/cicd
ENV PKG_CONFIG_LIBDIR=/opt/yapscan-deps/lib/pkgconfig
RUN /opt/cicd/buildYara.sh /opt/yara /opt/yapscan-deps

ENTRYPOINT /bin/bash
CMD ["-"]
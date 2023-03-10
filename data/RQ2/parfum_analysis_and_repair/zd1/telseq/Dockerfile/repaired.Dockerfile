FROM ubuntu:14.04
MAINTAINER Zhihao Ding <zhihao.ding@gmail.com>
LABEL Description="Telseq docker" Version="0.0.1"

VOLUME /tmp

WORKDIR /tmp

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        automake \
        autotools-dev \
        build-essential \
        cmake \
        libhts-dev \
        libhts0 \
        libjemalloc-dev \
        libsparsehash-dev \
        libz-dev \
        python-matplotlib \
        wget \
        zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# build remaining dependencies:
# bamtools
RUN mkdir -p /deps && \
    cd /deps && \
    wget https://github.com/pezmaster31/bamtools/archive/v2.4.0.tar.gz && \
    tar -xzvf v2.4.0.tar.gz && \
    rm v2.4.0.tar.gz && \
    cd bamtools-2.4.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make


# build telseq
RUN mkdir -p /src && \
    cd /src && \
    wget https://github.com/zd1/telseq/archive/v0.0.1.tar.gz && \
    tar -xzvf v0.0.1.tar.gz && \
    rm v0.0.1.tar.gz && \
    cd telseq-0.0.1/src && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-bamtools=/deps/bamtools-2.4.0 --prefix=/usr/local && \
    make && \
    make install


ENTRYPOINT ["/usr/local/bin/telseq"]
CMD ["--help"]
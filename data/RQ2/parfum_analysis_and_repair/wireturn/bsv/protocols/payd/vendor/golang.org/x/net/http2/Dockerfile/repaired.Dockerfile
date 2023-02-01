#
# This Dockerfile builds a recent curl with HTTP/2 client support, using
# a recent nghttp2 build.
#
# See the Makefile for how to tag it. If Docker and that image is found, the
# Go tests use this curl binary for integration tests.
#

FROM ubuntu:trusty

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git-core build-essential wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
       autotools-dev libtool pkg-config zlib1g-dev \
       libcunit1-dev libssl-dev libxml2-dev libevent-dev \
       automake autoconf && rm -rf /var/lib/apt/lists/*;

# The list of packages nghttp2 recommends for h2load:
RUN apt-get install -y --no-install-recommends make binutils \
        autoconf automake autotools-dev \
        libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev \
        libev-dev libevent-dev libjansson-dev libjemalloc-dev \
        cython python3.4-dev python-setuptools && rm -rf /var/lib/apt/lists/*;

# Note: setting NGHTTP2_VER before the git clone, so an old git clone isn't cached:
ENV NGHTTP2_VER 895da9a
RUN cd /root && git clone https://github.com/tatsuhiro-t/nghttp2.git

WORKDIR /root/nghttp2
RUN git reset --hard $NGHTTP2_VER
RUN autoreconf -i
RUN automake
RUN autoconf
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

WORKDIR /root
RUN wget https://curl.haxx.se/download/curl-7.45.0.tar.gz
RUN tar -zxvf curl-7.45.0.tar.gz && rm curl-7.45.0.tar.gz
WORKDIR /root/curl-7.45.0
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-ssl --with-nghttp2=/usr/local
RUN make
RUN make install
RUN ldconfig

CMD ["-h"]
ENTRYPOINT ["/usr/local/bin/curl"]


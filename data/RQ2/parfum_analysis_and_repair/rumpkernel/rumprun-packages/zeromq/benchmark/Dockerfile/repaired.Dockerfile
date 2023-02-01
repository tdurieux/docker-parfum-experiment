FROM ubuntu:16.04

MAINTAINER ZeroMQ Project <zeromq@imatix.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git build-essential libtool autoconf automake pkg-config unzip libkrb5-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && git clone --depth 1 https://github.com/zeromq/libzmq.git && cd libzmq && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make

# RUN cd /tmp/libzmq && make check

RUN cd /tmp/libzmq && make install && ldconfig

ADD example1 /bin/example1

ENTRYPOINT ["/bin/example1"]

RUN rm /tmp/* -rf

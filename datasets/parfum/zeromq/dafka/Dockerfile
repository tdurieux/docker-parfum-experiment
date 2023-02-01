FROM ubuntu:latest
MAINTAINER dafka Developers <zeromq-dev@lists.zeromq.org>

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q --force-yes build-essential git-core libtool autotools-dev autoconf automake pkg-config unzip libkrb5-dev cmake
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q --force-yes \
     libzmq3-dev \
     libleveldb-dev \
     libcjson-dev

RUN useradd -d /home/zmq -m -s /bin/bash zmq
RUN echo "zmq ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /tmp
RUN git clone --quiet https://github.com/zeromq/czmq.git czmq
WORKDIR /tmp/czmq
RUN ./autogen.sh 2> /dev/null
RUN ./configure --quiet --without-docs
RUN make
RUN make install
RUN ldconfig

WORKDIR /tmp
RUN git clone --quiet https://github.com/cucumber/gherkin-c gherkin
WORKDIR /tmp/gherkin
RUN ./autogen.sh 2> /dev/null
RUN ./configure --quiet --without-docs
RUN make
RUN make install
RUN ldconfig

WORKDIR /tmp
RUN git clone --quiet https://github.com/zeromq/dafka dafka
WORKDIR /tmp/dafka
RUN ./autogen.sh 2> /dev/null
RUN ./configure --quiet --without-docs
RUN make
RUN make install
RUN ldconfig


USER zmq

FROM ubuntu:15.10
MAINTAINER Lachlan McCalman <lachlan.mccalman@nicta.com.au>

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  libeigen3-dev \
  libzmq3-dev \
  libboost-program-options-dev \
  libboost-system-dev \
  libboost-filesystem-dev \
  libboost-regex-dev \
  libboost-coroutine-dev \
  libboost-thread-dev \
  libboost-date-time-dev \
  libboost-context-dev \
  libgtest-dev && rm -rf /var/lib/apt/lists/*;

ENV BUILD_DIR=/tmp/stateline LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

RUN mkdir -p /stateline /usr/local/src/stateline /usr/local/src/stateline/tools /tmp/build

COPY ./tools /usr/local/src/stateline/tools

COPY . /usr/local/src/stateline/
RUN mkdir /usr/local/build
WORKDIR /usr/local/build
RUN cmake /usr/local/src/stateline -DCMAKE_BUILD_TYPE=Release -DLOCAL_INSTALL=OFF \
  && make \
  && make install \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /stateline
EXPOSE 5555 5556

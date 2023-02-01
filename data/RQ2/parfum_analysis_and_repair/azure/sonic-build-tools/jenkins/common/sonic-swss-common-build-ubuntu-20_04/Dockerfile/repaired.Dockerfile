FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update  # 20210106 invalidate docker build cache
RUN apt-get install --no-install-recommends -y make libtool m4 autoconf dh-exec debhelper cmake pkg-config \
                       libhiredis-dev libnl-3-dev libnl-genl-3-dev libnl-route-3-dev libnl-nf-3-dev swig3.0 \
                       libpython2.7-dev libgtest-dev libboost-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y redis-server redis-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pytest

RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends cmake libgtest-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /usr/src/gtest && cmake . && make

FROM ubuntu:trusty
MAINTAINER czmq Developers <zeromq-dev@lists.zeromq.org>

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q --force-yes build-essential git-core libtool autotools-dev autoconf automake pkg-config unzip libkrb5-dev cmake && rm -rf /var/lib/apt/lists/*;

RUN useradd -d /home/zmq -m -s /bin/bash zmq
RUN echo "zmq ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/zmq
RUN chmod 0440 /etc/sudoers.d/zmq

USER zmq

WORKDIR /home/zmq
RUN git clone --quiet https://github.com/zeromq/libzmq.git
WORKDIR /home/zmq/libzmq
RUN ./autogen.sh 2> /dev/null
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --quiet --without-docs
RUN make
RUN sudo make install
RUN sudo ldconfig

WORKDIR /home/zmq
RUN git clone --quiet git://github.com/zeromq/czmq.git
WORKDIR /home/zmq/czmq
RUN ./autogen.sh 2> /dev/null
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --quiet --without-docs
RUN make
RUN sudo make install
RUN sudo ldconfig

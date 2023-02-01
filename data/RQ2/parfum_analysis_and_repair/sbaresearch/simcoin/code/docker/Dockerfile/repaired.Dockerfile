FROM library/ubuntu:xenial-20170119
RUN \
     apt-get update && \
     apt-get -y --no-install-recommends install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils && \
     apt-get -y --no-install-recommends install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev && \
     apt-get -y --no-install-recommends install software-properties-common && \
     add-apt-repository ppa:bitcoin/bitcoin && \
     apt-get -y update && \
     apt-get -y --no-install-recommends install libdb4.8-dev libdb4.8++-dev && \
     && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/simonmulser/bitcoin.git
WORKDIR "/bitcoin"
RUN git checkout simcoin

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"

RUN make
# multi-threaded
#RUN make -j4

ENV PATH /bitcoin/src:$PATH
RUN mkdir /data

EXPOSE 18332

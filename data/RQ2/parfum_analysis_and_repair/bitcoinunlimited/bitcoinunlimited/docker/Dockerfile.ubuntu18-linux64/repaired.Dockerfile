FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y libdb-dev libdb++-dev build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-all-dev libminiupnpc-dev libzmq3-dev git unzip wget vim && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# change the url to your forked repo if you dont want to pull the bitcoinunlimted repo
RUN git clone https://github.com/bitcoinunlimited/bitcoinunlimited

# to checkout a specific branch uncomment the lines in the section below
###############
# WORKDIR /bitcoinunlimited
# git checkout <branch name>
###############


WORKDIR /bitcoinunlimited

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-dependency-tracking --enable-glibc-back-compat --enable-reduce-exports LDFLAGS=-static-libstdc++ --with-gui=no --with-incompatible-bdb

RUN make -j2

RUN mkdir /root/.bitcoin/

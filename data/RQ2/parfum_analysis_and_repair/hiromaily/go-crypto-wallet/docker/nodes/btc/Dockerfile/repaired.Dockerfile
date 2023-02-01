FROM wallet-ubuntu:18.04
#FROM ubuntu:18.04

#RUN apt-get update && \
#    apt-get install -y software-properties-common

RUN add-apt-repository ppa:bitcoin/bitcoin && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get update && \
    apt-get install --no-install-recommends -y libstdc++-7-dev bitcoind && rm -rf /var/lib/apt/lists/*;

#RUN mkdir /root/.bitcoin
#COPY bitcoin.conf /root/.bitcoin/bitcoin.conf

FROM ubuntu:18.04

RUN apt-get -qq update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:bitcoin/bitcoin \
  && add-apt-repository -y universe && apt-get update

RUN apt-get install --no-install-recommends -y bitcoind && rm -rf /var/lib/apt/lists/*;

ADD ./bitcoin.conf /bitcoin/bitcoin.conf

FROM ubuntu:xenial

RUN apt-get update \
  && apt-get install --no-install-recommends -y wget software-properties-common \
  && rm -rf /var/lib/apt/lists/*

WORKDIR "/root"

RUN add-apt-repository -y ppa:ethereum/ethereum

ARG binary
RUN apt-get update \
  && apt-get install --no-install-recommends -y ethereum && rm -rf /var/lib/apt/lists/*;

CMD exec bootnode -nodekeyhex $nodekeyhex

EXPOSE 30301/udp
EXPOSE 30303/udp

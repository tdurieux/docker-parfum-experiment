FROM ubuntu:xenial

RUN apt-get update \
  && apt-get install --no-install-recommends -y wget software-properties-common \
  && rm -rf /var/lib/apt/lists/*

WORKDIR "/root"

RUN apt-get update \
  && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Pinning geth to version 1.9.20 as all successive geth versions dont support whisper anymore
# Refer to the release notes for 1.9.21 - https://github.com/ethereum/go-ethereum/releases/tag/v1.9.21
RUN wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.9.20-979fc968.tar.gz
RUN tar -xzvf geth-linux-amd64-1.9.20-979fc968.tar.gz && rm geth-linux-amd64-1.9.20-979fc968.tar.gz
RUN chmod +x ./geth-linux-amd64-1.9.20-979fc968/geth
RUN mv ./geth-linux-amd64-1.9.20-979fc968/geth /usr/local/bin/
RUN rm -rf ./geth-linux-amd64-1.9.20-979fc968

CMD exec bootnode -nodekeyhex $nodekeyhex

EXPOSE 30301/udp
EXPOSE 30303/udp

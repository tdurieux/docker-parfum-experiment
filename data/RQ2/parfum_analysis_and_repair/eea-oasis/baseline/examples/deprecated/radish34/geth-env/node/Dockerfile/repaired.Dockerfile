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

ARG password
ARG privatekey
RUN echo $password > ~/.accountpassword
RUN echo $privatekey > ~/.privatekey
ADD ./genesis.json ./genesis.json
ADD ./static-nodes.json ./.ethereum/geth/static-nodes.json
RUN geth init genesis.json
RUN geth account import --password ~/.accountpassword ~/.privatekey

CMD exec geth --bootnodes "enode://$bootnodeId@$bootnodeIp:30301" --networkid "$networkId" --nousb --verbosity=$verbosity --ws --wsport 8546 --wsaddr "0.0.0.0" --wsorigins="*" --wsapi=web3,shh,net,admin --rpc --rpcaddr "0.0.0.0" --rpcapi "eth,web3,net,admin,debug,shh" --rpccorsdomain "*" --syncmode="$nodeType" --etherbase $address --unlock $address --password ~/.accountpassword --allow-insecure-unlock --shh

EXPOSE 8545
EXPOSE 8546
EXPOSE 30303

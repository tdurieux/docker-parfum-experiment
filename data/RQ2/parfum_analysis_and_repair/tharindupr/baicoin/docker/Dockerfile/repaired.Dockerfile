FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt dist-upgrade -y

RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt update

RUN apt install --no-install-recommends -y build-essential gcc make perl dkms git build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libdb4.8-dev libdb4.8++-dev libminiupnpc-dev libzmq3-dev libprotobuf-dev protobuf-compiler libprotobuf-dev protobuf-compiler openssl1.0 libssl1.0-dev && rm -rf /var/lib/apt/lists/*;

ADD . /root/BaiCoin/
COPY docker/baicoin.conf /root/.baicoin/

WORKDIR /root/BaiCoin/bin

# Build: $docker build -f docker/Dockerfile . -t baicoins # (run from repo root)
# Run:   $docker run --name baicoin_miner -i baicoins
# Shell: $docker exec -it baicoin_miner /bin/bash

# To mine, goto the shell and run `./baicoind --daemon && ./baicoind setgenerate true $(nproc)`
# Transfer mined coins using `./baicoind sendtoaddress <address>`

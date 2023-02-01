FROM ubuntu:18.04
MAINTAINER Aleksey Karpov <admin@bitaps.com>
RUN apt-get update
# install python

RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir git+https://github.com/bitaps-com/aiojsonrpc
RUN pip3 install --no-cache-dir colorlog
RUN pip3 install --no-cache-dir aiohttp
RUN pip3 install --no-cache-dir pyzmq
RUN pip3 install --no-cache-dir uvloop
RUN pip3 install --no-cache-dir pybtc

COPY ./ /
WORKDIR /

ENTRYPOINT ["/bin/bash"]
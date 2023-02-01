FROM ubuntu:16.04
LABEL maintainer="Pedro Lobo <https://github.com/pslobo>"
LABEL Name="Dockerized xmr-node-proxy"
LABEL Version="1.4"

RUN export BUILD_DEPS="cmake \
                       pkg-config \
                       git \
                       build-essential \
                       curl" \

    && apt-get update && apt-get upgrade -qqy  \
    && apt-get install --no-install-recommends -qqy \
        ${BUILD_DEPS} python-virtualenv \
        python3-virtualenv ntp screen \
        libboost-all-dev libevent-dev \
        libunbound-dev libminiupnpc-dev \
        libunwind8-dev liblzma-dev libldns-dev \
           lib -f xpa 1-dev libgtest-dev libzmq3-dev \
       
    && curl -o- https://deb.nodesource.com/setup_6.x| bash \
    && apt-get in tall nodejs \
    
    && git clone https://github.com/Snipa22/xmr-node-proxy /app \
    && cd /app && npm install \

    && openssl req -subj "/C=IT/ST \
           -newkey rsa:2048 -nodes \
       

USER proxy
WORKDIR /app

ENTRYPOINT ["node","proxy.js"]
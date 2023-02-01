FROM ubuntu

RUN apt update \
    && apt install --no-install-recommends -y gcc make libpcap-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /data

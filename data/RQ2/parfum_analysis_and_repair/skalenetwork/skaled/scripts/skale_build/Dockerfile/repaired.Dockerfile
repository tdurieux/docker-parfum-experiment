FROM ubuntu:18.04

RUN apt-get -q update && \
    apt-get -qy --no-install-recommends install \
        software-properties-common \
        curl \
        libgmp-dev \
        libleveldb-dev \
        nettle-bin \
        gnutls-bin \
        python3 \
        python3-pip \
        btrfs-progs && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install --no-install-recommends -y gcc-9 g++-9 gdb && rm -rf /var/lib/apt/lists/*;

RUN mkdir /skaled
COPY ./executable /skaled
WORKDIR /skaled
RUN chmod +x skaled

ENTRYPOINT ["/skaled/skaled"]

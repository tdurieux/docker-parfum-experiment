FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade --yes && \
    apt-get --yes --no-install-recommends install build-essential git cmake wget zlibc zlib1g zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/gtc

WORKDIR /home/gtc

RUN git clone https://github.com/refresh-bio/GTC.git

WORKDIR /home/gtc/GTC

RUN ./install.sh

RUN make

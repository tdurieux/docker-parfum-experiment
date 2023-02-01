FROM ubuntu:latest

MAINTAINER aaron@aaronbedra.com

run apt-get -y update && apt-get -y --no-install-recommends install git libtool autoconf automake make gcc curl libcurl4-openssl-dev libpcre3-dev zlib1g-dev libhiredis0.13 libhiredis-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade


WORKDIR /build

COPY build.sh .

RUN bash build.sh

RUN tail -f /dev/null

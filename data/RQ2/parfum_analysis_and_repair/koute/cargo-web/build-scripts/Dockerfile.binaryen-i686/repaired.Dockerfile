FROM ubuntu:14.04
MAINTAINER Jan Bujak <j@exia.io>

RUN apt-get update && apt-get -y upgrade && \
    apt-get -y --no-install-recommends install build-essential gcc-4.8-multilib g++-4.8-multilib libc6-dev-i386 linux-libc-dev curl ruby && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD ./binaryen/* /root/build/
ADD ./common/ci.rb /root/build/

WORKDIR /root/build
ENV ARCH i686

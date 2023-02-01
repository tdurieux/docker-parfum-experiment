FROM ubuntu:18.04

WORKDIR /src

MAINTAINER sk svante.karlsson@csi.se


RUN apt-get update &&  apt-get install -y sudo pax-utils automake autogen shtool libtool git wget cmake unzip build-essential pkg-config \
      libboost-all-dev g++ python-dev autotools-dev libicu-dev zlib1g-dev openssl libssl-dev \
      libbz2-dev libsnappy-dev libgoogle-glog-dev libgflags-dev libjansson-dev libcurl4-openssl-dev libc-ares-dev \
      liblzma-dev libpq-dev freetds-dev libxml2-dev

#de we need libjansson-dev
      
COPY 3rdparty_install.sh 	.
RUN ./3rdparty_install.sh






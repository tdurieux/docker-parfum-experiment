#Dockerfile to build ig-sw container images
#Base image is ubuntu

FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y scons gcc g++ zlib1g-dev libpthread-stubs0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y dist-upgrade




ADD . /ig-sw/
WORKDIR "ig-sw/src/ig_align/"
RUN scons
WORKDIR "/ig-sw/src/"
RUN g++ test.cpp -lz
RUN ./a.out
WORKDIR "/ig-sw/"

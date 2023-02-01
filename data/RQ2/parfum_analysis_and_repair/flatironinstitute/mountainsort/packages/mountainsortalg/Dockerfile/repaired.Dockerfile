# Set the base image to Ubuntu
FROM ubuntu:16.04

MAINTAINER Jeremy Magland

RUN apt-get update

# Install qt5
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-add-repository ppa:ubuntu-sdk-team/ppa
RUN apt-get update && apt-get install --no-install-recommends -y qtdeclarative5-dev qt5-default qtbase5-dev qtscript5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y make g++ && rm -rf /var/lib/apt/lists/*;

# Install fftw3
RUN apt-get update && apt-get install --no-install-recommends -y fftw3-dev && rm -rf /var/lib/apt/lists/*;

ADD . /package

# Build
WORKDIR /package
RUN qmake
RUN make -j
RUN bin/mountainsortalg.mp spec > mountainsortalg.spec

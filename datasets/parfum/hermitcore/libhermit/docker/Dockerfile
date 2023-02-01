# Download base image ubuntu 18.04
FROM ubuntu:18.04

# Update Software repository
RUN apt-get -qq update

# Install required packets from ubuntu repository
RUN apt-get install -y apt-transport-https curl cmake bsdmainutils wget vim nano git binutils autoconf automake make cmake qemu-kvm qemu-system-x86 nasm gcc g++ ca-certificates build-essential libtool

# add path to hermitcore packets
RUN echo "deb [trusted=yes] https://dl.bintray.com/hermitcore/ubuntu bionic main" | tee -a /etc/apt/sources.list

# Update Software repository
RUN apt-get -qq update

# Install required packets from ubuntu repository
RUN apt-get install -y --allow-unauthenticated binutils-hermit newlib-hermit pte-hermit gcc-hermit libhermit libomp-hermit

ENV PATH="/opt/hermit/bin:${PATH}"
ENV EDITOR=vim

CMD echo "This is a HermitCore's toolchain!"; /bin/bash

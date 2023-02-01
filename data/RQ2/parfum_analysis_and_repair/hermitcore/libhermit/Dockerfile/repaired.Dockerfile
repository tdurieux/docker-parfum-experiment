# Download base image ubuntu 18.04
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Update Software repository
RUN apt-get -qq update

# Install required packets from ubuntu repository
RUN apt-get install --no-install-recommends -y apt-transport-https curl wget vim nano git binutils autoconf automake make cmake qemu-kvm qemu-system-x86 nasm gcc g++ build-essential libtool bsdmainutils && rm -rf /var/lib/apt/lists/*;

# add path to hermitcore packets
RUN echo "deb [trusted=yes] https://dl.bintray.com/hermitcore/ubuntu bionic main" | tee -a /etc/apt/sources.list

# Update Software repository
RUN apt-get -qq update

# Install required packets from ubuntu repository
RUN apt-get install --no-install-recommends -y --allow-unauthenticated binutils-hermit newlib-hermit pte-hermit gcc-hermit libhermit libomp-hermit && rm -rf /var/lib/apt/lists/*;

ENV PATH="/opt/hermit/bin:${PATH}"
ENV EDITOR=vim

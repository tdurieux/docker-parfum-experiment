#Download base image ubuntu 16.04
FROM ubuntu:16.04

# Update Software repository
RUN apt-get -qq update

# add https support
RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;

# add path to hermitcore packets
RUN echo "deb https://dl.bintray.com/rwth-os/hermitcore vivid main" | tee -a /etc/apt/sources.list

# Update Software repository
RUN apt-get -qq update

# Install required packets from ubuntu repository
RUN apt-get install --no-install-recommends -y curl wget vim nano git binutils autoconf automake make cmake qemu-system-x86 nasm gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --allow-unauthenticated binutils-hermit libhermit newlib-hermit pthread-embedded-hermit gcc-hermit && rm -rf /var/lib/apt/lists/*;

ENV PATH="/opt/hermit/bin:${PATH}"
ENV EDITOR=vim

CMD echo "This is a HermitCore's toolchain!"; /bin/bash

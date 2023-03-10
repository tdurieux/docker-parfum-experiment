FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

## INSTALL DEPENDENCIES
RUN apt-get update && \
    apt-get install --no-install-recommends -yq \
                    git gdb curl expect g++ make libssl-dev \
                    libxml2-dev libncurses5-dev flex bison \
                    libsctp-dev xutils-dev ant xsltproc automake perl sudo \
                    libedit2 libedit-dev && rm -rf /var/lib/apt/lists/*;

## CREATE SUDOER USER
RUN useradd --create-home --shell /bin/bash titan && \
    adduser --disabled-password titan sudo && \
    echo "titan ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER titan

## SET UP ENV VARIABLES
ENV TTCN3_DIR=/home/titan/titan.core/Install
ENV PATH=$TTCN3_DIR/bin:$PATH \
    LD_LIBRARY_PATH=$TTCN3_DIR/lib:$LD_LIBRARY_PATH

## CLONE TITAN
WORKDIR /home/titan/
RUN git clone https://github.com/eclipse/titan.core.git
# Checkout release 7.2.1
WORKDIR /home/titan/titan.core
RUN git checkout tags/7.2.1_final

## SET Makefile.personal
# TTCN3_DIR := /home/titan/titan.core/Install
# XMLDIR := /usr
# OPENSSL_DIR := /usr
# JNI := no
# GEN_PDF := no
COPY Makefile.personal-ubuntu Makefile.personal

## BUILD TITAN
RUN make install

WORKDIR /home/titan
CMD compiler -v && /bin/bash

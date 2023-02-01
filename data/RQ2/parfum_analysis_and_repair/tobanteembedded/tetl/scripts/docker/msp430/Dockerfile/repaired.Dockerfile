FROM ubuntu:20.04
MAINTAINER Tobias Hienzsch <post@tobias-hienzsch.de>

WORKDIR /toolchain

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git bzip2 wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

RUN apt-get clean


RUN wget -qO- https://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/9_3_1_2/export/msp430-gcc-9.3.1.11_linux64.tar.bz2 | tar -xj
ENV PATH "/toolchain/msp430-gcc-9.3.1.11_linux64/bin:$PATH"
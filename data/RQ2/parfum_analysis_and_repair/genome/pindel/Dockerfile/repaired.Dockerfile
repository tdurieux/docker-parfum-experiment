FROM ubuntu:xenial
MAINTAINER = Shin Leong <sleong@wustl.edu>
RUN apt-get update && apt-get install --no-install-recommends -y git binutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y automake cmake git libncurses5-dev zlib1g-dev g++ && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/local/ && git clone --recursive https://github.com/samtools/htslib
RUN cd /usr/local/htslib && make && make install
RUN cd /usr/local/ && git clone --recursive https://github.com/genome/pindel.git

RUN apt-get install --no-install-recommends -y wget libopenblas-base libopenblas-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /usr/local/pindel/ && ./INSTALL /usr/local/htslib

RUN apt-get install --no-install-recommends -y libnss-sss && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

RUN ln -s /usr/local/pindel/pindel /usr/local/bin/pindel


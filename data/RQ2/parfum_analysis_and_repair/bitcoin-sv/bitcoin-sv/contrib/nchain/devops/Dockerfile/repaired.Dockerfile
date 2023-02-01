#Dockerfile for building Bitcoin SV
FROM ubuntu:bionic
LABEL maintainer=p.foster@nchain.com
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
       libboost-all-dev \
       libdb-dev \
       libdb++-dev \
       build-essential \
       libtool \
       autotools-dev \
       automake \
       pkg-config \
       libssl-dev \
       libevent-dev \
       libminiupnpc-dev \
       libzmq3-dev \
       git \
       python3 \
       python3-pip \
       perl \
       cpanminus \
       libperlio-gzip-perl \
       libjson-perl \
       zlib1g-dev \
       bsdmainutils && rm -rf /var/lib/apt/lists/*;


RUN pip3 install --no-cache-dir requests pyzmq rpyc
RUN cpanm PerlIO::gzip
RUN cpanm JSON
RUN cpanm Term::ReadLine

COPY contrib/nchain/devops/* ./
RUN  chmod +x /entrypoint.py
RUN  useradd -G users jenkins
USER jenkins


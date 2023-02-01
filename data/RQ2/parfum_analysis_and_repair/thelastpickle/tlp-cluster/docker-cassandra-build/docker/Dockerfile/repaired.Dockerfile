FROM ubuntu:bionic

RUN apt update && apt-get install --no-install-recommends -y \
   ant \
   build-essential \
   curl \
   devscripts \
   git \
   openjdk-8-jdk \
   debhelper \
   python-dev \
   dpatch \
   bash-completion \
   quilt \
   rsync \
   sudo \
   dh-python \
   python3-distutils \
   python3-lib2to3 \
   equivs && rm -rf /var/lib/apt/lists/*;

COPY excludes.txt /
COPY unpack_cassandra.sh /usr/local/bin/
COPY build_cassandra.sh /usr/local/bin/

RUN mkdir /cassandra && \
    mkdir /local

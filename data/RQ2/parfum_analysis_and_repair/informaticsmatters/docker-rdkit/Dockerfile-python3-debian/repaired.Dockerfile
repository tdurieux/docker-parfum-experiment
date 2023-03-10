# Dockerfile for Python3 based RDKit implementation
# Based on Debian. Does not include Python2.

FROM debian:buster
LABEL maintainer="Tim Dudgeon<tdudgeon@informaticsmatters.com>"

RUN apt-get update &&\
 apt-get upgrade -y &&\ 
 apt-get install -y --no-install-recommends\
 python3\
 python3-dev\
 python3-numpy\
 python3-pip\
 python3-setuptools\
 python3-wheel\
 python3-six\
 gcc\
 libboost-system1.67.0\
 libboost-thread1.67.0\
 libboost-serialization1.67.0\
 libboost-python1.67.0\
 libboost-regex1.67.0\
 libboost-chrono1.67.0\
 libboost-date-time1.67.0\
 libboost-atomic1.67.0\
 libboost-iostreams1.67.0\
 sqlite3\
 wget\
 zip\
 libfreetype6 && \
 apt-get clean -y && rm -rf /var/lib/apt/lists/*;

ARG DOCKER_TAG=latest

COPY artifacts/debian/$DOCKER_TAG/debs/RDKit-*-Linux-Runtime.deb artifacts/debian/$DOCKER_TAG/debs/RDKit-*-Linux-Python.deb /tmp/
RUN dpkg -i /tmp/*.deb && rm -f /tmp/*.deb

# symlink python3 to python
RUN cd /usr/bin && ln -s python3 python && ln -s pip3 pip

ENV RDBASE=/usr/share/RDKit

WORKDIR /

# add the rdkit user
RUN useradd -u 1000 -g 0 -m rdkit
USER 1000

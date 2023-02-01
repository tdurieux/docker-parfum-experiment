# VERSION 1.0
FROM ubuntu
MAINTAINER Ranga Rao, rangrao@cisco.com
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get -y --no-install-recommends install git python python-pip && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt
RUN git clone https://github.com/datacenter/nxtoolkit
WORKDIR nxtoolkit
RUN python setup.py install

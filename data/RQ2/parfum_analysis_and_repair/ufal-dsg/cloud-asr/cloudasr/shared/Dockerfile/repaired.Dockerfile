FROM ubuntu:18.04

MAINTAINER Ondrej Klejch

RUN apt-get update && apt-get install --no-install-recommends -y wget build-essential python python-dev python-distribute python-pip python3 python3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --install-option="--zmq=bundled" pyzmq
RUN pip install --no-cache-dir protobuf==2.6.1 nose==1.3.7 gevent==1.0.2

ADD . /usr/lib/python2.7/dist-packages/

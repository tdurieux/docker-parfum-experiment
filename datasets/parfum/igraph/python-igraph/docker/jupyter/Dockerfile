FROM jupyter/notebook
MAINTAINER Tamas Nepusz <ntamas@gmail.com>
LABEL Description="Docker image that contains Jupyter with a pre-compiled version of igraph's Python interface"
RUN apt-get -y update && apt-get -y install build-essential libxml2-dev zlib1g-dev python-dev python-pip pkg-config libffi-dev libcairo-dev
RUN pip3 install igraph cairocffi matplotlib
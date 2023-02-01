FROM jupyter/notebook
MAINTAINER Tamas Nepusz <ntamas@gmail.com>
LABEL Description="Docker image that contains Jupyter with a pre-compiled version of igraph's Python interface"
RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential libxml2-dev zlib1g-dev python-dev python-pip pkg-config libffi-dev libcairo-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir igraph cairocffi matplotlib
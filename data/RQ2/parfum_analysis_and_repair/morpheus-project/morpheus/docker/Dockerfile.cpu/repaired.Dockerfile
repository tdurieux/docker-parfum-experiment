FROM ubuntu:18.04

LABEL maintainer 'rhausen@ucsc.edu'

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U setuptools
RUN pip3 install --no-cache-dir -U numpy
RUN pip3 install --no-cache-dir -U tensorflow
RUN pip3 install --no-cache-dir -U morpheus-astro

RUN ln -s /usr/bin/python3 /usr/bin/python
FROM ubuntu:latest
MAINTAINER x

RUN apt-get update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    arduino avrdude \
    gcc libelf-dev \
    freeglut3-dev scons swig \
    python-pip python-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pysimavr

CMD /bin/bash


FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -qy curl git python2.7 python-dev build-essential pkg-config autoconf wget libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y



RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

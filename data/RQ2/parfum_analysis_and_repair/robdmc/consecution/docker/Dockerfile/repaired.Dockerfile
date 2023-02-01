FROM ubuntu:xenial

# root is the home directory
WORKDIR /root

ADD simple_example.py /root/simple_example.py

# set up the system tools including conda
RUN \
    rm /bin/sh && ln -s /bin/bash /bin/sh && \
    apt-get update && \
    apt-get install --no-install-recommends -y vim && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y wget && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y graphviz && \
    apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;

RUN \
    curl -f -sS https://bootstrap.pypa.io/get-pip.py | python

RUN \
    pip install --no-cache-dir git+https://github.com/robdmc/consecution.git

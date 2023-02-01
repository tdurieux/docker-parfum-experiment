# TensorFlow and node.js development container.
#

FROM ubuntu:16.04
MAINTAINER Nikhil Kothari

# Setup OS and core packages
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y -q \
      curl wget unzip bzip2 git vim build-essential ca-certificates pkg-config \
      python2.7 python-dev python-pip python-setuptools && rm -rf /var/lib/apt/lists/*;

# Setup Node.js
RUN mkdir -p /tools/node && \
    wget -nv https://nodejs.org/dist/v8.9.3/node-v8.9.3-linux-x64.tar.gz -O node.tar.gz && \
    tar xf node.tar.gz -C /tools/node --strip-components=1 && \
    rm node.tar.gz

# Setup TensorFlow
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir tensorflow==1.4.1

# Configuration
ENV PATH $PATH:/tools/node/bin
ENTRYPOINT [ "/bin/bash" ]

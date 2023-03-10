FROM ubuntu:16.04
MAINTAINER Alexey Gurevich "https://github.com/alexeigurevich"

# Setup a base system
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl wget g++ make libboost-all-dev git \
        tar gzip bzip2 build-essential \
        python2.7-dev python-setuptools python-pip python-virtualenv \
        zlib1g-dev default-jdk perl && \
    apt-get upgrade -y libstdc++6 && rm -rf /var/lib/apt/lists/*;

# Matplotlib dependencies
RUN apt-get update && apt-get install --no-install-recommends -y pkg-config libfreetype6-dev \
    libpng-dev python-matplotlib && rm -rf /var/lib/apt/lists/*;

# QUAST installation
COPY . quast
RUN pip install --no-cache-dir --upgrade setuptools pip && \
    cd quast && \
    python setup.py develop && \
    cd ..

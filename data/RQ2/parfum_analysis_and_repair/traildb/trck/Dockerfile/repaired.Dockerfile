FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    libcurl4-gnutls-dev \
    libcmph-dev \
    libc6-dev \
    libjemalloc-dev \
    libarchive-dev \
    make \
    autoconf \
    cmake \
    libtool \
    git \
    gcc \
    jq \
    pkg-config \
    s3cmd \
    libtbb-dev \
    python2.7 \
    python2.7-dev \
    python-requests \
    python-pip \
    python3-pip \
    python-ply \
    libjudy-dev \
    libjson-c-dev \
    vim && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir awscli
RUN pip install --no-cache-dir boto msgpack-python future

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-pip libarchive13 \
    python-boto \
    curl && rm -rf /var/lib/apt/lists/*;
    #apt-transport-https \
    #rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get TrailDB
RUN cd /opt &&\
    git clone https://github.com/traildb/traildb &&\
    cd traildb &&\
    ./waf configure &&\
    ./waf install &&\
    cp /usr/local/lib/libtraildb.so* /usr/lib/

# Get traildb-python
RUN cd /opt &&\
    git clone https://github.com/traildb/traildb-python &&\
    cd traildb-python &&\
    python setup.py install

RUN mkdir /opt/trck
COPY . /opt/trck

RUN cd /opt/trck/ &&\
    git submodule update --init --remote --recursive

RUN cd /opt/trck/ &&\
    make msgpack

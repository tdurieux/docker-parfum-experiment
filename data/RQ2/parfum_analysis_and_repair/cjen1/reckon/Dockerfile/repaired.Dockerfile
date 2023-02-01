FROM cjen1/reckon-mininet:latest as base

RUN apt-get update && apt-get install --no-install-recommends -yy -qq \
    build-essential \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN ln /usr/bin/ovs-testcontroller /usr/bin/controller

# Build dependencies
RUN apt-get update && apt-get install --no-install-recommends -yy -qq \
    autoconf \
    automake \
    libtool \
    curl \
    g++ \
    unzip && rm -rf /var/lib/apt/lists/*;

# Runtime dependencies
RUN pip3 install --no-cache-dir --upgrade wheel setuptools
ADD requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install --no-install-recommends -yy -qq psmisc iptables && rm -rf /var/lib/apt/lists/*;

# Test dependencies
RUN apt-get update && apt-get install --no-install-recommends -yy -qq \
    tmux \
    screen \
    strace \
    linux-tools \
    tcpdump \
    lsof \
    vim && rm -rf /var/lib/apt/lists/*;


# Add reckon code
ADD . .
ENV PYTHONPATH="/root:${PYTHONPATH}"
ENV SHELL=/bin/bash

# Make directory for logs
RUN mkdir -p /results/logs

# Add built etcd artefacts
COPY --from=etcd-image /reckon/systems/etcd systems/etcd

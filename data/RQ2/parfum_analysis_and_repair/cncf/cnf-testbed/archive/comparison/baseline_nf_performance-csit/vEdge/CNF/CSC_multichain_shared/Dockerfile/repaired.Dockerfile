FROM ubuntu:bionic

COPY base/ /vEdge
WORKDIR /vEdge

CMD mkdir ~/sockets
CMD tail -f /dev/null

RUN apt-get update -y && \
    apt-get --no-install-recommends install -y --allow-unauthenticated \
        make \
        gcc \
        libcurl4-openssl-dev \
        python-pip \
        bridge-utils \
        apt-transport-https \
        ca-certificates \
        vim \
        curl && \
    pip install --no-cache-dir jsonschema && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://packagecloud.io/install/repositories/fdio/release/script.deb.sh | bash

RUN apt-get --no-install-recommends install -y \
        vpp=18.10-release \
        vpp-dbg=18.10-release \
        vpp-dev=18.10-release \
        vpp-lib=18.10-release \
        vpp-plugins=18.10-release && rm -rf /var/lib/apt/lists/*;

RUN touch in_container

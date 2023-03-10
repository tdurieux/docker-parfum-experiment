FROM ubuntu:bionic

ENV VPP_VER "19.04.1"

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
        dpdk \
        vpp=${VPP_VER}-release \
        vpp-plugin-core=${VPP_VER}-release \
        vpp-plugin-dpdk=${VPP_VER}-release \
        vpp-dev=${VPP_VER}-release \
        vpp-dbg=${VPP_VER}-release \
        libvppinfra=${VPP_VER}-release && rm -rf /var/lib/apt/lists/*;

RUN touch in_container

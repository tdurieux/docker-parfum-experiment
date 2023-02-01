ARG ARCH="amd64"
FROM ${ARCH}/ubuntu:impish

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

# Get dependencies
RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
        build-essential \
        libboost-all-dev \
        libgmp-dev \
        cmake \
        libhts-dev \
        python3-pip \
        git \
    && pip3 install --no-cache-dir distro && rm -rf /var/lib/apt/lists/*;

# Install Octopus
ARG THREADS=4
ARG CPU=haswell
COPY . /opt/octopus
RUN /opt/octopus/scripts/install.py \
    --threads $THREADS \
    --architecture $CPU

# Cleanup git - only needed during install for commit info
RUN apt-get purge -y git \
    && rm -r /opt/octopus/.git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/octopus/bin:${PATH}"

ENTRYPOINT ["octopus"]

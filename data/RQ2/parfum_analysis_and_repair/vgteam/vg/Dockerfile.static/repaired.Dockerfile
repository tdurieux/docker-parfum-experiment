# Dockerfile for shipping just the vg binary you have
# Run with DOCKER_BUILDKIT=1 to avoid shipping the whole vg directory as context
FROM ubuntu:18.04
MAINTAINER vgteam

WORKDIR /vg

ENV PATH /vg/bin:$PATH

ENTRYPOINT /vg/bin/vg

# Prevent dpkg from trying to ask any questions, ever
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Install dependencies for scripts
RUN apt-get -qq -y update && \
    apt-get -qq -y upgrade && \
    apt-get -qq --no-install-recommends -y install --no-upgrade \
    numactl \
    python3-matplotlib \
    python3-numpy \
    awscli \
    bwa \
    jq \
    bc \
    linux-tools-common \
    linux-tools-generic \
    binutils \
    perl \
    && apt-get -qq -y clean && rm -rf /var/lib/apt/lists/*;

COPY deps/FlameGraph /vg/deps/FlameGraph
COPY scripts /vg/scripts
COPY bin/vg /vg/bin/vg

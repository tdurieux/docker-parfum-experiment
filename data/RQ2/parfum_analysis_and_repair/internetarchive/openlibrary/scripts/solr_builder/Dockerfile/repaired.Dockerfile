## This image is where we should execute the Jenkins commands

FROM ubuntu:xenial
ARG DOCKER_VERSION=5:18.09.0~3-0~ubuntu-xenial

# Docker dependencies
RUN apt-get -qq update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get -qq update && apt-get install --no-install-recommends -y \
    docker-ce=$DOCKER_VERSION \
    docker-ce-cli=$DOCKER_VERSION \
    containerd.io && rm -rf /var/lib/apt/lists/*;

# Install docker-compose
RUN curl -f -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Script dependencies
RUN apt-get -qq update && apt-get install --no-install-recommends -y \
    curl \
    moreutils \
    wget \
    xmlstarlet && rm -rf /var/lib/apt/lists/*;

# Default to bash, not dash!
RUN ln -sf /bin/bash /bin/sh

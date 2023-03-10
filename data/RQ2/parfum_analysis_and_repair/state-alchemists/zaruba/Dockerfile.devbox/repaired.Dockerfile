FROM ubuntu:20.04

# Prepare environments
ENV DOCKER_HOST="tcp://host.docker.internal:2375"
ENV DEBIAN_FRONTEND=noninteractive

# Install ubuntu packages
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update --fix-missing && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git ncat curl wget inetutils-tools docker.io && \
    apt-get autoremove -yqq --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

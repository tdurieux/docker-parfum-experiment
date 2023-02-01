FROM ubuntu:19.10

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update \
    && apt-get install --no-install-recommends -y python3-pip \
    && pip3 install --no-cache-dir nexus3-cli \
    && rm -rf /var/lib/apt/lists/*

COPY nexus3-del-artifacts.py /usr/local/bin/

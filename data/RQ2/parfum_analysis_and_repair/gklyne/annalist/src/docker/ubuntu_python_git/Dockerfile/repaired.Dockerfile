# Build a base Ubuntu kit for installing Annalist:
# Includes base system updates, Python and git

FROM ubuntu

MAINTAINER Graham Klyne <gk-annalist@ninebynine.org>

RUN apt-get update -y  && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y python python-pip python-virtualenv && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /github && \
    cd /github && \
    git clone https://github.com/gklyne/annalist.git


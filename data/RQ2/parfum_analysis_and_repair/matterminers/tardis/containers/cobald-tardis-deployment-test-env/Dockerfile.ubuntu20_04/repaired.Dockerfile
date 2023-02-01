FROM ubuntu:20.04
LABEL maintainer="Manuel Giffels <giffels@gmail.com>"

RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y gcc g++ make curl dirmngr \
    apt-transport-https lsb-release ca-certificates \
    python3 python3-pip language-pack-en git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -f -sL https://deb.nodesource.com/setup_18.x | bash -

RUN apt-get install --no-install-recommends -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]

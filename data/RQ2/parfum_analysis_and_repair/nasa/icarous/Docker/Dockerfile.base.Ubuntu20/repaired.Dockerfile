############################################################
#
# Icarous Base container
#
############################################################

FROM ubuntu:20.04
MAINTAINER Marco A. Feliu (marco.feliu@nianet.org)
LABEL icarous-base version="1.0"

############################################################
#
# Ubuntu dependencies installation
#
############################################################

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -yq
RUN apt-get install -yq --no-install-recommends \
       build-essential \
       g++-multilib \
       sudo \
       wget \
       ca-certificates \
       cmake \
       zlib1g-dev \
       git \
       gdb \
       vim \
       ccache \
       gawk \
       libzmq3-dev \
       openssh-client \
       curl && rm -rf /var/lib/apt/lists/*;


############################################################
# Python libraries
############################################################

RUN apt install --no-install-recommends -yq software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -yq --no-install-recommends python3.9 python3.9-distutils python3.9-dev && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/python3 python3.9 `which python3.9` 0

WORKDIR /
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py

ADD retry.sh /bin
RUN chmod +x /bin/retry.sh


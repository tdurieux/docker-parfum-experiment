#
# Copyright (C) 2017 XLAB, Ltd.
# Copyright (C) 2018 Waldemar Kozaczuk
#
# This work is open source software, licensed under the terms of the
# BSD license as described in the LICENSE file in the top-level directory.
#
# This Docker file defines a container intended to run and test OSv
# It comes with capstan that can pull kernel and pre-built MPM packages
#
ARG DIST_VERSION=20.04
FROM ubuntu:${DIST_VERSION}

ENV DEBIAN_FRONTEND noninteractive
ENV TERM=linux

COPY ./etc/keyboard /etc/default/keyboard
COPY ./etc/console-setup /etc/default/console-setup

RUN apt-get update -y && apt-get install --no-install-recommends -y \
git \
python3 \
curl \
qemu-system-x86 \
qemu-utils && rm -rf /var/lib/apt/lists/*;

# - prepare directories
RUN mkdir /git-repos

# - clone OSv
WORKDIR /git-repos
ARG GIT_ORG_OR_USER=cloudius-systems
ARG GIT_BRANCH=master
RUN git clone --depth 1 -b ${GIT_BRANCH} --single-branch https://github.com/${GIT_ORG_OR_USER}/osv.git

# - install Capstan
ADD https://github.com/cloudius-systems/capstan/releases/latest/download/capstan /usr/local/bin/capstan
RUN chmod u+x /usr/local/bin/capstan

CMD /bin/bash

#
# NOTES
#
# Build the container example:
# docker build -t osv/runner-ubuntu -f Dockerfile.runner-ubuntu .
#
# Build the container based of specific Ubuntu version and git repo owner (if forked) example:
# docker build -t osv/runner-ubuntu -f Dockerfile.runner-ubuntu --build-arg DIST_VERSION=20.04 --build-arg GIT_ORG_OR_USER=a_user .
#
# Run the container FIRST time example:
# docker run -it --privileged osv/runner-ubuntu
#
# To restart:
# docker restart ID (from docker ps -a) && docker attach ID
#
# To open in another console:
# docker exec -it ID /bin/bash

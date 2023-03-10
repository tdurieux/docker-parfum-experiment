#
# Copyright (C) 2020 Waldemar Kozaczuk
#
# This work is open source software, licensed under the terms of the
# BSD license as described in the LICENSE file in the top-level directory.
#
# This Docker file defines an image based on Ubuntu distribution and provides
# all packages necessary to build and run kernel and applications.
#
ARG DIST_VERSION=20.04
FROM ubuntu:${DIST_VERSION}

ENV DEBIAN_FRONTEND noninteractive
ENV TERM=linux

COPY ./etc/keyboard /etc/default/keyboard
COPY ./etc/console-setup /etc/default/console-setup

RUN apt-get update -y && apt-get install --no-install-recommends -y git python3 && rm -rf /var/lib/apt/lists/*;

#
# PREPARE ENVIRONMENT
#

# - prepare directories
RUN mkdir -p /git-repos/osv/scripts

# - get setup.py
ARG GIT_ORG_OR_USER=cloudius-systems
ARG GIT_BRANCH=master
ADD https://raw.githubusercontent.com/${GIT_ORG_OR_USER}/osv/${GIT_BRANCH}/scripts/linux_distro.py /git-repos/osv/scripts/
ADD https://raw.githubusercontent.com/${GIT_ORG_OR_USER}/osv/${GIT_BRANCH}/scripts/setup.py /git-repos/osv/scripts/

# - install all required packages and remove scripts
RUN python3 /git-repos/osv/scripts/setup.py && rm -rf /git-repos/osv/scripts

RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# - install Capstan
ADD https://github.com/cloudius-systems/capstan/releases/latest/download/capstan /usr/local/bin/
RUN chmod u+x /usr/local/bin/capstan

WORKDIR /git-repos/osv
CMD /bin/bash

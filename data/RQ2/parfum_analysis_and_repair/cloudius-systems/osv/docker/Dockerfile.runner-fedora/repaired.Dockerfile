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
ARG DIST_VERSION=31
FROM fedora:${DIST_VERSION}

RUN yum install -y \
git \
python3 \
file \
which \
curl \
qemu-system-x86 \
qemu-img && rm -rf /var/cache/yum

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
# docker build -t osv/runner-fedora -f Dockerfile.runner-fedora .
#
# Build the container based of specific Fedora version and git repo owner (if forked) example:
# docker build -t osv/runner-fedora -f Dockerfile.runner-fedora --build-arg DIST_VERSION=31 --build-arg GIT_ORG_OR_USER=a_user .
#
# Run the container FIRST time example:
# docker run -it --privileged osv/runner-fedora
#
# To restart:
# docker restart ID (from docker ps -a) && docker attach ID
#
# To open in another console
# docker exec -it ID /bin/bash

#
# Copyright (C) 2020 Waldemar Kozaczuk
#
# This work is open source software, licensed under the terms of the
# BSD license as described in the LICENSE file in the top-level directory.
#
# This Docker file defines an image based on Ubuntu distribution and provides
# all packages necessary to build and run kernel and applications.
#
ARG DIST_VERSION=31
FROM fedora:${DIST_VERSION}

RUN yum install -y git python3 file which && rm -rf /var/cache/yum

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

# - install Capstan
ADD https://github.com/cloudius-systems/capstan/releases/latest/download/capstan /usr/local/bin/capstan
RUN chmod u+x /usr/local/bin/capstan

WORKDIR /git-repos/osv
CMD /bin/bash

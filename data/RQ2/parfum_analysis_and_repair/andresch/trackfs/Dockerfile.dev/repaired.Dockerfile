# =================================
# Dockerfile for trackfs development
#
# Copyright 2020 by Andreas Schmidt
# All rights reserved.
# This file is part of the trackfs project
# and licensed under the terms of the GNU Lesser General Public License v3.0.
# See https://github.com/andresch/trackfs for details.
#
# =================================

#FROM docker.io/python:3.8-alpine as builder
FROM docker:dind

RUN \
  apk add --no-cache python3 python3-dev py3-pip gcc musl-dev libffi-dev openssl-dev fuse fuse-dev flac bash curl git

RUN \
  python3 -m pip install --upgrade pip \
  && pip install --no-cache-dir --upgrade setuptools wheel twine

RUN curl -f https://raw.githubusercontent.com/nektos/act/master/install.sh | bash

RUN pip install --no-cache-dir --upgrade mutagen fusepy Lark chardet\<4,\>=3.0.2

# enable non-root users to make FUSE fs non-private
RUN echo "user_allow_other" >> /etc/fuse.conf

# FUSE requires that the user that mounts the FUSE filesystem
# has an entry in /etc/passwd
# Since we want to allow (and encourage) the usage of docker's
# --user option to run the container as non-root user,
# and with that don't know the uid of the user at build time
# we can't create the entry for that user at build time
# and also can't use adduser command during runtime as this would
# require root privileges.
# Instead we open /etc/passwd for writing.
# As /ets/shadow is still protected this should not cause harm,
# even if some attacker finds a way to take over the container

RUN chmod 666 /etc/passwd

# source directory containing flac+cue files
VOLUME /src

# mount point where to generate the tracks from the flac+cue files
VOLUME /dst

# mount project directory into docker
VOLUME /work

# copy launch script
COPY dev-launcher.sh /usr/local/bin/
RUN chmod 555 /usr/local/bin/dev-launcher.sh

ENTRYPOINT ["/usr/local/bin/dev-launcher.sh"]



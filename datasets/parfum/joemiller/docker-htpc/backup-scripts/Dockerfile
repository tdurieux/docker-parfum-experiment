FROM restic/restic:latest as restic-installer

FROM ubuntu:20.04

RUN apt-get update -q \
  && apt-get install -qy \
    bash \
    curl \
    zbackup \
    openssh-client \
    unzip \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

RUN curl https://rclone.org/install.sh | bash

COPY backup-gw.sh /
COPY backup-restic.sh /
COPY backup-to-b2.sh /

COPY --from=restic-installer /usr/bin/restic /usr/bin/restic

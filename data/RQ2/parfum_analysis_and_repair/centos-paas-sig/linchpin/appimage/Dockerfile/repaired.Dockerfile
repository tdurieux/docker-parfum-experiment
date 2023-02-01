# Beware: only meant for use with pkg2appimage-with-docker

FROM ubuntu:xenial

MAINTAINER "TheAssassin <theassassin@users.noreply.github.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    DOCKER_BUILD=1

RUN sed -i 's/archive.ubuntu.com/ftp.fau.de/g' /etc/apt/sources.list ;\
    echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu xenial main" >> /etc/apt/sources.list ;\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776 ;\
    apt-get update
RUN apt-get install --no-install-recommends -y python3.7 python3.7-dev python3.7-venv python3.7-distutils; rm -rf /var/lib/apt/lists/*; \
    python3.7 -m ensurepip --default-pip ; \
    python3.7 -m pip install --upgrade pip setuptools wheel virtualenv
RUN apt-get install --no-install-recommends -y apt-transport-https libcurl3-gnutls libarchive13 wget desktop-file-utils aria2 gnupg2 build-essential file libglib2.0-bin git sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config libvirt-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y fuse || true && rm -rf /var/lib/apt/lists/*;
RUN install -m 0777 -d /workspace

RUN adduser --system --uid 1000 test

WORKDIR /workspace

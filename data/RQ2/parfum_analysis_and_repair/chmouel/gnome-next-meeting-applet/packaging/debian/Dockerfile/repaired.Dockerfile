# Dockerfile
FROM ubuntu:rolling
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
    curl \
    vim \
    fakeroot \
    debhelper \
    dh-python \
    devscripts \
    python3-pip \
    python3-setuptools \
	git-buildpackage \
    git \
    pinentry-tty \
    lsb-release && \
	apt-get clean && rm -rf /var/lib/apt/lists/*;


RUN useradd -ms /bin/bash builder
USER builder
RUN mkdir -p /home/builder/build
WORKDIR /home/builder/build

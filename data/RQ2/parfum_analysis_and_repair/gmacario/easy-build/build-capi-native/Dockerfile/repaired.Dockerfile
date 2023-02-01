FROM ubuntu:16.04

MAINTAINER Gianpaolo Macario <gianpaolo_macario@mentor.com>

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get -y --no-install-recommends install autoconf build-essential file git libtool make sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libsystemd-dev pkg-config && rm -rf /var/lib/apt/lists/*;
RUN id build 2>/dev/null || useradd -m build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

# EOF

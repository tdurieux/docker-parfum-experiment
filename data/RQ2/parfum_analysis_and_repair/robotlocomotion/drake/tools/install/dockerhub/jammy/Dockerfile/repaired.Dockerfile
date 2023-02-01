# -*- mode: dockerfile -*-
# vi: set ft=dockerfile :

FROM ubuntu:jammy
ADD drake-latest-jammy.tar.gz /opt
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update -qq \
  && apt-get install --no-install-recommends -o Dpkg::Use-Pty=0 -qy \
    $(cat /opt/drake/share/drake/setup/packages-jammy.txt) \
# Make python and pip available to meet the requirements for deepnote.com:
# https://docs.deepnote.com/environment/custom-environments#custom-image-requirements
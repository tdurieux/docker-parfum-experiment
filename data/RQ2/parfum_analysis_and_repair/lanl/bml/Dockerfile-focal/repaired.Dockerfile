FROM ubuntu:focal
MAINTAINER nicolasbock@gmail.com

COPY scripts/prepare-container-focal.sh /usr/sbin
RUN /usr/sbin/prepare-container-focal.sh

WORkDIR /root
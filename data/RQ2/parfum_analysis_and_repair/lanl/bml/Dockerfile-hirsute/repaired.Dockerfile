FROM ubuntu:hirsute
MAINTAINER nicolasbock@gmail.com

COPY scripts/prepare-container-hirsute.sh /usr/sbin
RUN /usr/sbin/prepare-container-hirsute.sh

WORkDIR /root
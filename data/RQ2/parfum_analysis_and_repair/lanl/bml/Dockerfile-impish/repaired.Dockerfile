FROM ubuntu:impish
MAINTAINER nicolasbock@gmail.com

COPY scripts/prepare-container-impish.sh /usr/sbin
RUN /usr/sbin/prepare-container-impish.sh

WORkDIR /root
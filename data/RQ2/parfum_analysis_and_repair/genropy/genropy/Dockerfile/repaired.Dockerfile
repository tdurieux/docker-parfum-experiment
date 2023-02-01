############################################################
# Dockerfile to build Genropy container images
# Based on Alpine
############################################################

FROM alpine:latest
RUN apk update
RUN apk add --no-cache git
RUN apk add --no-cache python3
RUN apk add --no-cache py3-lxml
RUN apk add --no-cache py3-psutil
RUN apk add --no-cache py3-pip
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing py3-tzlocal

ADD . /home/genropy
RUN pip3 install --no-cache-dir paver

WORKDIR /home/genropy/gnrpy
RUN paver develop

ENV GNRLOCAL_PROJECTS=/etc/workspaces

RUN python3 initgenropy.py --no_user




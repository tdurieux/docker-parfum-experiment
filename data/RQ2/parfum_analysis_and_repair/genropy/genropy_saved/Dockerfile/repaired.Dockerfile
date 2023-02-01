############################################################
# Dockerfile to build Genropy container images
# Based on Ubuntu
############################################################

FROM alpine:3.7
MAINTAINER Francesco Porcari - francesco@genropy.org

RUN apk update
RUN apk add --no-cache git
RUN apk add --no-cache python3
RUN apk add --no-cache py3-lxml
RUN apk add --no-cache py3-psutil
RUN apk add --no-cache supervisor
RUN apk add --no-cache nginx

ADD . /home/genropy
RUN pip3 install --no-cache-dir paver
WORKDIR /home/genropy/gnrpy
RUN paver develop
RUN python3 initgenropy.py
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf




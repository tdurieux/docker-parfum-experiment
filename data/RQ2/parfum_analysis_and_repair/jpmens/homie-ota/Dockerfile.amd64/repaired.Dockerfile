FROM alpine:latest
# If you want to build this for Raspberry Pi, please use the next image
# FROM hypriot/rpi-alpine-scratch:v3.4
# Adds testing package to repositories
# Install needed packages. Notes:
#   * build-base: used so we include the basic development packages (gcc)
#   * python-dev: are used for gevent e.g.
#   * bash: so we can access /bin/bash
RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --update \
              musl \
              build-base \
              bash \
              git \
              python \
              python-dev \
              py-pip \
  && pip install --no-cache-dir --upgrade pip \
  && rm /var/cache/apk/*

# make some useful symlinks that are expected to exist
RUN cd /usr/bin \
  && ln -sf easy_install-2.7 easy_install \
  && ln -sf python2.7 python \
  && ln -sf python2.7-config python-config \
  && ln -sf pip2.7 pip
WORKDIR /app
ADD requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
ADD . .
EXPOSE 9080
# VOLUME ['/app/firmwares']
# since we will be "always" mounting the volume, we can set this up
CMD python homie-ota.py

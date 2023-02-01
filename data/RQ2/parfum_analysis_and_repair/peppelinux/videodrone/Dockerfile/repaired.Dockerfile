FROM alpine:3.12.1
MAINTAINER Giuseppe De Marco <giuseppe.demarco@unical.it>

RUN apk update
RUN apk add --no-cache chromium
RUN apk add --no-cache chromium-chromedriver

RUN apk add --no-cache xvfb
ENV DISPLAY=:99
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN apk add --no-cache py-pip
RUN pip install --no-cache-dir videodrone

ENV VDPATH=VideoDrone
ENV VD_Y4M="/$VDPATH/y4ms/"

RUN mkdir $VDPATH
WORKDIR $VD_Y4M
RUN wget https://media.xiph.org/video/derf/y4m/stefan_cif.y4m
WORKDIR $VDPATH

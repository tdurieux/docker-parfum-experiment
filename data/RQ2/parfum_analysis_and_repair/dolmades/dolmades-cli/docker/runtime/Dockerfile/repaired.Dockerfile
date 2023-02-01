FROM ubuntu:18.04

MAINTAINER Stefan Kombrink

RUN apt-get update && apt-get -y --no-install-recommends install lgogdownloader imagemagick librsvg2-bin curl gddrescue p7zip-full yad && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir /wineprefix
RUN mkdir /.dolmades

FROM golang:1.6-onbuild

MAINTAINER Magdy Salem <magdy.salem@emc.com>

RUN apt-get update && apt-get install --no-install-recommends -y \
    metapixel \
    imagemagick && rm -rf /var/lib/apt/lists/*;

ADD . /go/src/engine



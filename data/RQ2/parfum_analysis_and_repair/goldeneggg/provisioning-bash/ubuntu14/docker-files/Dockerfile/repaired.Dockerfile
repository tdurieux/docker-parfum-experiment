FROM ubuntu:14.04

MAINTAINER goldeneggg

RUN mkdir /tmp/prv-bash
WORKDIR /tmp/prv-bash

ADD https://git.io/prv-bash /tmp/prv-bash/entry.sh

RUN bash entry.sh ubuntu14 init.sh
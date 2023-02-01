# Base Image (gewo/base)
FROM ubuntu:14.04
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y wget build-essential socat && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV HOME /

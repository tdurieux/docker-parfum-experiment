FROM ubuntu:bionic
MAINTAINER Shaun Crampton <shaun@tigera.io>
ENV STREAM bionic

ADD install-ubuntu-build-deps install-ubuntu-build-deps
RUN ./install-ubuntu-build-deps

WORKDIR /code
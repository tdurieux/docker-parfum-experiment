FROM ubuntu:focal
MAINTAINER Shaun Crampton <shaun@tigera.io>
ENV STREAM focal

ADD install-ubuntu-build-deps install-ubuntu-build-deps
RUN ./install-ubuntu-build-deps

WORKDIR /code
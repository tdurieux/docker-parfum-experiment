FROM ubuntu:20.04

MAINTAINER Bartek Nowotarski <bartek@stellar.org>

ARG STELLAR_CORE_VERSION 
ENV STELLAR_CORE_VERSION=${STELLAR_CORE_VERSION:-*}
# to remove tzdata interactive flow
ENV DEBIAN_FRONTEND=noninteractive

ADD dependencies /
RUN ["chmod", "+x", "dependencies"]
RUN /dependencies

ADD stellar-core.cfg /

ADD start /
RUN ["chmod", "+x", "start"]

ENTRYPOINT ["/start"]

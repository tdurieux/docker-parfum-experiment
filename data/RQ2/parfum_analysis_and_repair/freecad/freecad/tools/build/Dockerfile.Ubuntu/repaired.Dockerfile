FROM ubuntu:rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV UTC=true
ENV ARC=false

COPY ubuntu.sh /tmp

RUN apt-get update && \
    apt-get upgrade --yes && \
    sh /tmp/ubuntu.sh && \
    mkdir /builds

WORKDIR /builds

VOLUME [ "/builds" ]
FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV UTC=true
ENV ARC=false

COPY debian.sh /tmp

RUN apt-get update && \
    apt-get upgrade --yes && \
    sh /tmp/debian.sh && \
    mkdir /builds

WORKDIR /builds

VOLUME [ "/builds" ]
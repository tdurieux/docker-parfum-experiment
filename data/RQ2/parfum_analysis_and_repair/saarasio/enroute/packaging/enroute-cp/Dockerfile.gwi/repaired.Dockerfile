FROM ubuntu:jammy

WORKDIR /bin

COPY enroute /bin/
ENV SEND_ANON_STAT="1"
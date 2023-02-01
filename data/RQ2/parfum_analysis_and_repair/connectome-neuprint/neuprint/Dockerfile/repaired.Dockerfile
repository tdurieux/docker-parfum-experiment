# Ubuntu 16.04 with Java 8 installed.
# Build image with:  docker build -t flyem/neuprint .

FROM ubuntu:16.04

MAINTAINER Tom Dolafi, https://github.com/tomdolafi

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y openjdk-8-jre && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /app/data

WORKDIR /app

COPY neuprint.jar .

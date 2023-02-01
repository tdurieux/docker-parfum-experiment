FROM alpine:3.6

RUN apk -U upgrade && \
    apk add --no-cache \
        build-base \
        curl \
        openssl \
        py-pip \
        python \
    && \
    pip install --no-cache-dir trytls

WORKDIR /root
ENV VERSION 0.3.4
RUN curl -f -Lo- https://github.com/ouspg/trytls/archive/v${VERSION}.tar.gz | zcat - | tar xvf - trytls-${VERSION}/stubs/
RUN mv trytls-${VERSION} trytls

# Go
RUN apk add --no-cache go
WORKDIR /root/trytls/stubs/go-nethttp
RUN go build run.go

# Java
RUN apk add --no-cache openjdk7
WORKDIR /root/trytls/stubs/java-https
RUN /usr/lib/jvm/java-1.7-openjdk/bin/javac Run.java
WORKDIR /root/trytls/stubs/java-net
RUN /usr/lib/jvm/java-1.7-openjdk/bin/javac Run.java

# Python 2
RUN pip install --no-cache-dir requests

# Python 3

RUN apk add --no-cache python3

# PHP 5
RUN apk add --no-cache php5

# Default workdir for easier manual stub testing
COPY shootout.sh /root/trytls/stubs/
WORKDIR /root/trytls/stubs/

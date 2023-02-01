FROM alpine:3.6

RUN apk -U upgrade && \
    apk add \
        build-base \
        curl \
        openssl \
        py-pip \
        python \
    && \
    pip install trytls

WORKDIR /root
ENV VERSION 0.3.4
RUN curl -Lo- https://github.com/ouspg/trytls/archive/v${VERSION}.tar.gz | zcat - | tar xvf - trytls-${VERSION}/stubs/
RUN mv trytls-${VERSION} trytls

# Go
RUN apk add go
WORKDIR /root/trytls/stubs/go-nethttp
RUN go build run.go

# Java
RUN apk add openjdk7
WORKDIR /root/trytls/stubs/java-https
RUN /usr/lib/jvm/java-1.7-openjdk/bin/javac Run.java
WORKDIR /root/trytls/stubs/java-net
RUN /usr/lib/jvm/java-1.7-openjdk/bin/javac Run.java

# Python 2
RUN pip install requests

# Python 3

RUN apk add python3

# PHP 5
RUN apk add php5

# Default workdir for easier manual stub testing
COPY shootout.sh /root/trytls/stubs/
WORKDIR /root/trytls/stubs/

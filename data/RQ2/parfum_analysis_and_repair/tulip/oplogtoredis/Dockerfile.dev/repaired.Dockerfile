FROM --platform=linux/amd64 golang:1.17.0-buster

ADD scripts/wait-for.sh /wait-for.sh
ADD scripts/install-debian-mongo.sh /install-debian-mongo.sh

RUN apt-get update && \
    mkdir -p /oplogtoredis && /install-debian-mongo.sh && \
    go get github.com/pilu/fresh

WORKDIR /oplogtoredis

CMD fresh
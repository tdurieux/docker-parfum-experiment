FROM ubuntu:14.04
MAINTAINER Rafal Jeczalik <rafal@koding.com>

ENV GOPATH /opt/koding/go

WORKDIR /opt/koding

RUN apt-get update && apt-get install --no-install-recommends -y git build-essential ubuntu-dev-tools dh-make && apt-get clean && \
    curl -f -sSL https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz | tar -C /usr/local/ -zxf - && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && rm -rf /var/lib/apt/lists/*;

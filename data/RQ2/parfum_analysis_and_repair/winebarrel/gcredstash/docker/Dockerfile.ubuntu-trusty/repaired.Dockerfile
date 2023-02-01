FROM ubuntu:trusty
MAINTAINER Genki Sugawara <sgwr_dts@yahoo.co.jp>

USER root
WORKDIR /

RUN apt-get update && apt-get install --no-install-recommends -y debhelper wget git && rm -rf /var/lib/apt/lists/*;

ARG GO_VERSION=1.8.3
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/.go
ENV PATH $GOROOT/bin:$PATH
RUN wget -O- -q https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz | tar zxf - && \
    mv go /usr/local/
RUN mkdir $GOPATH

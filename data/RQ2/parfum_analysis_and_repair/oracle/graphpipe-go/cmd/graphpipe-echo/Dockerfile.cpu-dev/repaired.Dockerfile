FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:gophers/archive

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/go-1.10/bin:/go/bin
ENV GOPATH=/go

RUN mkdir -p /go/src

RUN apt-get update && apt-get install --fix-missing -y --no-install-recommends \
      golang-1.10-go && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --fix-missing -y --no-install-recommends \
      make \
      git && rm -rf /var/lib/apt/lists/*;

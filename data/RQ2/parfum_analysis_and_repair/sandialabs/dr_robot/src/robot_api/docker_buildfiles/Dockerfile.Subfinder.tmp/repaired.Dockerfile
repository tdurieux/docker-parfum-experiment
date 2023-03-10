FROM golang:1.11.4-alpine3.7 AS build-env

ENV http_proxy $proxy
ENV https_proxy $proxy

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
	apk add --no-cache --upgrade git openssh-client ca-certificates

ADD certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
	go get github.com/golang/dep/cmd/dep

WORKDIR /go/src/app

# Install
RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
	go get -u github.com/subfinder/subfinder

RUN mkdir -p $output

ENTRYPOINT subfinder -d "$target" -o $output/subfinder.json -oJ 
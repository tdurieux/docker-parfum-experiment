FROM golang:1.13.1-buster as build

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
	apt update && \
	apt install --no-install-recommends -y git ca-certificates chromium; rm -rf /var/lib/apt/lists/*;

ADD certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
	go get -u github.com/sensepost/gowitness

ENV GO111MODULE on

WORKDIR /go/src/github.com/sensepost/gowitness

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
	go build && \
	cp gowitness /usr/bin/

ENV http_proxy $proxy
ENV https_proxy $proxy
ENV HOME /


ENTRYPOINT mkdir -p $output/gowitness && cd $output/gowitness && gowitness file -s $infile --threads 20

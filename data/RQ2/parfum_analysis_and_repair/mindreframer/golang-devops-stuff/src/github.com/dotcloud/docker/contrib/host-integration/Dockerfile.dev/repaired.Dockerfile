#
# This Dockerfile will create an image that allows to generate upstart and
# systemd scripts (more to come)
#
# docker-version 0.6.2
#

FROM		ubuntu:12.10
MAINTAINER	Guillaume J. Charmes <guillaume@docker.com>

RUN apt-get update && apt-get install --no-install-recommends -y wget git mercurial && rm -rf /var/lib/apt/lists/*;

# Install Go
RUN		wget --no-check-certificate https://go.googlecode.com/files/go1.1.2.linux-amd64.tar.gz -O go-1.1.2.tar.gz
RUN tar -xzvf go-1.1.2.tar.gz && mv /go /goroot && rm go-1.1.2.tar.gz
RUN		mkdir /go

ENV		GOROOT	  /goroot
ENV		GOPATH	  /go
ENV		PATH	  $GOROOT/bin:$PATH

RUN		go get github.com/docker/docker && cd /go/src/github.com/docker/docker && git checkout v0.6.3
ADD		manager.go	/manager/
RUN		cd /manager && go build -o /usr/bin/manager

ENTRYPOINT	["/usr/bin/manager"]


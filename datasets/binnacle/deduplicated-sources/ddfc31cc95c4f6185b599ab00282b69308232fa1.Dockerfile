FROM debian:stable-slim

COPY scripts/dev/go.sh /etc/profile.d/go.sh

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential \
		ca-certificates \
		curl \
		gccgo \
		git \
		iproute2 \
		iptables \
		iputils-ping \
		less \
		procps \
		telnet \
		vim \
		wget \
	&& mkdir /root/.ssh

########## Dapper Configuration #####################
ENV DAPPER_RUN_ARGS --privileged --name docker-volume-git_dev
ENV DAPPER_SOURCE /go/src/github.com/kassisol/docker-volume-git
ENV SHELL /bin/bash

WORKDIR ${DAPPER_SOURCE}

########## General Configuration #####################
ARG DAPPER_HOST_ARCH=amd64
ARG HOST_ARCH=${DAPPER_HOST_ARCH}
ARG ARCH=${HOST_ARCH}

ARG APP_REPO=kassisol

ARG DOCKER_VERSION=17.12.0

ARG DOCKER_URL_amd64=https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}-ce.tgz

# Set up environment and export all ARGS as ENV
ENV ARCH=${ARCH} \
	HOST_ARCH=${HOST_ARCH}

ENV DOCKER_URL=${DOCKER_URL_amd64} \
	DAPPER_HOST_ARCH=${DAPPER_HOST_ARCH} \
	GOPATH=/go \
	GOARCH=$ARCH \
	GO_VERSION=1.8.3

ENV PATH=/go/bin:/usr/local/go/bin:$PATH

# Install Docker
RUN curl -sfL ${DOCKER_URL} | tar -xzC /usr/local/src \
	&& cp /usr/local/src/docker/docker* /usr/bin/ \
	&& mkdir -p /var/lib/docker/volumes \
	&& mkdir -p /var/lib/docker/state

# Install Go
RUN curl -sfL https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz | tar -xzC /usr/local

# Install govendor
RUN go get -u github.com/kardianos/govendor

# Install Golint
RUN go get -u github.com/golang/lint/golint

# Install dotfiles
RUN git clone https://github.com/juliengk/dot-files /root/Dotfiles \
	&& mkdir /root/bin \
	&& wget https://raw.githubusercontent.com/juliengk/dotfiles/master/misc/get-dotfiles.sh -O /root/bin/get-dotfiles.sh \
	&& chmod +x /root/bin/get-dotfiles.sh \
	&& /root/bin/get-dotfiles.sh \
	&& /root/bin/dotfiles -sync -force

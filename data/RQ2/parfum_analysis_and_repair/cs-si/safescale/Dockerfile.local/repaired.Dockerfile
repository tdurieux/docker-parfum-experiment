FROM ubuntu:focal as base
LABEL maintainer="CS SI"
ARG http_proxy=""
ARG https_proxy=""
ARG LC_ALL=C.UTF-8
ARG LANG=C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV BUILD_ENV docker
ENV BRANCH_NAME $BRANCH_NAME
ENV GOVERSION $GOVERSION
ENV PROTOVERSION $PROTOVERSION

RUN apt-get update -y \
&& apt-get install -y --allow-unauthenticated --no-install-recommends \
wget unzip apt-utils && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp

# ----------------------
# Install GO $GOVERSION
# ----------------------
RUN wget --no-check-certificate https://dl.google.com/go/go$GOVERSION.linux-amd64.tar.gz \
&& tar -C /usr/local -xzf go$GOVERSION.linux-amd64.tar.gz \
&& rm /tmp/go$GOVERSION.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin:/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# ----------------------
# Install Protoc $PROTOVERSION
# ----------------------
RUN wget --no-check-certificate https://github.com/google/protobuf/releases/download/v$PROTOVERSION/protoc-$PROTOVERSION-linux-x86_64.zip \
&& unzip -d /usr/local/protoc protoc-$PROTOVERSION-linux-x86_64.zip \
&& ln -s /usr/local/protoc/bin/protoc /usr/local/bin \
&& rm /tmp/protoc-$PROTOVERSION-linux-x86_64.zip

FROM base AS builder

WORKDIR /tmp

# -----------------
# Install Standard packages
# -----------------
RUN apt-get install -y --allow-unauthenticated --no-install-recommends \
locales \
sudo \
locate \
build-essential \
make \
wget \
curl \
unzip \
vim \
git \
jq \
iproute2 \
iputils-ping \
openssh-server \
python3 \
python3-pip \
&& apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN python3 -c "print('testing UTF8: 👌')"

ENV SHELL /bin/bash
ENV GOPATH /go
COPY build-safescale-local.sh /opt/build-safescale-local.sh

ADD . /go/SafeScale

CMD sleep 5

COPY marker /dev/null

RUN cd /opt && ./build-safescale-local.sh

# --

FROM golang:$GOVERSION-alpine
LABEL maintainer="CS SI"
ARG http_proxy=""
ARG https_proxy=""
ARG LC_ALL=C.UTF-8
ARG LANG=C.UTF-8
ENV BUILD_ENV docker

RUN apk update && \
    apk add --no-cache \
    nano \
    curl \
    wget \
    openssl \
    ca-certificates \
    iproute2 \
    iperf

RUN ln -s /usr/lib/tc /lib/tc
RUN mkdir /exported

RUN apk add --no-cache bash

COPY --from=builder /exported/safescaled /exported/safescaled
COPY --from=builder /exported/safescale /exported/safescale
COPY --from=builder /exported/go.mod /exported/go.mod
COPY --from=builder /exported/go.sum /exported/go.sum

FROM ubuntu:18.04

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y build-essential && \
  apt-get install --no-install-recommends -y software-properties-common && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl ntp git zip htop unzip vim wget python-virtualenv python-dev python-pip && \
  apt-get update && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
  git clone https://github.com/unicorn-engine/unicorn && \
  cd unicorn && \
  UNICORN_ARCHS="x86" ./make.sh && \
  UNICORN_ARCHS="x86" ./make.sh install

RUN \
  wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go1.14.4.linux-amd64.tar.gz && \
  mkdir -p /bineedev/go/src/github.com/carbonblack/binee && rm go1.14.4.linux-amd64.tar.gz

ENV HOME /bineedev

ENV PATH "/usr/local/go/bin:${PATH}"

ENV GOPATH "${HOME}/go"

RUN \
  go get -u github.com/unicorn-engine/unicorn/bindings/go/unicorn

ENV TERM=xterm

WORKDIR /bineedev/go/src/github.com/carbonblack/binee

CMD \
  bash

#
# ubuntu latest upgrade version
#
# build:
#   docker build --force-rm=true -t subicura/ruby-node:2.5_12 .

FROM ubuntu:18.04

MAINTAINER subicura@subicura.com

RUN \
  echo 20200124 && \
  apt-get -qq update
ENV DEBIAN_FRONTEND noninteractive

# install essential packages
RUN \
  apt-get -qq -y install build-essential software-properties-common git curl wget \
    libcurl3-gnutls libcurl4-openssl-dev gnupg libssl-dev libcrypto++-dev
  
# install ruby2.3
RUN \
  add-apt-repository -y ppa:brightbox/ruby-ng && \
  apt-get -qq update && \
  apt-get -qq -y install ruby2.5 ruby2.5-dev && \
  gem install bundler --no-ri --no-rdoc --source http://rubygems.org

# install node 8
RUN \
    wget -qO- https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get -qq -y install nodejs



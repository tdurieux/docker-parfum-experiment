#
# ubuntu latest upgrade version
#
# build:
#   docker build --force-rm=true -f Dockerfile.2.5_8 -t subicura/ruby-node:2.5_8 .

FROM ubuntu:18.04

MAINTAINER subicura@subicura.com

RUN \
  echo 20200125 && \
  apt-get -qq update
ENV DEBIAN_FRONTEND noninteractive

# install essential packages
RUN \
  apt-get -qq --no-install-recommends -y install build-essential software-properties-common git curl wget \
    libcurl3-gnutls libcurl4-openssl-dev gnupg libssl-dev libcrypto++-dev && rm -rf /var/lib/apt/lists/*;

# install ruby2.3
RUN \
  add-apt-repository -y ppa:brightbox/ruby-ng && \
  apt-get -qq update && \
  apt-get -qq --no-install-recommends -y install ruby2.3 ruby2.3-dev && \
  gem install bundler -v 1.16.0 --no-ri --no-rdoc && rm -rf /var/lib/apt/lists/*;

# install node 8
RUN \
    wget -qO- https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get -qq --no-install-recommends -y install nodejs && rm -rf /var/lib/apt/lists/*;



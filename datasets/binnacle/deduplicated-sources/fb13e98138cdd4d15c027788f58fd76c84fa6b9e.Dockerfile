FROM ubuntu:bionic

ENV SCCACHE_VER=0.2.8

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -qy --no-install-recommends \
  audacious-dev \
  cmake \
  docbook2x \
  git \
  gpg \
  gpg-agent \
  lcov \
  less \
  libaudclient-dev \
  libcairo2-dev \
  libcurl4-openssl-dev \
  libical-dev \
  libimlib2-dev \
  libircclient-dev \
  libiw-dev \
  liblua5.3-dev \
  libmicrohttpd-dev \
  libmysqlclient-dev \
  libpulse-dev \
  librsvg2-dev \
  libssl-dev \
  libsystemd-dev \
  libxdamage-dev \
  libxext-dev \
  libxft-dev \
  libxinerama-dev \
  libxml2-dev \
  libxmmsclient-dev \
  libxnvctrl-dev \
  man \
  ncurses-dev \
  software-properties-common \
  wget \
  && wget -q https://github.com/mozilla/sccache/releases/download/${SCCACHE_VER}/sccache-${SCCACHE_VER}-x86_64-unknown-linux-musl.tar.gz -O sccache-${SCCACHE_VER}-x86_64-unknown-linux-musl.tar.gz \
  && tar xf sccache-${SCCACHE_VER}-x86_64-unknown-linux-musl.tar.gz \
  && cp sccache-${SCCACHE_VER}-x86_64-unknown-linux-musl/sccache /usr/bin \
  && rm -rf sccache-${SCCACHE_VER}-x86_64-unknown-linux-musl*


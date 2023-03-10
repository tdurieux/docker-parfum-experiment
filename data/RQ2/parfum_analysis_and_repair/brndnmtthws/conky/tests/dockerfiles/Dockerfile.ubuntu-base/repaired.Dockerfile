FROM ubuntu:focal

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -qy --no-install-recommends \
  audacious-dev \
  build-essential \
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
  wget && rm -rf /var/lib/apt/lists/*;


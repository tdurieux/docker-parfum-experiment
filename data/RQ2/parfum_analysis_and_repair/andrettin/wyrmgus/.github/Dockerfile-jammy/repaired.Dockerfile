FROM ubuntu:jammy
LABEL Description="Ubuntu Jammy Jellyfish environment to build and test Wyrmgus"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
# Build deps
RUN apt-get -y --no-install-recommends install \
  build-essential \
  cmake \
  git \
  libboost-dev \
  liblua5.1-dev \
  libsdl2-mixer-dev \
  libsdl2-dev \
  libsqlite3-dev \
  libtolua++5.1-dev \
  qtbase5-dev \
  qtlocation5-dev \
  qtmultimedia5-dev \
  qtpositioning5-dev \
; rm -rf /var/lib/apt/lists/*;
# Runtime deps
RUN apt-get -y --no-install-recommends install \
  qml-module-qtquick-controls2 \
  qml-module-qtquick-window2 \
  qml-module-qtquick2 \
  xvfb \
; rm -rf /var/lib/apt/lists/*;
# CI deps
RUN apt-get -y --no-install-recommends install \
  lintian \
; rm -rf /var/lib/apt/lists/*;
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

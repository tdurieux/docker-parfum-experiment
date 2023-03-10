FROM alpine:latest

RUN apk add --no-cache \
  binutils \
  cmake \
  curl-dev \
  docbook2x \
  gettext-tiny-dev \
  git \
  icu-dev \
  imlib2-dev \
  iw \
  libmicrohttpd-dev \
  libpulse \
  libxdamage-dev \
  libxext-dev \
  libxft-dev \
  libxinerama-dev \
  linux-headers \
  lua5.3-dev \
  make \
  musl-dev \
  ncurses-dev \
  patch
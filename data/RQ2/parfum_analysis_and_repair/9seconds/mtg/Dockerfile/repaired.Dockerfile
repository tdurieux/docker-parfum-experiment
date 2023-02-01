###############################################################################
# BUILD STAGE

FROM golang:1.18-alpine AS build

RUN set -x \
  && apk --no-cache --update add \
    bash \
    ca-certificates \
    curl \
    git \
    make

COPY . /app
WORKDIR /app

RUN set -x \
  && make -j 4 static


###############################################################################
# PACKAGE STAGE
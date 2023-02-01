# HackTheArch Dockerfile
# VERSION 3.0

################################################################################
# Builder
################################################################################
FROM ruby:3-alpine as builder
RUN apk add --no-cache --update \
        build-base \
        curl-dev \
        sqlite-dev \
        nodejs \
        libpq \
        postgresql \
        imagemagick \
        libxml2-dev \
        postgresql-dev \
        postgresql-client

WORKDIR /src
COPY Gemfile* ./
RUN bundle install --with production -j4 --retry 3 \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

ADD . ./
RUN mkdir -p ./tmp/cache ./log

################################################################################
# Production
################################################################################
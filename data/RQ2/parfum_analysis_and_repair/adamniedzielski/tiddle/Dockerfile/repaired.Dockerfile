FROM ruby:3.1-alpine

RUN apk add --no-cache build-base sqlite-dev tzdata git bash
    RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && gem install bundler && rm -rf /root/.gem;

WORKDIR /library

ENV BUNDLE_PATH=/vendor/bundle \
    BUNDLE_BIN=/vendor/bundle/bin \
    GEM_HOME=/vendor/bundle

ENV PATH="${BUNDLE_BIN}:${PATH}"

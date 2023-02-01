# Build for install dependency RubyGems
FROM ruby:3.1.1-alpine3.15 AS bundle

WORKDIR /tmp
COPY Gemfile .
COPY Gemfile.lock .

RUN set -ex \
    && apk add --update --no-cache curl build-base \
    && bundle config set frozen true \
    && bundle config set without 'test:development' \
    && bundle install --jobs=4 \
    && rm -rf "${GEM_HOME}/cache/*"

# Build for Sinatra app
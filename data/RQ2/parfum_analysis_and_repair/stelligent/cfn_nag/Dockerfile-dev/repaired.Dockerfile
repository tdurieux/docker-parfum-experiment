FROM ruby:2.7-alpine

COPY . /

RUN apk add --no-cache --update build-base \
    curl \
    git

RUN gem install bundler
RUN gem install rubocop
RUN bundle install

FROM ruby:3.0-alpine3.12

RUN gem install bundler:2.1.4

RUN apk update --no-cache && \
    apk add --no-cache build-base postgresql-dev git nodejs yarn tzdata bash sqlite-dev npm libtool && \
    mkdir -p /app

WORKDIR /app

COPY ./lib/ /app/lib/
COPY matestack-ui-core.gemspec /app/
COPY Gemfile* /app/
RUN bundle install

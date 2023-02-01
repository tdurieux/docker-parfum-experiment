FROM ruby:2.7.3-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
                      build-essential \
                      libpq-dev \
                      postgresql-client \
                      git-core

RUN mkdir /app
WORKDIR /app

RUN gem install bundler

COPY Gemfile .
COPY cranium.gemspec .

ARG https_proxy
ARG http_proxy
RUN bundle install -j 5
COPY . .
RUN mkdir /tmp/custdata/

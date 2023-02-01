FROM ruby:2.1
MAINTAINER Zach Latta <zach@hackclub.com>

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/Gemfile
ADD Gemfile.lock /usr/src/app/Gemfile.lock

ENV BUNDLE_GEMFILE=Gemfile \
  BUNDLE_JOBS=4 \
  BUNDLE_PATH=/bundle

RUN bundle install

ADD . /usr/src/app

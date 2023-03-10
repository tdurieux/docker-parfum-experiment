FROM ruby:2.4.2-alpine3.6

RUN apk update && apk upgrade
RUN apk add --no-cache bash
RUN apk add --no-cache curl-dev ruby-dev build-base git ruby-json openssl

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY lib/kirpich/version.rb /usr/src/app/lib/kirpich/
COPY kirpich.gemspec /usr/src/app/
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --jobs 4

COPY . /usr/src/app

CMD 'bin/run'

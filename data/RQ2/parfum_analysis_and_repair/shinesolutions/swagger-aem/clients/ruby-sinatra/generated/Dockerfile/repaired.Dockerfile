## Build libraries
FROM ruby:3.0-alpine as rubydev

## for thin or falcon
#RUN apk --no-cache add make g++ libc-dev
## for puma
#RUN apk --no-cache add make gcc libc-dev

ADD . /app
WORKDIR /app

RUN bundle config set path lib
RUN bundle install

## Build Runtime image
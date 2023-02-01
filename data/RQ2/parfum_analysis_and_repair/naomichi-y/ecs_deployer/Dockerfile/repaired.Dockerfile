FROM ruby:2.6.3-alpine3.10

RUN apk add --no-cache git build-base
WORKDIR /app

COPY . .
RUN bundle install

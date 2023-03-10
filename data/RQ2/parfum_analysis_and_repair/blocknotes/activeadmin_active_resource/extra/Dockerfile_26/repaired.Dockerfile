FROM ruby:2.6-alpine

RUN apk add --no-cache --update build-base dpkg gcompat sqlite sqlite-dev tzdata
RUN gem install bundler

# App setup
WORKDIR /usr/src/app
COPY .. .
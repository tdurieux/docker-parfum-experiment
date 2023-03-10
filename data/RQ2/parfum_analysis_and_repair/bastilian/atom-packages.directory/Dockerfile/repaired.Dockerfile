FROM alpine:latest

MAINTAINER Sebastian Gräßl <sebastian@validcode.me>

ENV RACK_ENV development

RUN apk add --no-cache --update build-base libffi libffi-dev git zsh wget
RUN apk add --no-cache nginx nodejs ruby ruby-dev ruby-bundler ruby-bigdecimal ruby-io-console
RUN rm -rf /var/cache/apk/*
RUN npm install -g bower && npm cache clean --force;

RUN mkdir /site
WORKDIR /site

COPY Gemfile* /site/
RUN bundle install --system

COPY bower.json /site/
COPY .bowerrc /site/
RUN bower --allow-root install

EXPOSE 80

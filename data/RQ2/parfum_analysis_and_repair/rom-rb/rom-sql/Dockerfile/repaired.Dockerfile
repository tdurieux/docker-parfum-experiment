FROM ruby:3.1-alpine

RUN apk update && apk add --no-cache bash git gnupg build-base sqlite-dev postgresql-dev mysql-dev

WORKDIR /usr/local/src/rom-sql

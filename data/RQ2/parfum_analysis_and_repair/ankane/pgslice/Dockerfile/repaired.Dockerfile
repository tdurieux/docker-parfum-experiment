FROM ruby:3.1.2-alpine3.15

MAINTAINER Andrew Kane <andrew@ankane.org>

RUN apk add --no-cache --update build-base libpq-dev && \
    gem install pgslice && \
    apk del build-base && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["pgslice"]

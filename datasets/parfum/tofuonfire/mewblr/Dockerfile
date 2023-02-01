FROM ruby:2.6.5-alpine

WORKDIR /mewblr

RUN apk add git --no-cache
RUN apk add --update bash perl --no-cache
RUN apk add libxslt-dev libxml2-dev build-base --no-cache
RUN apk add mysql-client mysql-dev --no-cache
RUN apk add --no-cache file
RUN apk add yarn --no-cache
RUN apk add tzdata --no-cache
RUN apk --update add imagemagick --no-cache

COPY . /mewblr

RUN bundle install
RUN yarn install

RUN mkdir -p /mewblr/tmp/sockets /mewblr/tmp/pids

RUN mkdir -p /tmp/public && \
    cp -rf /mewblr/public/* /tmp/public

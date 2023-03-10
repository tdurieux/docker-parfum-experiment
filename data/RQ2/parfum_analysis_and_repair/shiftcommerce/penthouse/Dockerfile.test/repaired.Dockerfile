ARG RUBY_VERSION="2.5"

FROM ruby:$RUBY_VERSION-alpine

ARG RUBY_VERSION="2.5"
ARG RAILS_VERSION="5.1.4"
ARG PG_VERSION="1.1.4"

RUN apk add --no-cache --update build-base postgresql-dev tzdata git

WORKDIR /app
ADD ./ /app/

RUN gem install bundler -v '1.17'

ENV RUBY_VERSION=$RUBY_VERSION
ENV RAILS_VERSION=$RAILS_VERSION
ENV PG_VERSION=$PG_VERSION

RUN RUBY_VERSION=$RUBY_VERSION RAILS_VERSION=$RAILS_VERSION PG_VERSION=$PG_VERSION bundle install --jobs=4 --no-cache

ENTRYPOINT ["bundle", "exec", "rspec"]

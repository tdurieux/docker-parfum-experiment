FROM ruby:3.0-alpine3.12

RUN gem install bundler:2.1.4

RUN apk update --no-cache && \
    apk add --no-cache build-base postgresql-dev git nodejs yarn tzdata bash sqlite-dev npm shared-mime-info && \
    mkdir -p /app

WORKDIR /app

COPY ./lib/ /app/lib/
COPY matestack-ui-bootstrap.gemspec /app/
COPY Gemfile* yarn* /app/
RUN bundle install

COPY package.json* /app/
RUN yarn install && yarn cache clean;

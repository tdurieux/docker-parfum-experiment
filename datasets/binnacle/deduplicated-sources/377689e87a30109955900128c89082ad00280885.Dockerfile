FROM ruby:2.5.1-alpine
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN apk add --no-cache build-base
RUN bundle install --without development test
CMD bundle exec bin/seal.rb

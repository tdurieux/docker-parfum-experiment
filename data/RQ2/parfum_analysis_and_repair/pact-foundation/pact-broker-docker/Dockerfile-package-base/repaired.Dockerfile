FROM ruby:2.6.8-alpine3.13

# Installation path
ENV HOME=/app
WORKDIR $HOME

RUN apk add --update --no-cache git
RUN gem install bundler -v 2.1.4

COPY Rakefile $HOME/
COPY Gemfile Gemfile.lock $HOME/
# Only loaded for running the specs
COPY pact_broker $HOME/pact_broker
COPY spec $HOME/spec
RUN bundle install
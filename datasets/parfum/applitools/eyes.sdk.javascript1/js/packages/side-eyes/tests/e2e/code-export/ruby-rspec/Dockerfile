FROM ruby:latest
RUN mkdir /runner
WORKDIR /runner
COPY tests/Gemfile .
RUN bundle install --system

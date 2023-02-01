# A distro upgrade requires changes here and in docker-prereqs.sh
FROM ruby:3.1.0-bullseye

COPY Gemfile* /tmp/
COPY docker-prereqs.sh /tmp/
WORKDIR /tmp

RUN ./docker-prereqs.sh

RUN gem install bundler:2.3.3

# If running in development, remove this line
RUN bundle config set without 'development test'

RUN bundle install

# set the container's time zone
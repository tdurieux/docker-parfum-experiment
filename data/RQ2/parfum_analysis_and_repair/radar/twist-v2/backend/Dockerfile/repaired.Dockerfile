FROM ruby:2.7

COPY . /app
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y cmake openssl libgit2-27 libssh-dev postgresql-client && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler -v 2.1.4
RUN bundle install
RUN bundle exec ruby -e 'require "rugged"; p Rugged.features'

ENTRYPOINT /bin/bash

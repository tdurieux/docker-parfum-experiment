# Pull base image.
FROM ruby:2.4.1-slim-stretch

RUN apt update
RUN apt -y install \
  git \
  curl \
  fontconfig \
  build-essential \
  patch \
  ruby-dev \
  zlib1g-dev \
  liblzma-dev \
  && rm -rf /var/cache/apt/*

# Install phantomjs
RUN cd /usr/local/share \
  && curl -L http://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar xj \
  && ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/share/phantomjs \
  && ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs \
  && ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin/phantomjs \
  && phantomjs --version


# Install gems with native extensions before running bundle install
# This avoids recompiling them everytime the Gemfile.lock changes.
# The versions need to be kept in sync with the Gemfile.lock
RUN  gem install nokogiri -v 1.8.0 \
  && gem install websocket-driver -v 0.6.5 \
  && gem sources -c \
  && rm -f /usr/local/bundle/cache/*

RUN mkdir -p /app

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install --without default test development production doc --standalone integration_test api_client

RUN rm -rf /app/Gemfile*

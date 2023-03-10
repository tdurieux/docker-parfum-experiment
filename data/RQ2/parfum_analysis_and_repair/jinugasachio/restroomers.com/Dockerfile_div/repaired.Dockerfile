FROM ruby:2.5.5-stretch AS builder
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl apt-transport-https wget && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    vim \ 
    mysql-client \
    yarn \
    nodejs && \
    gem install bundler && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

WORKDIR /myapp
COPY . /myapp
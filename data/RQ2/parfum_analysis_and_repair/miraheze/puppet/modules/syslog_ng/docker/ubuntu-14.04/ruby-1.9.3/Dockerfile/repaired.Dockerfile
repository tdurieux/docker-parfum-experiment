FROM ubuntu:14.04

MAINTAINER Tibor Benke ihrwein@gmail.com

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq ruby1.9.1 git && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler

ADD Gemfile /tmp/
RUN cd /tmp && bundle install

RUN mkdir /src
ADD module.tar.gz /src/
WORKDIR /src

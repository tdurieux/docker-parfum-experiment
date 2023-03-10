FROM ubuntu:20.04

MAINTAINER Graylog, Inc. <hello@graylog.com>

RUN apt-get update && \
    apt-get install --no-install-recommends -y ruby ruby2.7 ruby2.7-dev build-essential curl lsb-release git && \
    gem install fpm-cookery --no-document && \
    apt-get install --no-install-recommends -y openjdk-8-jre-headless uuid-runtime && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

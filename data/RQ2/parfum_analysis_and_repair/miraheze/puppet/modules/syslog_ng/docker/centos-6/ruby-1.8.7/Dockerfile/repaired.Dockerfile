FROM centos:centos6

MAINTAINER Tibor Benke ihrwein@gmail.com

RUN yum -y update && \
    yum -y install ruby git rubygems && rm -rf /var/cache/yum
RUN gem install bundler

ADD Gemfile /tmp/
RUN cd /tmp && bundle install

RUN mkdir /src
ADD module.tar.gz /src/
WORKDIR /src

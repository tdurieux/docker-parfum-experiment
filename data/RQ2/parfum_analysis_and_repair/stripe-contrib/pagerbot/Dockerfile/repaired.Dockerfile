FROM ruby:2.2

RUN apt-get update; apt-get install -y --no-install-recommends libgmp3-dev --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN mkdir /pagerbot

WORKDIR /pagerbot
ADD Gemfile* *.gemspec /pagerbot/
RUN bundle install
ADD . /pagerbot

ENV LOG_LEVEL 'debug'
ENV MONGODB_URI 'mongodb://mongo:27017/pagerbot'

EXPOSE 4567

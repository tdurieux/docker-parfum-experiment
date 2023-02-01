# Dockerfile for building a valid test environment
# $ docker build -t diskcached . && docker --rm run diskcached
FROM ruby:latest
RUN apt-get update && apt-get install --no-install-recommends -y memcached libsasl2-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /src
COPY . /src
WORKDIR /src
RUN bundle install
CMD bundle exec rake

#
# Cocaine Ruby HTTP application Dockerfile
#
# https://github.com/cocaine/cocaine-framework-ruby
#

# Pull base image.
FROM ubuntu:trusty

# Install Ruby.
RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y ruby ruby-dev ruby-bundler && \
  rm -rf /var/lib/apt/lists/*

# Copy application.
ADD http.rb /cocaine/
ADD Gemfile /cocaine/

# Define working directory.
WORKDIR /cocaine

RUN bundle install

# This file is used if building for Production environments
# It uses a multi-stage build to run jekyll to populate an nginx container

FROM ruby:2.6-alpine as build

# Add Gem build requirements
RUN apk add --no-cache g++ make libxml2-dev libxslt-dev

# Create app directory
WORKDIR /app

# Add Gemfile and Gemfile.lock
ADD Gemfile* /app/

# Install Gems
RUN gem install bundler -v 1.7.3 \
    && gem install bundler -v 2.1.4 \
    && bundle config build.nokogiri --use-system-libraries \
    && bundle config --global jobs $(nproc) \
    && bundle config set deployment 'true' \
    && bundle config set no-cache 'true' \
    && bundle install

# Copy Site Files
COPY . .

ENV JEKYLL_ENV=production

# Run jekyll build site
RUN bundle exec jekyll build --verbose

#-------------------------------------------------

FROM nginx:stable-alpine as webserver

# Copy built site from build stage
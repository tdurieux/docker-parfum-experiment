# This file is used if building for Production environments
# It uses a multi-stage build to run jekyll to populate an nginx container

FROM ruby:2.7-alpine as build

# Add Gem build requirements
RUN apk add --no-cache g++ make libxml2-dev libxslt-dev

# Create app directory
WORKDIR /app

# Add Gemfile and Gemfile.lock
ADD Gemfile* /app/

# Install Gems
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system \
    && gem install bundler -v $(grep -F -A 1 'BUNDLED WITH' Gemfile.lock | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+') \
    && bundle config build.nokogiri --use-system-libraries \
    && bundle config --global jobs $(nproc) \
    && bundle install --deployment --no-cache \
    && bundle clean && rm -rf /root/.gem;

# Copy Site Files
COPY . .

ENV JEKYLL_ENV=production

# Run jekyll build site
RUN bundle exec jekyll build --verbose

#-------------------------------------------------

FROM nginx:stable-alpine as webserver

# Copy built site from build stage
COPY --from=build /app/_site /usr/share/nginx/html

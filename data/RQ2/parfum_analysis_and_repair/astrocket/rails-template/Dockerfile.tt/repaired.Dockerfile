FROM ruby:<%= RUBY_VERSION %>-alpine

RUN apk add --no-cache \
    build-base \
    nano \
    curl-dev \
    ca-certificates \
    linux-headers \
    build-base \
    libxml2-dev \
    libxslt-dev \
    tzdata \
    postgresql-dev \
    nodejs \
    yarn \
    libc6-compat \
    curl \
    git

ARG master_key
ENV MASTER_KEY=$master_key

ARG deploy_version
ENV DEPLOY_VERSION=$deploy_version

ARG secret_key_base
ENV SECRET_KEY_BASE=$secret_key_base

ARG rails_env
ENV RAILS_ENV=$rails_env

ENV RAILS_ROOT /app
ENV BUNDLE_DIR /vendor/bundle

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY package.json yarn.lock ./
RUN yarn install --$RAILS_ENV && yarn cache clean;

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.3.4
RUN bundle config build.google-protobuf --with-cflags=-D__va_copy=va_copy
RUN BUNDLE_FORCE_RUBY_PLATFORM=1 bundle install --path $BUNDLE_DIR --jobs 20 --retry 5 --without development test

COPY . .

RUN bundle exec rake assets:precompile
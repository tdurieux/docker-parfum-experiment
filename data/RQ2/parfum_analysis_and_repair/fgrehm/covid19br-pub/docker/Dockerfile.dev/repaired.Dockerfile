FROM ruby:2.6-alpine3.11
ENV BUNDLE_JOBS 8
RUN apk add --no-cache \
            bash \
            build-base \
            git \
            less \
            nodejs \
            postgresql-dev \
            postgresql-client \
            yarn \
            tzdata \
    && gem install bundler --version 2.1.4
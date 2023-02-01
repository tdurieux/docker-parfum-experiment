ARG  RUBY_VERSION=2.7
FROM ruby:${RUBY_VERSION}

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN bash -lc "gem install bundler -v 2.2.32"

ARG BUNDLE_GEMFILE
ENV BUNDLE_GEMFILE $BUNDLE_GEMFILE

WORKDIR /usr/src/app
COPY . /usr/src/app
RUN bash -lc "bundle install"

ENV TEST_DB_USERNAME postgres

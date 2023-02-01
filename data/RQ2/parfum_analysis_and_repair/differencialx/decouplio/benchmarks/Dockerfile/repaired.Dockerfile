ARG RUBY_VERSION=2.7.0

FROM ruby:${RUBY_VERSION}-slim

RUN apt-get update && apt-get install --no-install-recommends -y git make gcc && rm -rf /var/lib/apt/lists/*;

COPY . /decouplio

WORKDIR /decouplio/benchmarks

RUN bundle check || bundle install

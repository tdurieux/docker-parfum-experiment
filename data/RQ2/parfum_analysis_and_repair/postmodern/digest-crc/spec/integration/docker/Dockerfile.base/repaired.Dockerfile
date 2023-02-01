ARG RUBY_VERSION=2.7.0
FROM ruby:${RUBY_VERSION}-slim

RUN apt-get update -y -qq && apt-get install --no-install-recommends -y -qq bash && rm -rf /var/lib/apt/lists/*;

COPY ./digest-crc.gem .

ENTRYPOINT gem install ./digest-crc.gem

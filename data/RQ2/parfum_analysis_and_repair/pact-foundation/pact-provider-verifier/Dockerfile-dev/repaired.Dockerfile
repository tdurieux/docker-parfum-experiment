FROM ruby:2.2.4-alpine

RUN apk update \
    && apk --no-cache add \
      "build-base>=0.4" \
      "bash>=4.3" \
      "ca-certificates>=20161130" \
      "git>=2.8" \
      "tzdata>=2015" \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile pact-provider-verifier.gemspec /app/
COPY lib/pact/provider_verifier/version.rb /app/lib/pact/provider_verifier/version.rb

RUN gem install bundler -v '1.17.3' \
    && bundle install --jobs 3 --retry 3

CMD []
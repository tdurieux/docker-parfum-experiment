FROM ruby:2.7-buster

RUN apt-get update && \
    apt-get install --no-install-recommends -yq ca-certificates procps systemd apt-transport-https libcap2-bin curl gnupg && rm -rf /var/lib/apt/lists/*;

WORKDIR /splunk-otel-collector

COPY Gemfile /splunk-otel-collector/

RUN bundle install

COPY ./ /splunk-otel-collector

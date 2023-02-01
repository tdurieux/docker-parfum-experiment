FROM ruby:2.5-stretch

MAINTAINER Kouhei Sutou <kou@clear-code.com>

RUN \
  apt update && \
  apt install --no-install-recommends -y apt-transport-https && \
  echo "deb https://packages.red-data-tools.org/debian/ stretch main" > \
    /etc/apt/sources.list.d/red-data-tools.list && \
  apt update --allow-insecure-repositories && \
  apt install -y --allow-unauthenticated red-data-tools-keyring && \
  apt update && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app
COPY . /app
RUN bundle install

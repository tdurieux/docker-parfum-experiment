FROM ruby:2.7.4
MAINTAINER Populate <lets@populate.tools>

RUN apt-get update && apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

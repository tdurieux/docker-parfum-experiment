FROM ruby:2.4.0-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install build-essential && gem install nokogiri && rm -rf /var/lib/apt/lists/*;

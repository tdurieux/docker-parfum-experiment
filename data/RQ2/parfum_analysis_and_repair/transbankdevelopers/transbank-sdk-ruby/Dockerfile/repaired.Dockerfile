FROM ruby:2.4-jessie
RUN apt-get update && apt-get install -y
RUN mkdir -p /sdk
WORKDIR /sdk
COPY . /sdk
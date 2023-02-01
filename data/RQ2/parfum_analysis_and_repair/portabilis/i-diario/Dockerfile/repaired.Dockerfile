FROM ruby:2.4.10-slim-buster

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs npm git && rm -rf /var/lib/apt/lists/*;
RUN npm i -g yarn && npm cache clean --force;

ENV app /app
RUN mkdir $app
WORKDIR $app

ENV BUNDLE_PATH /box

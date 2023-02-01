FROM ruby:2.6.5-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential nodejs libpq-dev postgresql-client imagemagick && rm -rf /var/lib/apt/lists/*;

ENV APP_PATH /var/www/app

WORKDIR $APP_PATH

COPY Gemfile* $APP_PATH/

RUN bundle install

COPY . $APP_PATH/

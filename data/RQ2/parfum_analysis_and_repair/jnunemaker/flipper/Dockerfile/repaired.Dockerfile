FROM ruby:3.0

RUN apt-get update && apt-get install --no-install-recommends -y \















  vim && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /srv/app

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=8 \
    BUNDLE_PATH=/bundle_cache

WORKDIR $APP_HOME

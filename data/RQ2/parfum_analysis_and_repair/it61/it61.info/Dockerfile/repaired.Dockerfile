FROM ruby:2.6.5-alpine3.9
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN apk update && apk upgrade && \
  apk add --no-cache bash git openssh \
  build-base nodejs tzdata postgresql \
  postgresql-dev python imagemagick yarn \
  && gem update bundler && rm -rf /root/.gem;

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install -j "$(getconf _NPROCESSORS_ONLN)" --retry 5 --without development test

ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE $SECRET_KEY_BASE

ARG APPLICATION_HOST
ENV APPLICATION_HOST $APPLICATION_HOST

COPY . ./

# Update crontab
RUN bundle exec whenever --update-crontab

EXPOSE 3000

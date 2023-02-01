FROM ruby:2.5.1-alpine

RUN apk add --no-cache bash \
    build-base \
    imagemagick \
    nodejs \
    tzdata \
    postgresql-dev

RUN mkdir /app

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

ENV BUNDLER_VERSION 2.1.4
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update bundler && bundle install && rm -rf /root/.gem;

COPY . /app

EXPOSE 3000

CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
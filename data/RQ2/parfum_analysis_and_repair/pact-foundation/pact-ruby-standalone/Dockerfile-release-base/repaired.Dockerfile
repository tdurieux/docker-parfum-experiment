FROM ruby:2.2.10-alpine

# Installation path
ENV HOME=/app
WORKDIR $HOME

RUN set -ex && \
  adduser -h $HOME -s /bin/false -D -S -G root ruby && \
  chmod g+w $HOME && \
  apk add --update --no-cache make gcc libc-dev git

RUN gem install bundler -v 1.15.4
COPY Gemfile Gemfile.lock $HOME/
RUN bundle install --no-cache
FROM alpine:3.15

ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=1
ENV BUNDLE_SILENCE_ROOT_WARNING=1

ADD docker/gemrc /root/.gemrc
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN apk update \
  && apk add --no-cache ruby \
             ruby-bigdecimal \
             ruby-bundler \
             ruby-io-console \
             ca-certificates \
             libressl \
             less \
  && apk add --no-cache --virtual build-dependencies \
             build-base \
             ruby-dev \
             libressl-dev \
             ruby-rdoc \

  && bundle config build.nokogiri --use-system-libraries \
  && bundle config git.allow_insecure true \
  && gem update --system \
  && gem install json && rm -rf /root/.gem;

ENV HOME /pact
ENV DOCKER true
WORKDIR $HOME

ADD pact-cli.gemspec Gemfile Gemfile.lock $HOME/
ADD lib/pact/cli/version.rb $HOME/lib/pact/cli/version.rb
RUN bundle install --without test development
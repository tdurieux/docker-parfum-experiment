FROM node:14.19.2-alpine3.15

LABEL maintainer="Beth Skurrie <beth@bethesque.com>"

ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=1
ENV BUNDLE_SILENCE_ROOT_WARNING=1

ADD docker/gemrc /root/.gemrc
ADD docker/pact /usr/local/bin/pact

# Update from rubygems 2.7.6 to 3.0.3 for security reasons
# Verify with gem -v
# TODO: Remove this when it is no longer needed
# For some reason this line changes the image size from 60 to 80 MB?!?
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN apk update \
  && apk add ruby \
             ruby-bigdecimal \
             ruby-bundler \
             ruby-io-console \
             ca-certificates \
             libressl \
             less \
             git \
  && apk add --virtual build-dependencies \
             build-base \
             ruby-dev \
             libressl-dev \
             ruby-rdoc \
  \
  && bundler -v \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle config git.allow_insecure true \
  && gem update --system \
  && gem install json -v "~>2.3" \
  && gem cleanup \
  && rm -rf /usr/lib/ruby/gems/*/cache/* \
            /var/cache/apk/* \
            /tmp/* \
            /var/tmp/* && rm -rf /root/.gem;

ENV HOME /pact
ENV DOCKER true
ENV BUNDLE_GEMFILE=$HOME/Gemfile
WORKDIR $HOME

ADD pact-cli.gemspec .
ADD Gemfile .
ADD Gemfile.lock .
ADD lib/pact/cli/version.rb ./lib/pact/cli/version.rb
RUN bundle config set without 'test development' \
      && bundle install \
      && find /usr/lib/ruby/gems/2.7.0/gems -name Gemfile.lock -maxdepth 2 -delete
ADD docker/entrypoint.sh $HOME/entrypoint.sh
ADD bin ./bin
ADD lib ./lib
CMD ["pact"]
